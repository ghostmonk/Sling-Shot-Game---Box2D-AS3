package Utils
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2World;
	
	import flash.display.Sprite;
	
	/**
	 * A simple name for Global conversions.
	 * 
	 * @author ghostmonk
	 * 
	 */
	public class Proj
	{
		/**
		 * How many pixels make up a meter in the Box2D world. 
		 */		
		public static const METER_PIXELS:Number = 30;
		
		/**
		 * The default Gravity setting for the world. 
		 */		
		public static const GRAVITY:b2Vec2 = new b2Vec2( 0, 50 );
		
		private static var world:b2World;
		
		/**
		 * The World function returns a singleton instance of b2World.
		 * All code should cache a reference to the World through this method. 
		 * @return 
		 * 
		 */		
		public static function get World() : b2World
		{
			if( !world ) world = new b2World( GRAVITY, true );
			return world;
		}
		
		/**
		 * Creates a default view for testing your game.
		 * Good for prototypes. 
		 *  
		 * @param root
		 * 
		 */		
		public static function DebugView( root:Sprite ) : void
		{
			var draw:b2DebugDraw = new b2DebugDraw();
			draw.SetSprite( root );
			draw.SetDrawScale( METER_PIXELS );
			draw.SetLineThickness( 1.0 );
			draw.SetAlpha( 1 );
			draw.SetAlpha( 0.4 );
			draw.SetFlags( b2DebugDraw.e_shapeBit );
			World.SetDebugDraw( draw );
		}
		
		/**
		 * Convert to Box2D Meters... because pixels are universal in flash, this conversion helper should be used 
		 * instead of straight literals in code that is not performance critical.
		 *  
		 * @param pixels
		 * @return 
		 * 
		 */		
		public static function Meters( pixels:Number ) : Number
		{
			return pixels / METER_PIXELS;
		}
	}
}