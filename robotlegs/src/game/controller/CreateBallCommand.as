package game.controller 
{
	import org.robotlegs.mvcs.Command;
	import game.view.Ball;
	
	public class CreateBallCommand extends Command
	{
		override public function execute():void
		{
			// Add a Ball to the view
			// A Mediator will be created for it automatically
			var ball:Ball = new Ball();
			ball.x = Math.random() * 500;
			ball.y = Math.random() * 375;
			contextView.addChild(ball);
		}
	}
}