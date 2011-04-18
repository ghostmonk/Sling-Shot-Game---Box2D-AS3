package Box2DExtention
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2World;
	
	import GameTools.Box2dGameDraw;
	
	import flash.display.Sprite;
	
	/**
	 * A simple name for Global conversions.
	 * 
	 * @author ghostmonk
	 * 
	 */
	public class World
	{		
		private static const GRAVITY:b2Vec2 = new b2Vec2( 0, 10 );
		
		private static var world:b2World;
		private static var draw:Box2dGameDraw;
		
		private static var meterPixels:Number = 30;
		
		/**
		 * Returns a singleton instance of b2World.
		 * All code should cache a reference to the World through this method. 
		 * @return 
		 * 
		 */		
		public static function get Instance() : b2World
		{
			if( !world ) 
				world = new b2World( GRAVITY, true );
			return world;
		}
		
		public static function set MeterPixels( value:Number ) : void
		{
			meterPixels = value;
		}
		
		public static function View( root:Sprite ) : void
		{
			draw = Box2dGameDraw.Instance;
			draw.Container = root;
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
			draw.SetSprite(root);
			draw.SetDrawScale(meterPixels);
			draw.SetFillAlpha(0.3);
			draw.SetLineThickness(1.0);
			draw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);
			Instance.SetDebugDraw(draw);
			Instance.DrawDebugData();
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
			return pixels / meterPixels;
		}
	}
}