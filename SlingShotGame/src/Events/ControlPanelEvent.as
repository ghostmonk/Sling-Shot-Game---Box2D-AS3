package Events 
{	
	import flash.events.Event;
	
	/**
	 *@author ghostmonk - Apr 10, 2011
	 */
	public class ControlPanelEvent extends Event 
	{
		public static const RELOAD:String = "reload";
		public static const RETURN_TO_MENU:String = "returnToMenu";
		public static const NEXT_LEVEL:String = "nextLevel";
		public static const CANCEL:String = "cancel";
		
		public function ControlPanelEvent( type:String )
		{
			super( type, bubbles, cancelable );
		}
		
		override public function clone() : Event
		{
			return new ControlPanelEvent( type );
		}
	}
}