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
		public static var GameComplete:String;
		
		public static var Menu:String;
		public static var Reload:String;
		public static var Next:String;
		
		public static var BairdsLeft:String;
		public static var Score:String;
		
		public static var HowToPlay:String;
		public static var Instruction1:String;
		public static var Instruction2:String;
		public static var Instruction3:String;
		public static var Disclaimer:String;
		
		public static var PublicService:String;
		public static var UniversalHealthCare:String;
		public static var GunControl:String;
		public static var WheatBoard:String;
		public static var Students:String;
		public static var Veterans:String;
		public static var Budget:String;
		public static var Broadcasting:String;
		public static var Environment:String;
		public static var Charter:String;
		public static var UN:String;
		public static var WomensRights:String;
		
		public static var SupremeCourt:String;
		public static var ParliamentHill:String;
		public static var TonyGazebo:String;
		public static var VoteLiberal:String;
		
		public static function SetLanguage( isEnglish:Boolean ) : void
		{
			ParliamentHill = isEnglish ? "Parliament Hill" : "Colline parlementaire";
			Level1 = isEnglish ? "Level 1" : "Niveau 1";
			Level2 = isEnglish ? "Level 2" : "Niveau 2";
			ChooseLevel = isEnglish ? "Choose A Level" : "Choisissez un niveau";
			Level3 = isEnglish ? "Level 3" : "Niveau 3";
			Pause = isEnglish ? "Pause" : "Pause";
			TryAgain = isEnglish ? "Try Again?" : "Essayez encore ?";
			YouWin = isEnglish ? "You Win!!" : "Vous gagnez !!";
			Menu = isEnglish ? "Menu" : "Menu";
			Reload = isEnglish ? "Reload" : "Rechargez";
			Next = isEnglish ? "Next" : "Au suivant";
			Disclaimer = "© 2011 Authorized by The Federal Liberal Agency of Canada, registered agent for the Liberal Party of Canada.";
			
			GameComplete = isEnglish ? "Game Over for Angry Harper and Angry Baird" : "C’est fini pour Harper-en-colère et Baird-en-colère";
			VoteLiberal = isEnglish ? "On May 2nd  - Vote Liberal" : "Votez libéral le 2 mai";
			
			AngryBairds = isEnglish ? "Angry Bairds" : "Bairds-en-colère";
					
			BairdsLeft = isEnglish ? "Bairds Left: " : "bairds restant: ";
			Score = isEnglish ? "Score:" : "Points: ";
			
			HowToPlay = isEnglish ? "How to play Angry Bairds" : "Comment jouer à bairds-en-colère";
			Instruction1 = isEnglish ? "1. Click on Angry Baird to help Harper pull the slingshot back" : "1. Cliquez sur  Baird-en-colère et aidez Harper à tirer la fronde vers l’arrière";
			Instruction2 = isEnglish ? "2. Aim and unleash him towards the Canadian groups and institutions on Harper’s hit list" : "2. Visez et lancez-le en direction des différents groupes et institutions du Canada sur la liste de Harper";
			Instruction3 = isEnglish ? "3. Crash Angry Baird into the various buildings" : "3. Utilisez Baird-en-colère pour fracasser différents édifices";
			
			PublicService = isEnglish ? "Public Servants" : "Fonctionnaires";
			UniversalHealthCare = isEnglish ? "Universal Healthcare" : "Système de soins de santé universel";
			GunControl = isEnglish ? "Gun Control" : "Contrôle des armes à feu";
			WheatBoard = isEnglish ? "The Wheat Board" : "La Commission du blé";
			Students = isEnglish ? "Students" : "Étudiants";
			Veterans = isEnglish ? "Vetrans" : "Anciens combattants";
			Budget = isEnglish ? "Parliamentary Budget Office" : "Bureau parlementaire du budget";
			Broadcasting = isEnglish ? "Public Broadcasting" : "Radiodiffusion publique";
			Environment = isEnglish ? "The Environment" : "L’environnement";
			Charter = isEnglish ? "Charter of Rights and Freedoms" : "La Charte des droits et libertés";
			UN = isEnglish ? "The U.N." : "Les Nations Unies";
			WomensRights = isEnglish ? "Women's Rights" : "Les droits des femmes";
			
			SupremeCourt = isEnglish ? "Supreme Court of Canada" : "Cour suprême du Canada";
			TonyGazebo = isEnglish ? "Tony's Gazebo" : "Pavillon de Tony";
		}
	}
}