package Utils 
{	
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;

	/**
	 *@author ghostmonk - Apr 4, 2011
	 */
	public class Ragdoll 
	{
		public static function Create( pos:b2Vec2 ) : void
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
	}
}