package Utils 
{
	
	import caurina.transitions.Equations;
	import caurina.transitions.Tweener;
	
	import com.ghostmonk.utils.SiteLoader;
	
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	/**
	 *@author ghostmonk - Apr 13, 2011
	 */
	public class GameLoader extends SiteLoader 
	{
		private var _preloader:SiteLoaderAsset;
		
		public function GameLoader()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			super( "SlingShotGame" );
			
			_preloader = new SiteLoaderAsset();
			addChild( _preloader );
			
			_preloader.alpha = 0;
			Tweener.addTween( _preloader, { alpha:1, time:0.3, transition:Equations.easeNone } );
			
			_preloader.x = ( stage.stageWidth - _preloader.width ) * 0.5;
			_preloader.y = ( stage.stageHeight - _preloader.height ) * 0.5;
			_preloader.percentTxt.text = "0%";
		}
		
		override protected function updateLoader( percent:Number ) : void 
		{	
			var number:int = Math.ceil( percent * _preloader.totalFrames );
			_preloader.percentTxt.text = number + "%";
			_preloader.gotoAndStop( number );	
		}
		
		override protected function cleanUp() : void 
		{
			Tweener.addTween( _preloader, { alpha:0, time:0.3, transition:Equations.easeNone, onComplete:removeChild, onCompleteParams:[ _preloader ] } );
		}
	}
}