package Pages 
{	
	import caurina.transitions.Tweener;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 *@author ghostmonk - Apr 10, 2011
	 */
	public class TitleScreen extends TitleScreenPageView
	{
		public static const START_GAME:String = "startGame";
		
		public function TitleScreen()
		{
			startGameBtn.addEventListener( MouseEvent.CLICK, OnStartGameCick );
			titleClip.titleTxt.text = Resources.AngryBairds;
			startGameLabel.text = Resources.StartGame;
		}
		
		private function OnStartGameCick( e:MouseEvent ) : void
		{
			dispatchEvent( new Event( START_GAME ) );
			Tweener.addTween( this, { alpha:0, time:0.3, transition:"linear", 
				onComplete:function() : void
				{
					parent.removeChild( this );
				} } );
		}
	}
}