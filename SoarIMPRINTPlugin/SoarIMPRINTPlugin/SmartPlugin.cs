using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SoarIMPRINTPlugin
{
	public class SmartPlugin
	{
		// provide access to the application through a static instance of a Generator
		public MAAD.Simulator.Utilities.ISimulationApplication app
		{
			get { return MAAD.Simulator.Generator.StaticGenerator.SimulationApplication; }
		}
	}
}
