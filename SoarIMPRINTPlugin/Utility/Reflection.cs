using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections;

namespace Utility
{	
	// for abbreviated access in IMPRINT
	public class R : Reflection
	{ }
	public class CJBMissingMemberException : System.Exception
	{
		public CJBMissingMemberException(System.Exception innerException)
			: base("No such member", innerException)
		{
		}
		public CJBMissingMemberException(string message, System.Exception innerException)
			: base(message, innerException)
		{
		}
	}
	public class Reflection
	{
		// TODO document the binding flags
		// Try to invoke a member on obj for each type in it's hierarchy as long as an exception with the same type as check is thrown
		public static Object InvokeUpHierarchy(string name, System.Reflection.BindingFlags flags, System.Reflection.Binder binder, Object obj, object[] args, System.Exception check)
		{
			// move up through hierarchy to look for field
			Type objType = obj.GetType();
			while (objType != null)
			{
				try
				{
					return objType.InvokeMember(name, flags, binder, obj, args);
				}
				catch (System.Exception e)
				{
					if (e.GetType() == check.GetType())
					{
						check = e;
					}
					else
					{
						throw e;
					}
				}
				objType = objType.BaseType;
			}
			throw check;
		}

		// call a method with arguments
		public static Object Call(Object obj, string method, object[] args)
		{
			System.Reflection.BindingFlags methodFlags =
				System.Reflection.BindingFlags.FlattenHierarchy |
				System.Reflection.BindingFlags.InvokeMethod |
				System.Reflection.BindingFlags.Instance |
				System.Reflection.BindingFlags.NonPublic |
				System.Reflection.BindingFlags.Public |
				System.Reflection.BindingFlags.Static;
			return InvokeUpHierarchy(method, methodFlags, null, obj, args, null);
		}

		// get a field on an object by name
		public static Object GetField(Object obj, string field)
		{
			System.Reflection.BindingFlags fieldFlags =
				System.Reflection.BindingFlags.FlattenHierarchy |
				System.Reflection.BindingFlags.GetField |
				System.Reflection.BindingFlags.Instance |
				System.Reflection.BindingFlags.NonPublic |
				System.Reflection.BindingFlags.Public |
				System.Reflection.BindingFlags.Static;
			if (isType(obj))
			{
				return ((System.Type)obj).InvokeMember(field, fieldFlags, null, obj, null);
			}
			else
			{
				return InvokeUpHierarchy(field, fieldFlags, null, obj, null, new System.MissingFieldException());
			}

		}
		// set a field on an object by name
		public static void SetField(Object obj, string field, Object value)
		{
			System.Reflection.BindingFlags setFieldFlags =
				System.Reflection.BindingFlags.FlattenHierarchy |
				System.Reflection.BindingFlags.SetField |
				System.Reflection.BindingFlags.Instance |
				System.Reflection.BindingFlags.Static |
				System.Reflection.BindingFlags.Public |
				System.Reflection.BindingFlags.NonPublic;
			//obj.GetType().InvokeMember(field, setFieldFlags, null, obj, new [] {value});
			InvokeUpHierarchy(field, setFieldFlags, null, obj, new[] { value }, new System.MissingFieldException());
		}
		// get a property of an object by name
		public static Object GetProp(Object obj, string property)
		{
			System.Reflection.BindingFlags propFlags =
				System.Reflection.BindingFlags.FlattenHierarchy |
				System.Reflection.BindingFlags.GetProperty |
				System.Reflection.BindingFlags.Instance |
				System.Reflection.BindingFlags.Static |
				System.Reflection.BindingFlags.Public |
				System.Reflection.BindingFlags.NonPublic;
			if (R.isType(obj))
			{
				return ((System.Type)obj).InvokeMember(property, propFlags, null, obj, null);
			}
			else
			{
				return InvokeUpHierarchy(property, propFlags, null, obj, null, new System.MissingMethodException());
			}
		}
		// Set a property on an object by name
		public static void SetProp(Object obj, string property, Object value)
		{
			System.Reflection.BindingFlags setPropFlags =
				System.Reflection.BindingFlags.FlattenHierarchy |
				System.Reflection.BindingFlags.SetProperty |
				System.Reflection.BindingFlags.Instance |
				System.Reflection.BindingFlags.Static |
				System.Reflection.BindingFlags.Public |
				System.Reflection.BindingFlags.NonPublic;
			//obj.GetType().InvokeMember(property, setPropFlags, null, obj, new [] {value});
			InvokeUpHierarchy(property, setPropFlags, null, obj, new[] { value }, new System.MissingMethodException());
		}

		// Get the value of a member of obj, whether it is a field or a property
		// this supports chained member names and array indices
		public static Object GetMember(Object obj, string name)
		{
			// do GetMemberPath if there are . or []
			if (name.Contains('.') || name.Contains('['))
			{
				return GetMemberPath(obj, name);
			}

			// try to read as field
			try
			{
				return GetField(obj, name);
			}
			catch (System.MissingFieldException)
			{
				// field didn't exist, try property
				try
				{
					return GetProp(obj, name);
				}
				catch (System.MissingMethodException e)
				{
					throw new CJBMissingMemberException(name + " does not exist as a field or property in " + obj, e);
				}
			}
		}
		// Set the value of a member of obj, whether it is a field or a property
		// this supports chained member names and array indices
		public static void SetMember(Object obj, string name, Object value)
		{
			// if name contains a member specifier, use SetMemberPath
			if (name.Contains('.') || name.Contains('['))
			{
				SetMemberPath(obj, name, value);
				return;
			}


			// try to set as field
			try
			{
				SetField(obj, name, value);
			}
			catch (System.MissingFieldException)
			{
				// field didn't exist, try to set as property
				try
				{
					SetProp(obj, name, value);
				}
				catch (System.MissingMethodException e)
				{
					throw new CJBMissingMemberException(name + " does not exist as a field or property in " + obj, e);
				}
			}
		}

