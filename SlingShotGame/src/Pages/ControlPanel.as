package Pages 
{	
	import Events.ControlPanelEvent;
	
	import caurina.transitions.Equations;
	import caurina.transitions.Tweener;
	
	import com.ghostmonk.ui.interactive.buttons.ClickableSprite;
	
	import flash.events.MouseEvent;

	[Event ( name="reload", type="Events.ControlPanelEvent" )]
	[Event ( name="returnToMenu", type="Events.ControlPanelEvent" )]
	[Event ( name="nextLevel", type="Events.ControlPanelEvent" )]
	[Event ( name="cancel", type="Events.ControlPanelEvent" )]
	
	/**
	 *@author ghostmonk - Apr 10, 2011
	 */
	public class ControlPanel extends ControlPanelView 
	{
		private var reload:ClickableSprite;
		private var next:ClickableSprite;
		private var menu:ClickableSprite;
		private var close:ClickableSprite;
		
		public function ControlPanel()
		{
			reload = new ClickableSprite( reloadBtn, OnReload );
			next = new ClickableSprite( nextBtn, OnNext );
			menu = new ClickableSprite( menuBtn, OnMenu );
			close = new ClickableSprite( closeBtn, OnClose );
			disable();
		}
		
		public function BuildIn() : void
		{
			alpha = 0;
			Tweener.addTween( this, { alpha:1, time:0.3, transition:Equations.easeNone,
				onComplete : function() : void
				{
					enable();
				}} );
		}
		
		public function BuildOut() : void
		{
			disable();
			Tweener.addTween( this, { alpha:0, time:0.3, transition:Equations.easeNone,
				onComplete : function() : void
				{
					if( parent ) 
						parent.removeChild( this );
				}} );
		}
		
		public function enable() : void
		{
			reload.enable();
			next.enable();
			menu.enable();
			close.enable();
		}
		
		public function disable() : void
		{
			reload.disable();
			next.disable();
			menu.disable();
			close.disable();
		}
		
		public function set Title( value:String ) : void
		{
			title.text = value;
		}
		
		private function OnReload( e:MouseEvent ) : void
		{
			dispatchEvent( new ControlPanelEvent( ControlPanelEvent.RELOAD ) );
		}
		
		private function OnNext( e:MouseEvent ) : void
		{	
			dispatchEvent( new ControlPanelEvent( ControlPanelEvent.RELOAD ) );
		}
		
		private function OnMenu( e:MouseEvent ) : void
		{
			dispatchEvent( new ControlPanelEvent( ControlPanelEvent.RELOAD ) );	
		}
		
		private function OnClose( e:MouseEvent ) : void
		{
			dispatchEvent( new ControlPanelEvent( ControlPanelEvent.CANCEL ) );	
			BuildOut();
		}
	}
}