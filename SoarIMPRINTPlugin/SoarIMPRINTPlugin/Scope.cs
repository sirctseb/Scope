using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Utility;
using SMLExtension;

namespace SoarIMPRINTPlugin
{
	public class Scope : Utility.IMPRINTAccess, MAAD.Utilities.Plugins.IPlugin
	{
		// for logging to the IMPRINT window
		private static Utility.IMPRINTLogger log = new IMPRINTLogger(5, new string[] {"debug"});

		private ScopeData scopeData = new ScopeData();

		// Class to represent a deferred action
		private class DeferredDecision
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
		private class InterruptDecision : DeferredDecision
		{
			// unique id of the entity this is supposed to interrupt
			public int interruptUniqueID;
		}

		// A set of currently deferred actions
		HashSet<DeferredDecision> deferredDecisions = new HashSet<DeferredDecision>();

		// The one decision that led to the entity in BE
		DeferredDecision lastDecision = null;

		// Properties we can ascribe to entities
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
		
		// A class to manage entity markings
		private class MutliDict<TKey, TValue> : Dictionary<TKey, HashSet<TValue> >
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
		private class EntityProperties : MutliDict<int, EntityProperty>
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
		private static sml.Kernel kernel = null;
		private sml.Agent agent = null;
		// True iff scope should be used during the simulation
		private static bool enable = false;
		// True iff the agent exists, has been initialized,
		// and instance event handlers are registered
		private static bool scopeInitialized = false;

		// Scope instance that static methods can access
		private static Scope instance = null;

		public Scope()
		{
			// store instance in static member
			instance = this;
			log.log("Registering instance in static member", 5);
		}

		public bool EnableScope()
		{
			// if Scope is already enabled, noop
			if (Scope.enable)
			{
				return true;
			}
			else
			{
				// set enabled
				Scope.enable = true;

				// initialize if we haven't yet
				if (!scopeInitialized)
				{
					InitializeAgent();
					ResetSoar();
					RegisterEvents();
					scopeInitialized = true;
				}
			}
			return true;
		}

		#region Static Event Handlers

		// Static handlers for initalization
		private static MAAD.Simulator.Utilities.DInitializeVariable IV = new MAAD.Simulator.Utilities.DInitializeVariable(OnInitializeVariable);
		private static MAAD.Simulator.Utilities.DNetworkEvent OSB = new MAAD.Simulator.Utilities.DNetworkEvent(OnSimulationBegin);
		private static MAAD.Simulator.Utilities.DNetworkEvent OSC = new MAAD.Simulator.Utilities.DNetworkEvent(OnSimulationComplete);
		private static MAAD.Utilities.Plugins.DStandardEvent OAC = new MAAD.Utilities.Plugins.DStandardEvent(OnApplicationClosing);

		// Check if the EnableScope variable is defined in the IMPRINT model, and enable if it is
		private static void OnInitializeVariable(MAAD.Simulator.Executor executor, string name, object variable)
		{
			// TODO check for the enable scope variable
			if (name == "EnableScope")
			{
				Scope.enable = true;
			}
		}

		// Initialize the agent and set up info on the input-link when the simulation starts
		// Also register for events
		private static void OnSimulationBegin(object sender, EventArgs e)
		{
			app.AcceptTrace("Simulation beginning, creating agent and registering events");

			if (enable)
			{
				// init agent and register handlers
				if (instance != null)
				{
					// setup agent stuff
					// initialize agent
					// TODO should agent be non-static then?
					instance.InitializeAgent();
					instance.ResetSoar();
					instance.RegisterEvents();
					scopeInitialized = true;
				}
				else
				{
					app.AcceptTrace("Beginning simulation but we have no Scope instance to register events");
				}
			}
		}
		
		// Kill the agent and unregister events when the simulation is over
		private static void OnSimulationComplete(object sender, EventArgs e)
		{
			app.AcceptTrace("Ending simulation, unregistering events");
			if (enable)
			{
				if (instance != null)
				{
					instance.UnregisterEvents();
					instance.KillAgent();
				}
				else
				{
					app.AcceptTrace("Ending simulation, but we have no Scope instance to unregister events");
				}

				// set enabled to false when a simulation ends so that it doesn't get stuck on after one simulation uses it
				enable = false;

				// TOOD renable this
				// write data
				//scopeData.WriteCounts("C:\\Users\\christopher.j.best2\\Documents\\ScopeData\\scope_counts.txt");
				//scopeData.WriteTrace("C:\\Users\\christopher.j.best2\\Documents\\ScopeData\\scope_trace.txt");
			}

			// reset initialization flag
			scopeInitialized = false;
		}
		
