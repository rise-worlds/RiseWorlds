package 
{
	import com.hires.Stats;
	import starling.core.Starling;
	import flash.events.Event;
	import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
	
	/**
	 * ...
	 * @author Rise
	 */
	public class Main extends Sprite 
	{
		private var mStarling:Starling;
		private var stats:Stats;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			stats = new Stats;
			addChild(stats);

			// Create a Starling instance that will run the "Game" class
			mStarling = new Starling(Game, stage);
			mStarling.start();
			mStarling.enableErrorChecking = true;
		}
		
	}
	
}