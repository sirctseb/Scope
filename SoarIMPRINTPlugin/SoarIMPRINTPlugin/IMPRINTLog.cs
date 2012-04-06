using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SoarIMPRINTPlugin
{
	public class IMPRINTLogger : SmartPlugin
	{
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
			if (logLevel >= LogLevel)
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
