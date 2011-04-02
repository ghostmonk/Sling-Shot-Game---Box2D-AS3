package Utils
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2World;
	
	import flash.display.Sprite;

	public class Settings
	{
		public static const METER_PIXELS:Number = 30;
		public static const GRAVITY:b2Vec2 = new b2Vec2( 0, 50 );
		
		private static var world:b2World;
		
		public static function get World() : b2World
		{
			if( !world ) world = new b2World( GRAVITY, true );
			return world;
		}
		
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
		
	}
}