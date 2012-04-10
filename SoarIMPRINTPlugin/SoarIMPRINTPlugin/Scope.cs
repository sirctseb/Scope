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

		private MAAD.IMPRINTPro.NetworkTask GetIMPRINTTaskFromRuntimeTask(MAAD.Simulator.Utilities.IRuntimeTask t)
		{
			// find corresponding MAAD.IMPRINTPro.NetworkTask
			foreach (MAAD.IMPRINTPro.NetworkTask nt in this.GetTaskList())
			{
				if (nt.ID == t.ID)
				{
					return nt;
				}
			}
			return null;
		}
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
				MAAD.IMPRINTPro.NetworkTask nt = GetIMPRINTTaskFromRuntimeTask(task);

				if (nt != null)
				{
					// add task props to Soar input
					AddTask(nt);
				}

				// TODO make "run until it decides what to do" more robust
				// run the agent until it decides what to do
				string output = agent.RunSelfTilOutput();
				//app.AcceptTrace(output);
				//app.AcceptTrace(GetOutput("strategy", "name"));
				// execute the strategy
				ApplyStrategy();
			}
		}
		private void OnAfterEndingEffect(MAAD.Simulator.Executor executor)
		{
			MAAD.Simulator.Utilities.IRuntimeTask task = executor.EventQueue.GetTask();
			// ignore first and last tasks
			int taskID = int.Parse(task.ID);
			if (taskID > 0 && taskID < 999)
			{
				RemoveTask(GetIMPRINTTaskFromRuntimeTask(task));
			}
			// can we kill entities here?
			//this.log("Aborting after end: " + app.Executor.Simulation.Model.Abort("Tag", app.Executor.EventQueue.GetEntity().Tag));
			//this.log("Aborting after end: " + app.Executor.Simulation.Model.Abort(app.Executor.EventQueue.GetEntity()));
			//this.log("task: " + app.Executor.EventQueue.GetTask().ID);
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
		private MAAD.Simulator.Utilities.DSimulationEvent OAEE;
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
			app.Generator.OnAfterEndingEffect +=
				OAEE = new MAAD.Simulator.Utilities.DSimulationEvent(OnAfterEndingEffect);
		}
		public void UnregisterEvents()
		{
			app.Generator.OnBeforeBeginningEffect -= OBBE;
			app.Generator.OnSimulationBegin -= OSB;
			app.Generator.OnSimulationComplete -= OSC;
			app.Generator.OnAfterEndingEffect -= OAEE;
		}

		#region IMPRINT communication stuff
		private void ApplyStrategy()
		{
			// get the strategy name
			string strategy = GetOutput("strategy", "name");
			// TODO make a class to handle this stuff
			switch (strategy)
			{
				case "ignore-new":
					// kill the entity in the newly started task
					// TODO trying to remove entity if Soar says to ignore it
					//this.log("Aborting: " + app.Executor.Simulation.Model.Abort("Tag", app.Executor.EventQueue.GetEntity().Tag));
					MAAD.Simulator.Utilities.IRuntimeTask task = app.Executor.EventQueue.GetTask();
					app.AcceptTrace("items in task: " + task.ItemsInTask);
					//app.Executor.EventQueue.AddEntityAction(app.Executor.EventQueue.GetEntity(), MAAD.Simulator.Utilities.EEntityAction.Suspend);
					app.Executor.EventQueue.GetTask().Remove(app.Executor.EventQueue.GetEntity(), MAAD.Simulator.Utilities.ETaskCollection.Task);

					this.log("Aborting: " + app.Executor.Simulation.Model.Abort(app.Executor.EventQueue.GetEntity()));

					app.AcceptTrace("items in task: " + task.ItemsInTask);
					this.log("Scope: Ignore new task");
					break;
				case "perform-all":
					// no action needed
					this.log("Scope: Perform all tasks");
					break;
				case "interrupt-task":
					this.log("Scope: Interrupt task");
					break;
				default:
					break;
			}

		}
		#endregion

		#region soar communication stuff
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
			// reinitialize
			this.log("Scope: initSoar: " + agent.InitSoar());
			this.log("is commit required: " + kernel.IsCommitRequired());
			this.log("Initializing soar");

			// tell Soar we are providing input
			if (agent.GetInputLink().FindByAttribute("IMPRINT", 0) == null)
			{
				agent.GetInputLink().CreateStringWME("IMPRINT", "yes");
				// sneak in a threshold value too
				agent.GetInputLink().CreateFloatWME("threshold", 8);
				this.log("putting IMPRINT on input link");
			}

			return !agent.HadError();
		}

		public bool RunAgent(int steps)
		{

			// run agent for 3 steps
			agent.RunSelf(steps);
			if (agent.HadError()) return false;

			return true;
		}

		public bool RemoveTask(MAAD.IMPRINTPro.NetworkTask task)
		{
			// get input link
			sml.Identifier input = agent.GetInputLink();

			// search tasks for this one
			for (int i = 0; i < input.GetNumberChildren(); i++)
			{
				sml.WMElement child = input.GetChild(i);
				if (child.IsIdentifier())
				{
					sml.Identifier childID = child.ConvertToIdentifier();
					if (childID.FindByAttribute("taskID", 0).GetValueAsString() == task.ID)
					{
						this.log("Removing input task: " + childID.DestroyWME());
						break;
					}
				}


				//sml.IdentifierSymbol blah = child.GetIdentifier();

				/*sml.StringElement taskIDElement = (sml.StringElement)child.FindByAttribute("taskID", 0);
				string taskID = taskIDElement.GetValue();
				if (taskID == task.ID)
				{
					this.log("Removing input task: " + child.DestroyWME());
					break;
				}*/
			}
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

			double totalWorkload = 0;
			foreach (MAAD.IMPRINTPro.Interfaces.ITaskDemand demand in task.TaskDemandList.GetITaskDemands)
			{
				// get workload attributes
				string name = demand.RIPair.Resource.Name;
				double value = demand.DemandValue;

				// create the demand wme
				sml.Identifier demandLink = taskLink.CreateIdWME("demand");

				// add the workload resource
				demandLink.CreateStringWME("resource", name);
				// add the workload value
				demandLink.CreateFloatWME("value", value);


				// TODO temporary
				totalWorkload += value;
			}
			// add sum of workload values as total workload
			taskLink.CreateFloatWME("workload", totalWorkload);

			// TODO add task duration
			// TODO add task priority
			//taskLink.CreateFloatWME("duration", task.TaskPriority

			//agent.Commit();
			//kernel.CheckForIncomingCommands();

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
					// TODO I don't really think this should be done here
					id.AddStatusComplete();
					agent.ClearOutputLinkChanges();
					agent.Commit();
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
		#endregion

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
