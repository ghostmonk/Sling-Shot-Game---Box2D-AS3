package
{	
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	
	import Box2DExtention.Config.BodyFactory;
	import Box2DExtention.Delgates.LoopManager;
	import Box2DExtention.Factories.Ragdoll;
	import Box2DExtention.World;
	
	import GameTools.Camera;
	import GameTools.SlingShot;
	import GameTools.TrajectoryPath;
	
	import Utils.HUD;
	import Utils.StageRef;
	
	import com.ghostmonk.utils.TimedCallback;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Point;
	
	import mx.core.ByteArrayAsset;

	[SWF(width="1100", height="500", pageTitle="Angry Bairds", frameRate=100, backgroundColor=0x333333)]
	public class SlingShotGame extends Sprite
	{
		private var loopManager:LoopManager;
		private var hud:HUD;
		private var slingShot:SlingShot;
		private var currentRagDoll:Array = [];
		private var trajectoryPath:TrajectoryPath;
		
		private var clearTrajectory:Boolean = true;
		private var camera:Camera;
		
		public function SlingShotGame()
		{
			SetUpStage();
			
			CreateLevel( Config );
			
			World.DebugView( this );
			loopManager = new LoopManager();
			loopManager.ShowFpsCounter = true;
			
			hud = new HUD();
			stage.addChild( hud );
			
			trajectoryPath = new TrajectoryPath();
			addChild( trajectoryPath );
			CreateSlingShot();
			NewMan();
			
			camera = new Camera( this, -1300, 0 );
		}
		
		private function SetUpStage() : void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			StageRef.stage = stage;
		}
		
		private function OnSlingRelease( e:Event ) : void
		{
			if( clearTrajectory ) trajectoryPath.Clear();
			clearTrajectory = !clearTrajectory;
			
			camera.Zoom( 0.7, 0.46 );
			camera.disable();
		}
		
		private function OnShotComplete( e:Event ) : void
		{
			camera.enable();
			camera.Zoom( 1.4, 1 );
			
			hud.RemoveMan();
			TimedCallback.create( CheckGameStatus, 500 );
		}
		
		private function CheckGameStatus() : void
		{
			if( hud.MenLeft == 0 ) 
			{
				hud.Reset();
				ResetGame();
			}
			NewMan();
		}
		
		private function get Config() : XML 
		{	
			[Embed("Structures.xml", mimeType="application/octet-stream")]
			var Structures:Class;
			var byteArray:ByteArrayAsset = ByteArrayAsset( new Structures() );
			return new XML( byteArray.readUTFBytes( byteArray.length ) );	
		}
		
		private function ResetGame( e:Event = null ) : void
		{
			trajectoryPath.Clear();
			clearTrajectory = true;
			var body:b2Body = World.Instance.GetBodyList();
			while( body )
			{
				World.Instance.DestroyBody( body );
				body = World.Instance.GetBodyList();	
			}
			CreateLevel( Config );
		}
		
		private function NewMan( e:Event = null ) : void
		{
			for each( var body:b2Body in currentRagDoll )
			{
				World.Instance.DestroyBody( body );
			}
			currentRagDoll = Ragdoll.Simple( 90, 350, 100 );
			slingShot.Load( currentRagDoll );
		}
		
		private function CreateLevel( xml:XML ) : void
		{
			BodyFactory.ParseConfig( xml );
		}
		
		private function CreateSlingShot() : void
		{
			slingShot = new SlingShot( 300, 300, UpdateContainer );
			slingShot.x = 350;
			slingShot.y = 100;
			slingShot.addEventListener( SlingShot.SHOT_COMPLETE, OnShotComplete );
			slingShot.addEventListener( SlingShot.SLING_RELEASE, OnSlingRelease );
			addChild( slingShot );
		}
		
		private function UpdateContainer( vec:b2Vec2 ) : void
		{
			trajectoryPath.Update( new Point( vec.x * 30, vec.y * 30 ) );
		}
	}
}