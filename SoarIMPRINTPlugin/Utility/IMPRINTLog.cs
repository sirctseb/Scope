using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Utility
{
	public class IMPRINTLogger : SmartPlugin
	{
		public IMPRINTLogger(int logLevel = 0, string[] groups = null)
		{
			// set log level
			LogLevel = logLevel;

			// intialize set of groups that are enabled
			if (groups != null)
			{
				foreach (string group in groups)
				{
					this.groups[group] = true;
				}
			}
		}

		private int logLevel = 0;
		public int LogLevel
		{
			get { return logLevel; }
			set { logLevel = value; }
		}
		private Dictionary<string, bool> groups = new Dictionary<string,bool>();
		public void enable(string group) {
			groups[group] = true;
		}
		public void disable(string group) {
			groups[group] = false;
		}

		public void log(object msg)
		{
			app.AcceptTrace(msg);
		}
		public void log(object msg, int logLevel)
		{
			if (LogLevel >= logLevel)
			{
				log(msg);
			}
		}
		public void log(object msg, string group)
		{
			if(groups.ContainsKey(group) && groups[group]) {
				log(msg);
			}
		}
	}
}
