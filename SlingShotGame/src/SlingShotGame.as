package
{	
	import Events.ControlPanelEvent;
	import Events.LevelEvent;
	
	import Pages.ControlPanel;
	import Pages.GamePage;
	import Pages.LevelChooser;
	import Pages.TitleScreen;
	
	import Utils.HUD;
	import Utils.KeyPressController;
	import Utils.StageRef;
	
	import com.ghostmonk.utils.TimedCallback;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;

	[SWF(width="1100", height="500", pageTitle="Angry Bairds", frameRate=100, backgroundColor=0x333333)]
	[Frame ( factoryClass="Utils.GameLoader" ) ]
	public class SlingShotGame extends Sprite
	{
		private var titleScreen:TitleScreen;
		private var levelChooser:LevelChooser;
		private var gamePage:GamePage;
		private var controlPanel:ControlPanel;
		
		public function SlingShotGame()
		{
			addEventListener( Event.ADDED_TO_STAGE, OnAddedToStage );
		}
		
		private function OnAddedToStage( e:Event ) : void
		{
			removeEventListener( Event.ADDED_TO_STAGE, OnAddedToStage );
			
			StageRef.stage = stage;
			Resources.SetLanguage( true );
			
			CreateControlPanel();
			
			titleScreen = new TitleScreen();
			titleScreen.addEventListener( TitleScreen.START_GAME, OnStartGameStart );
			addChild( titleScreen );
			
			KeyPressController.Instance.addEventListener( KeyPressController.KEY_PRESS, OnKeyPress );
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
			if( gamePage == null )
			{
				gamePage = new GamePage();
				gamePage.addEventListener( LevelEvent.LEVEL_SUCCESS, OnLevelSuccess );
				gamePage.addEventListener( LevelEvent.LEVEL_FAILED, OnLevelFailed );
				gamePage.Init();
			}
			gamePage.visible = true;
			gamePage.StartLevel( level );
		}
		
		private function OnLevelSuccess( e:LevelEvent ) : void
		{
			HUD.Instance.ScoreLeftOverMen();
			levelChooser.Unlock( e.Level + 1 );
			stage.addChild( controlPanel );
			
			if( gamePage.currentLevel == 3 )
				controlPanel.GameComplete();
			else
				controlPanel.SetWin();
				
			controlPanel.BuildIn();
		}
		
		private function OnLevelFailed( e:LevelEvent ) : void
		{
			stage.addChild( controlPanel );
			controlPanel.SetLose();
			controlPanel.BuildIn();	
		}
		
		private function OnControlPanelCancel( e:ControlPanelEvent ) : void
		{
			trace( "cancel" );
		}
		
		private function OnNextLevel( e:ControlPanelEvent ) : void
		{
			controlPanel.BuildOut();
			gamePage.NextLevel();
		}
		
		private function OnReloadLevel( e:ControlPanelEvent ) : void
		{
			controlPanel.BuildOut();
			gamePage.ResetGame();
		}
		
		private function OnReturnToMenu( e:ControlPanelEvent ) : void
		{
			controlPanel.BuildOut();
			HUD.Instance.visible = false;
			gamePage.visible = false;
			addChild( levelChooser );
			
			levelChooser.BuildIn();
		}
		
		private function OnKeyPress( e:KeyboardEvent ) : void
		{
			if( e.keyCode != 32 ) return;
			
			if( controlPanel.IsActive ) 
			{
				controlPanel.BuildOut();
				return;
			}
			
			stage.addChild( controlPanel );
			controlPanel.SetPause();
			controlPanel.BuildIn();
		}
	}
}