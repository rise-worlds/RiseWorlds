abstract class ShapesClass
{
    abstract public int Area();
}

class Square : ShapesClass
{
    int side = 0;

    public override int Area()
    {
        return side * side;
    }

    public Square(int n)
    {
        side = n;
    }

    static void Main()
    {
        Square square = new Square(100);
        System.Console.WriteLine(square.Area());
    }
}