		// Kill the kernel when IMPRINT closes
		// TODO we should test this. but it doesn't really matter, because the program is closing anyway
		private static void OnApplicationClosing(object sender, EventArgs e)
		{
			KillKernel();
		}

		#endregion

		#region Instance Event Handlers

		// Instance handlers for various events
		private MAAD.Simulator.Utilities.DSimulationEvent OBBE;
		private MAAD.Simulator.Utilities.DSimulationBoolEvent OARC;
		private MAAD.Simulator.Utilities.DSimulationEvent OAEE;
		private EventHandler<MAAD.Simulator.ClockChangedArgs> OCA;

		// Handler definitions
		private void OnBeforeBeginningEffect(MAAD.Simulator.Executor executor)
		{
			app.AcceptTrace("Before begin effect: " + executor.Simulation.GetTask().Properties.Name);

			// TODO checking for bug that should exist (see RC handler)
			// once an entity starts its task, it is out of resume purgatory
			entityProperties.RemoveProp(executor.Simulation.GetEntity().UniqueID, EntityProperty.ResumePurgatoryEntity);

			// TODO if a KILL_TAG entity gets here, something has gone wrong
			// check that entity hasn't been marked KILL_TAG yet
			//if (executor.EventQueue.GetEntity().Tag == KILL_TAG)
			if (entityProperties.EntityHas(executor.EventQueue.GetEntity().UniqueID, EntityProperty.IgnoreEntity))
			{
				log.log("KILL_TAG in Beginning Effect!");
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
					log.log("Entity beginning task that is not in last decision");
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
					log.log("suspending entity for interrupt-task: " +
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
				log.log("Begin: Adding task " + task.ID + " as an active task", 5);
				sml.Identifier taskWME = AddActiveTask(task);
			}
		}
		
		private void OnAfterEndingEffect(MAAD.Simulator.Executor executor)
		{
			log.log("Top of OnAfterEndingEffect: " + executor.Simulation.GetTask().Properties.Name, 5);
			MAAD.Simulator.Utilities.IRuntimeTask task = executor.EventQueue.GetTask();
			// ignore first and last tasks
			int taskID = int.Parse(task.ID);
			if (taskID > 0 && taskID < 999)
			{
				log.log("End: Removing task " + task.ID + " from input", 5);
				RemoveTask(GetIMPRINTTaskFromRuntimeTask(task));

				// check that there are any delayed tasks before trying to resume them
				// if we don't check, the scope agent can get confused
				// TODO can this happen before a delayed entity is marked ^delayed in scope?
				if (entityProperties.Any(entry => entry.Value.Contains(EntityProperty.DelayEntity) ||
												 entry.Value.Contains(EntityProperty.InterruptEntity)))
				{
					log.log("End: found delayed or interrupted tasks, running scope for resume decision", 5);
					// run scope to decide if we should resume any delayed or interrupted tasks
					string output = agent.RunSelfTilOutput();
					// get result
					sml.Identifier command = agent.GetCommand(0);
					if (command != null)
					{
						// get strategy name
						string strategy = command.GetParameterValue("name");
						log.log("End: scope responds with: " + strategy, 5);
						if (strategy == "resume-delayed")
						{
							// scope says to resume a task
							// find the task scope wants to resume
							string taskIDString = command.FindIDByAttribute("task").FindStringByAttribute("taskID");

							// search through entities in the task
							foreach (MAAD.Simulator.IEntity entity in app.Executor.Simulation.IModel.Find("ID", taskIDString))
							{
								// check if it is in a suspended state
								if (entityProperties.EntityHas(entity.UniqueID, EntityProperty.DelayEntity))
								{
									// mark the entity to be resumed
									log.log("Scope: Resume delayed");
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
									log.log("End: removing DELAY task " + entity.ID + " and marking RESUME_DELAY", 5);
									RemoveTask(executor.GetRuntimeTask(entity.ID));
								}
								else if (entityProperties.EntityHas(entity.UniqueID, EntityProperty.InterruptEntity))
								{
									log.log("Scope: Resume interrupted");
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
		
		private void OnAfterReleaseCondition(MAAD.Simulator.Executor executor, ref bool release)
		{
			log.log("Start OnAfterReleaseCondition: " + executor.Simulation.GetTask().Properties.Name, 5);

			// TODO check for resume purgatory entities which may exist due to a bug I can't produce but should exist
			if (entityProperties.EntityHas(executor.Simulation.GetEntity().UniqueID, EntityProperty.ResumePurgatoryEntity))
			{
				throw new Exception("Entity in resume purgatory entering RC");
			}

			// abort any entities that scope said to reject because they are duplicates
			foreach (int uniqueID in entityProperties.EntitiesWith(EntityProperty.RejectDuplicateEntity))
			{
				int removed = executor.Simulation.IModel.Abort("UniqueID", uniqueID);
				log.log("killing duplicate entity: " + removed, 5);
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
			if (entityProperties.EntityHas(executor.Simulation.GetEntity().UniqueID, EntityProperty.ResumeEntity))
			{
				log.log("RESUME_DELAY_TAG coming through release condition, accepting", 3);

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
					log.log("Release: adding release task: " + nt.ID);

					// add task props to Soar input
					sml.Identifier taskWME = AddReleaseTask(nt);

					log.log("Release: Running scope to get release decision", 5);
					string output = agent.RunSelfTilOutput();

					// get output commnad
					sml.Identifier command = agent.GetCommand(0);

					// TODO if no command exists?
					// if(!agent.Commands())

					// get strategy name
					string strategy = command.GetParameterValue("name");
					log.log("Release: Scope returned: " + strategy, 5);

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

		// Act on the decision made by scope
		// This is called exclusively by OnAfterReleaseCondition
		private bool ApplyStrategy(string strategy, sml.Identifier taskWME)
		{
			// get the strategy name
			//string strategy = GetOutput("strategy", "name");
			// TODO make a class to handle this stuff
			log.log("Applying strategy " + strategy, 5);
			switch (strategy)
			{
				case "delay-new":
					//log.log("Scope: Delay new task");
					// add ^delayed yes to WME
					//log.log("Delay: add ^delayed: " + taskWME.CreateStringWME("delayed", "yes").GetValue(), 5);
					// remove ^release from WME
					//log.log("Delay: remove ^release: " + taskWME.FindByAttribute("release", 0).DestroyWME(), 5);

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
					//log.log("Scope: Ignore new task");

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
					log.log("Scope: Perform all tasks");

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
					log.log("Scope: Interrupt task");

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
					//log.log("Interrupt: remove ^active: " + interruptedTaskWME.FindByAttribute("active", 0).DestroyWME(), 5);
					// add ^delayed yes to WME
					//log.log("Interrupt: add ^delayed: " + interruptedTaskWME.CreateStringWME("delayed", "yes").GetValue(), 5);
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
					log.log("Scope: Reject duplicate");

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

		private void OnClockAdvance(object sender, MAAD.Simulator.ClockChangedArgs args)
		{
			// call to check for reject/delayed actions
			CheckForDelaysAndRejects(args.Clock);
		}

		// Check if there are delayed or rejected entities that we should act on
		// This is called exclusively by OnClockAdvance
		private void CheckForDelaysAndRejects(double Clock)
		{
			// check each defered event
			foreach (DeferredDecision decision in this.deferredDecisions.Where(decision => decision.scheduledBeginTime < Clock))
			{
				log.log("Clock advanced, checking " + decision.type + " for action", 6);

				// check if clock is past the scheduled start of the decision
				if (decision.scheduledBeginTime < Clock)
				{
					// act on the decision
					if (decision.type == DeferredDecision.DecisionType.RejectDecision)
					{
						// kill the entity
						log.log("Killing entity for ignore-task: " +
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

		// Register for simulation events
		private void RegisterEvents()
		{
			app.Generator.OnAfterReleaseCondition +=
				OARC = new MAAD.Simulator.Utilities.DSimulationBoolEvent(OnAfterReleaseCondition);
			app.Generator.OnBeforeBeginningEffect +=
				OBBE = new MAAD.Simulator.Utilities.DSimulationEvent(OnBeforeBeginningEffect);
			app.Generator.OnAfterEndingEffect +=
				OAEE = new MAAD.Simulator.Utilities.DSimulationEvent(OnAfterEndingEffect);
			app.Generator.OnClockAdvance +=
				OCA = new EventHandler<MAAD.Simulator.ClockChangedArgs>(OnClockAdvance);
		}
		private void UnregisterEvents()
		{
			app.Generator.OnAfterReleaseCondition -= OARC;
			app.Generator.OnBeforeBeginningEffect -= OBBE;
			app.Generator.OnAfterEndingEffect -= OAEE;
			app.Generator.OnClockAdvance -= OCA;
		}

		#endregion

		#region Soar Communication

		// Start the kernel and register static event handlers
		// TODO this does more than initialize the kernel and should be renamed
		public static bool InitializeKernel()
		{
			// create the kernel if it doesn't exist yet
			if (kernel == null)
			{
				kernel = sml.Kernel.CreateKernelInNewThread();
				app.AcceptTrace("Creating kernel");

				// register static event handlers
				app.Generator.OnSimulationBegin += OSB;
				app.Generator.OnSimulationComplete += OSC;
				app.Generator.OnInitializeVariable += IV;
				app.OnApplicationClosing += OAC;

				return !kernel.HadError();
			}

			return true;
		}

		// Initialize the agent with the scope-agent rules
		public bool InitializeAgent()
		{
			return InitializeAgent("Scope/agent/scope.soar");
		}
		public bool InitializeAgent(string source)
		{
			// this will never happen but it's good practice if this is public
			if (agent != null && kernel.IsAgentValid(agent))
			{
				kernel.DestroyAgent(agent);
				agent = null;
			}

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
		
		// Clear the input link and populate with initial info
		private bool ResetSoar()
		{
			// reinitialize
			log.log("Scope: initSoar: " + agent.InitSoar());
			log.log("is commit required: " + kernel.IsCommitRequired());
			log.log("Initializing soar");

			// tell Soar we are providing input
			if (agent.GetInputLink().FindByAttribute("IMPRINT", 0) == null)
			{
				agent.GetInputLink().CreateStringWME("IMPRINT", "yes");
				// sneak in a threshold value too
				agent.GetInputLink().CreateFloatWME("threshold", 8);
				log.log("putting IMPRINT on input link");
			}

			// TODO I don't know why agent.InitSoar() doesn't clear the input link
			sml.WMElement element;
			while ((element = agent.GetInputLink().FindByAttribute("task", 0)) != null)
			{
				element.DestroyWME();
			}

			return !agent.HadError();
		}
		
		// Destory the agent
		private bool KillAgent()
		{
			if (agent != null)
			{
				kernel.DestroyAgent(agent);
				agent = null;
				return !kernel.HadError();
			}
			return false;
		}

		// shutdown the kernel
		private static bool KillKernel()
		{
			// shutdown kernel if we haven't already
			if (kernel != null)
			{
				kernel.Shutdown();
				kernel = null;
				return true;
			}

			return false;
		}

		// Run the agent for a number of steps
		public bool RunAgent(int steps)
		{
			// run agent for 3 steps
			agent.RunSelf(steps);
			if (agent.HadError()) return false;

			return true;
		}

		// Lookup between task object types. used by Add/RemoveTask below
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

		// TODO we should save the sml.Identifier we get from AddTask instead of
		// relying on task ID because this may cause problems if multiple entities go through
		// a task
		// Remove a task from the input-link
		private bool RemoveTask(MAAD.Simulator.Utilities.IRuntimeTask task)
		{
			return RemoveTask(GetIMPRINTTaskFromRuntimeTask(task));
		}
		private bool RemoveTask(MAAD.IMPRINTPro.NetworkTask task)
		{
			// get input link
			sml.Identifier input = agent.GetInputLink();

			// search task children
			foreach (sml.Identifier taskLink in input.GetIDChildren("task"))
			{
				// for the given ID
				if (taskLink.FindStringByAttribute("taskID") == task.ID)
				{
					// and destry if we find it
					return taskLink.DestroyWME();
				}
			}

			// return false if we didn't find a matching task
			return false;
		}
	
		// Put a task on the input-link
		private sml.Identifier AddTask(MAAD.Simulator.Utilities.IRuntimeTask task)
		{
			return AddTask(GetIMPRINTTaskFromRuntimeTask(task));
		}
		private sml.Identifier AddTask(MAAD.IMPRINTPro.NetworkTask task)
		{
			// get input link
			sml.Identifier input = agent.GetInputLink();

			// create a wme for the task
			sml.Identifier taskLink = input.CreateIdWME("task");

			// add the task ID
			taskLink.CreateStringWME("taskID", task.ID);

			double totalWorkload = 0;

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
			//taskLink.CreateFloatWME("duration", task.TaskPriority...

			return taskLink;
		}
		
		// Add a task to the input link and add ^active yes attribute
		private sml.Identifier AddActiveTask(MAAD.Simulator.Utilities.IRuntimeTask task)
		{
			return AddActiveTask(GetIMPRINTTaskFromRuntimeTask(task));
		}
		private sml.Identifier AddActiveTask(MAAD.IMPRINTPro.NetworkTask task)
		{
			sml.Identifier taskWME = AddTask(task);
			// add active attribute
			taskWME.CreateStringWME("active", "yes");
			return taskWME;
		}
		
		// Add a task to the input link and add ^release yes attribute
		private sml.Identifier AddReleaseTask(MAAD.Simulator.Utilities.IRuntimeTask task)
		{
			return AddReleaseTask(GetIMPRINTTaskFromRuntimeTask(task));
		}
		private sml.Identifier AddReleaseTask(MAAD.IMPRINTPro.NetworkTask task)
		{
			sml.Identifier taskWME = AddTask(task);
			// add release attribute
			taskWME.CreateStringWME("release", "yes");
			return taskWME;
		}
		
		// Mostly for testing
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
