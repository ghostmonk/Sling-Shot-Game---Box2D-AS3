package Utils
{
	import Box2D.Collision.b2Proxy;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2DistanceJoint;
	import Box2D.Dynamics.Joints.b2DistanceJointDef;
	import Box2D.Dynamics.Joints.b2PrismaticJoint;
	import Box2D.Dynamics.Joints.b2PrismaticJointDef;
	import Box2D.Dynamics.Joints.b2RevoluteJoint;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	import Box2D.Dynamics.b2Body;

	public class JointMaker
	{
		public static function DistanceJoint( body1:b2Body, body2:b2Body ) : b2DistanceJoint
		{
			var jointDef:b2DistanceJointDef = new b2DistanceJointDef();
			jointDef.Initialize( body1, body2, body1.GetWorldCenter(), body2.GetWorldCenter() );
			return Settings.World.CreateJoint( jointDef ) as b2DistanceJoint;
		}
		
		public static function RevoluteJoint( body1:b2Body, body2:b2Body ) : b2RevoluteJoint
		{
			var jointDef:b2RevoluteJointDef = new b2RevoluteJointDef();
			jointDef.Initialize( body1, body2, body1.GetWorldCenter() );
			jointDef.maxMotorTorque = 1.0;
			jointDef.enableMotor = true;
			return Settings.World.CreateJoint( jointDef ) as b2RevoluteJoint;
		}
		
		public static function PrismaticJoint( 
			body1:b2Body, body2:b2Body, axis:b2Vec2, lowerTranslation:Number = -5, upperTranslation:Number = 2.5 ) : b2PrismaticJoint
		{
			var jointDef:b2PrismaticJointDef = new b2PrismaticJointDef();
			jointDef.Initialize( body1, body2, body1.GetWorldCenter(), axis );
			jointDef.upperTranslation= upperTranslation;
			jointDef.lowerTranslation = lowerTranslation;
			jointDef.enableLimit = true;
			jointDef.maxMotorForce = 1.0;
			jointDef.motorSpeed = 0.0;
			jointDef.enableMotor = true;
			return Settings.World.CreateJoint( jointDef ) as b2PrismaticJoint;
		}
	}
}