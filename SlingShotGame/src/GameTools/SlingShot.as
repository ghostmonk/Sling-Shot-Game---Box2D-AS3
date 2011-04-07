package GameTools
{	
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	
	import Utils.StageRef;
	import Utils.World;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	/**
	 *@author ghostmonk - Apr 6, 2011
	 */
	public class SlingShot extends Sprite
	{
		private var textBox:TextField;
		private var projectile:b2Body;
		private var trajectory:b2Vec2 = new b2Vec2();
		private var xLimit:Number;
		private var yLimit:Number;
		
		public function SlingShot( xRange:Number, yRange:Number )
		{
			this.xLimit = xRange * 0.5;
			this.yLimit = yRange * 0.5;
			
			graphics.beginFill( 0x000000, 0.1 );
			graphics.drawRect( -xLimit, -yLimit, xRange, yRange ); 
			graphics.endFill();
			
			textBox = new TextField();
			textBox.autoSize = TextFieldAutoSize.LEFT;
			textBox.textColor = 0xaa1144;
			textBox.selectable = false;
			
			addChild( textBox );
		}
		
		public function Load( projectile:b2Body ) : void
		{	
			this.projectile = projectile;
			addEventListener( MouseEvent.MOUSE_DOWN, OnMouseDown );
		}
		
		private function OnMouseDown( e:MouseEvent ) : void
		{
			stage.addEventListener( MouseEvent.MOUSE_UP, OnMouseUp );
			stage.addEventListener( MouseEvent.MOUSE_MOVE, OnMouseMove );
		}
		
		private function OnMouseMove( e:MouseEvent ) : void
		{
			var M:Number = 10;
			var xM:Number = -World.Meters( Math.max( -xLimit, Math.min( mouseX, xLimit ) ) ); 
			var yM:Number = -World.Meters( Math.max( -yLimit, Math.min( mouseY, yLimit ) ) ) 
			trajectory.Set( xM * 15, yM * 15 );
			textBox.text = "x: " + xM * 15 + " y: " + yM * 15;
		}
		
		private function OnMouseUp( e:MouseEvent ) : void
		{
			projectile.SetAwake( true );
			projectile.SetLinearVelocity( trajectory );
			stage.removeEventListener( MouseEvent.MOUSE_UP, OnMouseUp ); 
			stage.removeEventListener( MouseEvent.MOUSE_MOVE, OnMouseMove );
		}
	}
}