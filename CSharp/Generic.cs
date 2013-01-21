
public class Generic<T>
{
	private T self;
	public Generic(T input)
	{
		self = input;
	}
	
	public T get()
	{
		return self;
	}
}

public class TestGeneric
{
	public static int Main()
	{
		Generic<int> intGeneric = new Generic<int>(100);
		//intGeneric.set(100);
		Generic<string> stringGeneric = new Generic<string>("string");
		//stringGeneric.set("string");
		
		System.Console.WriteLine(intGeneric.get());
		System.Console.WriteLine(stringGeneric.get());
		return 0;
	}
}