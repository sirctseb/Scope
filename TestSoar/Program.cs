using System;
using sml;

namespace TestSoar
{
	class Program
	{
		static bool Err(bool err, string errString)
		{
			if(err) {
				Console.WriteLine(errString);
				Console.ReadLine();
			}
			return err;
		}
		static void Main(string[] args)
		{
			Console.WriteLine("starting");
			// create a kernel
			sml.Kernel kernel = sml.Kernel.CreateKernelInNewThread();

			if (kernel.HadError())
			{
				Console.WriteLine("Error creating kernel");
				return;
			}

			// create an agent
			Agent agent = kernel.CreateAgent("test-agent");
			if (kernel.HadError())
			{
				Console.WriteLine("Error creating agent");
				return;
			}

			// load source
			agent.LoadProductions("../../../../Scope/TestAgent/test-agent.soar");
			if(Err(agent.HadError(), "Error loading source")) return;

			// give input
			Identifier input = agent.GetInputLink();
			if(Err(agent.HadError(), "Error getting input link")) return;

			// put stuff on input
			input.CreateStringWME("text", "something");

			agent.RunSelf(3);

			// get output
			for (int i = 0; i < agent.GetNumberCommands(); i++)
			{
				Identifier id = agent.GetCommand(i);
				if (id.GetCommandName() == "response")
				{
					Console.WriteLine("response: " + id.GetParameterValue("text"));
				}
			}

			Console.ReadLine();
		}
	}
}
