package Box2DExtention.Factories 
{	
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Common.b2Settings;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	import Box2D.Dynamics.Joints.b2WeldJoint;
	import Box2D.Dynamics.Joints.b2WeldJointDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FilterData;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	import Box2DExtention.Config.FixtureDefSettings;
	import Box2DExtention.Delgates.MouseActionDelegate;
	import Box2DExtention.World;
	
	import flash.display.Stage;
	import flash.events.MouseEvent;

	/**
	 *@author ghostmonk - Apr 4, 2011
	 */
	public class Ragdoll 
	{
		public static function SimpleWelded( x:Number, y:Number, height:Number, mouseEnabled:Boolean = false ) : Array
		{
			FixtureDefSettings.Instance.Density = 1.5;
			FixtureDefSettings.Instance.GroupIndex = -7461234743182;
			
			x = World.Meters( x );
			y = World.Meters( y );
			
			var headSize:Number = World.Meters( height / 5 );
			var offset:Number = World.Meters( 2 );
			var limbLength:Number = headSize * 0.8;
			var limbWidth:Number = headSize * 0.3;
			var legXOffset:Number = headSize - limbWidth;
			var armXOffset:Number = headSize + limbLength;
			var legY:Number = y + headSize * 3 + limbLength;
			var armY:Number = y + headSize + limbWidth * 1.5;
			var lightJointAngle:Number = 20;
			var extremeJointAngle:Number = 60;
			
			var jointDef:b2WeldJointDef = new b2WeldJointDef();
			
			var rad180:Number = 180 / Math.PI;
			
			var torso:b2Body = CreateBox( headSize, headSize, x, y + offset + headSize * 2 );
			
			var head:b2Body = BodyMaker.Circle( headSize );
			head.SetPosition( new b2Vec2( x, y ) );
			jointDef.referenceAngle = -lightJointAngle / rad180;
			jointDef.Initialize( head, torso, new b2Vec2( x, y + headSize ) );
			World.Instance.CreateJoint( jointDef );
			
			var leftLeg:b2Body = CreateBox( limbWidth, limbLength, x - legXOffset, legY  );
			jointDef.Initialize( torso, leftLeg, new b2Vec2( x - legXOffset, legY - limbLength ) );
			World.Instance.CreateJoint( jointDef );
			
			var rightLeg:b2Body = CreateBox( limbWidth, limbLength, x + legXOffset, legY );
			jointDef.Initialize( torso, rightLeg, new b2Vec2( x + legXOffset, legY - limbLength ) );
			World.Instance.CreateJoint( jointDef );
			
			var leftArm:b2Body = CreateBox( limbLength, limbWidth, x - armXOffset, armY );
			jointDef.referenceAngle = -extremeJointAngle / rad180;
			jointDef.Initialize( torso, leftArm, new b2Vec2( x - headSize, armY ) );
			World.Instance.CreateJoint( jointDef );
			
			var rightArm:b2Body = CreateBox( limbLength, limbWidth, x + armXOffset, armY );
			jointDef.Initialize( torso, rightArm, new b2Vec2( x + headSize, armY ) );
			World.Instance.CreateJoint( jointDef );
			
			if( mouseEnabled ) 
			{
				MouseActionDelegate.MouseEnabled.push( head );
				MouseActionDelegate.MouseEnabled.push( torso );
				MouseActionDelegate.MouseEnabled.push( leftLeg );
				MouseActionDelegate.MouseEnabled.push( rightLeg );
				MouseActionDelegate.MouseEnabled.push( leftArm );
				MouseActionDelegate.MouseEnabled.push( rightArm );
			}
			
			FixtureDefSettings.Instance.Reset();
			
			return [ head, torso, leftLeg, rightLeg, leftArm, rightArm ];
		}
		
		public static function Simple( x:Number, y:Number, height:Number, mouseEnabled:Boolean = false ) : Array
		{
			FixtureDefSettings.Instance.Density = 1.5;
			FixtureDefSettings.Instance.GroupIndex = -7461234743182;
			
			x = World.Meters( x );
			y = World.Meters( y );
			
			var headSize:Number = World.Meters( height / 5 );
			var offset:Number = World.Meters( 2 );
			var limbLength:Number = headSize * 0.8;
			var limbWidth:Number = headSize * 0.3;
			var legXOffset:Number = headSize - limbWidth;
			var armXOffset:Number = headSize + limbLength;
			var legY:Number = y + headSize * 3 + limbLength;
			var armY:Number = y + headSize + limbWidth * 1.5;
			var lightJointAngle:Number = 20;
			var extremeJointAngle:Number = 60;
			
			var jointDef:b2RevoluteJointDef = new b2RevoluteJointDef();
			jointDef.enableLimit = true;
			var rad180:Number = 180 / Math.PI;
			
			var torso:b2Body = CreateBox( headSize, headSize, x, y + offset + headSize * 2 );
			
			var head:b2Body = BodyMaker.Circle( headSize );
			head.SetPosition( new b2Vec2( x, y ) );
			jointDef.lowerAngle = -lightJointAngle / rad180;
			jointDef.upperAngle = lightJointAngle / rad180;
			jointDef.Initialize( head, torso, new b2Vec2( x, y + headSize ) );
			World.Instance.CreateJoint( jointDef );
			
			var leftLeg:b2Body = CreateBox( limbWidth, limbLength, x - legXOffset, legY  );
			jointDef.Initialize( torso, leftLeg, new b2Vec2( x - legXOffset, legY - limbLength ) );
			World.Instance.CreateJoint( jointDef );
			
			var rightLeg:b2Body = CreateBox( limbWidth, limbLength, x + legXOffset, legY );
			jointDef.Initialize( torso, rightLeg, new b2Vec2( x + legXOffset, legY - limbLength ) );
			World.Instance.CreateJoint( jointDef );
			
			var leftArm:b2Body = CreateBox( limbLength, limbWidth, x - armXOffset, armY );
			jointDef.lowerAngle = -extremeJointAngle / rad180;
			jointDef.upperAngle = extremeJointAngle / rad180;
			jointDef.Initialize( torso, leftArm, new b2Vec2( x - headSize, armY ) );
			World.Instance.CreateJoint( jointDef );
			
			var rightArm:b2Body = CreateBox( limbLength, limbWidth, x + armXOffset, armY );
			jointDef.Initialize( torso, rightArm, new b2Vec2( x + headSize, armY ) );
			World.Instance.CreateJoint( jointDef );
			
			if( mouseEnabled ) 
			{
				MouseActionDelegate.MouseEnabled.push( head );
				MouseActionDelegate.MouseEnabled.push( torso );
				MouseActionDelegate.MouseEnabled.push( leftLeg );
				MouseActionDelegate.MouseEnabled.push( rightLeg );
				MouseActionDelegate.MouseEnabled.push( leftArm );
				MouseActionDelegate.MouseEnabled.push( rightArm );
			}
			
			FixtureDefSettings.Instance.Reset();
			
			return [ head, torso, leftLeg, rightLeg, leftArm, rightArm ];
		}
		
		public static function Complex( pos:b2Vec2 ) : void
		{
			var scale:Number = 35.0;
			var startX:Number = pos.x * scale;
			var startY:Number = pos.y * scale;
			var world:b2World = World.Instance;
			{
				var circ:b2CircleShape; 
				var box:b2PolygonShape;
				var bd:b2BodyDef = new b2BodyDef();
				var jd:b2RevoluteJointDef = new b2RevoluteJointDef();
				var fixtureDef:b2FixtureDef = new b2FixtureDef();
			}
			{
				// BODIES
				// Set these to dynamic bodies
				bd.type = b2Body.b2_dynamicBody;
				
				// Head
				circ = new b2CircleShape( 12.5 / scale );
				fixtureDef.shape = circ;
				fixtureDef.density = 1.0;
				fixtureDef.friction = 0.4;
				fixtureDef.restitution = 0.3;
				bd.position.Set(startX / scale, startY / scale);
				var head:b2Body = world.CreateBody(bd);
				head.CreateFixture(fixtureDef);
				//if (i == 0){
				head.ApplyImpulse(new b2Vec2(0.5 * 100 - 50, 0.5 * 100 - 50), head.GetWorldCenter());
				//}
				
				// Torso1
				box = new b2PolygonShape();
				box.SetAsBox(15 / scale, 10 / scale);
				fixtureDef.shape = box;
				fixtureDef.density = 1.0;
				fixtureDef.friction = 0.4;
				fixtureDef.restitution = 0.1;
				bd.position.Set(startX / scale, (startY + 28) / scale);
				var torso1:b2Body = world.CreateBody(bd);
				torso1.CreateFixture(fixtureDef);
				// Torso2
				box = new b2PolygonShape();
				box.SetAsBox(15 / scale, 10 / scale);
				fixtureDef.shape = box;
				bd.position.Set(startX / scale, (startY + 43) / scale);
				var torso2:b2Body = world.CreateBody(bd);
				torso2.CreateFixture(fixtureDef);
				// Torso3
				box.SetAsBox(15 / scale, 10 / scale);
				fixtureDef.shape = box;
				bd.position.Set(startX / scale, (startY + 58) / scale);
				var torso3:b2Body = world.CreateBody(bd);
				torso3.CreateFixture(fixtureDef);
				
				// UpperArm
				fixtureDef.density = 1.0;
				fixtureDef.friction = 0.4;
				fixtureDef.restitution = 0.1;
				// L
				box = new b2PolygonShape();
				box.SetAsBox(18 / scale, 6.5 / scale);
				fixtureDef.shape = box;
				bd.position.Set((startX - 30) / scale, (startY + 20) / scale);
				var upperArmL:b2Body = world.CreateBody(bd);
				upperArmL.CreateFixture(fixtureDef);
				// R
				box = new b2PolygonShape();
				box.SetAsBox(18 / scale, 6.5 / scale);
				fixtureDef.shape = box;
				bd.position.Set((startX + 30) / scale, (startY + 20) / scale);
				var upperArmR:b2Body = world.CreateBody(bd);
				upperArmR.CreateFixture(fixtureDef);
				
				// LowerArm
				fixtureDef.density = 1.0;
				fixtureDef.friction = 0.4;
				fixtureDef.restitution = 0.1;
				// L
				box = new b2PolygonShape();
				box.SetAsBox(17 / scale, 6 / scale);
				fixtureDef.shape = box;
				bd.position.Set((startX - 57) / scale, (startY + 20) / scale);
				var lowerArmL:b2Body = world.CreateBody(bd);
				lowerArmL.CreateFixture(fixtureDef);
				// R
				box = new b2PolygonShape();
				box.SetAsBox(17 / scale, 6 / scale);
				fixtureDef.shape = box;
				bd.position.Set((startX + 57) / scale, (startY + 20) / scale);
				var lowerArmR:b2Body = world.CreateBody(bd);
				lowerArmR.CreateFixture(fixtureDef);
				
				// UpperLeg
				fixtureDef.density = 1.0;
				fixtureDef.friction = 0.4;
				fixtureDef.restitution = 0.1;
				// L
				box = new b2PolygonShape();
				box.SetAsBox(7.5 / scale, 22 / scale);
				fixtureDef.shape = box;
				bd.position.Set((startX - 8) / scale, (startY + 85) / scale);
				var upperLegL:b2Body = world.CreateBody(bd);
				upperLegL.CreateFixture(fixtureDef);
				// R
				box = new b2PolygonShape();
				box.SetAsBox(7.5 / scale, 22 / scale);
				fixtureDef.shape = box;
				bd.position.Set((startX + 8) / scale, (startY + 85) / scale);
				var upperLegR:b2Body = world.CreateBody(bd);
				upperLegR.CreateFixture(fixtureDef);
				
				// LowerLeg
				fixtureDef.density = 1.0;
				fixtureDef.friction = 0.4;
				fixtureDef.restitution = 0.1;
				// L
				box = new b2PolygonShape();
				box.SetAsBox(6 / scale, 20 / scale);
				fixtureDef.shape = box;
				bd.position.Set((startX - 8) / scale, (startY + 120) / scale);
				var lowerLegL:b2Body = world.CreateBody(bd);
				lowerLegL.CreateFixture(fixtureDef);
				// R
				box = new b2PolygonShape();
				box.SetAsBox(6 / scale, 20 / scale);
				fixtureDef.shape = box;
				bd.position.Set((startX + 8) / scale, (startY + 120) / scale);
				var lowerLegR:b2Body = world.CreateBody(bd);
				lowerLegR.CreateFixture( fixtureDef );
				
				
				// JOINTS
				jd.enableLimit = true;
				
				// Head to shoulders
				jd.lowerAngle = -40 / (180/Math.PI);
				jd.upperAngle = 40 / (180/Math.PI);
				jd.Initialize(torso1, head, new b2Vec2(startX / scale, (startY + 15) / scale));
				world.CreateJoint(jd);
				
				// Upper arm to shoulders
				// L
				jd.lowerAngle = -85 / (180/Math.PI);
				jd.upperAngle = 130 / (180/Math.PI);
				jd.Initialize(torso1, upperArmL, new b2Vec2((startX - 18) / scale, (startY + 20) / scale));
				world.CreateJoint(jd);
				// R
				jd.lowerAngle = -130 / (180/Math.PI);
				jd.upperAngle = 85 / (180/Math.PI);
				jd.Initialize(torso1, upperArmR, new b2Vec2((startX + 18) / scale, (startY + 20) / scale));
				world.CreateJoint(jd);
				
				// Lower arm to upper arm
				// L
				jd.lowerAngle = -130 / (180/Math.PI);
				jd.upperAngle = 10 / (180/Math.PI);
				jd.Initialize(upperArmL, lowerArmL, new b2Vec2((startX - 45) / scale, (startY + 20) / scale));
				world.CreateJoint(jd);
				// R
				jd.lowerAngle = -10 / (180/Math.PI);
				jd.upperAngle = 130 / (180/Math.PI);
				jd.Initialize(upperArmR, lowerArmR, new b2Vec2((startX + 45) / scale, (startY + 20) / scale));
				world.CreateJoint(jd);
				
				// Shoulders/stomach
				jd.lowerAngle = -15 / (180/Math.PI);
				jd.upperAngle = 15 / (180/Math.PI);
				jd.Initialize(torso1, torso2, new b2Vec2(startX / scale, (startY + 35) / scale));
				world.CreateJoint(jd);
				// Stomach/hips
				jd.Initialize(torso2, torso3, new b2Vec2(startX / scale, (startY + 50) / scale));
				world.CreateJoint(jd);
				
				// Torso to upper leg
				// L
				jd.lowerAngle = -25 / (180/Math.PI);
				jd.upperAngle = 45 / (180/Math.PI);
				jd.Initialize(torso3, upperLegL, new b2Vec2((startX - 8) / scale, (startY + 72) / scale));
				world.CreateJoint(jd);
				// R
				jd.lowerAngle = -45 / (180/Math.PI);
				jd.upperAngle = 25 / (180/Math.PI);
				jd.Initialize(torso3, upperLegR, new b2Vec2((startX + 8) / scale, (startY + 72) / scale));
				world.CreateJoint(jd);
				
				// Upper leg to lower leg
				// L
				jd.lowerAngle = -25 / (180/Math.PI);
				jd.upperAngle = 115 / (180/Math.PI);
				jd.Initialize(upperLegL, lowerLegL, new b2Vec2((startX - 8) / scale, (startY + 105) / scale));
				world.CreateJoint(jd);
				// R
				jd.lowerAngle = -115 / (180/Math.PI);
				jd.upperAngle = 25 / (180/Math.PI);
				jd.Initialize(upperLegR, lowerLegR, new b2Vec2((startX + 8) / scale, (startY + 105) / scale));
				world.CreateJoint(jd);
			}
		}
		
		private static function CreateBox( width:Number, height:Number, x:Number, y:Number ) : b2Body
		{
			var piece:b2Body = BodyMaker.Box( width, height );
			piece.SetPosition( new b2Vec2( x, y ) );
			return piece;
		}
	}
}