		// return a value at a path of member names described by the string path
		public static Object GetMemberPath(Object obj, string path)
		{
			string[] members = path.Split(new[] { '.', '[', ']' }, StringSplitOptions.RemoveEmptyEntries);
			return GetMemberPathComponents(obj, members);
		}
		// return a value at a path of member names held in the members array
		public static Object GetMemberPathComponents(Object obj, string[] members)
		{
			// go through path and get objects
			Object member = obj;
			int arrayIndex = 0;
			foreach (string memberName in members)
			{
				// check if memberName is a number, and thus, an array index
				if (int.TryParse(memberName, out arrayIndex))
				{
					// this should allow for both Array and ArrayList
					//member = ((IList<object>)member)[arrayIndex];
					try
					{
						member = ((Array)member).GetValue(arrayIndex);
					}
					catch (System.InvalidCastException e)
					{
						member = ((ArrayList)member)[arrayIndex];
					}
				}
				else
				{
					member = GetMember(member, memberName);
				}
			}
			return member;
		}
		// set a value at a path of member names described by the string path
		public static void SetMemberPath(Object obj, string path, Object value)
		{
			string[] members = path.Split(new[] { '.', '[', ']' }, StringSplitOptions.RemoveEmptyEntries);
			// get component array of all member names but last
			string[] allButOne = members.Take(members.Length - 1).ToArray();
			// get object who has final member
			Object parent = GetMemberPathComponents(obj, allButOne);
			// set value depending on whether name is array index or member
			int arrayIndex = 0;
			if (int.TryParse(members[members.Length - 1], out arrayIndex))
			{
				// this should allow for both Array and ArrayList
				//((IList<object>)parent)[arrayIndex] = value;

				// try to cast to array to index
				try
				{
					((Array)parent).SetValue(value, arrayIndex);
				}
				catch (System.InvalidCastException e)
				{
					// TODO test that this sets correctly
					((ArrayList)parent)[arrayIndex] = value;
				}
			}
			else
			{
				SetMember(parent, members[members.Length - 1], value);
			}
		}

		public static IEnumerable<System.Reflection.FieldInfo> GetLocalFields(Object obj)
		{
			System.Reflection.BindingFlags fieldFlags =
				//System.Reflection.BindingFlags.FlattenHierarchy |
				System.Reflection.BindingFlags.DeclaredOnly |
				System.Reflection.BindingFlags.GetField |
				System.Reflection.BindingFlags.Instance |
				System.Reflection.BindingFlags.NonPublic |
				System.Reflection.BindingFlags.Public |
				System.Reflection.BindingFlags.Static;
			return obj.GetType().GetFields(fieldFlags);
			//return null;
		}
		public static IEnumerable<System.Reflection.FieldInfo> GetAllFields(Object obj)
		{
			System.Reflection.BindingFlags fieldFlags =
				//System.Reflection.BindingFlags.FlattenHierarchy |
				System.Reflection.BindingFlags.DeclaredOnly |
				System.Reflection.BindingFlags.GetField |
				System.Reflection.BindingFlags.Instance |
				System.Reflection.BindingFlags.NonPublic |
				System.Reflection.BindingFlags.Public |
				System.Reflection.BindingFlags.Static;
			System.Reflection.FieldInfo[] fields = new System.Reflection.FieldInfo[] { };
			//fields.Concat(fields);
			// move up through hierarchy to look for field
			Type objType = obj.GetType();
			while (objType != null)
			{
				fields = fields.Concat(objType.GetFields(fieldFlags)).ToArray();
				objType = objType.BaseType;
			}
			return fields;
		}
		public static IEnumerable<System.Reflection.PropertyInfo> GetLocalProps(Object obj)
		{
			System.Reflection.BindingFlags propFlags =
				//System.Reflection.BindingFlags.FlattenHierarchy |
				   System.Reflection.BindingFlags.DeclaredOnly |
				   System.Reflection.BindingFlags.GetProperty |
				   System.Reflection.BindingFlags.Instance |
				   System.Reflection.BindingFlags.Static |
				   System.Reflection.BindingFlags.Public |
				   System.Reflection.BindingFlags.NonPublic;
			return obj.GetType().GetProperties(propFlags);
		}
		public static IEnumerable<System.Reflection.PropertyInfo> GetAllProps(Object obj)
		{
			System.Reflection.BindingFlags propFlags =
				//System.Reflection.BindingFlags.FlattenHierarchy |
				System.Reflection.BindingFlags.DeclaredOnly |
				System.Reflection.BindingFlags.GetProperty |
				System.Reflection.BindingFlags.Instance |
				System.Reflection.BindingFlags.Static |
				System.Reflection.BindingFlags.Public |
				System.Reflection.BindingFlags.NonPublic;
			System.Reflection.PropertyInfo[] props = new System.Reflection.PropertyInfo[] { };
			Type objType = obj.GetType();
			while (objType != null)
			{
				props = props.Concat(objType.GetProperties(propFlags)).ToArray();
				objType = objType.BaseType;
			}
			return props;
		}

		public static bool isType(Object obj)
		{
			return obj.GetType() == obj.GetType().GetType();
		}
	}
}
