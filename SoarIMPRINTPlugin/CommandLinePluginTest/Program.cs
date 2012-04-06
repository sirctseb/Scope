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
			if (SoarIMPRINTPlugin.Scope.CreateKernel())
			{
				Console.WriteLine("created kernel");
			}
			else
			{
				Console.WriteLine("Failed to create kernel");
			}

			Scope.InitializeScope("..\\..\\..\\..\\TestAgent\\test-agent.soar");
			Scope.SetInput("text", "blurg");
			Scope.RunAgent(3);
			string resp = Scope.GetOutput("response", "text");

			Console.WriteLine(resp);
			
			Console.ReadLine();
		}
	}
}
