package
{	
	import Events.ControlPanelEvent;
	import Events.LevelEvent;
	
	import Pages.ControlPanel;
	import Pages.GamePage;
	import Pages.LevelChooser;
	import Pages.TitleScreen;
	
	import Utils.StageRef;
	
	import com.ghostmonk.utils.GridMaker;
	import com.ghostmonk.utils.TimedCallback;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;

	[SWF(width="1100", height="500", pageTitle="Angry Bairds", frameRate=100, backgroundColor=0x333333)]
	public class SlingShotGame extends Sprite
	{
		private var titleScreen:TitleScreen;
		private var levelChooser:LevelChooser;
		private var gamePage:GamePage;
		private var controlPanel:ControlPanel;
		
		public function SlingShotGame()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			StageRef.stage = stage;
			Resources.SetLanguage( true );
			
			CreateControlPanel();
			
			titleScreen = new TitleScreen();
			titleScreen.addEventListener( TitleScreen.START_GAME, OnStartGameStart );
			addChild( titleScreen );
		}
		
		private function CreateControlPanel() : void
		{
			controlPanel = new ControlPanel();
			controlPanel.x = ( stage.stageWidth - controlPanel.width ) * 0.5;
			controlPanel.y = ( stage.stageHeight - controlPanel.height ) * 0.5;
			controlPanel.addEventListener( ControlPanelEvent.CANCEL, OnControlPanelCancel );
			controlPanel.addEventListener( ControlPanelEvent.NEXT_LEVEL, OnNextLevel );
			controlPanel.addEventListener( ControlPanelEvent.RELOAD, OnReloadLevel );
			controlPanel.addEventListener( ControlPanelEvent.RETURN_TO_MENU, OnReturnToMenu );
		}
		
		private function OnStartGameStart( e:Event ) : void
		{
			levelChooser = new LevelChooser();
			levelChooser.addEventListener( LevelEvent.LEVEL_CHOICE, OnLevelChosen );
			addChild( levelChooser );
			
			levelChooser.BuildIn();
		}
		
		private function OnLevelChosen( e:LevelEvent ) : void
		{
			levelChooser.BuildOut();
			TimedCallback.create( CreateNewGame, 300, e.Level );
		}
		
		private function CreateNewGame( level:int ) : void
		{
			gamePage = new GamePage();
			gamePage.addEventListener( LevelEvent.LEVEL_SUCCESS, OnLevelSuccess );
			gamePage.addEventListener( LevelEvent.LEVEL_FAILED, OnLevelFailed );
			gamePage.Init();
			gamePage.StartLevel( level );
		}
		
		private function OnLevelSuccess( e:LevelEvent ) : void
		{
			stage.addChild( controlPanel );
			controlPanel.Title = "YOU WIN!!";
			controlPanel.BuildIn();
		}
		
		private function OnLevelFailed( e:LevelEvent ) : void
		{
			stage.addChild( controlPanel );
			controlPanel.Title = "TRY AGAIN?";
			controlPanel.BuildIn();	
		}
		
		private function OnControlPanelCancel( e:ControlPanelEvent ) : void
		{
			trace( "cancel" );
		}
		
		private function OnNextLevel( e:ControlPanelEvent ) : void
		{
			
		}
		
		private function OnReloadLevel( e:ControlPanelEvent ) : void
		{
			
		}
		
		private function OnReturnToMenu( e:ControlPanelEvent ) : void
		{
			
		}
	}
}