package Config
{
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
		
		private var defaultSettings:Object = { density:0.1, friction:0.2, restitution:0.0, isSensor:false };
		
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
		public function Configure( config:XML ) : void
		{
			Density = Num( config.@density, Density );
			Friction = Num( config.@friction, Friction );
			Restitution = Num( config.@restitution, Restitution );
			IsSensor = Bool( config.@isSensor, IsSensor );
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
		}
		
		private function Initialize( config:XML ) : void
		{
			if( config == null ) return;
			
			defaultSettings.density = Num( config.@density, defaultSettings.density );
			defaultSettings.friction = Num( config.@friction, defaultSettings.friction );
			defaultSettings.restitution = Num( config.@restitution, defaultSettings.restitution );
			defaultSettings.isSensor = Bool( config.@isSensor, defaultSettings.isSensor );
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