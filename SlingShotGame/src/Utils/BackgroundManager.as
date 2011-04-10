package Utils 
{	
	import flash.display.Bitmap;
	import flash.display.Sprite;

	/**
	 *@author ghostmonk - Apr 9, 2011
	 */
	public class BackgroundManager 
	{
		public static function Level1BG( container:Sprite )
		{
			var bg:Bitmap = new Bitmap( new Level1BG() );
			var bg2:Bitmap = new Bitmap( new Level1BG() );
			bg2.scaleX = -1;
			var bg3:Bitmap = new Bitmap( new Level1BG() );
			bg3.scaleX = -1;
			bg.y = bg2.y = bg3.y = stage.stageHeight - bg.height + 90;
			bg3.x = bg.width * 2;
			container.addChildAt( bg, 0 );
			container.addChildAt( bg2, 0 );
			container.addChildAt( bg3, 0 );
		}
	}
}