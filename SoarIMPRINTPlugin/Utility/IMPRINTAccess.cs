using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Utility
{
	public class IMPRINTAccess : SmartPlugin
	{
		public MAAD.Network.TaskObject GetSelectedTask()
		{
			try
			{
				return (MAAD.Network.TaskObject)R.GetMember(app, "TaskNetworkView.mySelection.myObjects[0].TaskObject");
			}
			// catch to return null when nothing is selected
			catch (System.ArgumentOutOfRangeException)
			{
				return null;
			}
		}

		public MAAD.Network.TaskObject SelectedTask
		{
			get { return this.GetSelectedTask(); }
		}

		public IEnumerable<MAAD.IMPRINTPro.NetworkTask> GetTaskList()
		{
			// TODO handle if doesn't exist or isn't initialized or whatever
			return (IEnumerable<MAAD.IMPRINTPro.NetworkTask>)R.GetMember(app, "TaskNetwork.NetworkTaskList");
		}

		public IEnumerable<MAAD.IMPRINTPro.NetworkTask> TaskList
		{
			get { return this.GetTaskList(); }
		}

		/*public IEnumerable<MAAD.IMPRINTPro.Interfaces.IRIPairConflict> GetRIPairConflictList()
		{
			return (IEnumerable<MAAD.IMPRINTPro.Interfaces.IRIPairConflict>)R.GetMember(app, "TaskNetwork.Analysis.CurrentMission.RIPairConflictList.GetIRIPairConflicts");
		}*/

	}
}
