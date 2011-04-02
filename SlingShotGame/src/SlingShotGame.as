package
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Collision.b2AABB;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2DistanceJointDef;
	import Box2D.Dynamics.Joints.b2MouseJoint;
	import Box2D.Dynamics.Joints.b2MouseJointDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	import Delgates.LoopManager;
	import Delgates.MouseActionDelegate;
	
	import General.Input;
	
	import Utils.BodyMaker;
	import Utils.JointMaker;
	import Utils.Settings;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	[SWF(width="700", height="300", pageTitle="Angry Bairds", frameRate=60, backgroundColor=0x333333)]
	public class SlingShotGame extends Sprite
	{
		public static var H_X_STAGE:Number;
		public static var H_Y_STAGE:Number;
		
		private var loopManager:LoopManager;
		private var world:b2World;
		private var ground:b2Body;
		private var box1:b2Body;
		private var box2:b2Body;
		
		public function SlingShotGame()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			world = Settings.World;
			
			CreateGround();
			box1 = BodyMaker.Box( H_X_STAGE - Meters( 100 ), 0, 1, 1 );
			box2 = BodyMaker.Box( H_X_STAGE + Meters( 100 ), 0, 1, 1 );
			
			JointMaker.DistanceJoint( box1, box2 );
			
			Settings.DebugView( this );
			loopManager = new LoopManager( stage, new MouseActionDelegate( this ) );
			
			stage.addEventListener( Event.RESIZE, CreateGround );
			
			trace( "My world has " + world.GetBodyCount() + " bodies" );
		}
		
		private function CreateGround( e:Event = null ) : void
		{
			if( ground ) world.DestroyBody( ground );
			H_X_STAGE = Meters( stage.stageWidth * 0.5 );
			H_Y_STAGE = Meters( stage.stageHeight * 0.5 );
			ground = BodyMaker.Box( H_X_STAGE, H_Y_STAGE * 2, H_X_STAGE + 500, Meters( 5 ), true );
		}
		
		private function Meters( pixels:Number ) : Number
		{
			return pixels / Settings.METER_PIXELS;
		}
	}
}