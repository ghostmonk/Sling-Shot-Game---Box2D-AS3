package Box2DExtention.Delgates
{
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2World;
	
	import Box2DExtention.CustomCollisionListener;
	import Box2DExtention.World;
	
	import GameTools.Box2dGameDraw;
	
	import General.FRateLimiter;
	import General.FpsCounter;
	
	import Utils.HUD;
	import Utils.StageRef;
	
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
		public static var StepRatio:Number = 38;
		
		public static const DeletionBodies:Array = [];
		
		private var callbacks:Array = [];
		
		private var world:b2World;
		private var mouseActionDelegate:MouseActionDelegate;
		private var fpsCounter:FpsCounter;
		
		private var gameDraw:Box2dGameDraw;
		
		/**
		 * If managed correctly, the LoopManager should be able to handle updating the entire game.
		 * The stage is used to listen for the EnterFrame event. The MouseActionDelegate allows for interactivity 
		 * on DynamicBodies. 
		 * @param stage
		 * @param mouseActionDelegate
		 * 
		 */		
		public function LoopManager( mouseActionDelegate:MouseActionDelegate = null )
		{
			this.mouseActionDelegate = mouseActionDelegate;
			world = World.Instance;
			gameDraw = Box2dGameDraw.Instance;
			StageRef.stage.addEventListener( Event.ENTER_FRAME, OnEnterFrame );
		}
		
		public function AddCallback( method:Function ) : void
		{
			callbacks.push( method );
		}
		
		public function set ShowFpsCounter( value:Boolean ) : void
		{
			if( value )
			{
				fpsCounter = new FpsCounter();
				fpsCounter.x = 920;
				fpsCounter.y = 80;
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
			for each( var body:b2Body in DeletionBodies )
			{
				World.Instance.DestroyBody( body );
			}
			
			if( mouseActionDelegate != null )
				mouseActionDelegate.Update();
			
			var physStart:uint = getTimer();
			world.Step( 1 / StepRatio, 10, 10 );
			world.ClearForces();
			//world.DrawDebugData();
			gameDraw.Update();
			
			for each( var method:Function in callbacks ) 
			{
				method();
			}
			
			
			if( fpsCounter ) 
			{
				fpsCounter.update();
				fpsCounter.updatePhys( physStart );
			}
		}
	}
}