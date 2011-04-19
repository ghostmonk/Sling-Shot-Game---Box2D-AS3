package GameTools 
{	
	import Utils.KeyPressController;
	import Utils.StageRef;
	
	import caurina.transitions.Tweener;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;

	/**
	 *@author ghostmonk - Apr 9, 2011
	 */
	public class Camera 
	{
		private static const RIGHT:uint = 37;
		private static const LEFT:uint = 39;
		private static const ZOOM:uint = 90;
		
		private var container:Sprite;
		private var min:int;
		private var max:int;
		
		private var isManualZoomOut:Boolean = false;
		private var startY:Number;
		private var scaleEater:Sprite;
		private var scrollDelta:int;
		
		private var keyController:KeyPressController;
		
		public function Camera( container:Sprite, min:int, max:int )
		{
			this.container = container;
			this.min = min;
			this.max = max;
			
			scaleEater = new Sprite();
			StageRef.stage.addChild( scaleEater );
			scaleEater.addChild( container );
			startY = scaleEater.y;
			
			keyController = KeyPressController.Instance;
			keyController.addEventListener( KeyPressController.KEY_PRESS, OnKeyDown );
			keyController.addEventListener( KeyboardEvent.KEY_UP, OnKeyUp );
			
			enable();
		}
		
		public function Pan( x:Number ) : void
		{
			if( isManualZoomOut ) return;
			container.x = Math.min( max, Math.max( min, x ) );
		}
		
		public function GameStartPan() : void
		{
			Tweener.removeTweens(container);
			Tweener.removeTweens(scaleEater);
			scaleEater.scaleX = scaleEater.scaleY = 1;
			container.x = min;
			scaleEater.y = startY;
			Tweener.addTween( container, { x:0, y:0, time:1.5, delay:2, transition:"linear" } );
		}
		
		public function Zoom( time:Number, scale:Number ) : void
		{
			Tweener.removeAllTweens();
			
			Tweener.addTween( container, { x:0, y:0, time:time, transition:"linear" } );
			Tweener.addTween( scaleEater, {scaleX:scale, scaleY:scale, time:time, transition:"linear",
				onUpdate: function(): void
				{ 
					scaleEater.y = startY + ( ( 1 - scaleEater.scaleX ) * StageRef.stage.stageHeight );
				} 
			} );
		}
		
		public function enable() : void
		{
			keyController.Enable();	
		}
		
		public function disable() : void
		{
			keyController.Disable();
			StageRef.stage.removeEventListener( Event.ENTER_FRAME, OnEnterFrame );
		}
		
		private function OnKeyDown( e:KeyboardEvent ) : void
		{
			if( e.keyCode == ZOOM )
			{
				isManualZoomOut = !isManualZoomOut;
				if( isManualZoomOut )
					Zoom( 0.4, 0.46 );
				else
					Zoom( 0.4, 1 );
				return;
			}
			
			if( e.keyCode != RIGHT && e.keyCode != LEFT ) return;
			
			scrollDelta = e.keyCode == RIGHT ? 25 : -25;
			
			StageRef.stage.addEventListener( Event.ENTER_FRAME, OnEnterFrame );				
		}
		
		private function OnKeyUp( e:KeyboardEvent ) : void
		{
			StageRef.stage.removeEventListener( Event.ENTER_FRAME, OnEnterFrame );
		}
		
		private function OnEnterFrame( e:Event ) : void
		{
			Pan( container.x + scrollDelta );
		}
	}
}