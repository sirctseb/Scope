using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SoarIMPRINTPlugin
{
	public class Scope : IMPRINTLogger, MAAD.Utilities.Plugins.IPlugin
	{
		// TODO test when IMPRINT creates plugin objects
		private bool kernelInitialized = false;
		private sml.Kernel kernel = null;
		private sml.Agent agent = null;
		public string ScopeOutput = null;
		private bool eventsRegistered = false;

		public Scope()
		{
			enable("debug");
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
			// TODO add task props to Soar input
		}
		public void OnSimulationBegin(object sender, EventArgs e)
		{
			CreateKernel();
			InitializeScope();
		}
		public void OnSimulationComplete(object sender, EventArgs e)
		{
			KillKernel();
		}
		public void RegisterEvents()
		{
			if(!eventsRegistered) {
				app.Generator.OnBeforeBeginningEffect +=
					new MAAD.Simulator.Utilities.DSimulationEvent(OnBeforeBeginningEffect);
				app.Generator.OnSimulationBegin +=
					new MAAD.Simulator.Utilities.DNetworkEvent(OnSimulationBegin);
				app.Generator.OnSimulationComplete +=
					new MAAD.Simulator.Utilities.DNetworkEvent(OnSimulationComplete);
			}
		}

		public bool CreateKernel()
		{
			kernel = sml.Kernel.CreateKernelInNewThread();
			log("Creating kernel: " + kernel.HadError(), "debug");
			
			return kernelInitialized = !kernel.HadError();
		}

		public bool InitializeScope()
		{
			return InitializeScope("Scope/agent/test-agent.soar");
		}
		public bool InitializeScope(string source)
		{
			// create the agent
			agent = kernel.CreateAgent("scope-agent");
			if (kernel.HadError()) return false;

			// load scope productions
			// TODO load test productions for now
			agent.LoadProductions(source);
			if (agent.HadError()) return false;

			return true;
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
			log("killing kernel", "debug");

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
