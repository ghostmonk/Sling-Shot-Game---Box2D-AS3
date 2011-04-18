package GameTools
{
	import flash.display.Sprite;
	import flash.geom.Point;

	public class TrajectoryPath extends Sprite
	{
		private var fillColor:uint = 0xFFFFFF;
		private var fillAlpha:Number = 1;
		private var dashRadius:int = 2;
		
		public function Update( point:Point ) : void
		{
			graphics.beginFill( fillColor, fillAlpha );
			graphics.drawCircle( point.x, point.y, dashRadius ); 
			graphics.endFill();
		}
		
		public function Clear() : void
		{
			graphics.clear();
		}
	}	
}