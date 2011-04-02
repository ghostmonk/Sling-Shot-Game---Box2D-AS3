package Delgates
{
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Collision.b2AABB;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2MouseJoint;
	import Box2D.Dynamics.Joints.b2MouseJointDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2World;
	
	import General.Input;
	
	import Utils.Settings;
	
	import flash.display.Sprite;

	public class MouseActionDelegate
	{
		private var mouseJoint:b2MouseJoint;
		private var input:Input;
		private var mouseXWorldPhys:Number;
		private var mouseYWorldPhys:Number;
		private var mouseXWorld:Number;
		private var mouseYWorld:Number;
		private var mousePVec:b2Vec2 = new b2Vec2();
		
		private var world:b2World;
		
		public function MouseActionDelegate( stageSprite:Sprite )
		{
			input = new Input( stageSprite );
			world = Settings.World;
		}
		
		public function Update() : void
		{
			mouseXWorldPhys = Input.mouseX / Settings.METER_PIXELS;
			mouseYWorldPhys = Input.mouseY / Settings.METER_PIXELS;
			mouseXWorld = Input.mouseX;
			mouseYWorld = Input.mouseY;
			
			MouseDestroy();
			MouseDrag();
			Input.update();
		}
		
		private function GetBodyAtMouse( includeStatic:Boolean = false ) : b2Body
		{
			mousePVec.Set( mouseXWorldPhys, mouseYWorldPhys );
			var axisAlignedBoundingBox:b2AABB = new b2AABB();
			axisAlignedBoundingBox.lowerBound.Set( mouseXWorldPhys - 0.001, mouseYWorldPhys - 0.001 );
			axisAlignedBoundingBox.upperBound.Set( mouseXWorldPhys + 0.001, mouseYWorldPhys + 0.001 );
			
			var body:b2Body = null;
			var fixture:b2Fixture;
			
			function GetBodyCallBack( fixture:b2Fixture ) : Boolean
			{
				var shape:b2Shape = fixture.GetShape();
				if( fixture.GetBody().GetType() != b2Body.b2_staticBody || includeStatic )
				{
					var inside:Boolean = shape.TestPoint( fixture.GetBody().GetTransform(), mousePVec );
					if( inside ) 
					{
						body = fixture.GetBody();
						return false;
					}
				}
				return true;
			}
			
			world.QueryAABB( GetBodyCallBack, axisAlignedBoundingBox );
			return body;
		}
		
		private function MouseDrag() : void
		{
			if( Input.mouseDown && !mouseJoint )
			{
				var body:b2Body = GetBodyAtMouse();
				
				if( body )
				{
					var mouseJointDef:b2MouseJointDef = new b2MouseJointDef();
					mouseJointDef.bodyA = world.GetGroundBody();
					mouseJointDef.bodyB = body;
					mouseJointDef.target.Set( mouseXWorldPhys, mouseYWorldPhys );
					mouseJointDef.collideConnected = true;
					mouseJointDef.maxForce = body.GetMass() * 600.0;
					mouseJoint = world.CreateJoint( mouseJointDef ) as b2MouseJoint;
					body.SetAwake( true );
				}
			}
			
			if( !Input.mouseDown )
			{
				if( mouseJoint )
				{
					world.DestroyJoint( mouseJoint );
					mouseJoint = null;
				}
			}
			
			if( mouseJoint )
			{
				var p2:b2Vec2 = new b2Vec2( mouseXWorldPhys, mouseYWorldPhys );
				mouseJoint.SetTarget( p2 );
			}
		}
		
		private function MouseDestroy() : void
		{
			if( Input.mouseDown || !Input.isKeyPressed( 68 /*D*/ ) ) return;
			
			var body:b2Body = GetBodyAtMouse( true );
			if( body ) world.DestroyBody( body );
		}
		
		
	}
}