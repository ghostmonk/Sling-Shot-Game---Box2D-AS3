package Delgates
{
	import Box2D.Dynamics.b2World;
	
	import Utils.Settings;
	
	import flash.display.Stage;
	import flash.events.Event;

	public class LoopManager
	{
		private var world:b2World;
		private var stage:Stage;
		private var mouseActionDelegate:MouseActionDelegate;
		
		public function LoopManager( stage:Stage, mouseActionDelegate:MouseActionDelegate )
		{
			this.stage = stage;
			this.mouseActionDelegate = mouseActionDelegate;
			world = Settings.World;
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