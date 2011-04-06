package Delgates
{
	import Box2D.Dynamics.b2World;
	
	import General.FRateLimiter;
	import General.FpsCounter;
	
	import Utils.StageRef;
	import Utils.World;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.getTimer;

	/**
	 * Responsible for setting up the game loop. In this case, Event.EnterFrame, and invoking whatever methods 
	 * are needed to update the game screen.
	 * 
	 * @author ghostmonk
	 *  
	 */	
	public class LoopManager
	{
		private var world:b2World;
		private var mouseActionDelegate:MouseActionDelegate;
		private var fpsCounter:FpsCounter;
		
		/**
		 * If managed correctly, the LoopManager should be able to handle updating the entire game.
		 * The stage is used to listen for the EnterFrame event. The MouseActionDelegate allows for interactivity 
		 * on DynamicBodies. 
		 * @param stage
		 * @param mouseActionDelegate
		 * 
		 */		
		public function LoopManager( mouseActionDelegate:MouseActionDelegate )
		{
			this.mouseActionDelegate = mouseActionDelegate;
			world = World.Instance;
			StageRef.stage.addEventListener( Event.ENTER_FRAME, OnEnterFrame );
		}
		
		public function set ShowFpsCounter( value:Boolean ) : void
		{
			if( value )
			{
				fpsCounter = new FpsCounter();
				fpsCounter.x = 20;
				fpsCounter.y = 20;
				StageRef.stage.addChild( fpsCounter );
			}
			else
			{
				StageRef.stage.removeChild( fpsCounter );
				fpsCounter = null;
			}
		}
		
		private function OnEnterFrame( e:Event ) : void
		{
			mouseActionDelegate.Update();
			
			var physStart:uint = getTimer();
			world.Step( 1 / 38, 10, 10 );
			world.ClearForces();
			world.DrawDebugData();
			
			
			if( fpsCounter ) 
			{
				fpsCounter.update();
				fpsCounter.updatePhys( physStart );
			}
		}
	}
}