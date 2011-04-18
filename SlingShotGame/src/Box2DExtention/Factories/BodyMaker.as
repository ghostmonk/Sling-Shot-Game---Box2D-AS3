package Box2DExtention.Factories
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
	
	import Box2DExtention.Config.BodyDefSettings;
	import Box2DExtention.Config.FixtureDefSettings;
	import Box2DExtention.World;
	
	import com.ghostmonk.utils.ObjectFuncs;

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
		
		public static function Trapezoid( topWidth:Number, bottomWidth:Number, height:Number ) : b2Body
		{
			var halfTop:Number = topWidth * 0.5;
			var halfBottom:Number = bottomWidth * 0.5;
			var halfHeight:Number = height * 0.5;
			
			var trapShape:b2PolygonShape = new b2PolygonShape();
			trapShape.SetAsArray( [
				new b2Vec2( -halfTop, -halfHeight ),
				new b2Vec2( halfTop, -halfHeight ),
				new b2Vec2( halfBottom, halfHeight ),
				new b2Vec2( -halfBottom, halfHeight )], 4 );
			
			return GetFixturedBody( trapShape );
		}
		
		public static function Triangle( width:Number, height:Number ) : b2Body
		{
			var halfHeight:Number = height * 0.5;
			var halfWidth:Number = width * 0.5;
			
			var triangleShape:b2PolygonShape = new b2PolygonShape();
			triangleShape.SetAsArray( [
				new b2Vec2( 0, -halfHeight  ),
				new b2Vec2( halfWidth, halfHeight ),
				new b2Vec2( -halfWidth, halfHeight )], 3 );
			
			return  GetFixturedBody( triangleShape );
		}
		
		private static function GetFixturedBody( shape:b2Shape ) : b2Body
		{
			var fixtureDef:b2FixtureDef = GetFixtureDef();
			var body:b2Body = World.Instance.CreateBody( GetBodyDef() );
			fixtureDef.shape = shape;
			body.CreateFixture( fixtureDef );
			body.SetUserData( ObjectFuncs.clone( FixtureDefSettings.Instance.UserData ) );
			return body;
		}
		
		private static function GetFixtureDef() : b2FixtureDef
		{
			var	fixtureConf:FixtureDefSettings = FixtureDefSettings.Instance;
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.density = fixtureConf.Density;
			fixtureDef.friction = fixtureConf.Friction;
			fixtureDef.isSensor = fixtureConf.IsSensor;
			fixtureDef.restitution = fixtureConf.Restitution;
			fixtureDef.filter.groupIndex = fixtureConf.GroupIndex;
			fixtureDef.filter.maskBits = fixtureConf.MaskBits;
			fixtureDef.filter.categoryBits = fixtureConf.CategoryBits;
			
			return fixtureDef;
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