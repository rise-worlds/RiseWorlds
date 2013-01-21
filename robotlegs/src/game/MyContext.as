package game 
{
	import flash.display.DisplayObjectContainer;
	
	import org.robotlegs.base.ContextEvent;
	import game.controller.CreateBallCommand;
	import game.controller.HelloFlashEvent;
	import game.model.StatsModel;
	import game.view.Ball;
	import game.view.BallMediator;
	import org.robotlegs.mvcs.Context;
	
	public class MyContext extends Context
	{
		public function MyContext(contextView:DisplayObjectContainer) 
		{
			super(contextView);
		}
		
		override public function startup():void 
		{
			// Map some Commands to Events
			commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, CreateBallCommand, ContextEvent, true);
			commandMap.mapEvent(HelloFlashEvent.BALL_CLICKED, CreateBallCommand, HelloFlashEvent );
			
			// Create a rule for Dependency Injection
			injector.mapSingleton(StatsModel);
			
			// Here we bind Mediator Classes to View Classes:
			// Mediators will be created automatically when
			// view instances arrive on stage (anywhere inside the context view)
			mediatorMap.mapView(Ball, BallMediator);
			
			//// Manually add something to stage
			//contextView.addChild(new Ball());
			
			// And we're done
			super.startup();
		}
	
	}
}