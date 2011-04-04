package Config
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2World;
	
	import Utils.BodyMaker;
	import Utils.StageRef;
	import Utils.World;
	
	import flash.display.Stage;

	public class BodyFactory
	{
		private var fixtureDefs:Object = {};
		private var bodyDefs:Object = {};
		
		public function BodyFactory( config:XML )
		{
			ParseDefaultSettings( config.defaultSettings[0] );
			CacheFixtureDefs( config.fixtureDef );
			CacheBodyDefs( config.bodyDef); 
			CreateStructures( config.structure );
			fixtureDefs = null;
			bodyDefs = null;
		}
		
		private function ParseDefaultSettings( config:XML ) : void
		{
			if( config == null ) return;
			
			new FixtureDefSettings( config.fixtureDef[0] );
			new BodyDefSettings( config.bodyDef[0] );
			WorldSettings( config.world[0] );
			CreateBoundary( config.boundary[0] );
		}
		
		private function WorldSettings( config:XML ) : void
		{
			if( config == null ) return;
			
			var meterPixels:Number = config.@meterPixels;
			World.MeterPixels = Number( config.@meterPixels );
			var vec:b2Vec2 = new b2Vec2( Number( config.@xGravity ), Number( config.@yGravity ) );
			World.Instance.SetGravity( vec );
		}
		
		private function CreateBoundary( config:XML ) : void
		{
			if( config == null ) return;
			
			var width:Number = World.Meters( config.@width ) * 0.5;
			var height:Number = World.Meters( config.@height ) * 0.5;
			var stageWidth:Number = World.Meters( StageRef.stage.stageWidth );
			var stageHeight:Number = World.Meters( StageRef.stage.stageHeight );
			var thickness:Number = World.Meters( 5 );
			
			BodyDefSettings.Instance.Type = b2Body.b2_staticBody;
			
			//floor
			BodyDefSettings.Instance.X = stageWidth * 0.5;
			BodyDefSettings.Instance.Y = stageHeight - ( thickness * 0.5 );
			BodyMaker.Box( width, thickness );
			
			//roof
			BodyDefSettings.Instance.Y = stageHeight - height * 2;
			BodyMaker.Box( width, thickness );
			
			//left wall
			BodyDefSettings.Instance.X = ( stageWidth * 0.5 ) - width;
			BodyDefSettings.Instance.Y = stageHeight - height;
			BodyMaker.Box( thickness, height );
			
			//right wall
			BodyDefSettings.Instance.X = ( stageWidth * 0.5 ) + width;
			BodyMaker.Box( thickness, height );
			
			ResetConfig();
		}
		
		private function CacheFixtureDefs( list:XMLList ) : void
		{
			for each( var node:XML in list )
			{
				fixtureDefs[ node.@id.toString() ] = node;
			}
		}
		
		private function CacheBodyDefs( list:XMLList ) : void
		{
			for each( var node:XML in list )
			{
				bodyDefs[ node.@id.toString() ] = node;
			}
		}
		
		private function CreateStructures( list:XMLList ) : void
		{
			for each( var node:XML in list )
			{
				CreateBoxes( node.box );
				CreateCircles( node.circle );
			}
		}
		
		private function CreateBoxes( list:XMLList ) : void
		{
			for each( var node:XML in list )
			{
				CheckForCachedBodyDef( node.@bodyDefId );
				CheckForCachedFixtureDef( node.@fixtureDefId );
				SetInlineValues( node );
				BodyMaker.Box( World.Meters( node.@width ), World.Meters( node.@height ) );
				ResetConfig();
			}
		}
		
		private function CreateCircles( list:XMLList ) : void
		{
			for each( var node:XML in list )
			{
				CheckForCachedBodyDef( node.@bodyDefId );
				CheckForCachedFixtureDef( node.@fixtureDefId );
				SetInlineValues( node );
				BodyMaker.Circle( World.Meters( node.@radius ) );
				ResetConfig();
			}
		}
		
		private function CheckForCachedFixtureDef( id:String ) : void
		{
			if( id == "" || id == null ) return;
			var config:XML = fixtureDefs[ id ] as XML;
			FixtureDefSettings.Instance.Configure( config );
		}
		
		private function CheckForCachedBodyDef( id:String ) : void
		{
			if( id == "" || id == null ) return;
			var config:XML = bodyDefs[ id ] as XML;
			BodyDefSettings.Instance.Configure( config );
		}
		
		private function SetInlineValues( node:XML ) : void
		{
			BodyDefSettings.Instance.Configure( node );
			FixtureDefSettings.Instance.Configure( node );
		}
		
		private function ResetConfig() : void
		{
			BodyDefSettings.Instance.Reset();
			FixtureDefSettings.Instance.Reset();
		}
	}
}