using System;

public static class Test
{
	/// <summary>
	/// 生成一个非重复的随机序列。
	/// </summary>
	/// <param name="count">序列长度。</param>
	/// <returns>序列。</returns>
	//private static int BuildRandomSequence(int length) {
	//	int[] array = new int[10];
	//	for (int i = 0; i < array.Length; i++) {
	//		array[i] = i;
	//	}
	//	Random random = new Random();
	//	int x = 0, tmp = 0;
	//	for (int i = array.Length - 1; i > 0; i--) {
	//		x = random.Next(0, i + 1);
	//		tmp = array[i];
	//		array[i] = array[x];
	//		array[x] = tmp;
	//	}
	//	int sequence = 0;
	//	for (int i = 0; i < length; i++)
	//	{
	//		x = random.Next(0, 10);
	//		sequence = (sequence * 10) + array[x];
	//	}
	//	return sequence;
	//}
	private static string BuildRandomSequence(int length) {
		int[] array = new int[10];
		for (int i = 0; i < array.Length; i++) {
			array[i] = i;
		}
		Random random = new Random();
		int x = 0, tmp = 0;
		for (int i = array.Length - 1; i > 0; i--) {
			x = random.Next(0, i + 1);
			tmp = array[i];
			array[i] = array[x];
			array[x] = tmp;
		}

		string sequence = string.Empty;
		for (int i = 0; i < length; i++)
		{
			x = random.Next(0, 10);
			sequence += array[x];
		}
		return sequence;
	}

	public static void Main(string[] args)
	{
		Console.WriteLine(BuildRandomSequence(5));
	}
}