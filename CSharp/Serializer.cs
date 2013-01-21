using System;
using System.Xml;
using System.Xml.Serialization;
using System.IO;
using System.Collections.Generic;
using System.Diagnostics;
using System.Threading.Tasks;

public class Book
{
	public string title;
}

public class Serializer
{
	public void WriteXML()
	{
		Book overview = new Book();

		overview.title = "Serialization Overview";
		XmlSerializer writer = new XmlSerializer(typeof(Book));
		StreamWriter file = new StreamWriter(@"SerializationOverview.xml");
		await writer.Serialize(file, overview);
		file.Flush();
		file.Close();
	}

	public void ReadXML()
	{
		XmlSerializer reader = new XmlSerializer(typeof(Book));
		StreamReader file = new StreamReader(@"SerializationOverview.xml");
		Book overview = new Book();
		overview = (Book)reader.Deserialize(file);

		System.Console.WriteLine(overview.title);
	}

	static void Main()
	{
		Serializer s = new Serializer();
		s.WriteXML();
		s.ReadXML();
	}
}