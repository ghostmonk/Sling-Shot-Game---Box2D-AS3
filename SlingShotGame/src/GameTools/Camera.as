package GameTools 
{	
	import Utils.StageRef;
	
	import caurina.transitions.Tweener;
	
	import com.ghostmonk.utils.GridMaker;
	
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
		
		public function Camera( container:Sprite, min:int, max:int )
		{
			this.container = container;
			this.min = min;
			this.max = max;
			
			scaleEater = new Sprite();
			StageRef.stage.addChild( scaleEater );
			scaleEater.addChild( container );
			startY = scaleEater.y;
			
			enable();
			CreateGrid();
		}
		
		public function Pan( x:Number ) : void
		{
			if( isManualZoomOut ) return;
			container.x = Math.min( max, Math.max( min, x ) );
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
			StageRef.stage.addEventListener( KeyboardEvent.KEY_DOWN, OnKeyDown );	
		}
		
		public function disable() : void
		{
			StageRef.stage.removeEventListener( KeyboardEvent.KEY_DOWN, OnKeyDown );
			StageRef.stage.removeEventListener( KeyboardEvent.KEY_UP, OnKeyUp );
			StageRef.stage.removeEventListener( Event.ENTER_FRAME, OnEnterFrame );
		}
		
		private function CreateGrid() : void
		{
			var sprite:Sprite = new Sprite();
			sprite.graphics.drawRect( 0, 0, container.width, container.height * 2 );
			GridMaker.lineStyle( 0, 0xFFFFFF, 0.3 );
			GridMaker.drawGrid( sprite, 50, 100 );
			sprite.y = -9000;
			container.addChild( sprite );
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
			
			StageRef.stage.removeEventListener( KeyboardEvent.KEY_DOWN, OnKeyDown );
			StageRef.stage.addEventListener( KeyboardEvent.KEY_UP, OnKeyUp );
			StageRef.stage.addEventListener( Event.ENTER_FRAME, OnEnterFrame );				
		}
		
		private function OnKeyUp( e:KeyboardEvent ) : void
		{
			StageRef.stage.addEventListener( KeyboardEvent.KEY_DOWN, OnKeyDown );
			StageRef.stage.removeEventListener( KeyboardEvent.KEY_UP, OnKeyUp );
			StageRef.stage.removeEventListener( Event.ENTER_FRAME, OnEnterFrame );
		}
		
		private function OnEnterFrame( e:Event ) : void
		{
			Pan( container.x + scrollDelta );
			//container.x = Math.min( max, Math.max( min, container.x + scrollDelta ) );
		}
	}
}