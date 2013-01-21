using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Text;
using System.Threading.Tasks;

class Async
{
	public async void ProcessWrite()
	{
		string filePath = @"temp2.txt";
		string text = "Hello World\r\n";

		await WriteTextAsync(filePath, text);
	}

	private async Task WriteTextAsync(string filePath, string text)
	{
		byte[] encodedText = Encoding.Unicode.GetBytes(text);

		using (FileStream sourceStream = new FileStream(filePath,
			FileMode.Append, FileAccess.Write, FileShare.None,
			bufferSize: 4096, useAsync: true))
		{
			await sourceStream.WriteAsync(encodedText, 0, encodedText.Length);
		};
	}

	static void Main()
	{
		Async myAsync = new Async();
		myAsync.ProcessWrite();
	}
}