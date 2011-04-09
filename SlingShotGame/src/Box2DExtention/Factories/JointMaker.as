package Box2DExtention.Factories
{
	import Box2D.Collision.b2Proxy;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Common.b2Settings;
	import Box2D.Dynamics.Joints.b2DistanceJoint;
	import Box2D.Dynamics.Joints.b2DistanceJointDef;
	import Box2D.Dynamics.Joints.b2GearJoint;
	import Box2D.Dynamics.Joints.b2GearJointDef;
	import Box2D.Dynamics.Joints.b2LineJoint;
	import Box2D.Dynamics.Joints.b2LineJointDef;
	import Box2D.Dynamics.Joints.b2PrismaticJoint;
	import Box2D.Dynamics.Joints.b2PrismaticJointDef;
	import Box2D.Dynamics.Joints.b2PulleyJoint;
	import Box2D.Dynamics.Joints.b2PulleyJointDef;
	import Box2D.Dynamics.Joints.b2RevoluteJoint;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	import Box2D.Dynamics.Joints.b2WeldJoint;
	import Box2D.Dynamics.Joints.b2WeldJointDef;
	import Box2D.Dynamics.b2Body;
	
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	import Box2DExtention.World;

	public class JointMaker
	{
		public static function DistanceJoint( body1:b2Body, body2:b2Body ) : b2DistanceJoint
		{
			var jointDef:b2DistanceJointDef = new b2DistanceJointDef();
			jointDef.Initialize( body1, body2, body1.GetWorldCenter(), body2.GetWorldCenter() );
			return World.Instance.CreateJoint( jointDef ) as b2DistanceJoint;
		}
		
		public static function RevoluteJoint( body1:b2Body, body2:b2Body ) : b2RevoluteJoint
		{
			var jointDef:b2RevoluteJointDef = new b2RevoluteJointDef();
			jointDef.Initialize( body1, body2, body1.GetWorldCenter() );
			jointDef.maxMotorTorque = 1.0;
			jointDef.enableMotor = true;
			return World.Instance.CreateJoint( jointDef ) as b2RevoluteJoint;
		}
		
		public static function PrismaticJoint( 
			body1:b2Body, body2:b2Body, axis:b2Vec2, lowerTranslation:Number = -5.0, upperTranslation:Number = 2.5 ) : b2PrismaticJoint
		{
			var jointDef:b2PrismaticJointDef = new b2PrismaticJointDef();
			jointDef.Initialize( body2, body1, body1.GetWorldCenter(), axis );
			jointDef.lowerTranslation = lowerTranslation;
			jointDef.upperTranslation= upperTranslation;
			jointDef.enableLimit = true;
			jointDef.maxMotorForce = 1.0;
			jointDef.motorSpeed = 0.0;
			jointDef.enableMotor = true;
			return World.Instance.CreateJoint( jointDef ) as b2PrismaticJoint;
		}
		
		public static function PullyJoint( body1:b2Body, body2:b2Body ) : b2PulleyJoint
		{
			var ratio:Number = 1.0;
			var anchor1:b2Vec2 = body1.GetWorldCenter();
			var anchor2:b2Vec2 = body2.GetWorldCenter();
			var groundAnchor1:b2Vec2 = new b2Vec2( anchor1.x, anchor1.y - World.Meters( 300 ) );
			var groundAnchor2:b2Vec2 = new b2Vec2( anchor2.x, anchor2.y - World.Meters( 300 ) );
			
			var jointDef:b2PulleyJointDef = new b2PulleyJointDef();
			jointDef.Initialize( body1, body2, groundAnchor1, groundAnchor2, anchor1, anchor2, ratio );
			jointDef.maxLengthA = World.Meters( 600 );
			jointDef.maxLengthB = World.Meters( 600 );
			
			return World.Instance.CreateJoint( jointDef ) as b2PulleyJoint;
		}
		
		public static function GearJoint( ground:b2Body, body1:b2Body, body2:b2Body ) : b2GearJoint
		{
			var revJoint:b2RevoluteJoint = RevoluteJoint( ground, body1 );
			revJoint.SetMaxMotorTorque( 10.0 );
			revJoint.SetMotorSpeed( 0.0 );
			revJoint.EnableLimit( true );
			revJoint.SetLimits( -0.5 * b2Settings.b2_pi, 2 * b2Settings.b2_pi );
			
			var prismaticJoint:b2PrismaticJoint = PrismaticJoint( body2, ground, new b2Vec2( 1.0, 0.0 ) );
			
			var gearJointDef:b2GearJointDef = new b2GearJointDef();
			gearJointDef.joint1 = revJoint;
			gearJointDef.joint2 = prismaticJoint;
			gearJointDef.bodyA = body1;
			gearJointDef.bodyB = body2;
			gearJointDef.ratio = 2.0 * b2Settings.b2_pi / World.Meters( 300 );
			
			return World.Instance.CreateJoint( gearJointDef ) as b2GearJoint;
		}
		
		public static function LineJoint( ground:b2Body, body:b2Body ) : b2LineJoint
		{
			var jointDef:b2LineJointDef = new b2LineJointDef();
			jointDef.Initialize( ground, body, body.GetWorldCenter(), new b2Vec2( 0.0, 1.0 ) );
			jointDef.lowerTranslation = -2.0;
			jointDef.upperTranslation = 2.0;
			jointDef.enableLimit = true;
			jointDef.maxMotorForce = 200.0;
			jointDef.motorSpeed = 10.0;
			jointDef.enableMotor = true;
			return World.Instance.CreateJoint( jointDef ) as b2LineJoint;
		}
		
		public static function WeldJoint( body1:b2Body, body2:b2Body ) : b2WeldJoint
		{
			var jointDef:b2WeldJointDef = new b2WeldJointDef();
			jointDef.Initialize( body1, body2, body1.GetWorldCenter() );
			return World.Instance.CreateJoint( jointDef ) as b2WeldJoint;
		}
		
		private function JointTests() : void
		{
			/*
			//DISTANCE
			JointMaker.DistanceJoint( 
			BodyMaker.Box( H_X_STAGE - Meters( 100 ), 0, BOX_SIZE, BOX_SIZE ), 
			BodyMaker.Box( H_X_STAGE + Meters( 100 ), 0, BOX_SIZE, BOX_SIZE ) );
			
			//REVOLUTE
			JointMaker.RevoluteJoint( 
			BodyMaker.Box( 20, 15, 0.1, 0.1, true ), 
			BodyMaker.Box( 30, 15, BOX_SIZE, BOX_SIZE ) );
			
			//PRISMATIC
			JointMaker.PrismaticJoint( 
			BodyMaker.Box( 10, 5, BOX_SIZE, BOX_SIZE ),
			BodyMaker.Box( 10, 15, BOX_SIZE, BOX_SIZE ),
			new b2Vec2( 0, 0.5 ) );
			
			//PULLY
			JointMaker.PullyJoint( 
			BodyMaker.Box( 10, 10, BOX_SIZE, BOX_SIZE ),
			BodyMaker.Box( 15, 10, BOX_SIZE, BOX_SIZE ) );
			
			//GEAR
			var gear1:b2Body = BodyMaker.Box( 10, 10, BOX_SIZE, BOX_SIZE );
			var gear2:b2Body = BodyMaker.Box( 10, 9, BOX_SIZE, BOX_SIZE );
			var ground:b2Body = BodyMaker.Box( 10, 10, 0.1, 0.1, true );
			JointMaker.GearJoint( ground, gear1, gear2 ); 
			
			//LINE
			JointMaker.LineJoint( 
			BodyMaker.Box( 10, 10, 0.1, 0.1, true ),
			BodyMaker.Box( 10, 15, BOX_SIZE, BOX_SIZE ) );
			
			//WELD
			var xPos:Number = 1.0;
			var yPos:Number = 1.0;
			var currentLink:b2Body = BodyMaker.Box( xPos, yPos, BOX_SIZE, BOX_SIZE, true ); 
			for( var i:int = 0; i < 12; i++ )
			{
			xPos += 1.0;
			var nextLink:b2Body = BodyMaker.Box( xPos, yPos, BOX_SIZE, BOX_SIZE );
			JointMaker.WeldJoint( currentLink, nextLink );
			currentLink = nextLink;
			}*/
		}
	}
}