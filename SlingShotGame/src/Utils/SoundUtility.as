package Utils {
	import flash.media.Sound;
	
	/**
	 *@author ghostmonk - Apr 16, 2011
	 */
	public class SoundUtility 
	{
		private static const ANGRY_BAIRD_SOUNDS:Array = [ 
			new AnyQuestionsSound(), 
			new AskMeToComeSound(), 
			new CorruptionSound(), 
			new DisgraceSound(), 
			new HowItWorksSound(), 
			new OrderSound()];
		
		private static var index:int = 0;
		
		public static function PlayNextAngryComment() : void
		{
			var comment:Sound = ANGRY_BAIRD_SOUNDS[index];
			comment.play();
			if( ++index == ANGRY_BAIRD_SOUNDS.length ) index = 0;
		}
	}
}