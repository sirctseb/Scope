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

		private ScopeData scopeData = new ScopeData();
		private const int KILL_TAG = 1953;
		private const int INTERRUPT_TAG = 1954;
		private const int DELAY_TAG = 1955;
		private const int RESUME_DELAY_TAG = 1956;

		// TODO test when IMPRINT creates plugin objects
		private static bool kernelInitialized = false;
		private static sml.Kernel kernel = null;
		private static sml.Agent agent = null;
		public string ScopeOutput = null;
		private bool eventsRegistered = false;

		// hold the last decision & time so that we can filter duplicate perfom-alls
		private string lastStrategyDecision;
		private double lastStrategyDecisionTime;

		public Scope()
		{
			//app.AcceptTrace("Scope Constructor");
			logger = new IMPRINTLogger();
			this.enable("debug");
		}

		public void EnableScope()
		{
			CreateKernel();
			InitializeScope();
			RegisterEvents();
			// TODO we don't catch OnSimulationBegin if we wait for first task begin to initialize
			ResetSoar();
			app.AcceptTrace("Enable Scope Called");
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
			app.AcceptTrace("Before begin effect: " + executor.Simulation.GetTask().Properties.Name);
			// TODO if a KILL_TAG entity gets here, something has gone wrong
			// check that entity hasn't been marked KILL_TAG yet
			if (executor.EventQueue.GetEntity().Tag == KILL_TAG)
			{
				logger.log("KILL_TAG in Beginning Effect!");
				return;
			}

			MAAD.Simulator.Utilities.IRuntimeTask task = executor.EventQueue.GetTask();

			// ignore the first and last task
			int taskID = int.Parse(task.ID);
			if (taskID > 0 && taskID < 999)
			{
				// if the strategy that allowed this task to begin was a perform-all returned
				// to OnAfterReleaseCondition, then the strategy was submitted to the log but
				// has not yet been entered to prevent multiple entries for the same perform-all.
				// enter it to the log here
				scopeData.CommitStrategy();
				// find corresponding MAAD.IMPRINTPro.NetworkTask
				MAAD.IMPRINTPro.NetworkTask nt = GetIMPRINTTaskFromRuntimeTask(task);
				if (nt != null)
				{
					// add task props to Soar input
					sml.Identifier taskWME = AddActiveTask(nt);
				}
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

			// check to see if we should resume interrupted tasks
			foreach (MAAD.Simulator.IEntity entity in app.Executor.Simulation.IModel.Find("Tag", INTERRUPT_TAG))
			{
				// add the task in release condition
				// TODO may eventually do ^resume instead of ^release if we want to have separate reasoning
				AddReleaseTask(executor.GetRuntimeTask(entity.ID));
				// see what scope says
				string output = agent.RunSelfTilOutput();
				// get result
				string strategy = GetOutput("strategy", "name");
				// remove task as a release task
				RemoveTask(executor.GetRuntimeTask(entity.ID));
				// instead of returning release, resume the task if it is true
				//if (release)
				// TODO sometimes tasks are resumed by interrupting other tasks and that causes problems
				if (strategy == "perform-all")
				{
					this.log("Scope: Perform all tasks");
					// trace that we are resuming
					app.AcceptTrace("Resuming task " + executor.GetRuntimeTask(entity.ID).Properties.Name + ": " + executor.Simulation.IModel.Resume("ID", entity.ID));
					// TODO this should be restored from what it was before
					entity.Tag = 0;
					// add the task as a real task
					AddActiveTask(executor.GetRuntimeTask(entity.ID));
					// log that we resumed a task
					scopeData.LogStrategy("Resume", app.Executor.Simulation.Clock);
					// log the decision that allowed for the resume
					scopeData.LogStrategy(strategy, app.Executor.Simulation.Clock);
					// force logging because there's no corresponding begin task
					// TODO this is a bad way to do this
					scopeData.CommitStrategy();
				}
			}
			// check to see if we should 'resume' delayed tasks
			foreach (MAAD.Simulator.IEntity entity in app.Executor.Simulation.IModel.Find("Tag", DELAY_TAG))
			{
				// run scope
				string output = agent.RunSelfTilOutput();
				// get result
				string strategy = GetOutput("strategy", "name");
				if (strategy == "resume-delayed")
				{
					this.log("Scope: Resume delayed");
					// trace that we are resuming
					app.AcceptTrace("Marking delayed task to be resumed: " + executor.GetRuntimeTask(entity.ID).Properties.Name);
					// set tag to that release condition automatically accepts it
					// TODO there is now a gap between marking to resume and actually starting the task
					// TODO is this a problem?
					entity.Tag = RESUME_DELAY_TAG;
					// add the task as a real task
					AddActiveTask(executor.GetRuntimeTask(entity.ID));
					// log that we resumed a task
					scopeData.LogStrategy("Resume Delayed", app.Executor.Simulation.Clock);
				}
			}
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
			// write data
			scopeData.WriteCounts("C:\\Users\\christopher.j.best2\\Documents\\ScopeData\\scope_counts.txt");
			scopeData.WriteTrace("C:\\Users\\christopher.j.best2\\Documents\\ScopeData\\scope_trace.txt");
		}
		public void OnAfterReleaseCondition(MAAD.Simulator.Executor executor, ref bool release)
		{
			// kill any entities that have been marked
			executor.Simulation.IModel.Abort("Tag", KILL_TAG);
			// TODO suspend any entities that have been marked delayed

			// check that entity hasn't been marked KILL_TAG yet
			if (executor.EventQueue.GetEntity().Tag == KILL_TAG)
			{
				release = false;
				return;
			}
			// check that entity isn't marked delayed
			if (executor.EventQueue.GetEntity().Tag == DELAY_TAG)
			{
				release = false;
				return;
			}

			// if entity is marked to resume after delay, return true
			if (executor.EventQueue.GetEntity().Tag == RESUME_DELAY_TAG)
			{
				release = true;
				return;
			}

			MAAD.Simulator.Utilities.IRuntimeTask task = executor.EventQueue.GetTask();

			// ignore the first and last task
			int taskID = int.Parse(task.ID);
			if (taskID > 0 && taskID < 999)
			{
				// find corresponding MAAD.IMPRINTPro.NetworkTask
				MAAD.IMPRINTPro.NetworkTask nt = GetIMPRINTTaskFromRuntimeTask(task);
				if (nt != null)
				{
					// add task props to Soar input
					sml.Identifier taskWME = AddReleaseTask(nt);

					// TODO make "run until it decides what to do" more robust
					// run the agent until it decides what to do
					string output = agent.RunSelfTilOutput();
					string strategy = GetOutput("strategy", "name");
					//app.AcceptTrace(strategy);
					// execute the strategy
					release = ApplyStrategy(strategy, taskWME);
					// log the decision
					scopeData.LogStrategy(strategy, executor.Simulation.Clock);
				}
			}
		}

		private MAAD.Simulator.Utilities.DSimulationEvent OBBE;
		private MAAD.Simulator.Utilities.DSimulationBoolEvent OARC;
		private MAAD.Simulator.Utilities.DSimulationEvent OAEE;
		private MAAD.Simulator.Utilities.DNetworkEvent OSB;
		private MAAD.Simulator.Utilities.DNetworkEvent OSC;
		public void RegisterEvents()
		{
			app.Generator.OnAfterReleaseCondition +=
				OARC = new MAAD.Simulator.Utilities.DSimulationBoolEvent(OnAfterReleaseCondition);
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
			app.Generator.OnAfterReleaseCondition -= OARC;
			app.Generator.OnBeforeBeginningEffect -= OBBE;
			app.Generator.OnSimulationBegin -= OSB;
			app.Generator.OnSimulationComplete -= OSC;
			app.Generator.OnAfterEndingEffect -= OAEE;
		}

		#region IMPRINT communication stuff
		private bool ApplyStrategy(string strategy, sml.Identifier taskWME)
		{
			// get the strategy name
			//string strategy = GetOutput("strategy", "name");
			// TODO make a class to handle this stuff
			switch (strategy)
			{
				case "delay-new":
					this.log("Scope: Delay new task");
					// mark DELAY_TAG
					app.Executor.EventQueue.GetEntity().Tag = DELAY_TAG;
					// add ^delayed yes to WME
					taskWME.CreateStringWME("delayed", "yes");
					// remove ^release from WME
					taskWME.FindByAttribute("release", 0).DestroyWME();
					// TODO can an entity be suspended in release condition event? NOPE
					//app.AcceptTrace("Suspend for delay: " + app.Executor.Simulation.IModel.Suspend("Tag", DELAY_TAG));
					// return false so the entity is not released
					return false;
					break;
				case "ignore-new":
					this.log("Scope: Ignore new task");
					// mark KILL_TAG
					app.Executor.EventQueue.GetEntity().Tag = KILL_TAG;
					// destroy the task input element
					taskWME.DestroyWME();
					// return false because entity should not be released
					return false;
					break;
				case "perform-all":
					// no action needed
					this.log("Scope: Perform all tasks");
					// destroy the task input element and it will be added later on task begin
					taskWME.DestroyWME();
					// return true because entity should be released
					return true;
					break;
				case "interrupt-task":
					this.log("Scope: Interrupt task");

					// get task which should be interrupted
					string taskID = agent.GetOutputLink()
											.FindIDByAttribute("strategy")
											.FindIDByAttribute("interrupt-task")
											.FindStringByAttribute("taskID");
					// suspend entity(ies?) in task
					// TODO this will abort all entities in task. should we include entity tag?
					// suspend, and ask Scope if we can restart once in a while (in end effect?)
					app.AcceptTrace("Interrupting " + app.Executor.Simulation.IModel.FindTask(taskID).Properties.Name + ": " + app.Executor.Simulation.IModel.Suspend("ID", taskID));
					// remove task from Scope
					// TODO should we actually annotate with ^suspend yes and to let Scope know more about what's happening?
					RemoveTask(GetIMPRINTTaskFromRuntimeTask(app.Executor.Simulation.IModel.FindTask(taskID)));
					// give entity the SUSPEND_TAG tag
					// TODO this could be disruptive if the model is otherwise using tags
					foreach (MAAD.Simulator.IEntity entity in app.Executor.Simulation.IModel.Find("ID", taskID))
					{
						// TODO at the very least, we should restore the original tag when we resume
						entity.Tag = INTERRUPT_TAG;
					}
					// destroy the task input element and it will be added later on task begin
					taskWME.DestroyWME();
					// return true because entity should be released
					return true;
					break;
				default:
					break;
			}
			return true;

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

			// TODO I don't know why agent.InitSoar() doesn't clear the input link
			sml.WMElement element;
			while ((element = agent.GetInputLink().FindByAttribute("task", 0)) != null)
			{
				element.DestroyWME();
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

		// TODO we should save the sml.Identifier we get from AddTask instead of
		// relying on task ID because this may cause problems if multiple entities go through
		// a task
		public bool RemoveTask(MAAD.Simulator.Utilities.IRuntimeTask task)
		{
			return RemoveTask(GetIMPRINTTaskFromRuntimeTask(task));
		}
		public bool RemoveTask(MAAD.IMPRINTPro.NetworkTask task)
		{
			// get input link
			sml.Identifier input = agent.GetInputLink();

			foreach (sml.Identifier taskLink in input.GetIDChildren("task"))
			{
				if (taskLink.FindStringByAttribute("taskID") == task.ID)
				{
					taskLink.DestroyWME();
					break;
				}
			}

			// search tasks for this one
			/*for (int i = 0; i < input.GetNumberChildren(); i++)
			{
				sml.WMElement child = input.GetChild(i);
				if (child.IsIdentifier())
				{
					sml.Identifier childID = child.ConvertToIdentifier();
					if (childID.FindByAttribute("taskID", 0).GetValueAsString() == task.ID)
					{
						//this.log("Removing input task: " + childID.DestroyWME());
						childID.DestroyWME();
						break;
					}
				}
			}*/
			return true;
		}
		public sml.Identifier AddTask(MAAD.IMPRINTPro.NetworkTask task)
		{
			// get input link
			sml.Identifier input = agent.GetInputLink();

			// create a wme for the task
			sml.Identifier taskLink = input.CreateIdWME("task");

			// add the task ID
			taskLink.CreateStringWME("taskID", task.ID);

			double totalWorkload = 0;
			//foreach (MAAD.IMPRINTPro.Interfaces.ITaskDemand demand in task.TaskDemandList.GetITaskDemands())
			// Looks like GetITaskDemands doesn't exist in 3.1.0.86. Using Active instead, hopefully it's the same
			// similarly, MAAD.IMPRINTPro.Interfaces.ITaskDemand -> MAAD.IMPRINTPro.TaskDemand
			foreach (MAAD.IMPRINTPro.TaskDemand demand in task.TaskDemandList.Active)
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

			//return !agent.HadError();
			return taskLink;
		}
		public sml.Identifier AddActiveTask(MAAD.Simulator.Utilities.IRuntimeTask task)
		{
			return AddActiveTask(GetIMPRINTTaskFromRuntimeTask(task));
		}
		public sml.Identifier AddActiveTask(MAAD.IMPRINTPro.NetworkTask task)
		{
			sml.Identifier taskWME = AddTask(task);
			// add active attribute
			taskWME.CreateStringWME("active", "yes");
			return taskWME;
		}
		public sml.Identifier AddReleaseTask(MAAD.Simulator.Utilities.IRuntimeTask task)
		{
			return AddReleaseTask(GetIMPRINTTaskFromRuntimeTask(task));
		}
		public sml.Identifier AddReleaseTask(MAAD.IMPRINTPro.NetworkTask task)
		{
			sml.Identifier taskWME = AddTask(task);
			// add release attribute
			taskWME.CreateStringWME("release", "yes");
			return taskWME;
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
