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
		private var blueprints:Object = {};
		
		public function BodyFactory( config:XML )
		{
			ParseDefaultSettings( config.defaultSettings[0] );
			CacheFixtureDefs( config.fixtureDef );
			CacheBodyDefs( config.bodyDef); 
			CacheBluePrints( config.blueprint );
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
		
		private function CacheBluePrints( list:XMLList ) : void
		{
			for each( var node:XML in list )
			{
				blueprints[ node.@id.toString() ] = node;
			}
		}
		
		private function CreateStructures( list:XMLList ) : void
		{
			for each( var node:XML in list )
			{
				CheckForBluePrint( node );
				ParseNode( node );
			}
		}
		
		private function CheckForBluePrint( node:XML ) : void
		{
			var bluePrint:XML = XML( blueprints[ node.@blueprintId.toString() ] ).copy();
			if( !bluePrint ) return;
			bluePrint.@['x'] = node.@x;
			bluePrint.@['y'] = node.@y;
			ParseNode( bluePrint );
		}
		
		private function ParseNode( node:XML ) : void
		{
			CreateBoxes( node, node.box );
			CreateCircles( node, node.circle );
			CreateTriangles( node, node.triangle );
			CreateTrapezoids( node, node.trapezoid );
		}
		
		private function CreateBoxes( structureNode:XML, list:XMLList ) : void
		{
			for each( var node:XML in list )
			{
				PreserveStructurePositions( structureNode, node );
				BodyMaker.Box( World.Meters( node.@width ), World.Meters( node.@height ) );
				ResetConfig();
			}
		}
		
		private function CreateCircles( structureNode:XML, list:XMLList ) : void
		{
			for each( var node:XML in list )
			{
				PreserveStructurePositions( structureNode, node );
				BodyMaker.Circle( World.Meters( node.@radius ) );
				ResetConfig();
			}
		}
		
		private function CreateTriangles( structureNode:XML, list:XMLList ) : void
		{
			for each( var node:XML in list )
			{
				PreserveStructurePositions( structureNode, node );
				BodyMaker.Triangle( World.Meters( node.@width ), World.Meters( node.@height ) );
				ResetConfig();
			}
		}
		
		private function CreateTrapezoids( structureNode:XML, list:XMLList ) : void
		{
			for each( var node:XML in list )
			{
				PreserveStructurePositions( structureNode, node );
				BodyMaker.Trapezoid( World.Meters( node.@topWidth ), World.Meters( node.@bottomWidth ), World.Meters( node.@height ) );
				ResetConfig();
			}
		}
		
		private function PreserveStructurePositions( structureNode:XML, bodyNode:XML ) : void
		{
			ResolveNodeSettings( structureNode );
			var x:Number = World.Meters( bodyNode.@x );
			var y:Number = World.Meters( bodyNode.@y );
			delete bodyNode.@x;
			delete bodyNode.@y;
			ResolveNodeSettings( bodyNode );
			BodyDefSettings.Instance.X += x;
			BodyDefSettings.Instance.Y += y;
		}
		
		private function ResolveNodeSettings( node:XML ) : void
		{
			CheckForCachedBodyDef( node.@bodyDefId );
			CheckForCachedFixtureDef( node.@fixtureDefId );
			SetInlineValues( node );
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