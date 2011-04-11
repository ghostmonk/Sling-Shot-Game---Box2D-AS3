package Events 
{	
	import flash.events.Event;
	
	/**
	 *@author ghostmonk - Apr 10, 2011
	 */
	public class LevelEvent extends Event 
	{
		public static const LEVEL_CHOICE:String = "levelChoice";
		public static const LEVEL_SUCCESS:String = "levelSuccess";
		public static const LEVEL_FAILED:String = "levelFailed";
		
		private var level:int;
		
		public function LevelEvent( type:String, level:int )
		{
			this.level = level;
			super( type, false, false );
		}
		
		public function get Level() : int
		{
			return level;
		}
		
		override public function clone():Event
		{
			return new LevelEvent( type, level );
		}
	}
}