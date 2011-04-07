package
{	
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	
	import Config.BodyFactory;
	
	import Delgates.LoopManager;
	import Delgates.MouseActionDelegate;
	
	import GameTools.SlingShot;
	
	import Utils.Ragdoll;
	import Utils.StageRef;
	import Utils.World;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import mx.core.ByteArrayAsset;

	[SWF(width="1100", height="500", pageTitle="Angry Bairds", frameRate=100, backgroundColor=0x333333)]
	public class SlingShotGame extends Sprite
	{
		private var loopManager:LoopManager;
		private var controlPanel:ControlPanel;
		private var slingShot:SlingShot;
		private var currentRagDoll:Array = [];
		
		[Embed("./Config/Structures.xml", mimeType="application/octet-stream")]
		private static const Structures:Class;
		
		public function SlingShotGame()
		{
			stage.addEventListener( KeyboardEvent.KEY_DOWN, OnKeyDown );
			slingShot = new SlingShot( 300, 300 );
			slingShot.x = 250;
			slingShot.y = 250;
			stage.addChild( slingShot );
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			StageRef.stage = stage;
			
			CreateWorld();
			World.DebugView( this );
			loopManager = new LoopManager();
			loopManager.ShowFpsCounter = true;
			
			controlPanel = new ControlPanel();
			controlPanel.addEventListener( ControlPanel.RESET_GAME, ResetGame );
			controlPanel.addEventListener( ControlPanel.NEW_MAN, NewMan );
			
			stage.addChild( controlPanel );
			controlPanel.x = ( stage.stageWidth - controlPanel.width ) * 0.5;
			controlPanel.y = 25;
			
		}
		
		private function ResetGame( e:Event ) : void
		{
			var body:b2Body = World.Instance.GetBodyList();
			while( body )
			{
				World.Instance.DestroyBody( body );
				body = World.Instance.GetBodyList();	
			}
			CreateWorld();
		}
		
		private function NewMan( e:Event = null ) : void
		{
			for each( var body:b2Body in currentRagDoll )
			{
				World.Instance.DestroyBody( body );
			}
			currentRagDoll = Ragdoll.Simple( 90, 350, 100 );
			slingShot.Load( currentRagDoll[ 0 ] );
		}
		
		private function CreateWorld() : void
		{
			new BodyFactory( Config );
			NewMan();
		}
		
		private function OnKeyDown( e:KeyboardEvent ) : void
		{
			if( e.keyCode == 39 ) x -= 100;
			else x += 100;
		}
		
		private function get Config() : XML 
		{	
			var byteArray:ByteArrayAsset = ByteArrayAsset( new Structures() );
			return new XML( byteArray.readUTFBytes( byteArray.length ) );	
		}
	}
}