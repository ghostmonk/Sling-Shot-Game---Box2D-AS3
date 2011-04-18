package GameTools 
{	
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	
	import Box2DExtention.World;
	
	import Utils.MaterialsMaker;
	
	import flash.display.Sprite;

	/**
	 *@author ghostmonk - Apr 17, 2011
	 */
	public class Box2dGameDraw 
	{
		private static var instance:Box2dGameDraw;
		private static const rads:Number = 180 / Math.PI;
		
		private var container:Sprite;
		
		private var bodies:Array = [];
		
		public function set Container( value:Sprite ) : void
		{
			container = value;
		}
		
		public static function get Instance() : Box2dGameDraw 
		{ 
			if( !instance ) 
				instance = new Box2dGameDraw();
			return instance; 
		}
		
		public function AddBody( body:b2Body, width:int, height:int ) : void
		{
			var skinId:String = body.GetUserData().skinId;
			var materialId:String = body.GetUserData().material;
			var hasSkin:Boolean = skinId != null;
			var hasMaterialId:Boolean = materialId != null;
			
			if( hasSkin )
				body.GetUserData().skin = MaterialsMaker.GetClip( skinId );
			else if( hasMaterialId )
				body.GetUserData().skin = MaterialsMaker.GetMaterial( materialId, width, height );
			
			if( hasSkin || hasMaterialId )
			{
				bodies.push( body );
				container.addChild( body.GetUserData().skin );
			}
		}
		
		public function RemoveBody( body:b2Body ) : void
		{
			var index:int = bodies.indexOf( body );
			if( index == -1 ) return;
			var target:b2Body = bodies.splice( index, 1 )[0];
			var skin:Sprite = target.GetUserData().skin;
			if( skin != null && skin.parent )
				skin.parent.removeChild( skin );
		}
		
		public function Update() : void
		{
			var radians:Number = rads;
			for each( var body:b2Body in bodies )
			{
				var skin:Sprite = body.GetUserData().skin as Sprite;
				var position:b2Vec2 = body.GetPosition();
				skin.x = position.x * 30;
				skin.y = position.y * 30;
				skin.rotation = body.GetAngle() * radians;
			}
		}
		
		public function Clear() : void
		{
			for each( var body:b2Body in bodies )
			{
				var skin:Sprite = body.GetUserData().skin as Sprite;
				if( skin.parent )
					skin.parent.removeChild( skin );
			}
		}
	}
}