package
{	
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2World;
	
	import Config.BodyFactory;
	
	import Delgates.LoopManager;
	import Delgates.MouseActionDelegate;
	
	import Utils.StageRef;
	import Utils.World;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import mx.core.ByteArrayAsset;

	[SWF(width="1200", height="500", pageTitle="Angry Bairds", frameRate=60, backgroundColor=0x333333)]
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
		
		[Embed("./Config/Structures.xml", mimeType="application/octet-stream")]
		private static const Structures:Class;
		
		public function SlingShotGame()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			StageRef.stage = stage;
			
			world = World.Instance;
			new BodyFactory( Config );
			
			World.DebugView( this );
			loopManager = new LoopManager( new MouseActionDelegate( this ) );
			loopManager.ShowFpsCounter = true;
		}
		
		private function get Config() : XML 
		{	
			var byteArray:ByteArrayAsset = ByteArrayAsset( new Structures() );
			return new XML( byteArray.readUTFBytes( byteArray.length ) );	
		}
	}
}