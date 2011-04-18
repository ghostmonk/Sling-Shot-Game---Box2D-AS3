package
{	
	import Events.ControlPanelEvent;
	import Events.LevelEvent;
	
	import Pages.ControlPanel;
	import Pages.GamePage;
	import Pages.InstructionsPage;
	import Pages.LevelChooser;
	import Pages.TitleScreen;
	
	import Utils.BackgroundManager;
	import Utils.HUD;
	import Utils.KeyPressController;
	import Utils.SoundUtility;
	import Utils.StageRef;
	
	import com.ghostmonk.utils.TimedCallback;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;

	[SWF(width="1100", height="500", pageTitle="Angry Bairds", frameRate=100, backgroundColor=0x333333)]
	[Frame ( factoryClass="Utils.GameLoader" ) ]
	public class SlingShotGame extends Sprite
	{
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
			
			//CreateNewGame( 3 );
			CreateControlPanel();
			
			BackgroundManager.AddGradientBackground();
			var titleScreen:TitleScreen = new TitleScreen();
			titleScreen.addEventListener( TitleScreen.START_GAME, OnInstructions );
			addChild( titleScreen );
		}
		
		private function OnInstructions( e:Event ) : void
		{
			var instructions:InstructionsPage = new InstructionsPage();
			instructions.addEventListener( InstructionsPage.NEXT_CLICKED, OnStartGameStart );
			addChild( instructions );
		}
		
		private function OnStartGameStart( e:Event ) : void
		{
			levelChooser = new LevelChooser();
			levelChooser.addEventListener( LevelEvent.LEVEL_CHOICE, OnLevelChosen );
			addChild( levelChooser );
			
			levelChooser.BuildIn();
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
		
		private function OnLevelChosen( e:LevelEvent ) : void
		{
			KeyPressController.Instance.addEventListener( KeyPressController.KEY_PRESS, OnKeyPress );
			BackgroundManager.RemoveGradientBackground();
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
			StageRef.stage.addChild( HUD.Instance );
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
			BackgroundManager.AddGradientBackground();
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