package Utils
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;

	public class BodyMaker
	{
		public static function Box( x:Number, y:Number, width:Number, height:Number, isStatic:Boolean = false, friction:Number = 0.5, density:Number = 1 ) : b2Body
		{
			var boxBodyDef:b2BodyDef = new b2BodyDef();
			boxBodyDef.type = isStatic ? b2Body.b2_staticBody : b2Body.b2_dynamicBody;
			boxBodyDef.position.Set( x, y );
			
			var body:b2Body = Settings.World.CreateBody( boxBodyDef );
			
			var boxShape:b2PolygonShape = new b2PolygonShape();
			boxShape.SetAsBox( width, height );
			
			var fixture:b2FixtureDef = new b2FixtureDef();
			fixture.shape = boxShape;
			fixture.density = density;
			fixture.friction = friction;
			
			body.CreateFixture( fixture );
			
			return body;
		}
	}
}