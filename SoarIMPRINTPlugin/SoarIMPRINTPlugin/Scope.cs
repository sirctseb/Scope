using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Utility;
using SMLExtension;

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
		private const int TO_DELAY_TAG = 1957;
		private const int PERFORM_DELAY_KILL_TAG = 1958;

		// TODO test when IMPRINT creates plugin objects
		private static bool kernelInitialized = false;
		private static sml.Kernel kernel = null;
		public static sml.Agent agent = null;
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
			// high debug output
			this.logger.LogLevel = 5;
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
			app.AcceptTrace("Before begin effect: " + executor.Simulation.GetTask().Properties.ID);

			MAAD.Simulator.Utilities.IRuntimeTask task = executor.EventQueue.GetTask();

			// ignore the first and last task
			int taskID = int.Parse(task.ID);
			if (taskID == 999)
			{
				// check if the entity wants to kill / delay other ones
				// TODO this isn't strictly necessary, we could check for delays and kills every time
				// anything enters END
				if (executor.Simulation.GetEntity().Tag == PERFORM_DELAY_KILL_TAG)
				{
					// on END begin, check for entities that should be delayed
					foreach (MAAD.Simulator.IEntity entity in
						executor.Simulation.IModel.Find("Tag", TO_DELAY_TAG).Cast<MAAD.Simulator.IEntity>())
					{
						this.log("suspending to delay entity in " + entity.ID + ": " +
							executor.Simulation.IModel.Suspend(entity), 4);
						this.log("setting entity's tag to DELAY_TAG", 4);
						entity.Tag = DELAY_TAG;
					}
					// on END begin, check for entities that should be killed
					foreach (MAAD.Simulator.IEntity entity in
						executor.Simulation.IModel.Find("Tag", KILL_TAG).Cast<MAAD.Simulator.IEntity>())
					{
						this.log("killing entity in " + entity.ID + ": " +
							executor.Simulation.IModel.Abort(entity), 4);
					}
				}
			}
			else if (taskID > 0 && taskID < 999)
			{
				// add task to scope input to get a decision
				// TODO don't do this if the entitiy is TO_DELAY_TAG or KILL_TAG
				if (executor.Simulation.GetEntity().Tag == TO_DELAY_TAG ||
					executor.Simulation.GetEntity().Tag == KILL_TAG)
				{
					this.log("Begin: Got TO_DELAY or KILL tagged entity", 4);
				}

				// find corresponding MAAD.IMPRINTPro.NetworkTask
				MAAD.IMPRINTPro.NetworkTask nt = GetIMPRINTTaskFromRuntimeTask(task);
				if (nt != null)
				{
					this.log("Begin: adding release task: " + nt.ID);
					// add task props to Soar input
					sml.Identifier taskWME = AddReleaseTask(nt);

					// TODO make "run until it decides what to do" more robust
					// run the agent until it decides what to do
					this.log("Begin: Running scope to get release decision", 5);
					string output = agent.RunSelfTilOutput();
					sml.Identifier command = agent.GetCommand(0);
					// TODO if no command exists?
					// if(!agent.Commands())
					// get strategy name
					string strategy = command.GetParameterValue("name");
					this.log("Begin: Scope returned: " + strategy, 5);
					// TODO if command isn't a strategy somehow?
					// if(agent.GetCommandName() != "strategy")
					//string strategy = GetOutput("strategy", "name");
					//this.log("Output strategy was: " + strategy, 5);
					// execute the strategy
					ApplyStrategy(strategy, taskWME);
					// mark the command as complete
					command.AddStatusComplete();
					agent.ClearOutputLinkChanges();
					// log the decision
					scopeData.LogStrategy(strategy, executor.Simulation.Clock);
				}
			}
		}
		private void OnAfterEndingEffect(MAAD.Simulator.Executor executor)
		{
			this.log("Top of OnAfterEndingEffect: " + executor.Simulation.GetTask().Properties.Name, 5);
			MAAD.Simulator.Utilities.IRuntimeTask task = executor.EventQueue.GetTask();
			// ignore first and last tasks
			int taskID = int.Parse(task.ID);
			if (taskID > 0 && taskID < 999)
			{
				this.log("End: Removing task " + task.ID + " from input", 5);
				RemoveTask(GetIMPRINTTaskFromRuntimeTask(task));

				// check that there are any delayed tasks before trying to resume them
				// if we don't check, the scope agent can get confused
				if (executor.Simulation.IModel.Find("Tag", DELAY_TAG).Count > 0 ||
					executor.Simulation.IModel.Find("Tag", INTERRUPT_TAG).Count > 0)
				{
					this.log("End: found delayed or interrupted tasks, running scope for resume decision", 5);
					// run scope to decide if we should resume any delayed or interrupted tasks
					string output = agent.RunSelfTilOutput();
					// get result
					sml.Identifier command = agent.GetCommand(0);
					if (command != null)
					{
						// get strategy name
						string strategy = command.GetParameterValue("name");
						this.log("End: scope responds with: " + strategy, 5);
						if (strategy == "resume-delayed")
						{
							// scope says to resume a task
							// find the task scope wants to resume
							string taskIDString = command.FindIDByAttribute("task").FindStringByAttribute("taskID");
							//app.Executor.Simulation.IModel.Resume("ID", taskIDString);
							// search through entities in the task
							foreach (MAAD.Simulator.IEntity entity in app.Executor.Simulation.IModel.Find("ID", taskIDString))
							{
								// check if it is in a suspended state
								if (entity.Tag == DELAY_TAG)
								{
									// mark the entity to be resumed
									this.log("Scope: Resume delayed");
									// trace that we are resuming
									app.AcceptTrace("Marking delayed task to be resumed: " + executor.GetRuntimeTask(entity.ID).Properties.Name);
									// set tag to that release condition automatically accepts it
									// TODO there is now a gap between marking to resume and actually starting the task
									// TODO is this a problem?
									entity.Tag = RESUME_DELAY_TAG;
									// add the task as a real task
									//AddActiveTask(executor.GetRuntimeTask(entity.ID));
									// log that we resumed a task
									scopeData.LogStrategy("Resume Delayed", app.Executor.Simulation.Clock);
									// remove task from input, and it will be added as active in begin event
									this.log("End: removing DELAY task " + entity.ID + " and marking RESUME_DELAY", 5);
									RemoveTask(executor.GetRuntimeTask(entity.ID));
								}
								else if (entity.Tag == INTERRUPT_TAG)
								{
									this.log("Scope: Resume interrupted");
									// trace that we are resuming
									app.AcceptTrace("Resuming task " + entity.ID + ": " + executor.Simulation.IModel.Resume("ID", entity.ID));
									// TODO this should be restored from what it was before
									entity.Tag = 0;
									// add the task as a real task
									//AddActiveTask(executor.GetRuntimeTask(entity.ID));
									// log that we resumed a task
									scopeData.LogStrategy("Resume", app.Executor.Simulation.Clock);
									// log the decision that allowed for the resume
									scopeData.LogStrategy(strategy, app.Executor.Simulation.Clock);
									// force logging because there's no corresponding begin task
									// TODO this is a bad way to do this
									//scopeData.CommitStrategy();

									// remove ^delayed from WME
									command.FindIDByAttribute("task").FindByAttribute("delayed", 0).DestroyWME();
									// add ^active
									command.FindIDByAttribute("task").CreateStringWME("active", "yes");
								}
							}
						}
						command.AddStatusComplete();
						agent.ClearOutputLinkChanges();
					}
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
			return;
			this.log("Start OnAfterReleaseCondition: " + executor.Simulation.GetTask().Properties.Name, 5);

			// kill any entities that have been marked
			executor.Simulation.IModel.Abort("Tag", KILL_TAG);
			// TODO suspend any entities that have been marked delayed

			// check that entity hasn't been marked KILL_TAG yet
			if (executor.EventQueue.GetEntity().Tag == KILL_TAG)
			{
				this.log("KILL_TAG coming through release condition, rejecting", 3);
				release = false;
				return;
			}
			// check that entity isn't marked delayed
			if (executor.EventQueue.GetEntity().Tag == DELAY_TAG)
			{
				this.log("DELAY_TAG coming through release condition, rejecting", 3);
				release = false;
				return;
			}

			// if entity is marked to resume after delay, return true
			if (executor.EventQueue.GetEntity().Tag == RESUME_DELAY_TAG)
			{
				this.log("RESUME_DELAY_TAG coming through release condition, accepting", 3);
				// set tag to normal
				// TODO this should reset tag to what is was before
				executor.Simulation.GetEntity().Tag = 0;
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
					this.log("Release: adding release task: " + nt.ID);
					// add task props to Soar input
					sml.Identifier taskWME = AddReleaseTask(nt);

					// TODO make "run until it decides what to do" more robust
					// run the agent until it decides what to do
					this.log("Release: Running scope to get release decision",5);
					string output = agent.RunSelfTilOutput();
					sml.Identifier command = agent.GetCommand(0);
					// TODO if no command exists?
					// if(!agent.Commands())
					// get strategy name
					string strategy = command.GetParameterValue("name");
					this.log("Release: Scope returned: " + strategy, 5);
					// TODO if command isn't a strategy somehow?
					// if(agent.GetCommandName() != "strategy")
					//string strategy = GetOutput("strategy", "name");
					//this.log("Output strategy was: " + strategy, 5);
					// execute the strategy
					release = ApplyStrategy(strategy, taskWME);
					// mark the command as complete
					command.AddStatusComplete();
					agent.ClearOutputLinkChanges();
					// log the decision
					scopeData.LogStrategy(strategy, executor.Simulation.Clock);
				}
			}
		}
		public void OnAfterDuration(MAAD.Simulator.Executor executor, ref double number)
		{
			this.log("OnAfterDuration for task: " + executor.Simulation.GetTask().Properties.ID);
		}
		public void OnAfterLaunchEffect(MAAD.Simulator.Executor executor)
		{
			this.log("OnAfterLaunchEffect for task: " + executor.Simulation.GetTask().Properties.ID);
		}
		public void OnBeforeDuration(MAAD.Simulator.Executor executor)
		{
			this.log("OnBeforeDuration for task: " + executor.Simulation.GetTask().Properties.ID);
		}
		public void OnBeforeLaunchEffect(MAAD.Simulator.Executor executor)
		{
			this.log("OnBeforeLaunchEffect for task: " + executor.Simulation.GetTask().Properties.ID);
		}
		public void OnAfterBeginningEffect(MAAD.Simulator.Executor executor)
		{
			this.log("OneAfterBeginningEffect for task: " + executor.Simulation.GetTask().Properties.ID);
		}
		private MAAD.Simulator.Utilities.DSimulationEvent OBBE;
		private MAAD.Simulator.Utilities.DSimulationBoolEvent OARC;
		private MAAD.Simulator.Utilities.DSimulationEvent OAEE;
		private MAAD.Simulator.Utilities.DNetworkEvent OSB;
		private MAAD.Simulator.Utilities.DNetworkEvent OSC;
		private MAAD.Simulator.Utilities.DSimulationDoubleEvent OAD;
		private MAAD.Simulator.Utilities.DSimulationEvent OALE;
		private MAAD.Simulator.Utilities.DSimulationEvent OBD;
		private MAAD.Simulator.Utilities.DSimulationEvent OBLE;
		private MAAD.Simulator.Utilities.DSimulationEvent OABE;
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

			// testing other events
			//app.Generator.OnAddEntityToEventQueue += new MAAD.Simulator.Utilities.DSimulationAddEvent(Generator_OnAddEntityToEventQueue);
			//app.Generator.OnAfterAddEntityToEventQueue += new MAAD.Simulator.Utilities.DSimulationEntityEvent(Generator_OnAfterAddEntityToEventQueue);
			//public delegate void DSimulationDoubleEvent(Executor executor, ref double number);
			app.Generator.OnAfterDuration += OAD = new MAAD.Simulator.Utilities.DSimulationDoubleEvent(OnAfterDuration);
			//app.Generator.OnAfterEntitiesAborted += new MAAD.Simulator.Utilities.DSimulationModificationEvent(Generator_OnAfterEntitiesAborted);
			//app.Generator.OnAfterGetNextEvents += new MAAD.Simulator.Utilities.DSimulationArrayListEvent(Generator_OnAfterGetNextEvents);
			//public delegate void DSimulationEvent(Executor executor);
			app.Generator.OnAfterLaunchEffect += OALE = new MAAD.Simulator.Utilities.DSimulationEvent(OnAfterLaunchEffect);
			app.Generator.OnBeforeDuration += OBD = new MAAD.Simulator.Utilities.DSimulationEvent(OnBeforeDuration);
			//public delegate void DSimulationDoubleEvent(Executor executor, ref double number);
			//app.Generator.OnAfterQueuePriorityCode += new MAAD.Simulator.Utilities.DSimulationDoubleEvent(Generator_OnAfterQueuePriorityCode);
			app.Generator.OnBeforeLaunchEffect += OBLE = new MAAD.Simulator.Utilities.DSimulationEvent(OnBeforeLaunchEffect);
			//app.Generator.OnEntityMerged += new MAAD.Simulator.Utilities.DSimulationEntityEvent(Generator_OnEntityMerged);
			app.Generator.OnAfterBeginningEffect += OABE = new MAAD.Simulator.Utilities.DSimulationEvent(OnAfterBeginningEffect);
		}
		public void UnregisterEvents()
		{
			app.Generator.OnAfterReleaseCondition -= OARC;
			app.Generator.OnBeforeBeginningEffect -= OBBE;
			app.Generator.OnSimulationBegin -= OSB;
			app.Generator.OnSimulationComplete -= OSC;
			app.Generator.OnAfterEndingEffect -= OAEE;

			app.Generator.OnAfterDuration -= OAD;
			app.Generator.OnAfterLaunchEffect -= OALE;
			app.Generator.OnBeforeDuration -= OBD;
			app.Generator.OnBeforeLaunchEffect -= OBLE;
		}

		#region IMPRINT communication stuff
		private bool ApplyStrategy(string strategy, sml.Identifier taskWME)
		{
			// get the strategy name
			//string strategy = GetOutput("strategy", "name");
			// TODO make a class to handle this stuff
			this.log("Applying strategy " + strategy, 5);
			switch (strategy)
			{
				case "delay-new":
					this.log("Scope: Delay new task");
					// mark DELAY_TAG
					app.Executor.EventQueue.GetEntity().Tag = TO_DELAY_TAG;
					// add ^delayed yes to WME
					this.log("Delay: add ^delayed: " + taskWME.CreateStringWME("delayed", "yes").GetValue(), 5);
					// remove ^release from WME
					this.log("Delay: remove ^release: " + taskWME.FindByAttribute("release", 0).DestroyWME(), 5);
					// start an entity in END so that this will be suspended
					app.Executor.Simulation.IModel.Start("999", PERFORM_DELAY_KILL_TAG);
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
					// start an entity in END so that this will be suspended
					// TODO this requires that the task we want to suspend has non-zero duration
					// we could enforce this by checking the tag in onafterduration and making sure
					// the duration is non-zero
					app.Executor.Simulation.IModel.Start("999", PERFORM_DELAY_KILL_TAG);
					// return false because entity should not be released
					return false;
					break;
				case "perform-all":
					// no action needed
					this.log("Scope: Perform all tasks");
					// destroy the task input element and it will be added later on task begin
					//taskWME.DestroyWME();
					// remove ^release and add ^active
					taskWME.FindByAttribute("release", 0).DestroyWME();
					taskWME.CreateStringWME("active", "yes");
					// return true because entity should be released
					return true;
					break;
				case "interrupt-task":
					this.log("Scope: Interrupt task");

					// get task which should be interrupted
					/*sml.Identifier interruptedTaskWME = agent.GetOutputLink()
															 .FindIDByAttribute("strategy")
															 .FindIDByAttribute("interrupt-task");*/
					sml.Identifier interruptedTaskWME = agent.GetOutputLink().GetIDAtAttributePath("strategy.interrupt-task");
					string taskID = interruptedTaskWME.FindStringByAttribute("taskID");
					// suspend entity(ies?) in task
					// TODO this will abort all entities in task. should we include entity tag?
					// suspend, and ask Scope if we can restart once in a while (in end effect?)
					app.AcceptTrace("Interrupting " + app.Executor.Simulation.IModel.FindTask(taskID).Properties.Name + ": " + app.Executor.Simulation.IModel.Suspend("ID", taskID));
					// remove task from Scope
					// TODO should we actually annotate with ^suspend yes and to let Scope know more about what's happening?
					//RemoveTask(GetIMPRINTTaskFromRuntimeTask(app.Executor.Simulation.IModel.FindTask(taskID)));
					// TODO for some reason we have to remove ^active before adding ^delayed, otherwise it crashes. we should figure out why
					// remove ^active from WME
					this.log("Interrupt: remove ^active: " + interruptedTaskWME.FindByAttribute("active", 0).DestroyWME(), 5);
					// add ^delayed yes to WME
					this.log("Interrupt: add ^delayed: " + interruptedTaskWME.CreateStringWME("delayed", "yes").GetValue(), 5);
					// give entity the INTERRUPT_TAG tag
					// TODO this could be disruptive if the model is otherwise using tags
					foreach (MAAD.Simulator.IEntity entity in app.Executor.Simulation.IModel.Find("ID", taskID))
					{
						// TODO at the very least, we should restore the original tag when we resume
						entity.Tag = INTERRUPT_TAG;
					}
					// destroy the task input element and it will be added later on task begin
					//taskWME.DestroyWME();
					// remove release and add active
					taskWME.FindByAttribute("release", 0).DestroyWME();
					taskWME.CreateStringWME("active", "yes");
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
		// WARNING: DO NOT USE. only still used temporarily for test console app
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
