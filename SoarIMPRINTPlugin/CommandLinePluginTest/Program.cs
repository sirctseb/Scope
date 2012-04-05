using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

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
			Console.ReadLine();
		}
	}
}
