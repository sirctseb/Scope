using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Utility;
namespace SoarIMPRINTPlugin
{
	public class Scope : Utility.IMPRINTAccess, Utility.IIMPRINTLogger, MAAD.Utilities.Plugins.IPlugin
	{
		// to "subclass" from IMPRINTLogger
		public Utility.IMPRINTLogger logger
		{
			get;
			set;
		}

		// TODO test when IMPRINT creates plugin objects
		private static bool kernelInitialized = false;
		private static sml.Kernel kernel = null;
		private static sml.Agent agent = null;
		public string ScopeOutput = null;
		private bool eventsRegistered = false;

		public Scope()
		{
			CreateKernel();
			InitializeScope();
			RegisterEvents();
			logger = new IMPRINTLogger();
			this.enable("debug");
		}
		
		// we learned that a new object is constructed everytime a simulation starts
		//private static int constructorCalls = 0;
		/*public Scope()
		{
			constructorCalls += 1;
			app.AcceptTrace("constructing!");
		}
		~Scope()
		{
			app.AcceptTrace("destructing!");
		}
		public int getConstructorCalls()
		{
			return constructorCalls;
		}*/

		//public delegate void DSimulationEvent(Executor executor);
		//public delegate void DNetworkEvent(object sender, EventArgs e);
		private void OnBeforeBeginningEffect(MAAD.Simulator.Executor executor)
		{
			MAAD.Simulator.Utilities.IRuntimeTask task = executor.EventQueue.GetTask();
			//app.AcceptTrace(task.ID);
			// ignore the first and last task
			int taskID = int.Parse(task.ID);
			if (taskID > 0 && taskID < 999)
			{
				// find corresponding MAAD.IMPRINTPro.NetworkTask
				foreach (MAAD.IMPRINTPro.NetworkTask nt in this.GetTaskList())
				{
					if (nt.ID == task.ID)
					{
						// add task props to Soar input
						AddTask(nt);
					}
				}
			}

			// run the agent until it decides what to do
			string output = agent.RunSelfTilOutput();
			//app.AcceptTrace(output);
			app.AcceptTrace(GetOutput("strategy", "name"));
		}
		public void OnSimulationBegin(object sender, EventArgs e)
		{
			ResetSoar();
		}
		public void OnSimulationComplete(object sender, EventArgs e)
		{
			//KillKernel();
			// TODO when to shutdown kernel?
			UnregisterEvents();
		}

		private MAAD.Simulator.Utilities.DSimulationEvent OBBE;
		private MAAD.Simulator.Utilities.DNetworkEvent OSB;
		private MAAD.Simulator.Utilities.DNetworkEvent OSC;
		public void RegisterEvents()
		{
			app.Generator.OnBeforeBeginningEffect +=
				OBBE = new MAAD.Simulator.Utilities.DSimulationEvent(OnBeforeBeginningEffect);
			app.Generator.OnSimulationBegin +=
				OSB = new MAAD.Simulator.Utilities.DNetworkEvent(OnSimulationBegin);
			app.Generator.OnSimulationComplete +=
				OSC = new MAAD.Simulator.Utilities.DNetworkEvent(OnSimulationComplete);
		}
		public void UnregisterEvents()
		{
			app.Generator.OnBeforeBeginningEffect -= OBBE;
			app.Generator.OnSimulationBegin -= OSB;
			app.Generator.OnSimulationComplete -= OSC;
		}

		public static bool CreateKernel()
		{
			if (kernel == null)
			{
				kernel = sml.Kernel.CreateKernelInNewThread();
				//this.log("Creating kernel: " + !kernel.HadError(), "debug");

				return kernelInitialized = !kernel.HadError();
			}
			return true;
		}

		public static bool InitializeScope()
		{
			return InitializeScope("Scope/agent/scope.soar");
		}
		public static bool InitializeScope(string source)
		{
			if (agent == null)
			{
				// create the agent
				agent = kernel.CreateAgent("scope-agent");
				if (kernel.HadError()) return false;

				// load scope productions
				// TODO load test productions for now
				agent.LoadProductions(source);
				if (agent.HadError()) return false;
			}

			return true;
		}
		public bool ResetSoar()
		{
			agent.InitSoar();

			return !agent.HadError();
		}

		public bool RunAgent(int steps) {

			// run agent for 3 steps
			agent.RunSelf(steps);
			if (agent.HadError()) return false;

			return true;
		}

		public bool AddTask(MAAD.IMPRINTPro.NetworkTask task)
		{
			// get input link
			sml.Identifier input = agent.GetInputLink();

			// create a wme for the task
			sml.Identifier taskLink = input.CreateIdWME("task");
			
			// add the task ID
			taskLink.CreateStringWME("taskID", task.ID);

			foreach (MAAD.IMPRINTPro.Interfaces.ITaskDemand demand in task.TaskDemandList.GetITaskDemands) {
				// get workload attributes
				string name = demand.RIPair.Resource.Name;
				double value = demand.DemandValue;

				// create the demand wme
				sml.Identifier demandLink = taskLink.CreateIdWME("demand");

				// add the workload resource
				demandLink.CreateStringWME("resource", name);
				// add the workload value
				demandLink.CreateFloatWME("value", value);
			}
			//agent.Commit();
			kernel.CheckForIncomingCommands();

			return !agent.HadError();
		}
		public bool SetInput(string attribute, string value)
		{
			// get input link
			sml.Identifier input = agent.GetInputLink();
			// set value
			sml.StringElement el = input.CreateStringWME(attribute, value);
			return el != null;
		}
		public string GetOutput(string command, string parameter)
		{
			string output = null;
			// get output
			for (int i = 0; i < agent.GetNumberCommands(); i++)
			{
				sml.Identifier id = agent.GetCommand(i);
				if (id.GetCommandName() == command)
				{
					output = id.GetParameterValue(parameter);
				}
			}

			return output;
		}

		public bool KillKernel()
		{
			//this.log("killing kernel", "debug");
			kernel.Shutdown();
			return true;
		}

		#region IPlugin Implementation
		public string Password
		{
			get { return null; }
		}

		public MAAD.Utilities.Plugins.IPluginApplication PluginApplication
		{
			get;
			set;
		}

		public string PluginID
		{
			get { return "Scope plugin class"; }
		}

		public bool ReadOnly
		{
			get;
			set;
		}

		public string ReadOnlyPassword
		{
			get { return null; }
		}
		#endregion
	}
}
