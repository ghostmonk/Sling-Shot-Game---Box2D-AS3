package Pages 
{	
	import caurina.transitions.Equations;
	import caurina.transitions.Tweener;
	
	import com.ghostmonk.ui.interactive.buttons.ClickableSprite;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 *@author ghostmonk - Apr 16, 2011
	 */
	public class InstructionsPage extends InstructionPageView 
	{
		public static const NEXT_CLICKED:String = "nextClicked";
		
		public function InstructionsPage()
		{
			title.text = Resources.HowToPlay;
			instruction1.text = Resources.Instruction1;
			instruction2.text = Resources.Instruction2;
			instruction3.text = Resources.Instruction3;
			disclaimer.text = Resources.Disclaimer;
			
			iconTxt1.text = Resources.PublicService;
			iconTxt2.text = Resources.UniversalHealthCare;
			iconTxt3.text = Resources.GunControl;
			iconTxt4.text = Resources.WheatBoard;
			iconTxt5.text = Resources.Students;
			iconTxt6.text = Resources.Veterans;
			iconTxt7.text = Resources.Budget;
			iconTxt8.text = Resources.Broadcasting;
			iconTxt9.text = Resources.Environment;
			iconTxt10.text = Resources.Charter;
			iconTxt11.text = Resources.UN;
			iconTxt12.text = Resources.WomensRights;
			
			var next:ClickableSprite = new ClickableSprite( nextBtn, BuildOut );
			
			alpha = 0;
			addEventListener( Event.ADDED_TO_STAGE, BuildIn );
		}
		
		private function BuildIn( e:Event ) : void
		{
			Tweener.addTween( this, { alpha:1, time:0.3, transition:Equations.easeNone } );
		}
		
		private function BuildOut( e:Event ) : void
		{
			dispatchEvent( new Event( NEXT_CLICKED ) );
			Tweener.addTween( this, { alpha:0, time:0.3, transition:Equations.easeNone, 
				onComplete:function() : void
				{
					parent.removeChild( this );
				} } );
		}
	}
}