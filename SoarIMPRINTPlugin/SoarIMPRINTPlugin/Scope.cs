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

		public static bool CreateKernel()
		{
			kernel = sml.Kernel.CreateKernelInNewThread();
			
			return kernelInitialized = !kernel.HadError();
		}

		public static bool InitializeScope()
		{
			// create the agent
			agent = kernel.CreateAgent("scope-agent");
			if (kernel.HadError()) return false;

			// load scope productions
			// TODO load test productions for now
			agent.LoadProductions("Scope/agent/test-agent.soar");
			if (agent.HadError()) return false;

			// run agent for 3 steps
			agent.RunSelf(3);
			if (agent.HadError()) return false;
			
			// get output
			for (int i = 0; i < agent.GetNumberCommands(); i++)
			{
				sml.Identifier id = agent.GetCommand(i);
				if (id.GetCommandName() == "response")
				{
					Scope.ScopeOutput = id.GetParameterValue("text");
				}
			}

			return true;
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
