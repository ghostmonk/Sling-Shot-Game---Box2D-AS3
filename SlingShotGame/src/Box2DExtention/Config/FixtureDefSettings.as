package Box2DExtention.Config
{
	import com.ghostmonk.utils.ObjectFuncs;

	/**
	 * Singleton used to configure new b2FixtureDefs through the BodyFactory. 
	 *  
	 * @author ghostmonk
	 * 
	 */	
	public class FixtureDefSettings
	{
		public var Density:Number;
		public var Friction:Number;
		public var Restitution:Number;
		public var IsSensor:Boolean;
		public var GroupIndex:int;
		public var MaskBits:uint;
		public var CategoryBits:uint;
		public var UserData:*;
		
		private var defaultSettings:Object = { 
			density:0.1, friction:0.2, restitution:0.0, isSensor:false, 
			groupIndex:0, maskBits:0xFFFF, categoryBits:0x0001 };
		
		private static var instance:FixtureDefSettings;
		
		/**
		 * Call the constructor and pass in an xml node with attribute that correspond to the accessors starting with a lowercase.
		 * i.e. 
		 * <fixtureDef density="0.0", friction="0.2", restitution="0.0", isSensor="false" />
		 * 
		 * Omitted values will have defaults.
		 * 
		 * @param config
		 * 
		 */		
		public function FixtureDefSettings( config:XML = null )
		{
			instance = this;
			
			Initialize( config );
			
			Reset();
		}
		
		/**
		 * FixtureDefSetting is a Singleton. To set custom default values, the constructor should be called first.
		 * And then the Instance getter everytime after.  
		 */		
		public static function get Instance() : FixtureDefSettings { return instance || new FixtureDefSettings(); }
		
		/**
		 * Used this to overwrite the default values. Useful when you temporarily wish to 
		 * configure a b2FixtureDef to have values different from the default ones. The format of the XML is the same 
		 * as the one that should be passed to the constructor.
		 * 
		 * Omitted values will be set to their defaults.
		 * 
		 * @param config
		 * 
		 */		
		public function Configure( config:XML, userData:Object = null ) : void
		{
			UserData = ResolveUserData( userData );
			
			if( config == null ) config = new XML();
			
			Density = Num( config.@density, Density );
			Friction = Num( config.@friction, Friction );
			Restitution = Num( config.@restitution, Restitution );
			IsSensor = Bool( config.@isSensor, IsSensor );
			GroupIndex = Num( config.@groupIndex, GroupIndex );
			MaskBits = Num( config.@maskBits, MaskBits );
			CategoryBits = Num( config.@categoryBits, CategoryBits );
		}
		
		private function ResolveUserData( userData:Object ) : Object
		{
			if( UserData == null && userData == null  ) 
				return null;
			
			if( UserData == null ) 
			{
				return userData;	
			}
			
			var output:Object = ObjectFuncs.clone( UserData );
			for( var key:String in userData ) 
			{
				output[ key ] = userData[ key ];
			}
			return output;
		}
		
		/**
		 * Reverts all members back to their default values.
		 */		
		public function Reset() : void
		{
			Density = defaultSettings.density;
			Friction = defaultSettings.friction;
			Restitution = defaultSettings.restitution;
			IsSensor = defaultSettings.isSensor;
			GroupIndex = defaultSettings.groupIndex;
			MaskBits = defaultSettings.maskBits;
			CategoryBits = defaultSettings.categoryBits;
			UserData = defaultSettings.userData;
		}
		
		private function Initialize( config:XML, userData:* = null ) : void
		{
			if( config == null ) return;
			
			defaultSettings.density = Num( config.@density, defaultSettings.density );
			defaultSettings.friction = Num( config.@friction, defaultSettings.friction );
			defaultSettings.restitution = Num( config.@restitution, defaultSettings.restitution );
			defaultSettings.isSensor = Bool( config.@isSensor, defaultSettings.isSensor );
			defaultSettings.groupIndex = Num( config.@groupIndex, defaultSettings.groupIndex );
			defaultSettings.maskBits = Num( config.@maskBits, defaultSettings.maskBits );
			defaultSettings.categoryBits = Num( config.@categoryBits, defaultSettings.categoryBits );
			defaultSettings.userData = userData;
		}
		
		private static function Num( node:String, def:Number ) : Number
		{
			if( node == "" || node == null ) return def
			return Number( node );
		}
		
		private static function Bool( node:String, def:Boolean ) : Boolean
		{
			if( node == "" || node == null ) return def
			return node == "true" ? true : false;
		}
	}
}