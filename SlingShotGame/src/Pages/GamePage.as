package Pages 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	
	import Box2DExtention.Config.BodyFactory;
	import Box2DExtention.Delgates.LoopManager;
	import Box2DExtention.Factories.Ragdoll;
	import Box2DExtention.World;
	
	import Events.LevelEvent;
	
	import GameTools.Camera;
	import GameTools.SlingShot;
	import GameTools.TrajectoryPath;
	
	import Utils.HUD;
	import Utils.StageRef;
	
	import com.ghostmonk.ui.graveyard.idecomposed.Switch;
	import com.ghostmonk.utils.GridMaker;
	import com.ghostmonk.utils.TimedCallback;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	import mx.core.ByteArrayAsset;
	
	[Event (name="levelSuccess", type="Events.LevelEvent")]
	[Event (name="levelFailed", type="Events.LevelEvent")]
	
	/**
	 *@author ghostmonk - Apr 10, 2011
	 */
	public class GamePage extends Sprite
	{
		[Embed("Levels/Level1.xml", mimeType="application/octet-stream")]
		private var level1:Class;
		
		[Embed("Levels/Level2.xml", mimeType="application/octet-stream")]
		private var level2:Class;
		
		[Embed("Levels/Level3.xml", mimeType="application/octet-stream")]
		private var level3:Class;
		
		private var currentLevelConfig:Class;
		private var currentLevel:int;
		
		private var loopManager:LoopManager;
		private var hud:HUD;
		private var slingShot:SlingShot;
		private var currentRagDoll:Array = [];
		private var trajectoryPath:TrajectoryPath;
		
		private var oldX:int = 0;
		
		private var clearTrajectory:Boolean = true;
		private var camera:Camera;
		
		public function Init() : void
		{
			World.DebugView( this );
			loopManager = new LoopManager();
			loopManager.ShowFpsCounter = true;
			
			hud = HUD.Instance;
			StageRef.stage.addChild( hud );
			
			trajectoryPath = new TrajectoryPath();
			addChild( trajectoryPath );
			CreateSlingShot();
			
			camera = new Camera( this, -1300, 0 );
		}
		
		public function NextLevel() : void
		{
			ClearLevel();
			if( currentLevel == 3 )
				StartLevel( currentLevel );
			else
				StartLevel( ++currentLevel );
		}
		
		public function StartLevel( level:int ) : void
		{
			hud.visible = true;
			currentLevel = level;
			
			switch( level )
			{
				case 1: currentLevelConfig = level1; break;
				case 2: currentLevelConfig = level2; break;
				case 3: currentLevelConfig = level3; break;
			}
			ClearLevel();
			CreateLevel( GetLevelConfig( currentLevelConfig ) );
			NewMan();
		}
		
		public function ResetGame() : void
		{
			ClearLevel();
			CreateLevel( GetLevelConfig( currentLevelConfig ) );
			NewMan();
		}
		
		private function CheckGameStatus() : void
		{
			if( hud.MenLeft > 0 ) 
				NewMan();
			else
				dispatchEvent( new LevelEvent( LevelEvent.LEVEL_SUCCESS, currentLevel ) );
		}
		
		private function GetLevelConfig( XmlClass:Class ) : XML 
		{
			var byteArray:ByteArrayAsset = ByteArrayAsset( new XmlClass() );
			return new XML( byteArray.readUTFBytes( byteArray.length ) );
		}
		
		private function NewMan() : void
		{
			for each( var body:b2Body in currentRagDoll )
			{
				World.Instance.DestroyBody( body );
			}
			currentRagDoll = Ragdoll.Simple( 90, 350, 100 );
			slingShot.Load( currentRagDoll );
		}
		
		private function ClearLevel() : void
		{
			hud.Reset();
			trajectoryPath.Clear();
			clearTrajectory = true;
			var body:b2Body = World.Instance.GetBodyList();
			while( body )
			{
				World.Instance.DestroyBody( body );
				body = World.Instance.GetBodyList();	
			}
		}
		
		private function CreateLevel( xml:XML ) : void
		{
			BodyFactory.ParseConfig( xml );
			CreateGrid();
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
			hud.AddToScore( Math.max( 0, vec.x - oldX ) );
			oldX = vec.x;
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
			oldX = 0;
			
			HUD.Instance.RemoveMan();
			TimedCallback.create( CheckGameStatus, 500 );
		}
		
		private var gridSprite:Sprite = new Sprite();
		
		private function CreateGrid() : void
		{
			gridSprite.graphics.clear();
			gridSprite.graphics.drawRect( 0, 0, 3000, 1200 );
			GridMaker.lineStyle( 0, 0xFFFFFF, 0.3 );
			GridMaker.drawGrid( gridSprite, 20, 10 );
			gridSprite.y = -600;
			gridSprite.x = 0;
			addChild( gridSprite );
		}
	}
}