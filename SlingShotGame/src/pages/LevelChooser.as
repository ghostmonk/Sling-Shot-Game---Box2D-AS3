package Pages 
{	
	import Events.LevelEvent;
	
	import caurina.transitions.Tweener;
	
	import com.ghostmonk.display.color.ColorConversion;
	import com.ghostmonk.ui.interactive.buttons.ClickableSprite;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.engine.EastAsianJustifier;
	
	import flashx.textLayout.utils.CharacterUtil;

	/**
	 *@author ghostmonk - Apr 10, 2011
	 */
	public class LevelChooser extends LevelChooserView
	{
		private var level1Badge:ClickableSprite;
		private var level2Badge:ClickableSprite;
		private var level3Badge:ClickableSprite;
		
		private var titleYHome:int;
		private var badge1XHome:int;
		private var badge2XHome:int;
		private var badge3XHome:int;
		
		private var titleYOut:int;
		private var badge1XOut:int;
		private var badge2XOut:int;
		private var badge3XOut:int;
		
		public function LevelChooser()
		{
			level1Badge = new ClickableSprite( badge1, OnChooseLevel1 );
			
			level2Badge = new ClickableSprite( badge2, OnChooseLevel2 );
			Disable( level2Badge );
			
			level3Badge = new ClickableSprite( badge3, OnChooseLevel3 );
			Disable( level3Badge );
			
			badge1.inner.title.text = Resources.Level1.toUpperCase();
			badge2.inner.title.text = Resources.Level2.toUpperCase();
			badge3.inner.title.text = Resources.Level3.toUpperCase();
			title.text = Resources.ChooseLevel.toUpperCase();
				
			titleYHome = title.y;
			badge1XHome = badge1.x;
			badge2XHome = badge2.x;
			badge3XHome = badge3.x;
			
			titleYOut = titleYHome - 100;
			badge1XOut = badge1XHome + 1400;
			badge2XOut = badge1XHome + 1400;
			badge3XOut = badge1XHome + 1400;
		}
		
		public function BuildIn() : void
		{
			title.y = titleYOut;
			Tweener.addTween( title, { y:titleYHome, time:0.3 } );
			
			badge1.x = badge1XOut;
			Tweener.addTween( badge1, { x:badge1XHome, time:0.3 } );
			
			badge2.x = badge2XOut;
			Tweener.addTween( badge2, { x:badge2XHome, time:0.3, delay:0.1 } );
			
			badge3.x = badge3XOut;
			Tweener.addTween( badge3, { x:badge3XHome, time:0.3, delay:0.2 } );
		}
		
		public function BuildOut() : void
		{
			title.y = titleYHome;
			Tweener.addTween( title, { y:titleYOut, time:0.3 } );
			
			badge1.x = badge1XHome;
			Tweener.addTween( badge1, { x:badge1XOut, time:0.3 } );
			
			badge2.x = badge2XHome;
			Tweener.addTween( badge2, { x:badge2XOut, time:0.3 } );
			
			badge3.x = badge3XHome;
			Tweener.addTween( badge3, { x:badge3XOut, time:0.3 } );
		}
		
		public function Unlock( level:int ) : void
		{
			if( level == 2 )
				Enable( level2Badge );
			
			if( level == 3 )
				Enable( level3Badge );
		}
		
		private function Enable( clip:ClickableSprite ) : void
		{
			clip.enable();
			clip.view.alpha = 1;
		}
		
		private function Disable( clip:ClickableSprite ) : void
		{
			clip.disable();
			clip.view.alpha = 0.3;
		}
		
		private function OnChooseLevel1( e:MouseEvent ) : void
		{
			dispatchEvent( new LevelEvent( LevelEvent.LEVEL_CHOICE, 1 ) );
		}
		
		private function OnChooseLevel2( e:MouseEvent ) : void
		{
			dispatchEvent( new LevelEvent( LevelEvent.LEVEL_CHOICE, 2 ) );
		}
		
		private function OnChooseLevel3( e:MouseEvent ) : void
		{
			dispatchEvent( new LevelEvent( LevelEvent.LEVEL_CHOICE, 3 ) );
		}
	}
}