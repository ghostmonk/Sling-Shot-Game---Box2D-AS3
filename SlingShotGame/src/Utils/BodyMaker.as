package Utils
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Common.b2Settings;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	
	import Config.BodyDefSettings;
	import Config.FixtureDefSettings;

	public class BodyMaker
	{
		public static function Box( width:Number, height:Number ) : b2Body
		{
			var boxShape:b2PolygonShape = new b2PolygonShape();
			boxShape.SetAsBox( width, height );
			return GetFixturedBody( boxShape );
		}
		
		public static function Circle( radius:Number ) : b2Body
		{
			return GetFixturedBody( new b2CircleShape( radius ) );
		}
		
		public static function Triangle( width:Number, height:Number ) : b2Body
		{
			var bodyDef:b2BodyDef = GetBodyDef();
			var triangle:b2Body = World.Instance.CreateBody( bodyDef );
			
			var triangleShape:b2PolygonShape = new b2PolygonShape();
			var halfHeight:Number = height * 0.5;
			var halfWidth:Number = width * 0.5;
			
			var verticies:Array = [
				new b2Vec2( 0, halfHeight ),
				new b2Vec2( -halfWidth, -halfHeight ),
				new b2Vec2( halfWidth, -halfHeight ) ];
			
			triangleShape.SetAsArray( verticies, 3 );
			
			var fixtureDef:b2FixtureDef = GetFixtureDef();
			fixtureDef.shape = triangleShape;
			triangle.CreateFixture( fixtureDef );
			triangle.SetAngle( b2Settings.b2_pi );
			return triangle;
		}
		
		private static function GetFixturedBody( shape:b2Shape ) : b2Body
		{
			var fixtureDef:b2FixtureDef = GetFixtureDef();
			var body:b2Body = World.Instance.CreateBody( GetBodyDef() );
			fixtureDef.shape = shape;
			body.CreateFixture( fixtureDef );
			return body;
		}
		
		private static function GetFixtureDef() : b2FixtureDef
		{
			var	fixtureConf:FixtureDefSettings = FixtureDefSettings.Instance;
			var fixture:b2FixtureDef = new b2FixtureDef();
			fixture.density = fixtureConf.Density;
			fixture.friction = fixtureConf.Friction;
			fixture.isSensor = fixtureConf.IsSensor;
			fixture.restitution = fixtureConf.Restitution;
			
			return fixture;
		}
		
		private static function GetBodyDef() : b2BodyDef
		{
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
			
			return bodyDef;
		}
	}
}