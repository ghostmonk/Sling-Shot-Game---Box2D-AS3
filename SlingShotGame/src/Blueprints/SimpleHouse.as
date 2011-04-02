package Blueprints
{
	import Box2D.Dynamics.b2Body;
	
	import Utils.BodyMaker;
	import Utils.Proj;

	public class SimpleHouse
	{
		private var xOffset:Number = Proj.Meters( 600 );
		private var yOffset:Number = Proj.Meters( 400 );
		private var thickness:Number = Proj.Meters( 5 );
		private var length:Number = Proj.Meters( 100 );
		private var houseWidth:Number = length * 2 + thickness;
		
		private var leftWall:b2Body;
		private var rightWall:b2Body;
		private var roof:b2Body;
		
		public function SimpleHouse()
		{
			leftWall = BodyMaker.Box( xOffset, yOffset, thickness, length );
			rightWall = BodyMaker.Box( xOffset + houseWidth, yOffset, thickness, length );
			roof = BodyMaker.Box( xOffset + length, yOffset - length, length + thickness * 2, thickness );
		}
	}
}