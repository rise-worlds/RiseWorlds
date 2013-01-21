namespace GenericList
{
	using System.Collections.Generic;

	public class GenericList<T>
	{
		public GenericList()
		{
			head = null;
			end = null;
		}
		
		private class Node
		{
			public Node(T t)
			{
				next = null;
				data = t;
			}
			
			private Node next;
			public Node Next
			{
				get { return next; }
				set { next = value; }
			}
			
			private T data;
			public T Data
			{
				get { return data; }
				set { data = value; }
			}
		}
		
		private Node head;
		private Node end;
		
		public void AddHead(T t)
		{
			Node n = new Node(t);
			if (head == null)
			{
				head = n;
			}
			//System.Console.Write(t + ", ");
			
			if (end != null)
			{
				//n.Next = end;
				end.Next = n;
			}
			end = n;
		}
		
		public IEnumerator<T> GetEnumerator()
		{
			Node current = head;
			
			while (current != null)
			{
				yield return current.Data;
				current = current.Next;
			}
		}
	}
	
	public class GenericListTest
	{
		public static int Main()
		{
			GenericList<int> list = new GenericList<int>();
			for (int i = 0; i < 10; i++)
			{
				list.AddHead(i);
			}
			//System.Console.WriteLine();
			
			foreach (int j in list)
			{
				System.Console.Write(j + ", ");
			}
			
			return 0;
		}
	}
	
}