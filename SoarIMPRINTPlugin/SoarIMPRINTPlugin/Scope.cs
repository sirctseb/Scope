using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SoarIMPRINTPlugin
{
	public class Scope : MAAD.Utilities.Plugins.IPlugin
	{
		// TODO test when IMPRINT creates plugin objects
		private static bool kernelInitialized = false;
		private static sml.Kernel kernel = null;
		private static sml.Agent agent = null;
		public static string ScopeOutput = null;
		private static bool eventsRegistered = false;

		//private static MAAD.Simulator.Utilities.DSimulationEvent Generator_OnBeforeBeginningEffect;
		private static void OnBeforeBeginningEffect(MAAD.Simulator.Executor executor)
		{
			// blah blah
			staticApplication.AcceptTrace("beginnign effect!");
		}
		public static void RegisterEvents()
		{
			if(!eventsRegistered) {
				MAAD.Simulator.Utilities.ISimulationApplication app =
					staticApplication as MAAD.Simulator.Utilities.ISimulationApplication;
				app.Generator.OnBeforeBeginningEffect +=
					new MAAD.Simulator.Utilities.DSimulationEvent(OnBeforeBeginningEffect);
			}
		}

		public static bool CreateKernel()
		{
			kernel = sml.Kernel.CreateKernelInNewThread();
			
			return kernelInitialized = !kernel.HadError();
		}

		public static bool InitializeScope()
		{
			return InitializeScope("Scope/agent/test-agent.soar");
		}
		public static bool InitializeScope(string source)
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

		public static bool RunAgent(int steps) {

			// run agent for 3 steps
			agent.RunSelf(steps);
			if (agent.HadError()) return false;

			return true;
		}

		public static bool SetInput(string attribute, string value)
		{
			// get input link
			sml.Identifier input = agent.GetInputLink();
			// set value
			sml.StringElement el = input.CreateStringWME(attribute, value);
			return el != null;
		}
		public static string GetOutput(string command, string parameter)
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

		public static bool KillKernel()
		{
			kernel.Shutdown();
			return true;
		}

		#region IPlugin Implementation
		public string Password
		{
			get { return null; }
		}

		MAAD.Utilities.Plugins.IPluginApplication application;
		static MAAD.Utilities.Plugins.IPluginApplication staticApplication;
		public MAAD.Utilities.Plugins.IPluginApplication PluginApplication
		{
			get { return application; }
			set { application = value; staticApplication = application; RegisterEvents(); }
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
