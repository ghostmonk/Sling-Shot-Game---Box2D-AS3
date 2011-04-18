package Box2DExtention 
{	
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2ContactListener;
	
	import Box2DExtention.Delgates.LoopManager;
	
	import GameTools.Box2dGameDraw;
	
	import Pages.GamePage;
	
	import Utils.HUD;
	
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
			
			var velA:Number = Math.abs( bodyA.GetAngularVelocity() );
			var velB:Number = Math.abs( bodyB.GetAngularVelocity() );
			
			if( velA < 1 && velB < 1 )
				return;
			
			var isAFaster:Boolean = velA > velB;
			var speed:Number = isAFaster ? velA : velB;
			
			var reduction:int;
			
			if( speed < 5 ) reduction = 2;
			else if( speed < 10 ) reduction = 3;
			else if ( speed < 15 ) reduction = 4;
			else reduction = 5;
			
			HandleImpact( isAFaster ? bodyB : bodyA, reduction );
		}
		
		private function HandleImpact( body:b2Body, reduction:int ) : void
		{
			var data:Object = body.GetUserData();
			
			if( data != null && !isNaN( data.strength ) && data.canDelete )
			{
				var strength:int = data.strength -= reduction;
				if( strength <= 0 )
				{
					LoopManager.DeletionBodies.push( body );
					Box2dGameDraw.Instance.RemoveBody( body );
					HUD.Instance.AddToScore( int( data.score ) );
					if( data.isTarget ) GamePage.DeletedTargets++;
				}
			}
		}
	}
}