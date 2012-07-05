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

		// class to represent a deferred action
		public class DeferredDecision
		{
			public enum DecisionType
			{
				RejectDecision,
				DelayDecision,
				PerformAllDecision,
				InterruptDecision,
				ResumeDecision
			}

			// what the decision was
			public DecisionType type;
			// what time the entity was scheduled to begin
			public double scheduledBeginTime;
			// the unique ID of the entity that the decision pertains to
			public int uniqueID;
		}
		public class InterruptDecision : DeferredDecision
		{
			// unique id of the entity this is supposed to interrupt
			public int interruptUniqueID;
		}

		// a set of currently deferred actions
		HashSet<DeferredDecision> deferredDecisions = new HashSet<DeferredDecision>();

		// the one decision that led to the entity in BE
		DeferredDecision lastDecision = null;

		// properties we can ascribe to entities
		public enum EntityProperty
		{
			RejectDuplicateEntity,
			IgnoreEntity,
			InterruptEntity,
			DelayEntity,
			TentativeDelayEntity,
			ResumeEntity,
			ResumePurgatoryEntity
		};
		
		// a class to manage entity markings
		public class MutliDict<TKey, TValue> : Dictionary<TKey, HashSet<TValue> >
		{
			// determine if an entity has a property
			public bool Contains(TKey key, TValue value) {
				if(this.ContainsKey(key)) {
					return this[key].Contains(value);
				}
				return false;
			}
			// add property to entity
			public bool Add(TKey key, TValue value)
			{
				// if no properties for this entry, add the set
				if (!this.ContainsKey(key))
				{
					this[key] = new HashSet<TValue>();
				}
				// add the property
				return this[key].Add(value);
			}
			// remove property from entity
			public bool Remove(TKey key, TValue value)
			{
				if (this.ContainsKey(key))
				{
					return this[key].Remove(value);
				}
				return false;
			}
		}
		public class EntityProperties : MutliDict<int, EntityProperty>
		{
			public bool EntityHas(int ID, EntityProperty property)
			{
				return Contains(ID, property);
			}
			public bool AddProp(int ID, EntityProperty property)
			{
				return Add(ID, property);
			}
			public bool RemoveProp(int ID, EntityProperty property)
			{
				return Remove(ID, property);
			}
			public IEnumerable<int> EntitiesWith(EntityProperty property) {
				return Keys.Where(key => EntityHas(key, property));
			}
		}

		private EntityProperties entityProperties = new EntityProperties();

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

		// check if there are delayed or rejected entities that we should act on
		// TODO what events should call this?
		// TODO why not just call from that event for when the clock changes?
		private void CheckForDelaysAndRejects(double Clock)
		{
			// check each defered event
			foreach (DeferredDecision decision in this.deferredDecisions.Where(decision => decision.scheduledBeginTime < Clock))
			{
				this.log("Clock advanced, checking " + decision.type + " for action", 6);

				// check if clock is past the scheduled start of the decision
				if (decision.scheduledBeginTime < Clock)
				{
					// act on the decision
					if (decision.type == DeferredDecision.DecisionType.RejectDecision)
					{
						// kill the entity
						this.log("Killing entity for ignore-task: " +
							app.Executor.Simulation.IModel.Abort("UniqueID", decision.uniqueID)
							);
					}
					else if (decision.type == DeferredDecision.DecisionType.DelayDecision)
					{
						// change the entity property from tentative delay to actually delayed
						entityProperties.RemoveProp(decision.uniqueID, EntityProperty.TentativeDelayEntity);
						entityProperties.AddProp(decision.uniqueID, EntityProperty.DelayEntity);

						// add task as delayed in scope
						string ID = ((MAAD.Simulator.IEntity)app.Executor.Simulation.IModel.Find("UniqueID", decision.uniqueID)[0]).ID;
						this.AddTask(app.Executor.Simulation.IModel.FindTask(ID)).CreateStringWME("delayed", "yes");
					}
				}
			}
			// remove processed decisions from set
			deferredDecisions.RemoveWhere(decision => decision.scheduledBeginTime < Clock);
		}

		//public delegate void DSimulationEvent(Executor executor);
		//public delegate void DNetworkEvent(object sender, EventArgs e);
		private void OnBeforeBeginningEffect(MAAD.Simulator.Executor executor)
		{
			app.AcceptTrace("Before begin effect: " + executor.Simulation.GetTask().Properties.Name);

			// TODO checking for bug that should exist (see RC handler)
			// once an entity starts its task, it is out of resume purgatory
			entityProperties.RemoveProp(executor.Simulation.GetEntity().UniqueID, EntityProperty.ResumePurgatoryEntity);

			// TODO if a KILL_TAG entity gets here, something has gone wrong
			// check that entity hasn't been marked KILL_TAG yet
			//if (executor.EventQueue.GetEntity().Tag == KILL_TAG)
			if(entityProperties.EntityHas(executor.EventQueue.GetEntity().UniqueID, EntityProperty.IgnoreEntity))
			{
				logger.log("KILL_TAG in Beginning Effect!");
				return;
			}

			MAAD.Simulator.Utilities.IRuntimeTask task = executor.EventQueue.GetTask();

			// ignore the first and last task
			int taskID = int.Parse(task.ID);
			if (taskID > 0 && taskID < 999)
			{
				// sanity check: any entity starting this task should be referenced in the last decision
				if (executor.Simulation.GetEntity().UniqueID != lastDecision.uniqueID)
				{
					this.log("Entity beginning task that is not in last decision");
					throw new Exception("Entity beginning task that is not in last decision");
				}

				// if the strategy that allowed this task to begin was a perform-all returned
				// to OnAfterReleaseCondition, then the strategy was submitted to the log but
				// has not yet been entered to prevent multiple entries for the same perform-all.
				// enter it to the log here
				scopeData.CommitStrategy();

				// if entity is starting because of interrupt-task strategy, suspend the other task
				if (lastDecision.type == DeferredDecision.DecisionType.InterruptDecision)
				{
					// suspend task
					this.log("suspending entity for interrupt-task: " +
						executor.Simulation.IModel.Suspend("UniqueID", ((InterruptDecision)lastDecision).interruptUniqueID)
						, 3);

					// get interrupted task ID
					string ID = ((MAAD.Simulator.IEntity)executor.Simulation.IModel.Find("UniqueID", ((InterruptDecision)lastDecision).interruptUniqueID)[0]).ID;

					// add ^delayed to scope task and take off ^active
					sml.Identifier interruptedTaskWME = agent.GetInputLink().GetChildren("task")
						.Select(wme => wme.ConvertToIdentifier())
						.Where(id => id.FindStringByAttribute("taskID") == ID).First();
					// take off ^active
					interruptedTaskWME.FindByAttribute("active", 0).DestroyWME();
					// add ^delayed
					interruptedTaskWME.CreateStringWME("delayed", "yes");

					// mark interrupted task as interrupted
					entityProperties.AddProp(((InterruptDecision)lastDecision).interruptUniqueID, EntityProperty.InterruptEntity);
				}

				// add task props to Soar input
				this.log("Begin: Adding task " + task.ID + " as an active task", 5);
				sml.Identifier taskWME = AddActiveTask(task);
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
				// TODO can this happen before a delayed entity is marked ^delayed in scope?
				if(entityProperties.Any(entry => entry.Value.Contains(EntityProperty.DelayEntity)||
												 entry.Value.Contains(EntityProperty.InterruptEntity)))
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

							// search through entities in the task
							foreach (MAAD.Simulator.IEntity entity in app.Executor.Simulation.IModel.Find("ID", taskIDString))
							{
								// check if it is in a suspended state
								if(entityProperties.EntityHas(entity.UniqueID, EntityProperty.DelayEntity))
								{
									// mark the entity to be resumed
									this.log("Scope: Resume delayed");
									// trace that we are resuming
									app.AcceptTrace("Marking delayed task to be resumed: " + executor.GetRuntimeTask(entity.ID).Properties.Name);
									// set tag to that release condition automatically accepts it
									// TODO there is now a gap between marking to resume and actually starting the task
									// TODO is this a problem?
									entityProperties.AddProp(entity.UniqueID, EntityProperty.ResumeEntity);
									// remove the delay property
									entityProperties.RemoveProp(entity.UniqueID, EntityProperty.DelayEntity);
									// add the task as a real task
									//AddActiveTask(executor.GetRuntimeTask(entity.ID));
									// log that we resumed a task
									scopeData.LogStrategy("Resume Delayed", app.Executor.Simulation.Clock);
									// remove task from input, and it will be added as active in begin event
									this.log("End: removing DELAY task " + entity.ID + " and marking RESUME_DELAY", 5);
									RemoveTask(executor.GetRuntimeTask(entity.ID));
								}
								else if(entityProperties.EntityHas(entity.UniqueID, EntityProperty.InterruptEntity))
								{
									this.log("Scope: Resume interrupted");
									// trace that we are resuming
									app.AcceptTrace("Resuming task " + entity.ID + ": " + executor.Simulation.IModel.Resume("ID", entity.ID));
									// TODO this should be restored from what it was before
									entityProperties.RemoveProp(entity.UniqueID, EntityProperty.InterruptEntity);
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
			this.log("Start OnAfterReleaseCondition: " + executor.Simulation.GetTask().Properties.Name, 5);

			// TODO check for resume purgatory entities which may exist due to a bug I can't produce but should exist
			if (entityProperties.EntityHas(executor.Simulation.GetEntity().UniqueID, EntityProperty.ResumePurgatoryEntity))
			{
				throw new Exception("Entity in resume purgatory entering RC");
			}

			// abort any entities that scope said to reject because they are duplicates
			foreach (int uniqueID in entityProperties.EntitiesWith(EntityProperty.RejectDuplicateEntity))
			{
				int removed = executor.Simulation.IModel.Abort("UniqueID", uniqueID);
				this.log("killing duplicate entity: " + removed, 5);
				if (removed > 0)
				{
					entityProperties.RemoveProp(uniqueID, EntityProperty.RejectDuplicateEntity);
				}
			}

			// don't let delayed entities through. this filter is to replace suspending and resuming the entity
			if (entityProperties.EntityHas(executor.Simulation.GetEntity().UniqueID, EntityProperty.DelayEntity))
			{
				// don't let it through
				release = false;

				// also don't make a decision about it
				return;
			}

			// if entity is marked to resume after delay, return true
			if(entityProperties.EntityHas(executor.Simulation.GetEntity().UniqueID, EntityProperty.ResumeEntity))
			{
				this.log("RESUME_DELAY_TAG coming through release condition, accepting", 3);

				// remove resume property
				// TODO what if there is another task starting when this is resumed, and they both have their
				// RCs evaluated, but the other one actually starts before this one, so this one has RC evaluated
				// again. then this would be subject to release decision again. This is a bug
				entityProperties.RemoveProp(executor.Simulation.GetEntity().UniqueID, EntityProperty.ResumeEntity);
				// TODO to detect manifestation of this bug, put the resume purgatory property on the entity and check for it later
				entityProperties.AddProp(executor.Simulation.GetEntity().UniqueID, EntityProperty.ResumePurgatoryEntity);

				// update last decision as resume decision
				this.lastDecision = new DeferredDecision
				{
					type = DeferredDecision.DecisionType.ResumeDecision,
					uniqueID = executor.Simulation.GetEntity().UniqueID,
					scheduledBeginTime = executor.Simulation.Clock
				};

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

					this.log("Release: Running scope to get release decision",5);
					string output = agent.RunSelfTilOutput();

					// get output commnad
					sml.Identifier command = agent.GetCommand(0);

					// TODO if no command exists?
					// if(!agent.Commands())

					// get strategy name
					string strategy = command.GetParameterValue("name");
					this.log("Release: Scope returned: " + strategy, 5);

					// TODO if command isn't a strategy somehow?
					// if(agent.GetCommandName() != "strategy")

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

		public void OnClockAdvance(object sender, MAAD.Simulator.ClockChangedArgs args)
		{
			// call to check for reject/delayed actions
			CheckForDelaysAndRejects(args.Clock);
		}

		private MAAD.Simulator.Utilities.DSimulationEvent OBBE;
		private MAAD.Simulator.Utilities.DSimulationBoolEvent OARC;
		private MAAD.Simulator.Utilities.DSimulationEvent OAEE;
		private MAAD.Simulator.Utilities.DNetworkEvent OSB;
		private MAAD.Simulator.Utilities.DNetworkEvent OSC;
		private EventHandler<MAAD.Simulator.ClockChangedArgs> OCA;
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

			//public delegate void EventHandler<TEventArgs>(object sender, TEventArgs e);
			app.Generator.OnClockAdvance +=
				OCA = new EventHandler<MAAD.Simulator.ClockChangedArgs>(OnClockAdvance);
		}
		public void UnregisterEvents()
		{
			app.Generator.OnAfterReleaseCondition -= OARC;
			app.Generator.OnBeforeBeginningEffect -= OBBE;
			app.Generator.OnSimulationBegin -= OSB;
			app.Generator.OnSimulationComplete -= OSC;
			app.Generator.OnAfterEndingEffect -= OAEE;

			app.Generator.OnClockAdvance -= OCA;
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
					//this.log("Scope: Delay new task");
					// add ^delayed yes to WME
					//this.log("Delay: add ^delayed: " + taskWME.CreateStringWME("delayed", "yes").GetValue(), 5);
					// remove ^release from WME
					//this.log("Delay: remove ^release: " + taskWME.FindByAttribute("release", 0).DestroyWME(), 5);

					// create the info to defer the execution of the action
					// only create if we haven't already done so
					if (!entityProperties.EntityHas(app.Executor.Simulation.GetEntity().UniqueID, EntityProperty.TentativeDelayEntity))
					{
						// mark DELAY_TAG
						entityProperties.AddProp(app.Executor.Simulation.GetEntity().UniqueID, EntityProperty.TentativeDelayEntity);

						// create info
						deferredDecisions.Add(new DeferredDecision
						{
							type = DeferredDecision.DecisionType.DelayDecision,
							uniqueID = app.Executor.Simulation.GetEntity().UniqueID,
							scheduledBeginTime = app.Executor.Simulation.Clock // TODO is this always true?
						});
					}

					// remove task from input
					taskWME.DestroyWME();

					// return false so the entity is not released
					return false;
					break;
				case "ignore-new":
					//this.log("Scope: Ignore new task");

					// create the info to defer the execution of the action
					// only create if we haven't already done so
					if (!entityProperties.EntityHas(app.Executor.Simulation.GetEntity().UniqueID, EntityProperty.IgnoreEntity))
					{
						// mark KILL_TAG
						entityProperties.AddProp(app.Executor.Simulation.GetEntity().UniqueID, EntityProperty.IgnoreEntity);

						// create info
						deferredDecisions.Add(new DeferredDecision
						{
							type = DeferredDecision.DecisionType.RejectDecision,
							uniqueID = app.Executor.Simulation.GetEntity().UniqueID,
							scheduledBeginTime = app.Executor.Simulation.Clock // TODO is this always true?
						});
					}

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

					// store info about the decision
					this.lastDecision = new DeferredDecision
					{
						type = DeferredDecision.DecisionType.PerformAllDecision,
						uniqueID = app.Executor.Simulation.GetEntity().UniqueID,
						scheduledBeginTime = app.Executor.Simulation.Clock
					};

					// return true because entity should be released
					return true;
					break;
				case "interrupt-task":
					this.log("Scope: Interrupt task");

					// get task which should be interrupted
					sml.Identifier interruptedTaskWME = agent.GetOutputLink().GetIDAtAttributePath("strategy.interrupt-task");
					string taskID = interruptedTaskWME.FindStringByAttribute("taskID");

					// store info on decision
					this.lastDecision = new InterruptDecision
					{
						type = DeferredDecision.DecisionType.InterruptDecision,
						uniqueID = app.Executor.Simulation.GetEntity().UniqueID,
						scheduledBeginTime = app.Executor.Simulation.Clock,
						interruptUniqueID = ((MAAD.Simulator.IEntity)app.Executor.Simulation.IModel.Find("ID", taskID)[0]).UniqueID
					};

					// suspend entity(ies?) in task
					// TODO this will abort all entities in task. should we include entity tag?
					// suspend, and ask Scope if we can restart once in a while (in end effect?)
					//app.AcceptTrace("Interrupting " + app.Executor.Simulation.IModel.FindTask(taskID).Properties.Name + ": " + app.Executor.Simulation.IModel.Suspend("ID", taskID));
					// remove task from Scope
					// TODO for some reason we have to remove ^active before adding ^delayed, otherwise it crashes. we should figure out why
					// remove ^active from WME
					//this.log("Interrupt: remove ^active: " + interruptedTaskWME.FindByAttribute("active", 0).DestroyWME(), 5);
					// add ^delayed yes to WME
					//this.log("Interrupt: add ^delayed: " + interruptedTaskWME.CreateStringWME("delayed", "yes").GetValue(), 5);
					// give entity the INTERRUPT_TAG tag
					// TODO store uniqueID on task so we can target exactly which one
					/*foreach (MAAD.Simulator.IEntity entity in app.Executor.Simulation.IModel.Find("ID", taskID))
					{
						entityProperties.AddProp(entity.UniqueID, EntityProperty.InterruptEntity);
					}*/

					// destroy the task input element and it will be added later on task begin
					taskWME.DestroyWME();
					// return true because entity should be released
					return true;
					break;
				case "reject-duplicate":
					this.log("Scope: Reject duplicate");

					// mark KILL_TAG
					entityProperties.AddProp(app.Executor.Simulation.GetEntity().UniqueID, EntityProperty.RejectDuplicateEntity);

					// TODO what to do with these? kill them immediately? or deferred?
					// killing immediately in RC

					// destroy the task input element
					taskWME.DestroyWME();

					// return false because entity should not be released
					return false;
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
		public sml.Identifier AddTask(MAAD.Simulator.Utilities.IRuntimeTask task)
		{
			return AddTask(GetIMPRINTTaskFromRuntimeTask(task));
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
