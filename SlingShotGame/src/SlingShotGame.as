package
{	
	import Box2D.Common.Math.b2Vec2;
	
	import Config.BodyFactory;
	
	import Delgates.LoopManager;
	import Delgates.MouseActionDelegate;
	
	import Utils.Ragdoll;
	import Utils.StageRef;
	import Utils.World;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import mx.core.ByteArrayAsset;

	[SWF(width="1100", height="500", pageTitle="Angry Bairds", frameRate=100, backgroundColor=0x333333)]
	public class SlingShotGame extends Sprite
	{
		private var loopManager:LoopManager;
		
		[Embed("./Config/Structures.xml", mimeType="application/octet-stream")]
		private static const Structures:Class;
		
		public function SlingShotGame()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			StageRef.stage = stage;
			
			new BodyFactory( Config );
			Ragdoll.Simple( 70, 350, 100, true );
			
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