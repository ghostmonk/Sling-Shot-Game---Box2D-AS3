package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import General.Input;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	
	
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	public class ForumBalls extends MouseJointTutorial
	{
		public const RADIANS_TO_DEGREES:Number = 57.2957795;
		public const DEGREES_TO_RADIANS:Number = 0.0174532925;
		private var balls:Array = new Array();
	
		override protected function setup():void
		{
			var ballContactListener = new BallContactListener();
			_world.SetContactListener(ballContactListener);
			
			var groundObject:Object = new Object();
			groundObject.bodyType = BodyType.GROUND;
			_groundBody.SetUserData(groundObject);
			
			var blueBall1 = createBall(100, 100, 50, BlueBallTexture, BodyType.BLUE_BALL);
			var redBall1 = createBall(225, 200, 50, RedBallTexture, BodyType.RED_BALL);
			var blueBall2 = createBall(350, 50, 50, BlueBallTexture, BodyType.BLUE_BALL);
			var redBall2 = createBall(475, 150, 50, RedBallTexture, BodyType.RED_BALL);
		}
		
		public function createBall(x:Number, y:Number, radius:Number, texture:Class, bodyType:String):b2Body
		{
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.type = b2Body.b2_dynamicBody;
			bodyDef.fixedRotation = true;
			bodyDef.position.Set(x / PIXELS_TO_METRE, y / PIXELS_TO_METRE);
			
			var body:b2Body = _world.CreateBody(bodyDef);
			
			var bodyShape:b2CircleShape = new b2CircleShape();
			bodyShape.SetRadius(radius / PIXELS_TO_METRE);
			
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.shape = bodyShape;
			fixtureDef.restitution = .7;
			fixtureDef.friction = .5;
			
			body.CreateFixture(fixtureDef);
			
			var ballTexture = new texture();
			addChild(ballTexture);
			
			var ballObject:Object = new Object();
			ballObject.body = body;
			ballObject.texture = ballTexture;
			ballObject.startX = x;
			ballObject.startY = y;
			ballObject.contact = false;
			ballObject.bodyType = bodyType;
			
			body.SetUserData(ballObject);
			balls.push(ballObject);
			
			return body;
		}
		
		override protected function update(e:Event):void
		{
			var timeStep:Number = 1 / 60;
			var velocityIterations:int = 6;
			var positionIterations:int = 2;

			UpdateMouseWorld();
			MouseDestroy();
			MouseDrag();

			_world.Step(timeStep, velocityIterations, positionIterations);
			_world.ClearForces();
			_world.DrawDebugData();
			updateTextures();
			General.Input.update();
			checkCollisions();
		}
		
		private function updateTextures():void
		{
			var i = balls.length;
			while (i--)
			{
				var currentBallObject = balls[i];

				currentBallObject.texture.x = currentBallObject.body.GetPosition().x * PIXELS_TO_METRE;
				currentBallObject.texture.y = currentBallObject.body.GetPosition().y * PIXELS_TO_METRE;
				currentBallObject.texture.rotation = currentBallObject.body.GetAngle() * RADIANS_TO_DEGREES;
			}
		}
		
		private function checkCollisions():void
		{
			var i = balls.length;
			while (i--)
			{
				var currentBallObject = balls[i];
				
				if (currentBallObject.contact)
				{
					currentBallObject.body.SetPosition(new b2Vec2(currentBallObject.startX / PIXELS_TO_METRE, currentBallObject.startY / PIXELS_TO_METRE));
					currentBallObject.body.SetLinearVelocity(new b2Vec2(0, 0));
					currentBallObject.body.SetAngularVelocity(0);
					currentBallObject.contact = false;
				}
			}
		}
		
	}
}