using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SoarIMPRINTPlugin
{
	// a class for convenience methods on SML classes
	public static class SMLExtension
	{
		// get a command link by name
		public static sml.Identifier GetCommand(this sml.Agent agent, string command_name)
		{
			// get output
			for (int i = 0; i < agent.GetNumberCommands(); i++)
			{
				sml.Identifier id = agent.GetCommand(i);
				if (id.GetCommandName() == command_name)
				{
					return id;
				}
			}
			return null;
		}

		// get typed children of links
		public static string FindStringByAttribute(this sml.Identifier element, string attribute, int index = 0)
		{
			sml.WMElement child = element.FindByAttribute(attribute, index);
			if (child == null) return null;
			sml.StringElement stringChild = child.ConvertToStringElement();
			if (stringChild == null) return null;
			return stringChild.GetValue();
		}
		public class AttributeNotFoundException : SystemException
		{
			public string attribute;
			public sml.Identifier element;
			public AttributeNotFoundException(string attr, sml.Identifier el)
			{
				attribute = attr;
				element = el;
			}
		}
		public class InvalidElementTypeException : SystemException
		{
			public string type;
			public sml.WMElement element;
			public InvalidElementTypeException(string t, sml.WMElement el)
			{
				type = t;
				element = el;
			}
		}
		public static long FindIntByAttribute(this sml.Identifier element, string attribute, int index = 0)
		{
			sml.WMElement child = element.FindByAttribute(attribute, index);
			if (child == null) throw new AttributeNotFoundException(attribute, element);
			sml.IntElement intChild = child.ConvertToIntElement();
			if (intChild == null) throw new InvalidElementTypeException("int", child);
			return intChild.GetValue();
		}
		public static double FindFloatByAttribute(this sml.Identifier element, string attribute, int index = 0)
		{
			sml.WMElement child = element.FindByAttribute(attribute, index);
			if (child == null) throw new AttributeNotFoundException(attribute, element);
			sml.FloatElement floatChild = child.ConvertToFloatElement();
			if (floatChild == null) throw new InvalidElementTypeException("float", child);
			return floatChild.GetValue();
		}
		public static sml.Identifier FindIDByAttribute(this sml.Identifier element, string attribute, int index = 0)
		{
			sml.WMElement child = element.FindByAttribute(attribute, index);
			if (child == null) return null;
			sml.Identifier idChild = child.ConvertToIdentifier();
			return idChild;
		}
		// get iterable children. optionally by attribute
		public static IEnumerable<sml.WMElement> GetChildren(this sml.Identifier element, string attribute = null)
		{
			List<sml.WMElement> children = new List<sml.WMElement>();

			if (attribute == null)
			{
				int numChildren = element.GetNumberChildren();
				// add all children
				for (int i = 0; i < numChildren; i++)
				{
					children.Add(element.GetChild(i));
				}
			}
			else
			{
				// add children at attribute
				sml.WMElement child;
				int i = 0;
				// wow this is horrifying. TODO CHECK THIS
				while ((child = element.FindByAttribute(attribute, i++)) != null) children.Add(child);
			}

			return children;
		}
		// get typed iterable children. optionally by attribute
		public static IEnumerable<sml.Identifier> GetIDChildren(this sml.Identifier element, string attribute = null)
		{
			return
				from child in element.GetChildren(attribute)
				where child.IsIdentifier()
				select child.ConvertToIdentifier();
		}
		public static IEnumerable<double> GetFloatChildren(this sml.Identifier element, string attribute = null)
		{
			return
				from child in element.GetChildren(attribute)
				where child.GetValueType() == "float"
				select child.ConvertToFloatElement().GetValue();
		}
		public static IEnumerable<long> GetIntChildren(this sml.Identifier element, string attribute = null)
		{
			return
				from child in element.GetChildren(attribute)
				where child.GetValueType() == "int"
				select child.ConvertToIntElement().GetValue();
		}
		public static IEnumerable<string> GetStringChildren(this sml.Identifier element, string attribute = null)
		{
			return
				from child in element.GetChildren(attribute)
				where child.GetValueType() == "string"
				select child.ConvertToStringElement().GetValue();
		}
	}
}
