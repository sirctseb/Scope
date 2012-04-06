using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using SoarIMPRINTPlugin;

namespace CommandLinePluginTest
{
	class Program
	{
		static void Main(string[] args)
		{
			SoarIMPRINTPlugin.Scope scope = new Scope();
			if (scope.CreateKernel())
			{
				Console.WriteLine("created kernel");
			}
			else
			{
				Console.WriteLine("Failed to create kernel");
			}

			scope.InitializeScope("..\\..\\..\\..\\TestAgent\\test-agent.soar");
			scope.SetInput("text", "blurg");
			scope.RunAgent(3);
			string resp = scope.GetOutput("response", "text");

			Console.WriteLine(resp);
			
			Console.ReadLine();
		}
	}
}
