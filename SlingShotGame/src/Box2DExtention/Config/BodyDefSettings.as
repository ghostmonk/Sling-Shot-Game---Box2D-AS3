package Box2DExtention.Config
{
	import Box2D.Dynamics.b2Body;
	
	import Box2DExtention.World;

	/**
	 * Singleton used to configure new b2BodyDefs through the BodyFactory. 
	 *  
	 * @author ghostmonk
	 * 
	 */	
	public class BodyDefSettings
	{
		public var Active:Boolean;
		public var AllowSleep:Boolean;
		public var Angle:Number;
		public var AngularDamping:Number;
		public var AngularVelocity:Number;
		public var Awake:Boolean;
		public var Bullet:Boolean;
		public var FixedRotation:Boolean;
		public var InertiaScale:Number;
		public var LinearDamping:Number;
		public var LinearVelocityX:Number;
		public var LinearVelocityY:Number;
		public var X:Number;
		public var Y:Number;
		public var Type:uint;
		
		private var defaultSettings:Object = { 
			x:0.0, y:0.0, type:b2Body.b2_staticBody,
			active:true, allowSleep:true, awake:true, bullet:false, fixedRotation:false, inertiaScale:1.0,  
			angle:0.0, angularDamping:0.0, angularVelocity:0.0, 
			linearDamping:0.0, linearVelocityX:0.0, linearVelocityY:0.0 };
		
		private static var instance:BodyDefSettings;
		
		/**
		 * Call the constructor and pass in an xml node with attributes that correspond to the accessors starting with a lowercase.
		 * i.e. 
		 * <bodyDef x="0" y="0" type="static" awake="true"
		 *		active="true" allowSleep="true" bullet="false" fixedRotation="false" inertiaScale="1.0" 
		 *		angle="0.0" angularDamping="0.0" angularVelocity="0.0"
		 *		linearDamping="0.0" linearVelocityX="0.0" linearVelocityY="0.0" />
		 * 
		 * Omitted values will have the same defaults set in b2Body.
		 * 
		 * @param config
		 * 
		 */
		public function BodyDefSettings( config:XML = null )
		{
			instance = this;
			
			initialize( config );
			
			Reset();
		}
		
		/**
		 * BodyDefSettings is a Singleton. To set custom default values, the constructor should be called first.
		 * And then the Instance getter everytime after.  
		 */	
		public static function get Instance() : BodyDefSettings
		{
			return instance || new BodyDefSettings();
		}
		
		/**
		 * Used this to overwrite the default values. Useful when you temporarily wish to 
		 * configure a b2BodyDef to have values different from the default ones. The format of the XML is the same 
		 * as the one that should be passed to the constructor.
		 * 
		 * Omitted values will be set to their defaults.
		 * 
		 * @param config
		 * 
		 */	
		public function Configure( config:XML ) : void
		{
			Active = Bool( config.@active, Active );
			AllowSleep = Bool( config.@allowSleep, AllowSleep );
			Awake = Bool( config.@awake, Awake );
			Bullet = Bool( config.@bullet, Bullet );
			FixedRotation = Bool( config.@fixedRotation, FixedRotation );
			
			Angle = Num( config.@angle, Angle );
			AngularDamping = Num( config.@angularDamping, AngularDamping );
			AngularVelocity = Num( config.@angularVelocity, AngularVelocity );
			InertiaScale = Num( config.@inertiaScale, InertiaScale );
			LinearDamping = Num( config.@linearDamping, LinearDamping );
			LinearVelocityX = Num( config.@linearVelocityX, LinearVelocityX );
			LinearVelocityY = Num( config.@linearVelocityY, LinearVelocityY );
			
			X = Pos( config.@x, X );
			Y = Pos( config.@y, Y );
			
			Type = BodyType( config.@type, Type );
		}
		
		/**
		 * Reverts all members back to their default values.
		 */
		public function Reset() : void
		{
			Active = defaultSettings.active;
			AllowSleep = defaultSettings.allowSleep;
			Angle = defaultSettings.angle;
			AngularDamping = defaultSettings.angularDamping;
			AngularVelocity = defaultSettings.angularVelocity;
			Awake = defaultSettings.awake;
			Bullet = defaultSettings.bullet;
			FixedRotation = defaultSettings.fixedRotation;
			InertiaScale = defaultSettings.inertiaScale;
			LinearDamping = defaultSettings.linearDamping;
			LinearVelocityX = defaultSettings.linearVelocityX;
			LinearVelocityY = defaultSettings.linearVelocityY;
			X = defaultSettings.x;
			Y = defaultSettings.y;
			Type = defaultSettings.type;
		}
		
		private function initialize( config:XML ) : void
		{
			if( config == null ) return;
			
			defaultSettings.active = Bool( config.@active, defaultSettings.active );
			defaultSettings.allowSleep = Bool( config.@allowSleep, defaultSettings.allowSleep );
			defaultSettings.awake = Bool( config.@awake, defaultSettings.awake );
			defaultSettings.bullet = Bool( config.@bullet, defaultSettings.bullet );
			defaultSettings.fixedRotation = Bool( config.@fixedRotation, defaultSettings.fixedRotation );
			
			defaultSettings.angle = Num( config.@angle, defaultSettings.angle );
			defaultSettings.angularDamping = Num( config.@angularDamping, defaultSettings.angularDamping );
			defaultSettings.angularVelocity = Num( config.@angularVelocity, defaultSettings.angularVelocity );
			defaultSettings.inertiaScale = Num( config.@inertiaScale, defaultSettings.inertiaScale );
			defaultSettings.linearDamping = Num( config.@linearDamping, defaultSettings.linearDamping );
			defaultSettings.linearVelocityX = Num( config.@linearVelocityX, defaultSettings.linearVelocityX );
			defaultSettings.linearVelocityY = Num( config.@linearVelocityY, defaultSettings.linearVelocityY );
			
			defaultSettings.x = Pos( config.@x, defaultSettings.x );
			defaultSettings.y = Pos( config.@y, defaultSettings.y );
			
			defaultSettings.type = BodyType( config.@type, defaultSettings.type );
		}
		
		private static function BodyType( type:String, def:uint ) : uint
		{
			switch( type )
			{
				case "static": return b2Body.b2_staticBody; break;
				case "dynamic": return b2Body.b2_dynamicBody; break;
				case "kinematic": return b2Body.b2_kinematicBody; break;
				default: return def;
			}
		}
		
		private static function Pos( value:String, def:Number ) : Number
		{
			if( value == "" || value == null ) return def;
			return World.Meters( Number( value ) );
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