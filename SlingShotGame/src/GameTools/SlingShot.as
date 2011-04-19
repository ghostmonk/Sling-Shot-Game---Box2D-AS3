package GameTools
{	
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	
	import Box2DExtention.Delgates.LoopManager;
	import Box2DExtention.World;
	
	import Utils.StageRef;
	
	import caurina.transitions.Tweener;
	
	import com.ghostmonk.utils.GridMaker;
	import com.ghostmonk.utils.TimedCallback;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	
	import flashx.textLayout.events.UpdateCompleteEvent;
	
	import org.osmf.events.TimeEvent;

	/**
	 *@author ghostmonk - Apr 6, 2011
	 */
	public class SlingShot extends Sprite
	{
		public static const SLING_RELEASE:String = "slingRelease";
		public static const SHOT_COMPLETE:String = "shotComplete";
		
		private static const X_OFFSET:Number = 11.7;
		private static const Y_OFFSET:Number = 5.3;	
		private static const POWER:Number = 7.5;
		
		private var timer:Timer;
		public var projectilePosition:b2Vec2 = new b2Vec2();
		//private var textBox:TextField;
		private var ragDoll:Array;
		private var projectile:b2Body;
		private var trajectory:b2Vec2 = new b2Vec2();
		private var xLimit:Number;
		private var yLimit:Number;
		
		private var onUpdate:Function;
		
		public function SlingShot( xRange:Number, yRange:Number, onUpdate:Function )
		{
			this.xLimit = -xRange;
			this.yLimit = yRange;
			this.onUpdate = onUpdate;
			
			var slingshotFrame:SlingShotFrame = new SlingShotFrame();
			slingshotFrame.mouseEnabled = false;
			slingshotFrame.x = -30;
			slingshotFrame.y = yRange - 120;
			addChild( slingshotFrame );
			
			graphics.beginFill( 0x000000, 0 );
			graphics.drawRect( -xRange, 0, xRange, yRange ); 
			graphics.endFill();
			
			/*textBox = new TextField();
			textBox.autoSize = TextFieldAutoSize.LEFT;
			textBox.textColor = 0xaa1144;
			textBox.selectable = false;
			
			addChild( textBox );*/
		}
		
		public function Load( ragDoll:Array ) : void
		{	
			this.ragDoll = ragDoll;
			this.projectile = ragDoll[1];
			projectile.SetPosition( new b2Vec2( X_OFFSET - 1, Y_OFFSET + 1 ) );

			projectile.SetType( b2Body.b2_staticBody );
			addEventListener( MouseEvent.MOUSE_DOWN, OnMouseDown );
		}
		
		private function OnMouseDown( e:MouseEvent ) : void
		{
			projectile.SetType( b2Body.b2_staticBody );
			stage.addEventListener( MouseEvent.MOUSE_UP, OnMouseUp );
			stage.addEventListener( MouseEvent.MOUSE_MOVE, OnMouseMove );
		}
		
		private function OnMouseMove( e:MouseEvent ) : void
		{
			var M:Number = 10;
			var xV:Number = World.Meters( Math.max( xLimit, Math.min( mouseX, 0 ) ) ); 
			var yV:Number = World.Meters( Math.max( 0, Math.min( mouseY, yLimit ) ) );
			
			projectile.SetPosition( new b2Vec2( xV + X_OFFSET, yV + Y_OFFSET ) );
			
			for each( var part:b2Body in ragDoll )
				part.SetAwake( true );
				
			trajectory.Set( -xV * POWER, -yV * POWER );
			//textBox.text = "x: " + -xV * POWER + " y: " + -yV * POWER;
		}
		
		private function OnMouseUp( e:MouseEvent ) : void
		{
			dispatchEvent( new Event( SLING_RELEASE ) );
			
			projectile.SetType( b2Body.b2_dynamicBody );
			projectile.SetAwake( true );
			projectile.SetLinearVelocity( trajectory );
			stage.removeEventListener( MouseEvent.MOUSE_UP, OnMouseUp ); 
			stage.removeEventListener( MouseEvent.MOUSE_MOVE, OnMouseMove );
			removeEventListener( MouseEvent.MOUSE_DOWN, OnMouseDown );
			addEventListener( Event.ENTER_FRAME, OnEnterFrame );
			
			TimedCallback.create( OnTimerComplete, GameSettings.CompletedShotPause );
		}
		
		private function OnTimerComplete() : void
		{
			removeEventListener( Event.ENTER_FRAME, OnEnterFrame );
			dispatchEvent( new Event( SHOT_COMPLETE ) );
		}
		
		private function OnEnterFrame( e:Event ) : void
		{
			onUpdate( projectile.GetWorldCenter() );
		}
	}
}