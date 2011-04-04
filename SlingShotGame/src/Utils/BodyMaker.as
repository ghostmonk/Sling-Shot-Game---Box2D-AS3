package Utils
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	
	import Config.BodyDefSettings;
	import Config.FixtureDefSettings;

	public class BodyMaker
	{
		public static function Box( width:Number, height:Number ) : b2Body
		{
			var boxShape:b2PolygonShape = new b2PolygonShape();
			boxShape.SetAsBox( width, height );
			return Shape( boxShape );
		}
		
		public static function Circle( radius:Number ) : b2Body
		{
			return Shape( new b2CircleShape( radius ) );
		}
		
		private static function Shape( shape:b2Shape ) : b2Body
		{
			var	fixtureConf:FixtureDefSettings = FixtureDefSettings.Instance;
			var bodyConf:BodyDefSettings = BodyDefSettings.Instance;
			
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.type = bodyConf.Type;
			bodyDef.active = bodyConf.Active;
			bodyDef.allowSleep = bodyConf.AllowSleep;
			bodyDef.angle = bodyConf.Angle;
			bodyDef.angularDamping = bodyConf.AngularDamping;
			bodyDef.angularVelocity = bodyConf.AngularVelocity;
			bodyDef.awake = bodyConf.Awake;
			bodyDef.bullet = bodyConf.Bullet;
			bodyDef.fixedRotation = bodyConf.FixedRotation;
			bodyDef.inertiaScale = bodyConf.InertiaScale;
			bodyDef.linearDamping = bodyConf.LinearDamping;
			bodyDef.linearVelocity = new b2Vec2( bodyConf.LinearVelocityX, bodyConf.LinearVelocityY );  
			bodyDef.position = new b2Vec2( bodyConf.X, bodyConf.Y ); 
			
			var fixture:b2FixtureDef = new b2FixtureDef();
			fixture.shape = shape;
			fixture.density = fixtureConf.Density;
			fixture.friction = fixtureConf.Friction;
			fixture.isSensor = fixtureConf.IsSensor;
			fixture.restitution = fixtureConf.Restitution;
			
			var body:b2Body = World.Instance.CreateBody( bodyDef );
			body.CreateFixture( fixture );
			
			return body;
		}
	}
}