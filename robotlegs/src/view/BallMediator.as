package view 
{
	import controller.HelloFlashEvent;
	import flash.events.MouseEvent;
	import model.StatsModel;
	import org.robotlegs.mvcs.Mediator;
	
	public class BallMediator extends Mediator
	{
		[Inject]
		public var view:Ball;
		
		[Inject]
		public var statsModel:StatsModel;
		
		public function BallMediator()
		{
			// Avoid doing work in your constructors!
			// Mediators are only ready to be used when onRegister gets called
		}
		
		override public function onRegister():void
		{
			// Listen to the view
			eventMap.mapListener(view, MouseEvent.CLICK, onClick);
		}
		
		protected function onClick(e:MouseEvent):void
		{
			// Manipulate the model
			statsModel.recordBallClick();
		}
	}
}