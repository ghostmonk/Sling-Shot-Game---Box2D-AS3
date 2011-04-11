package 
{
	
	/**
	 *@author ghostmonk - Apr 10, 2011
	 */
	public class Resources 
	{
		public static var AngryBairds:String;
		public static var StartGame:String;
		
		public static var ChooseLevel:String;
		public static var Level1:String;
		public static var Level2:String;
		public static var Level3:String;
		
		public static var Pause:String;
		public static var TryAgain:String;
		public static var YouWin:String;
		
		public static var Menu:String;
		public static var Reload:String;
		public static var Next:String;
		
		public static var BairdsLeft:String;
		public static var Score:String;
		
		public static function SetLanguage( isEnglish:Boolean ) : void
		{
			AngryBairds = "Angry Bairds";
			StartGame = "Start Game";
			
			ChooseLevel = "Choose A Level";
			Level1 = "Level 1";
			Level2 = "Level 2";
			Level3 = "Level 3";
			
			Pause = "Pause";
			TryAgain = "Try Again?";
			YouWin = "You Win!!";
			
			Menu = "Menu";
			Reload = "Reload";
			Next = "Next";
			
			BairdsLeft = "Bairds Left";
			Score = "Score";
		}
	}
}