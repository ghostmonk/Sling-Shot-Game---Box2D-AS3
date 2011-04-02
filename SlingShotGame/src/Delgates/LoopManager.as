package Delgates
{
	import Box2D.Dynamics.b2World;
	
	import Utils.Proj;
	
	import flash.display.Stage;
	import flash.events.Event;

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
		private var stage:Stage;
		private var mouseActionDelegate:MouseActionDelegate;
		
		/**
		 * If managed correctly, the LoopManager should be able to handle updating the entire game.
		 * The stage is used to listen for the EnterFrame event. The MouseActionDelegate allows for interactivity 
		 * on DynamicBodies. 
		 * @param stage
		 * @param mouseActionDelegate
		 * 
		 */		
		public function LoopManager( stage:Stage, mouseActionDelegate:MouseActionDelegate )
		{
			this.stage = stage;
			this.mouseActionDelegate = mouseActionDelegate;
			world = Proj.World;
			stage.addEventListener( Event.ENTER_FRAME, OnEnterFrame );
		}
		
		private function OnEnterFrame( e:Event ) : void
		{
			mouseActionDelegate.Update();
			
			world.Step( 1 / 60, 6, 2 );
			world.ClearForces();
			world.DrawDebugData();
		}
	}
}