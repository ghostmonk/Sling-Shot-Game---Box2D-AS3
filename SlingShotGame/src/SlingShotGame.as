package
{	
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	
	import Box2DExtention.Config.BodyFactory;
	import Box2DExtention.Delgates.LoopManager;
	import Box2DExtention.Delgates.MouseActionDelegate;
	import Box2DExtention.Factories.Ragdoll;
	import Box2DExtention.World;
	
	import GameTools.SlingShot;
	
	import Utils.ControlPanel;
	import Utils.StageRef;
	
	import caurina.transitions.Tweener;
	
	import com.ghostmonk.utils.GridMaker;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
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
		
		private var startY:Number;
		
		private var scaleEater:Sprite;
		
		[Embed("Structures.xml", mimeType="application/octet-stream")]
		private static const Structures:Class;
		
		public function SlingShotGame()
		{
			scaleEater = new Sprite();
			stage.addChild( scaleEater );
			scaleEater.addChild( this );
			stage.addEventListener( KeyboardEvent.KEY_DOWN, OnKeyDown );
			slingShot = new SlingShot( 300, 300, this );
			slingShot.x = 180;
			slingShot.y = 280;
			slingShot.addEventListener( SlingShot.SHOT_COMPLETE, OnShotComplete );
			slingShot.addEventListener( SlingShot.SLING_RELEASE, OnSlingRelease );
			addChild( slingShot );
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			StageRef.stage = stage;
			
			CreateWorld();
			World.DebugView( this );
			loopManager = new LoopManager();
			//loopManager.ShowFpsCounter = true;
			
			controlPanel = new ControlPanel();
			controlPanel.addEventListener( ControlPanel.RESET_GAME, ResetGame );
			controlPanel.addEventListener( ControlPanel.NEW_MAN, NewMan );
			
			stage.addChild( controlPanel );
			controlPanel.x = ( stage.stageWidth - controlPanel.width ) * 0.5;
			controlPanel.y = 25;
			startY = scaleEater.y;
			
			CreateGrid();
		}
		
		private function OnShotComplete( e:Event ) : void
		{
			Tweener.addTween( this, { x:0, y:0, scaleX:1, scaleY:1, time:3 } );
			Tweener.addTween( scaleEater, { scaleX:1, scaleY:1, y:startY, time:3,
				onComplete: function() : void { NewMan(); } 
			} );
		}
		
		private function OnSlingRelease( e:Event ) : void
		{
			if( scaleX == 1 ) Zoom( 0.5 );
		}
		
		private function get Config() : XML 
		{	
			var byteArray:ByteArrayAsset = ByteArrayAsset( new Structures() );
			return new XML( byteArray.readUTFBytes( byteArray.length ) );	
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
			slingShot.Load( currentRagDoll );
		}
		
		private function CreateWorld() : void
		{
			new BodyFactory( Config );
			NewMan();
		}
		
		private function OnKeyDown( e:KeyboardEvent ) : void
		{
			switch( e.keyCode )
			{
				case 37: x += 50; break;
				case 38: y -= 50; break;
				case 39: x -= 50; break;
				case 40: y += 50; break;
				case 71: CreateGrid(); break;
				case 90: Zoom( 0.4, 0.3 ); break;
			}
		}
		
		private function Zoom( percent:Number, time:Number = 1.5 ) : void
		{
			Tweener.removeAllTweens();
			var scale:Number = scaleEater.scaleX == 1 ? percent : 1;
			Tweener.addTween( scaleEater, {scaleX:scale, scaleY:scale, time:time, transition:"linear",
				onUpdate: function(): void
				{ 
					scaleEater.y = startY + ( ( 1 - scaleEater.scaleX ) * stage.stageHeight );
				} 
			} );
		}
		
		private function CreateGrid() : void
		{
			var sprite:Sprite = new Sprite();
			sprite.graphics.drawRect( 0, 0, width, height * 2 );
			GridMaker.lineStyle( 0, 0xFFFFFF, 0.3 );
			GridMaker.drawGrid( sprite, 50, 100 );
			sprite.y = -9000;
			addChild( sprite );
		}
	}
}