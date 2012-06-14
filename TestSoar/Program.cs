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
		class SoarHandler
		{

			public Agent agent = null;
			public Kernel kernel = null;
			public bool stopFlag = false;
			public bool addition = false;
			public string addAttribute = null;
			public string addValue = null;

			public void main()
			{

				Console.WriteLine("starting");
				// create a kernel
				kernel = sml.Kernel.CreateKernelInNewThread();

				if (kernel.HadError())
				{
					Console.WriteLine("Error creating kernel");
					return;
				}

				// create an agent
				agent = kernel.CreateAgent("test-agent");
				if (kernel.HadError())
				{
					Console.WriteLine("Error creating agent");
					return;
				}

				// load source
				agent.LoadProductions("../../../../TestAgent/test-agent.soar");
				if (Err(agent.HadError(), "Error loading source")) return;

				// give input
				Identifier input = agent.GetInputLink();
				if (Err(agent.HadError(), "Error getting input link")) return;

				// put stuff on input
				//input.CreateStringWME("text", "something");

				//agent.RunSelf(3);

				// get output
				/*for (int i = 0; i < agent.GetNumberCommands(); i++)
				{
					Identifier id = agent.GetCommand(i);
					if (id.GetCommandName() == "response")
					{
						Console.WriteLine("response: " + id.GetParameterValue("text"));
					}
				}*/

				// register for after output phase
				kernel.RegisterForUpdateEvent(sml.smlUpdateEventId.smlEVENT_AFTER_ALL_OUTPUT_PHASES, GeneralOutputCallbackHandler, null);
				System.Threading.Thread thread = null;
				string command = Console.ReadLine();
				while (command != "exit")
				{
					switch (command)
					{
						case "start":
							// start soar instance
							thread = new System.Threading.Thread(new System.Threading.ThreadStart(RunSoarForever));
							thread.Start();
							break;
						case "stop":
							// TODO what to do with the thread?
							//Console.WriteLine("kernel.StopAllAgents(): " + kernel.StopAllAgents());
							stopFlag = true;
							Console.WriteLine("Planning to stop. Waiting for next output phase to tell it");
							break;
						case "add":
							// read what to add
							addAttribute = Console.ReadLine();
							addValue = Console.ReadLine();
							// schedule to add to input
							addition = true;
							Console.WriteLine("Scheduling addition: ^" + addAttribute + " " + addValue);
							break;
						default:
							Console.WriteLine(thread.ThreadState.ToString());
							break;
					}
					command = Console.ReadLine();
				}
			}

			public void RunSoarForever()
			{
				try
				{
					Console.WriteLine("starting agents");
					string result = kernel.RunAllAgentsForever();
					Console.WriteLine("after return: " + result);
				}
				catch (Exception e)
				{
					Console.WriteLine(e.Message);
				}
				//Console.WriteLine("kernel.RunAllAgentsForever() returned: " + kernel.RunAllAgentsForever());
			}
			//public delegate void Kernel::UpdateEventCallback(smlUpdateEventId eventID, IntPtr callbackData, IntPtr kernel, smlRunFlags runFlags);
			public void GeneralOutputCallbackHandler(sml.smlUpdateEventId eventID, IntPtr callbackData, IntPtr kernel, sml.smlRunFlags runFlags)
			{
				// update work theoretically
				if (stopFlag)
				{
					Console.WriteLine("After output phase and stopFlag, stopping agents: " +
						this.kernel.StopAllAgents());
					stopFlag = false;
				}
				if (addition)
				{
					Console.WriteLine("After output phase and addition, adding input");
					this.agent.GetInputLink().CreateStringWME(addAttribute, addValue);
					addition = false;
				}
			}
		}
		static void Main(string[] args)
		{
			// create Soar handler
			SoarHandler handler = new SoarHandler();
			handler.main();
		}
	}
}
