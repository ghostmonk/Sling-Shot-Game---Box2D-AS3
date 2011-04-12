package 
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Collision.b2AABB;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2MouseJoint;
	import Box2D.Dynamics.Joints.b2MouseJointDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	import General.Input;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;

	public class MouseJointTutorial extends MovieClip
	{
		protected const PIXELS_TO_METRE:int = 30;
		protected const SWF_HALF_WIDTH:int = 300;
		protected const SWF_HEIGHT:int = 400;
		protected var _world:b2World;
		protected var _mouseJoint:b2MouseJoint;
		protected var _input:Input;
		protected var _mouseXWorldPhys:Number;
		protected var _mouseYWorldPhys:Number;
		protected var _mouseXWorld:Number;
		protected var _mouseYWorld:Number;
		protected var _mousePVec:b2Vec2 = new b2Vec2();
		protected var _groundBody:b2Body;

		public function MouseJointTutorial()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		protected function onAddedToStage(e:Event):void
		{
			init();
			setup();
		}

		protected function setup():void
		{
			createBox(400, 30, 30, 30);
		}

		protected function init():void
		{
			_world = new b2World(new b2Vec2(0, 10), true);

			var groundBodyDef:b2BodyDef = new b2BodyDef();
			groundBodyDef.position.Set(SWF_HALF_WIDTH / PIXELS_TO_METRE, SWF_HEIGHT / PIXELS_TO_METRE - 20 / PIXELS_TO_METRE);

			_groundBody = _world.CreateBody(groundBodyDef);

			var groundBox:b2PolygonShape = new b2PolygonShape();
			groundBox.SetAsBox(SWF_HALF_WIDTH / PIXELS_TO_METRE, 20 / PIXELS_TO_METRE);

			var groundFixtureDef:b2FixtureDef = new b2FixtureDef();
			groundFixtureDef.shape = groundBox;
			groundFixtureDef.density = 1;
			groundFixtureDef.friction = 1;
			_groundBody.CreateFixture(groundFixtureDef);
			
			var debugSprite:Sprite = new Sprite();
			addChild(debugSprite);
			var debugDraw:b2DebugDraw = new b2DebugDraw();
			debugDraw.SetSprite(debugSprite);
			debugDraw.SetDrawScale(PIXELS_TO_METRE);
			debugDraw.SetLineThickness(1.0);
			debugDraw.SetAlpha(1);
			debugDraw.SetFillAlpha(0.4);
			debugDraw.SetFlags(b2DebugDraw.e_shapeBit);
			_world.SetDebugDraw(debugDraw);
			
			_input = new Input(this);
			addEventListener(Event.ENTER_FRAME, update);
		}

		protected function createBox(x:int,y:int,width:int,height:int):b2Body
		{
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.type = b2Body.b2_dynamicBody;
			bodyDef.position.Set(x / PIXELS_TO_METRE, y / PIXELS_TO_METRE);
			var body:b2Body = _world.CreateBody(bodyDef);

			var dynamicBox:b2PolygonShape = new b2PolygonShape();
			dynamicBox.SetAsBox(width / PIXELS_TO_METRE, height / PIXELS_TO_METRE);

			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.shape = dynamicBox;
			fixtureDef.density = 1;
			fixtureDef.friction = 0.3;

			body.CreateFixture(fixtureDef);
			return body;
		}

		protected function update(e:Event):void
		{
			var timeStep:Number = 1 / 30;
			var velocityIterations:int = 6;
			var positionIterations:int = 2;

			UpdateMouseWorld();
			MouseDestroy();
			MouseDrag();

			_world.Step(timeStep, velocityIterations, positionIterations);
			_world.ClearForces();
			_world.DrawDebugData();
			General.Input.update();
		}

		
		protected function GetBodyAtMouse(includeStatic:Boolean = false):b2Body
		{
			_mousePVec.Set(_mouseXWorldPhys, _mouseYWorldPhys);
			var aabb:b2AABB = new b2AABB();
			aabb.lowerBound.Set(_mouseXWorldPhys - 0.001, _mouseYWorldPhys - 0.001);
			aabb.upperBound.Set(_mouseXWorldPhys + 0.001, _mouseYWorldPhys + 0.001);
			var body:b2Body = null;
			var fixture:b2Fixture;

			// Query the world for overlapping shapes.
			function GetBodyCallback(fixture:b2Fixture):Boolean
			{
				var shape:b2Shape = fixture.GetShape();
				if (fixture.GetBody().GetType() != b2Body.b2_staticBody || includeStatic)
				{
					var inside:Boolean = shape.TestPoint(fixture.GetBody().GetTransform(), _mousePVec);
					if (inside)
					{
						body = fixture.GetBody();
						return false;
					}
				}
				return true;
			}
			_world.QueryAABB(GetBodyCallback, aabb);
			return body;
		}

		protected function MouseDestroy():void
		{
			if (!Input.mouseDown && Input.isKeyPressed(68/*D*/))
			{
				var body:b2Body = GetBodyAtMouse(true);

				if (body)
				{
					_world.DestroyBody(body);
					return;
				}
			}
		}

		protected function MouseDrag():void
		{
			if (Input.mouseDown && !_mouseJoint)
			{
				var body:b2Body = GetBodyAtMouse();
				
				if (body)
				{
					var md:b2MouseJointDef = new b2MouseJointDef();
					md.bodyA = _world.GetGroundBody();
					md.bodyB = body;
					md.target.Set(_mouseXWorldPhys, _mouseYWorldPhys);
					md.collideConnected = true;
					md.maxForce = 300.0 * body.GetMass();
					_mouseJoint = _world.CreateJoint(md) as b2MouseJoint;
					body.SetAwake(true);
				}
			}
			
			if (!Input.mouseDown)
			{
				if (_mouseJoint)
				{
					_world.DestroyJoint(_mouseJoint);
					_mouseJoint = null;
				}
			}

			if (_mouseJoint)
			{
				var p2:b2Vec2 = new b2Vec2(_mouseXWorldPhys, _mouseYWorldPhys);
				_mouseJoint.SetTarget(p2);
			}
		}

		protected function UpdateMouseWorld():void
		{
			_mouseXWorldPhys = (Input.mouseX) / PIXELS_TO_METRE;
			_mouseYWorldPhys = (Input.mouseY) / PIXELS_TO_METRE;

			_mouseXWorld = (Input.mouseX);
			_mouseYWorld = (Input.mouseY);
		}
	}
}