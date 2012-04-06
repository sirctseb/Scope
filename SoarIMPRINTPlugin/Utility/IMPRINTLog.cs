using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Utility
{
	// TODO this crazy approach works but:
	// 1) you're just duplicating the interface in the extension instead of the subclass
	// 2) you have to use this.method() in the subclass instead of just method()
	public interface IIMPRINTLogger
	{
		IMPRINTLogger logger
		{
			get;
			set;
		}
	}
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
	public static class IMPRINTLoggerExtensions
	{
		public static void enable(this IIMPRINTLogger ILogger, string group)
		{
			ILogger.logger.enable(group);
		}
		public static void disable(this IIMPRINTLogger ILogger, string group)
		{
			ILogger.logger.disable(group);
		}
		public static void log(this IIMPRINTLogger ILogger, object msg)
		{
			ILogger.logger.log(msg);
		}
		public static void log(this IIMPRINTLogger ILoggger, object msg, int logLevel)
		{
			ILoggger.logger.log(msg, logLevel);
		}
		public static void log(this IIMPRINTLogger ILogger, object msg, string group)
		{
			ILogger.logger.log(msg, group);
		}
	}
}
