package
{
	import Blueprints.SimpleHouse;
	
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2World;
	
	import Delgates.LoopManager;
	import Delgates.MouseActionDelegate;
	
	import Utils.BodyMaker;
	import Utils.JointMaker;
	import Utils.Proj;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	[SWF(width="1500", height="1000", pageTitle="Angry Bairds", frameRate=60, backgroundColor=0x333333)]
	public class SlingShotGame extends Sprite
	{
		private static var H_X_STAGE:Number;
		private static var H_Y_STAGE:Number;
		
		private static var BOX_SIZE:Number = 0.5;
		
		private var loopManager:LoopManager;
		private var world:b2World;
		private var ground:b2Body;
		private var leftWall:b2Body;
		private var rightWall:b2Body;
		private var roof:b2Body;
		
		public function SlingShotGame()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			world = Proj.World;
			
			CreateBounds();
			JointTests();
			
			Proj.DebugView( this );
			loopManager = new LoopManager( stage, new MouseActionDelegate( this ) );
			
			stage.addEventListener( Event.RESIZE, CreateBounds );
			
			BodyMaker.Circle( 3, 3, 1 );
			
			new SimpleHouse();
			
			trace( "My world has " + world.GetBodyCount() + " bodies" );
		}
		
		private function JointTests() : void
		{
			/*
			//DISTANCE
			JointMaker.DistanceJoint( 
				BodyMaker.Box( H_X_STAGE - Meters( 100 ), 0, BOX_SIZE, BOX_SIZE ), 
				BodyMaker.Box( H_X_STAGE + Meters( 100 ), 0, BOX_SIZE, BOX_SIZE ) );
			
			//REVOLUTE
			JointMaker.RevoluteJoint( 
				BodyMaker.Box( 20, 15, 0.1, 0.1, true ), 
				BodyMaker.Box( 30, 15, BOX_SIZE, BOX_SIZE ) );
			
			//PRISMATIC
			JointMaker.PrismaticJoint( 
				BodyMaker.Box( 10, 5, BOX_SIZE, BOX_SIZE ),
				BodyMaker.Box( 10, 15, BOX_SIZE, BOX_SIZE ),
				new b2Vec2( 0, 0.5 ) );
			
			//PULLY
			JointMaker.PullyJoint( 
			BodyMaker.Box( 10, 10, BOX_SIZE, BOX_SIZE ),
			BodyMaker.Box( 15, 10, BOX_SIZE, BOX_SIZE ) );
			
			//GEAR
			var gear1:b2Body = BodyMaker.Box( 10, 10, BOX_SIZE, BOX_SIZE );
			var gear2:b2Body = BodyMaker.Box( 10, 9, BOX_SIZE, BOX_SIZE );
			var ground:b2Body = BodyMaker.Box( 10, 10, 0.1, 0.1, true );
			JointMaker.GearJoint( ground, gear1, gear2 ); 
			
			//LINE
			JointMaker.LineJoint( 
			BodyMaker.Box( 10, 10, 0.1, 0.1, true ),
			BodyMaker.Box( 10, 15, BOX_SIZE, BOX_SIZE ) );
			
			//WELD
			var xPos:Number = 1.0;
			var yPos:Number = 1.0;
			var currentLink:b2Body = BodyMaker.Box( xPos, yPos, BOX_SIZE, BOX_SIZE, true ); 
			for( var i:int = 0; i < 12; i++ )
			{
				xPos += 1.0;
				var nextLink:b2Body = BodyMaker.Box( xPos, yPos, BOX_SIZE, BOX_SIZE );
				JointMaker.WeldJoint( currentLink, nextLink );
				currentLink = nextLink;
			}*/
		}
		
		private function CreateBounds( e:Event = null ) : void
		{
			if( ground ) 
			{
				world.DestroyBody( ground );
				world.DestroyBody( roof );
				world.DestroyBody( leftWall );
				world.DestroyBody( rightWall );
			}
			
			H_X_STAGE = Proj.Meters( stage.stageWidth * 0.5 );
			H_Y_STAGE = Proj.Meters( stage.stageHeight * 0.5 );
			
			var thickness:Number = Proj.Meters( 5 );
			var exaggeratedLength:Number = Proj.Meters( 5000 );
			
			ground = BodyMaker.Box( H_X_STAGE, H_Y_STAGE * 2, exaggeratedLength, thickness, true );
			roof = BodyMaker.Box( H_X_STAGE, 0, exaggeratedLength, thickness, true );
			leftWall = BodyMaker.Box( 0, 0, thickness, exaggeratedLength, true );
			rightWall = BodyMaker.Box( H_X_STAGE * 2, 0, thickness, exaggeratedLength, true, 10 );
			rightWall.GetFixtureList().SetRestitution( 1 );
		}
	}
}