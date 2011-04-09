package GameTools
{	
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	
	import Box2DExtention.Delgates.LoopManager;
	import Box2DExtention.World;
	
	import Utils.StageRef;
	
	import caurina.transitions.Tweener;
	
	import com.ghostmonk.utils.GridMaker;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	
	import org.osmf.events.TimeEvent;

	/**
	 *@author ghostmonk - Apr 6, 2011
	 */
	public class SlingShot extends Sprite
	{
		public static const SLING_RELEASE:String = "slingRelease";
		public static const SHOT_COMPLETE:String = "shotComplete";
		
		private static const POWER:Number = 16;
		private var timer:Timer;
		public var projectilePosition:b2Vec2 = new b2Vec2();
		private var textBox:TextField;
		private var ragDoll:Array;
		private var projectile:b2Body;
		private var trajectory:b2Vec2 = new b2Vec2();
		private var xLimit:Number;
		private var yLimit:Number;
		
		private var container:Sprite;
		
		public function SlingShot( xRange:Number, yRange:Number, container:Sprite )
		{
			this.xLimit = xRange * 0.5;
			this.yLimit = yRange * 0.5;
			this.container = container;
			
			graphics.beginFill( 0x000000, 0.1 );
			graphics.drawRect( -xLimit, -yLimit, xRange, yRange ); 
			graphics.endFill();
			
			textBox = new TextField();
			textBox.autoSize = TextFieldAutoSize.LEFT;
			textBox.textColor = 0xaa1144;
			textBox.selectable = false;
			
			addChild( textBox );
		}
		
		public function Load( ragDoll:Array ) : void
		{	
			this.ragDoll = ragDoll;
			this.projectile = ragDoll[1];
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
			var xM:Number = -World.Meters( Math.max( -xLimit, Math.min( mouseX, xLimit ) ) ); 
			var yM:Number = -World.Meters( Math.max( -yLimit, Math.min( mouseY, yLimit ) ) );
			
			projectile.SetPosition( new b2Vec2( -xM + 6.5, -yM + 11 ) );
				
			trajectory.Set( xM * POWER, yM * POWER );
			textBox.text = "x: " + xM * 15 + " y: " + yM * 15;
		}
		
		private function OnMouseUp( e:MouseEvent ) : void
		{
			dispatchEvent( new Event( SLING_RELEASE ) );
			
			projectile.SetType( b2Body.b2_dynamicBody );
			projectile.SetAwake( true );
			projectile.SetLinearVelocity( trajectory );
			stage.removeEventListener( MouseEvent.MOUSE_UP, OnMouseUp ); 
			stage.removeEventListener( MouseEvent.MOUSE_MOVE, OnMouseMove );
			addEventListener( Event.ENTER_FRAME, OnEnterFrame );
			
			StartTimeout();
		}
		
		private function StartTimeout() : void
		{
			timer = new Timer( 7000, 1 );
			timer.addEventListener( TimerEvent.TIMER_COMPLETE, OnTimerComplete );
			timer.start();
		}
		
		private function OnTimerComplete( e:TimerEvent ) : void
		{
			/*for( var i:int = 0; i < World.Instance.GetBodyCount(); i++ )
			{
				var body:b2Body = World.Instance.GetBodyList();
				body.SetActive( false );
				body.SetAwake( false );
			}*/
			timer = null;
			removeEventListener( Event.ENTER_FRAME, OnEnterFrame );
			dispatchEvent( new Event( SHOT_COMPLETE ) );
		}
		
		private function OnEnterFrame( e:Event ) : void
		{
			var offset:int = 100;
			container.x = ( -projectile.GetWorldCenter().x * 30 ) + 400;
			//container.y = ( -projectile.GetWorldCenter().y * 30 ) + 330;
		}
	}
}