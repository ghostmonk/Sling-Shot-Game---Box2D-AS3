package
{
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.b2ContactListener;

	public class BallContactListener extends b2ContactListener
	{
		public function BallContactListener()
		{
			trace(this+" initalized");
		}

		override public function BeginContact(contact:b2Contact):void
		{		
		
			if (contact.GetFixtureA().GetBody().GetUserData().bodyType == BodyType.BLUE_BALL 
				&& contact.GetFixtureB().GetBody().GetUserData().bodyType == BodyType.GROUND)
			{
				contact.GetFixtureA().GetBody().GetUserData().contact = true;
			}
			
			if (contact.GetFixtureA().GetBody().GetUserData().bodyType == BodyType.GROUND 
				&& contact.GetFixtureB().GetBody().GetUserData().bodyType == BodyType.BLUE_BALL)
			{
				contact.GetFixtureB().GetBody().GetUserData().contact = true;
			}


			if (contact.GetFixtureA().GetBody().GetUserData().bodyType == BodyType.RED_BALL 
				&& contact.GetFixtureB().GetBody().GetUserData().bodyType == BodyType.GROUND)
			{
				contact.GetFixtureA().GetBody().GetUserData().contact = true;
			}
			
			if (contact.GetFixtureA().GetBody().GetUserData().bodyType == BodyType.GROUND 
				&& contact.GetFixtureB().GetBody().GetUserData().bodyType == BodyType.RED_BALL)
			{
				contact.GetFixtureB().GetBody().GetUserData().contact = true;
			}
			
		}
	}
}