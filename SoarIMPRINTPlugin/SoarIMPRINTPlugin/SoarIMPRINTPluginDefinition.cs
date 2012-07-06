using System;
using System.Collections.Generic;
using MAAD.Plugins.ImprintPluginLoader;

[assembly: ImprintPluginAttribute()]

namespace SoarIMPRINTPlugin
{
	public class SoarIMPRINTPluginDefinition : IExternalVariableProvider, IImprintPlugin
	{
		// TODO find out when this class is constructed
		public string[] GetAssemblyReferences()
		{
			return new string[]
			{
				"SoarIMPRINTPlugin.dll",
				"Utility.dll"
			};
		}

		public IEnumerable<VariableName> GetExternalVariables()
		{
			// initialize the soar kernel
			Scope.InitializeKernel();

			return new VariableName[]{
				new VariableName("SoarPlugin", typeof(Scope))
			};
		}

		public string[] GetNamespaceAliases()
		{
			return new string[]{};
		}

		public string Author
		{
			get { return "Christopher Best"; }
		}

		public DateTime Date
		{
			get { return DateTime.Today; }
		}

		public string Description
		{
			get { return "IMPRINT plugin for the Scope system"; }
		}

		public string Name
		{
			get { return "Scope"; }
		}
	}
}
