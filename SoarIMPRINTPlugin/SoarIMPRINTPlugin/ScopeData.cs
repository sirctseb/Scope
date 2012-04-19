using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SoarIMPRINTPlugin
{
	// A class to keep data on what scope does
	public class ScopeData
	{
		// a class to store info about a strategy decision
		public class Strategy : IEquatable<Strategy>
		{
			public string Name { get; set; }
			public double Time { get; set; }

			public bool Equals(Strategy other)
			{
				return this.Name == other.Name;
			}
			public override int GetHashCode()
			{
				if (this.Name == null)
				{
					return 0;
				}
				return this.Name.GetHashCode();
			}
		}

		public List<Strategy> StrategyLog { get; set; }

		public ScopeData()
		{
			StrategyLog = new List<Strategy>();
		}

		// add a strategy decision to the log
		public void LogStrategy(string strategy, double time)
		{
			StrategyLog.Add(new Strategy {Name = strategy, Time = time});
		}

		// return the number of times a strategy has been used
		public int GetStrategyCount(string strategy)
		{
			return StrategyLog.Count(item => item.Name == strategy);
		}

		public struct StrategyCount
		{
			public string Name;
			public int Count;
		}
		// return the number of times each strategy is used
		// returns IEnumberable< {string Name, int Count} >
		public IEnumerable<StrategyCount> GetStrategyCounts()
		{
			/*List<StrategyCount> counts = new List<StrategyCount>();
			IEnumerable<string> strings = GetStrategies();
			foreach (string strategy in strings)
			{
				int count = StrategyLog.Count(strat => strat.Name == strategy);
				counts.Add(new StrategyCount { Name = strategy, Count = count });
			}
			return counts;*/

			return GetStrategies().Select(strategy => new StrategyCount{Name= strategy, Count= StrategyLog.Count(strat => strat.Name == strategy)} );
		}

		// return a list of the strategies used
		public IEnumerable<string> GetStrategies()
		{
			/*IEnumerable<Strategy> distincts = StrategyLog.Distinct();
			List<Strategy> actuallyDistinct = new List<Strategy>();
			foreach (Strategy strategy in distincts)
			{
				actuallyDistinct.Add(strategy);
			}
			IEnumerable<string> strings = distincts.Select(strategy => strategy.Name);
			return strings;*/
			return StrategyLog.Distinct().Select(strategy => strategy.Name);
		}
	}
}
