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
		//private static Utility.IMPRINTLogger log = new IMPRINTLogger(10, new string[] {"debug", "event", "error"});
		private static IMPRINTLogNamespace.IMPRINTLog log = new IMPRINTLogNamespace.IMPRINTLog("scope", new IMPRINTLogNamespace.IMPRINTOutputWindow());

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
			ResumeEntity
		};
		
		// A class to manage entity markings
		private class MultiDict<TKey, TValue> : Dictionary<TKey, HashSet<TValue> >
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
		private class EntityProperties : MultiDict<int, EntityProperty>
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

		// A map from an Entity's UniqueID to the time it first RCed at its current task
		private Dictionary<int, double> initTimes = new Dictionary<int, double>();

		// TODO test when IMPRINT creates plugin objects
		private static sml.Kernel kernel = null;
		private static sml.Agent agent = null;
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
			log.Log("Scope: Registering instance in static member", 10);
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
				log.Log("Scope: EnableScope() called. Enabling scope", 5);

				// initialize if we haven't yet
				if (!scopeInitialized)
				{
					log.Log("Scope: Initializing", 4);
					InitializeAgent();
					ResetSoar();
					RegisterEvents();
					scopeInitialized = true;
				}
			}
			return true;
		}

		#region Parameters

		public void SetExpirationTime(double expirationTime)
		{
			if (Scope.enable && scopeInitialized)
			{
				log.Log("Scope: Setting expiration length to " + expirationTime, 6);
				// destroy existing one if it exists first
				sml.WMElement element = agent.GetInputLink().FindByAttribute("expiration-date", 0);
				if (element != null)
				{
					log.Log("Scope: Destroying existing value first: " + element.DestroyWME(), 7);
				}
				agent.GetInputLink().CreateFloatWME("expiration-date", expirationTime);
			}
		}

		#endregion

		#region Log access
		// IMPRINT code should just use IMPRINTLog.GetLog("scope").Stuff now
		public void SetLogLevel(int level)
		{
			log.LogLevel = level;
		}

		public void EnableLogGroup(string group)
		{
			log.EnableGroup(group);
		}
		public void DisableLogGroup(string group)
		{
			log.DisableGroup(group);
		}
		public void DisableAllLogGroups()
		{
			log.DisableAllGroups();
		}
		#endregion

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
				log.Log("Scope: Found EnableScope variable. Enabling Scope", 5);
				Scope.enable = true;
			}
		}

		// Initialize the agent and set up info on the input-link when the simulation starts
		// Also register for events
		private static void OnSimulationBegin(object sender, EventArgs e)
		{
			log.Log("Scope: OnSimulationBegin", "event");

			if (enable)
			{
				// init agent and register handlers
				if (instance != null)
				{
					// setup agent stuff
					// initialize agent
					// TODO should agent be non-static then?
					log.Log("Scope: Initializing agent, resetting, and registering events", 5);
					instance.InitializeAgent();
					instance.ResetSoar();
					instance.RegisterEvents();
					scopeInitialized = true;
				}
				else
				{
					log.Log("Scope: Beginning simulation but we have no Scope instance to register events", "error");
				}
			}
			else
			{
				log.Log("Scope: Scope not enabled, nothing to do on simulation begin", 9);
			}
		}
		
		// Kill the agent and unregister events when the simulation is over
		private static void OnSimulationComplete(object sender, EventArgs e)
		{
			log.Log("Scope: OnSimulationComplete", "event");

			if (enable)
			{
				if (instance != null)
				{
					log.Log("Scope: Unregistering events and killing agent", 5);
					instance.UnregisterEvents();
					if (kernel.IsRemoteConnection())
					{
						log.Log("Scope: Kernel is remote, not killing agent", 6);
					}
					else
					{
						instance.KillAgent();
					}

					// write data
					instance.scopeData.WriteCounts("C:\\Users\\christopher.j.best2\\Documents\\ScopeData\\scope_counts.txt");
					instance.scopeData.WriteTrace("C:\\Users\\christopher.j.best2\\Documents\\ScopeData\\scope_trace.txt");
				}
				else
				{
					log.Log("Scope: Ending simulation, but we have no Scope instance to unregister events", "error");
				}

				// set enabled to false when a simulation ends so that it doesn't get stuck on after one simulation uses it
				enable = false;
			}
			else
			{
				// obviously no one would ever want to see this
				log.Log("Scope: Scope not enabled, nothing to do on simulation complete", 9);
			}

			// reset initialization flag
			scopeInitialized = false;
		}
		
		// Kill the kernel when IMPRINT closes
		// TODO we should test this. but it doesn't really matter, because the program is closing anyway
		private static void OnApplicationClosing(object sender, EventArgs e)
		{
			// TODO this probably won't work because the application is closing
			//log.Log("Scope: OnApplicationClosing", "event");
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
			log.Log("Scope: OnBeforeBeginningEffect", 10);

			// take Resume property off once a resume task starts
			entityProperties.RemoveProp(executor.Simulation.GetEntity().UniqueID, EntityProperty.ResumeEntity);

			// TODO if a KILL_TAG entity gets here, something has gone wrong
			// check that entity hasn't been marked KILL_TAG yet
			//if (executor.EventQueue.GetEntity().Tag == KILL_TAG)
			if (entityProperties.EntityHas(executor.EventQueue.GetEntity().UniqueID, EntityProperty.IgnoreEntity))
			{
				log.Log("Scope: IgnoreEntity in Beginning Effect", "error");
				return;
			}

			MAAD.Simulator.Utilities.IRuntimeTask task = executor.EventQueue.GetTask();

			// ignore the first and last task
			int taskID = int.Parse(task.ID);
			if (taskID > 0 && taskID < 999)
			{
				log.Log("Scope: OnBeforeBeginningEffect: " + executor.Simulation.GetTask().Properties.Name, "event");

				// sanity check: any entity starting this task should be referenced in the last decision
				if (executor.Simulation.GetEntity().UniqueID != lastDecision.uniqueID)
				{
					log.Log("Scope: Entity beginning task that is not in last decision", "error");
					//throw new Exception("Entity beginning task that is not in last decision");
				}

				// if entity is starting because of interrupt-task strategy, suspend the other task
				if (lastDecision.type == DeferredDecision.DecisionType.InterruptDecision)
				{
					// suspend task
					log.Log("Scope: Suspending entity (" + ((InterruptDecision) lastDecision).interruptUniqueID + ") for interrupt-task: " +
						executor.Simulation.IModel.Suspend("UniqueID", ((InterruptDecision)lastDecision).interruptUniqueID)
						, 3);
					//PrintEntitiesInTasks();
					// add ^delayed to scope task and take off ^active
					sml.Identifier interruptedTaskWME = GetInputTask(((InterruptDecision)lastDecision).interruptUniqueID);
					// take off ^active
					log.Log("Scope: BE: Removing ^active: " + interruptedTaskWME.FindByAttribute("active", 0).DestroyWME(), 8);
					// add ^delayed
					log.Log("Scope: BE: Adding ^delayed: " + interruptedTaskWME.CreateStringWME("delayed", "yes"), 8);

					log.Log("Scope: Added ^delayed and removed ^active", 4);

					// mark interrupted task as interrupted
					entityProperties.AddProp(((InterruptDecision)lastDecision).interruptUniqueID, EntityProperty.InterruptEntity);
					log.Log("Scope: Added InteruptEntity property", 6);

					// enter decision in scope log
					scopeData.LogStrategy("interrupt-task", executor.Simulation.Clock);
				}
				else if (lastDecision.type == DeferredDecision.DecisionType.PerformAllDecision)
				{
					// enter decision in scope log
					scopeData.LogStrategy("perform-all", executor.Simulation.Clock);
				}

				// add task props to Soar input
				log.Log("Scope: BE: Adding task " + task.ID + " as an active task", 3);
				AddActiveTask(executor.Simulation.GetEntity());

				// clear last decision
				lastDecision = null;
			}
		}

		private void PrintEntitiesInTasks()
		{
			try
			{
				foreach (var entry in app.Executor.RuntimeTaskList)
				{
					log.Log(entry.Key + ":");
					if (entry.Value.Entities != null)
					{
						foreach (MAAD.Simulator.IEntity entity in entry.Value.Entities)
						{
							log.Log("(" + entity.UniqueID + ") " + entity.Event + ", " + entity.ToString());
						}
					}
				}
			}
			catch (Exception e)
			{
				log.Log(e.Message);
			}
		}
		
		private void OnAfterEndingEffect(MAAD.Simulator.Executor executor)
		{
			// clear initial time for the entity
			initTimes.Remove(executor.Simulation.GetEntity().UniqueID);

			MAAD.Simulator.Utilities.IRuntimeTask task = executor.EventQueue.GetTask();
			// ignore first and last tasks
			int taskID = int.Parse(task.ID);
			if (taskID > 0 && taskID < 999)
			{
				log.Log("Scope: OnAfterEndingEffect: " + executor.Simulation.GetTask().Properties.Name, "event");

				log.Log("Scope: EE: Removing task " + task.ID + " from input: " + RemoveTask(executor.Simulation.GetEntity()), 5);

				// check that there are any delayed tasks before trying to resume them
				// if we don't check, the scope agent can get confused
				// TODO can this happen before a delayed entity is marked ^delayed in scope?
				if (entityProperties.Any(entry => entry.Value.Contains(EntityProperty.DelayEntity) ||
												 entry.Value.Contains(EntityProperty.InterruptEntity)))
				{
					log.Log("Scope: EE: Found delayed or interrupted tasks, running scope for resume decision", 3);
					// run scope to decide if we should resume any delayed or interrupted tasks
					string output = agent.RunSelfTilOutput();
					// get result
					sml.Identifier command = agent.GetCommand(0);
					if (command != null)
					{
						// get strategy name
						string strategy = command.GetParameterValue("name");
						log.Log("Scope: EE: Scope responds with: " + strategy, 5);
						if (strategy == "resume-delayed")
						{
							// scope says to resume a task
							// find the task scope wants to resume
							int UniqueID = (int)command.FindIDByAttribute("task").FindIntByAttribute("UniqueID");

							// search through entities in the task
							foreach (MAAD.Simulator.IEntity entity in app.Executor.Simulation.IModel.Find("UniqueID", UniqueID))
							{
								// sanity check
								if (UniqueID != entity.UniqueID)
								{
									//throw new Exception("Sanity check failed. Entity.UniqueID != UniqueID");
									log.Log("Sanity check failed. Entity.UniqueID (" + entity.UniqueID + " ) != UniqueID (" + UniqueID + ")", "error");
								}

								// check if it is in a suspended state
								if (entityProperties.EntityHas(entity.UniqueID, EntityProperty.DelayEntity))
								{
									// trace that we are resuming
									log.Log("Scope: EE: Marking delayed task to be resumed: " + executor.GetRuntimeTask(entity.ID).Properties.Name, 4);
									// set tag to that release condition automatically accepts it
									// TODO there is now a gap between marking to resume and actually starting the task
									// TODO is this a problem?
									entityProperties.AddProp(entity.UniqueID, EntityProperty.ResumeEntity);
									// remove the delay property
									entityProperties.RemoveProp(entity.UniqueID, EntityProperty.DelayEntity);

									// log that we resumed a task
									scopeData.LogStrategy("Resume Delayed", app.Executor.Simulation.Clock);

									// remove task from input, and it will be added as active in begin event
									log.Log("Scope: EE: removing task " + entity.ID, 5);
									RemoveTask(entity);
								}
								else if (entityProperties.EntityHas(entity.UniqueID, EntityProperty.InterruptEntity))
								{
									// trace that we are resuming
									//log.Log("Scope: EE: Resuming interrupted task " + entity.ID + ": " + executor.Simulation.IModel.Resume("ID", entity.ID));
									log.Log("Scope: EE: Resuming interrupted task " + entity.ID + "(" + entity.UniqueID + "): " + executor.Simulation.IModel.Resume(entity), 4);

									// TODO this should be restored from what it was before
									entityProperties.RemoveProp(entity.UniqueID, EntityProperty.InterruptEntity);

									// log that we resumed a task
									scopeData.LogStrategy("Resume Interrupted", app.Executor.Simulation.Clock);

									/* TODO: looks like there is a big problem with changing modifying objects
									 * that we get from GetCommand instead of input. We should only change stuff
									 * that we get from input link
									 */
									// remove ^delayed from WME
									//command.FindIDByAttribute("task").FindByAttribute("delayed", 0).DestroyWME();
									// add ^active
									//command.FindIDByAttribute("task").CreateStringWME("active", "yes");

									// update task WME
									sml.Identifier taskElement = GetInputTask(entity);
									// remove ^delayed from WME
									log.Log("Scope: EE: Removing ^delayed: " + taskElement.FindByAttribute("delayed", 0).DestroyWME(), 8);
									// add ^active
									log.Log("Scope: EE: Adding ^active: " + taskElement.CreateStringWME("active", "yes"), 8);

									log.Log("Scope: EE: Switching from ^delayed to ^active", 6);
								}
							}
						}

						log.Log("Scope: EE: Marking command complete and clearing output changed", 7);
						command.AddStatusComplete();
						agent.ClearOutputLinkChanges();
					}
				}
			}
		}
		
		private void ShowInputState()
		{
			log.Log("From SML: " + agent.GetInputLink().Print(3));
			log.Log("From CMD: " + agent.ExecuteCommandLine("print i2 --depth 3", true, true));
		}
		private void OnAfterReleaseCondition(MAAD.Simulator.Executor executor, ref bool release)
		{
			// mark first RC time if it doesn't have one yet
			if (!initTimes.ContainsKey(executor.Simulation.GetEntity().UniqueID))
			{
				initTimes[executor.Simulation.GetEntity().UniqueID] = executor.Simulation.Clock;
			}

			// don't override false RC evaluations
			// TODO should the special case checks be evaluated before this?
			// TODO seems like maybe the ResumeEntity and RejectDuplicateEntity should?
			if (release == false && !entityProperties.EntityHas(executor.Simulation.GetEntity().UniqueID, EntityProperty.ResumeEntity))
			{
				return;
			}

			// if there is a resume entity trying to get through, return false for all others until it starts
			if (entityProperties.EntitiesWith(EntityProperty.ResumeEntity).Count() > 0)
			{
				if (entityProperties.EntityHas(executor.Simulation.GetEntity().UniqueID, EntityProperty.ResumeEntity))
				{
					release = true;

					// update last decision as resume decision
					log.Log("Scope: RC: Setting last decision to this resume decision", 5);
					this.lastDecision = new DeferredDecision
					{
						type = DeferredDecision.DecisionType.ResumeDecision,
						uniqueID = executor.Simulation.GetEntity().UniqueID,
						scheduledBeginTime = executor.Simulation.Clock
					};
				}
				else
				{
					release = false;
				}
				return;
			}

			// abort any entities that scope said to reject because they are duplicates
			foreach (int uniqueID in entityProperties.EntitiesWith(EntityProperty.RejectDuplicateEntity))
			{
				int removed = executor.Simulation.IModel.Abort("UniqueID", uniqueID);
				log.Log("Scope: RC: Killing duplicate entity: " + removed, 5);
				if (removed > 0)
				{
					entityProperties.RemoveProp(uniqueID, EntityProperty.RejectDuplicateEntity);
				}
			}

			// don't let delayed entities through. this filter is to replace suspending and resuming the entity
			if (entityProperties.EntityHas(executor.Simulation.GetEntity().UniqueID, EntityProperty.DelayEntity))
			{
				log.Log("Scope: RC: Delayed entity in RC, not releasing", 5);

				// don't let it through
				release = false;

				// also don't make a decision about it
				return;
			}

			// if an entity has a deferred decision associated with it, destroy it because we are making a new decision
			int UniqueID = executor.Simulation.GetEntity().UniqueID;
			if (entityProperties.EntityHas(UniqueID, EntityProperty.TentativeDelayEntity))
			{
				// TentativeDelay entities will have a deferred decision in the queue
				deferredDecisions.RemoveWhere(decision => decision.uniqueID == UniqueID);
				// TODO, this should be a hash table, which would at least limit us to one deferred decision per UID

				// remove TentativeDelay property
				entityProperties.RemoveProp(UniqueID, EntityProperty.TentativeDelayEntity);

				// TODO implement this for ignore-new
			}

			MAAD.Simulator.Utilities.IRuntimeTask task = executor.EventQueue.GetTask();

			// ignore the first and last task
			int taskID = int.Parse(task.ID);
			if (taskID > 0 && taskID < 999)
			{
				log.Log("Scope: OnAfterReleaseCondition: " + executor.Simulation.GetTask().Properties.Name, 4);

				// find corresponding MAAD.IMPRINTPro.NetworkTask
				MAAD.IMPRINTPro.NetworkTask nt = GetIMPRINTTaskFromRuntimeTask(task);
				if (nt != null)
				{
					log.Log("Scope: RC: adding release task: " + nt.ID, 5);

					// add task props to Soar input
					sml.Identifier taskWME = AddReleaseTask(executor.Simulation.GetEntity());

					log.Log("Scope: RC: Running scope to get release decision", 5);
					string output = agent.RunSelfTilOutput();

					// get output commnad
					sml.Identifier command = agent.GetCommand(0);

					// TODO if no command exists?
					// if(!agent.Commands())

					// get strategy name
					string strategy = command.GetParameterValue("name");
					log.Log("Scope: RC: Scope returned: " + strategy, 5);

					// TODO if command isn't a strategy somehow?
					// if(agent.GetCommandName() != "strategy")

					// execute the strategy
					release = ApplyStrategy(strategy, taskWME);

					// mark the command as complete
					command.AddStatusComplete();
					agent.ClearOutputLinkChanges();
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
			log.Log("Scope: Applying strategy " + strategy, 5);
			switch (strategy)
			{
				case "delay-new":
					log.Log("Scope: Delay new", 3);

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
					log.Log("Scope: Ignore new task", 3);

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
					log.Log("Scope: Perform all tasks", 3);

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
					log.Log("Scope: Interrupt task", 3);

					// get task which should be interrupted
					//sml.Identifier interruptedTaskWME = agent.GetOutputLink().GetIDAtAttributePath("strategy.interrupt-task");
					//string taskID = interruptedTaskWME.FindStringByAttribute("taskID");
					int UniqueID = (int)agent.GetOutputLink().GetIntAtAttributePath("strategy.interrupt-task.UniqueID");

					log.Log("Scope: Interrupt: Creating InterruptDecision with uniqueID: " + app.Executor.Simulation.GetEntity().UniqueID, 8);
					log.Log("Scope:                                   interruptUniqueID: " + UniqueID, 8);
					// store info on decision
					this.lastDecision = new InterruptDecision
					{
						type = DeferredDecision.DecisionType.InterruptDecision,
						uniqueID = app.Executor.Simulation.GetEntity().UniqueID,
						scheduledBeginTime = app.Executor.Simulation.Clock,
						interruptUniqueID = UniqueID
					};

					// suspend entity(ies?) in task
					// TODO this will abort all entities in task. should we include entity tag?
					// suspend, and ask Scope if we can restart once in a while (in end effect?)
					//app.AcceptTrace("Interrupting " + app.Executor.Simulation.IModel.FindTask(taskID).Properties.Name + ": " + app.Executor.Simulation.IModel.Suspend("ID", taskID));
					// remove task from Scope
					// TODO for some reason we have to remove ^active before adding ^delayed, otherwise it crashes. we should figure out why
					// remove ^active from WME
					//log.Log("Interrupt: remove ^active: " + interruptedTaskWME.FindByAttribute("active", 0).DestroyWME(), 5);
					// add ^delayed yes to WME
					//log.Log("Interrupt: add ^delayed: " + interruptedTaskWME.CreateStringWME("delayed", "yes").GetValue(), 5);
					// give entity the INTERRUPT_TAG tag
					// TODO store uniqueID on task so we can target exactly which one
					/*foreach (MAAD.Simulator.IEntity entity in app.Executor.Simulation.IModel.Find("ID", taskID))
					{
						entityProperties.AddProp(entity.UniqueID, EntityProperty.InterruptEntity);
					}*/

					// destroy the task input element and it will be added later on task begin
					log.Log("Scope: Interrupt: Removing task from input: " + taskWME.DestroyWME(), 8);
					// return true because entity should be released
					return true;
					break;
				case "reject-duplicate":
					log.Log("Scope: Reject duplicate", 3);

					// mark KILL_TAG
					entityProperties.AddProp(app.Executor.Simulation.GetEntity().UniqueID, EntityProperty.RejectDuplicateEntity);

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
			// put new clock value on input-link
			log.Log("Scope: CA: Setting new clock value: " + args.Clock, 8);
			agent.GetInputLink().FindByAttribute("clock", 0).ConvertToFloatElement().Update(args.Clock);

			// call to check for reject/delayed actions
			CheckForDelaysAndRejects(args.Clock);

			// ask scope if we should expire anything
			
			// put request on input
			log.Log("Scope: CA: Putting expire decision request on input link", 8);
			sml.StringElement expireString = agent.GetInputLink().CreateStringWME("decision-request", "expire");
			
			// run scope to output
			log.Log("Scope: CA: Running agent to make expire decision", 9);
			string result = agent.RunSelfTilOutput();

			// get output commnad
			sml.Identifier command = agent.GetCommand(0);

			// get strategy name
			string strategy = command.GetParameterValue("name");
			log.Log("Scope: CA: Scope returned: " + strategy, 5);

			// TODO this returns a valid entity, so we have to be careful below
			// when we abort an expired entity. If it is the one returned here,
			// it might fail to abort. This is probably a bug.
			//log.Log(args.Executor.Simulation.GetEntity().UniqueID);

			if (strategy == "expire-task")
			{
				sml.Identifier taskIdentifier = command.FindIDByAttribute("task");
				string expireTaskID = taskIdentifier.FindStringByAttribute("taskID");
				int UniqueID = (int)taskIdentifier.FindIntByAttribute("UniqueID");
				log.Log(args.Executor.Simulation.GetEntity().UniqueID);
				log.Log("Scope: CA: Resuming entity (" + UniqueID + ") in task: " + expireTaskID + ": " +
						app.Executor.Simulation.IModel.Resume("UniqueID", UniqueID), 4);
				log.Log("Scope: CA: Expiring entity (" + UniqueID + ") in task: " + expireTaskID + ": " +
						app.Executor.Simulation.IModel.Abort("UniqueID", UniqueID), 4);
				log.Log("Scope: CA: Removing expired entity from input link", 4);
				GetInputTask(UniqueID).DestroyWME();
				entityProperties.RemoveProp(UniqueID, EntityProperty.DelayEntity);
				entityProperties.RemoveProp(UniqueID, EntityProperty.InterruptEntity);
			}

			// mark command as complete
			command.AddStatusComplete();
			agent.ClearOutputLinkChanges();

			// remove expire decision request from input link
			expireString.DestroyWME();
		}

		// Check if there are delayed or rejected entities that we should act on
		// This is called exclusively by OnClockAdvance
		private void CheckForDelaysAndRejects(double Clock)
		{
			// check each defered event
			foreach (DeferredDecision decision in this.deferredDecisions.Where(decision => decision.scheduledBeginTime < Clock))
			{
				log.Log("Scope: Clock advanced, checking " + decision.type + " for action", 6);

				// check if clock is past the scheduled start of the decision
				if (decision.scheduledBeginTime < Clock)
				{
					// act on the decision
					if (decision.type == DeferredDecision.DecisionType.RejectDecision)
					{
						// kill the entity
						log.Log("Scope: Killing entity for ignore-task: " +
							app.Executor.Simulation.IModel.Abort("UniqueID", decision.uniqueID)
							, 3);

						// enter decision in scope log
						// TODO check that "ignore-new" is exactly equal to DD.DT.RejectDecision
						scopeData.LogStrategy("ignore-new", decision.scheduledBeginTime);
					}
					else if (decision.type == DeferredDecision.DecisionType.DelayDecision)
					{
						// change the entity property from tentative delay to actually delayed
						entityProperties.RemoveProp(decision.uniqueID, EntityProperty.TentativeDelayEntity);
						entityProperties.AddProp(decision.uniqueID, EntityProperty.DelayEntity);

						// add task as delayed in scope
						AddTask((MAAD.Simulator.IEntity)app.Executor.Simulation.IModel.Find("UniqueID", decision.uniqueID)[0]).CreateStringWME("delayed", "yes");
						log.Log("Scope: Setting task as acutally delayed for delay-new", 3);

						// enter decision in scope log
						scopeData.LogStrategy("delay-new", decision.scheduledBeginTime);
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
			log.Log("Scope: Initializing Kernel", 6);
			// create the kernel if it doesn't exist yet
			if (kernel == null)
			{
				// try connecting to a remote kernel first, in case
				// we have a debugger open and running
				kernel = sml.Kernel.CreateRemoteConnection();
				if (!kernel.HadError())
				{
					log.Log("Scope: Connecting to remote kernel", 6);
					// check that it's running the correct agent,
					// and not just some random debugger
					// TODO the agent won't be named this unless we manually
					// create a new agent in the debugger, name it, and then load
					// the source
					//agent = kernel.GetAgent("scope-agent");
					if (kernel.GetNumberAgents() > 0)
					{
						// just get the first agent // TODO how can we check this is scope?
						agent = kernel.GetAgentByIndex(0);
						if (!AgentIsGood())
						{
							log.Log("Scope: Agent in remote kernel invalid, disconnecting from remote kernel", 6);
						}
					}
					else
					{
						log.Log("Scope: No agents found in kernel, disconnecting from remote kernel", 6);
						kernel = null;
					}
				}
				else
				{
					// TODO do we have to dispose the object?
					kernel = null;
				}
				// if remote connection fails, create local kernel
				if (kernel == null)
				{
					kernel = sml.Kernel.CreateKernelInNewThread();
					log.Log("Scope: No remote kernel found, creating local kernel", 6);
				}

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
			// don't create a new agent if one already exists
			if (AgentIsGood())
			{
				log.Log("Scope: Agent already exists, not creating a new one", 6);
				return true;
			}

			if (agent == null)
			{
				// create the agent
				agent = kernel.CreateAgent("scope-agent");
				if (kernel.HadError())
				{
					log.Log("Scope: Failed to create agent", "error");
					return false;
				}

				// load scope productions
				agent.LoadProductions(source);
				if (agent.HadError())
				{
					log.Log("Scope: Failed to load productions from " + source, "error");
					return false;
				}

				log.Log("Scope: Created agent scope-agent from " + source, 5);
			}

			return true;
		}
		// return true iff agent exists and is valid
		private static bool AgentIsGood()
		{
			return kernel != null && agent != null && kernel.IsAgentValid(agent);
		}
		
		// Clear the input link and populate with initial info
		private bool ResetSoar()
		{
			// reinitialize
			log.Log("Scope: Calling InitSoar: " + agent.InitSoar(), 6);

			// tell Soar we are providing input
			if (agent.GetInputLink().FindByAttribute("IMPRINT", 0) == null)
			{
				agent.GetInputLink().CreateStringWME("IMPRINT", "yes");
				// put threshold value on
				agent.GetInputLink().CreateFloatWME("threshold", 8);
				// put clock value on
				agent.GetInputLink().CreateFloatWME("clock", 0);
				// put expiration time on
				agent.GetInputLink().CreateFloatWME("expiration-date", 3);

				log.Log("Scope: Putting IMPRINT on input link", 6);
			}

			// TODO I don't know why agent.InitSoar() doesn't clear the input link
			sml.WMElement element;
			while ((element = agent.GetInputLink().FindByAttribute("task", 0)) != null)
			{
				element.DestroyWME();
				log.Log("Scope: Removing existing task from input", 9);
			}

			return !agent.HadError();
		}
		
		// Destory the agent
		private bool KillAgent()
		{
			if (agent != null)
			{
				log.Log("Scope: Destroying agent: " + kernel.DestroyAgent(agent), 6);
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
		private bool RemoveTask(MAAD.Simulator.IEntity entity)
		{
			// get input link
			sml.Identifier input = agent.GetInputLink();

			bool success = GetInputTask(entity.UniqueID).DestroyWME();
			log.Log("Scope: Attempting to remove task from input: " + success, 7);
			return success;
		}
	
		// Put a task on the input-link
		private sml.Identifier AddTask(MAAD.Simulator.IEntity entity)
		{
			MAAD.IMPRINTPro.NetworkTask task = GetIMPRINTTaskFromRuntimeTask(app.Executor.Simulation.IModel.FindTask(entity.ID));

			// get input link
			sml.Identifier input = agent.GetInputLink();

			// create a wme for the task
			sml.Identifier taskLink = input.CreateIdWME("task");

			// add the entity uniqueID
			taskLink.CreateIntWME("UniqueID", entity.UniqueID);

			// add the task ID
			taskLink.CreateStringWME("taskID", task.ID);

			// add the initial time
			log.Log("Adding initial time: " + initTimes[entity.UniqueID], 7);
			taskLink.CreateFloatWME("initial-time", initTimes[entity.UniqueID]);

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

			log.Log("Scope: Added task to input-link", 7);

			return taskLink;
		}
		
		// Add a task to the input link and add ^active yes attribute
		private sml.Identifier AddActiveTask(MAAD.Simulator.IEntity entity)
		{
			sml.Identifier taskWME = AddTask(entity);
			// add active attribute
			taskWME.CreateStringWME("active", "yes");
			return taskWME;
		}
		
		// Add a task to the input link and add ^release yes attribute
		private sml.Identifier AddReleaseTask(MAAD.Simulator.IEntity entity)
		{
			sml.Identifier taskWME = AddTask(entity);
			// add release attribute
			taskWME.CreateStringWME("release", "yes");
			return taskWME;
		}

		private sml.Identifier GetInputTask(MAAD.Simulator.IEntity entity)
		{
			return GetInputTask(entity.UniqueID);
		}
		private sml.Identifier GetInputTask(int UniqueID)
		{
			return agent.GetInputLink().GetChildren("task")
				.Select(wme => wme.ConvertToIdentifier())
				.Where(id => id.FindIntByAttribute("UniqueID") == UniqueID).First();
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
