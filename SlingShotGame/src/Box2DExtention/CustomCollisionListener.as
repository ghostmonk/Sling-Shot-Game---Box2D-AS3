package Box2DExtention 
{	
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2ContactListener;
	
	import GameTools.TrajectoryPath;
	
	import Pages.GamePage;
	
	/**
	 *@author ghostmonk - Apr 11, 2011
	 */
	public class CustomCollisionListener extends b2ContactListener 
	{
		public var IsDisabled:Boolean = true;
		
		private var game:GamePage;
		
		public function CustomCollisionListener( game:GamePage )
		{
			this.game = game;
		}
		
		public override function BeginContact( contact:b2Contact ) : void
		{
			if( IsDisabled ) return;
			game.UpdatePath = false;
			
			var bodyA:b2Body = contact.GetFixtureA().GetBody();
			var bodyB:b2Body = contact.GetFixtureB().GetBody();
			
			var dataA:Object = bodyA.GetFixtureList().GetUserData();
			var dataB:Object = bodyB.GetFixtureList().GetUserData();
			
			var velocityA:b2Vec2 = bodyA.GetLinearVelocity();
			var velocityB:b2Vec2 = bodyB.GetLinearVelocity();
			
			trace( "POW" );
		}
	}
}