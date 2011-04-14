package Utils 
{	
	import caurina.transitions.Tweener;
	
	import flash.display.Sprite;

	/**
	 *@author ghostmonk - Apr 6, 2011
	 */
	public class HUD extends HudView
	{
		private var menLeft:int;
		private var score:int;
		
		private var men:Array = [];
		
		private static var instance:HUD;
		
		public function HUD()
		{
			instance = this;
			Reset();
			score = 0;
			scoreTxt.text = score.toString();
			bairdsLabel.text = Resources.BairdsLeft.toUpperCase();
			scoreLabel.text = Resources.Score.toUpperCase();
		}
		
		public static function get Instance() : HUD
		{
			return instance || new HUD();
		}
		
		public function get MenLeft() : int
		{
			return men.length;	
		}
		
		public function AddToScore( amt:int ) : void
		{
			score += amt;
			scoreTxt.text = score.toString();
		}
		
		public function ScoreLeftOverMen() : void
		{
			AddToScore( men.length * 1000 );
			RemoveMan();
			RemoveMan();
			RemoveMan();			
		}
		
		public function Reset() : void
		{
			men = [ man1, man2, man3 ];
			for each( var man:Sprite in men )
			{
				man.visible = true;
				Tweener.addTween( man, { alpha:1, time:0.5, transition:"linear" } );
			}
		} 
		
		public function RemoveMan() : void
		{
			if( men.length == 0 ) return;
			var target:Sprite = men.pop();
			Tweener.addTween( target, { alpha:0, time:0.5, transition:"linear",
				onComplete:function() : void
				{
					target.visible = false;
				}} );
		}
	}
}