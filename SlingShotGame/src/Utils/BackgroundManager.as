package Utils 
{	
	import flash.display.Bitmap;
	import flash.display.Sprite;

	/**
	 *@author ghostmonk - Apr 9, 2011
	 */
	public class BackgroundManager 
	{
		private static var gradientBackground:GradientBackground = new GradientBackground();
		private static var grass:Grass = new Grass();
		private static var isGradBgActive:Boolean = false;
		private static var clouds:Array = []; 
		
		public static function AddGradientBackground() : void
		{
			if( isGradBgActive ) return;
			isGradBgActive = true;
			StageRef.stage.addChildAt( gradientBackground, 0 );
			if( grass.parent == StageRef.stage )
				StageRef.stage.removeChild( grass );
		}
		
		public static function RemoveGradientBackground() : void
		{
			if( !isGradBgActive ) return;
			isGradBgActive = false;
			StageRef.stage.addChildAt( grass, 1 );
			//StageRef.stage.removeChild( gradientBackground );
		}
		
		public static function AddClouds( container:Sprite ) : void
		{
			clouds = [];
			
			for( var i:int = 0; i < 20; i++ )
			{
				var cloud:Sprite = Math.random() > 0.5 ? new LargeCloud : new SmallCloud();
				clouds.push( cloud );
				cloud.x = 2500 * Math.random();
				cloud.y = 700 * Math.random() - 600;
				cloud.scaleX = cloud.scaleY = 1 + Math.random();
				container.addChildAt( cloud, 0 ); 
			}
		}
		
		public static function ClearClouds( container:Sprite ) : void
		{
			for each( var cloud:Sprite in clouds )
			{
				container.removeChild( cloud );
			}
		}
		
		public static function SetLevel1BG( container:Sprite ) : void
		{
			var bg:Bitmap = new Bitmap( new Level1BG() );
			var bg2:Bitmap = new Bitmap( new Level1BG() );
			bg2.scaleX = -1;
			var bg3:Bitmap = new Bitmap( new Level1BG() );
			bg3.scaleX = -1;
			bg.y = bg2.y = bg3.y = StageRef.stage.stageHeight - bg.height + 90;
			bg3.x = bg.width * 2;
			container.addChildAt( bg, 0 );
			container.addChildAt( bg2, 0 );
			container.addChildAt( bg3, 0 );
		}
	}
}