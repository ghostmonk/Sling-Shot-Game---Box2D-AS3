package Box2DExtention.Config
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2World;
	
	import Box2DExtention.Factories.BodyMaker;
	import Box2DExtention.World;
	
	import GameTools.Box2dGameDraw;
	
	import Utils.StageRef;
	
	import com.ghostmonk.utils.ObjectFuncs;
	import com.ghostmonk.utils.XMLUtils;
	
	import flash.display.Stage;

	public class BodyFactory
	{
		private static var fixtureDefs:Object = {};
		private static var bodyDefs:Object = {};
		private static var blueprints:Object = {};
		private static var userDatas:Object = {};
		
		public static function ParseConfig( config:XML ) : void
		{
			ParseDefaultSettings( config.defaultSettings[0] );
			CacheFixtureDefs( config.fixtureDef );
			CacheBodyDefs( config.bodyDef); 
			CacheBluePrints( config.blueprint );
			CacheUserDatas( config.userData );
			CreateStructures( config.structure );
			fixtureDefs = {};
			bodyDefs = {};
			blueprints = {};
			userDatas = {};
			config = null;
		}
		
		private static function ParseDefaultSettings( config:XML ) : void
		{
			if( config == null ) return;
			
			new FixtureDefSettings( config.fixtureDef[0] );
			new BodyDefSettings( config.bodyDef[0] );
			WorldSettings( config.world[0] );
			CreateBoundary( config.boundary[0] );
		}
		
		private static function WorldSettings( config:XML ) : void
		{
			if( config == null ) return;
			
			var meterPixels:Number = config.@meterPixels;
			World.MeterPixels = Number( config.@meterPixels );
			var vec:b2Vec2 = new b2Vec2( Number( config.@xGravity ), Number( config.@yGravity ) );
			World.Instance.SetGravity( vec );
		}
		
		private static function CreateBoundary( config:XML ) : void
		{
			if( config == null ) return;
			
			var width:Number = World.Meters( config.@width ) * 0.5;
			var height:Number = World.Meters( config.@height ) * 0.5;
			var stageWidth:Number = World.Meters( StageRef.stage.stageWidth );
			var stageHeight:Number = World.Meters( StageRef.stage.stageHeight );
			var thickness:Number = World.Meters( 5 );
			
			BodyDefSettings.Instance.Type = b2Body.b2_staticBody;
			
			//floor
			BodyDefSettings.Instance.X = width * 0.5;
			BodyDefSettings.Instance.Y = stageHeight - ( thickness * 0.5 ) - 1;
			BodyMaker.Box( width, thickness );
			
			//roof
			BodyDefSettings.Instance.Y = stageHeight - height * 2;
			BodyMaker.Box( width, thickness );
			
			//left wall
			BodyDefSettings.Instance.X = -width * 0.5;
			BodyDefSettings.Instance.Y = stageHeight - height;
			BodyMaker.Box( thickness, height );
			
			//right wall
			BodyDefSettings.Instance.X = width * 0.5 + width;
			BodyDefSettings.Instance.Y = stageHeight - height;
			BodyMaker.Box( thickness, height );
			
			ResetConfig();
		}
		
		private static function CacheFixtureDefs( list:XMLList ) : void
		{
			for each( var node:XML in list )
			{
				fixtureDefs[ node.@id.toString() ] = node;
			}
		}
		
		private static function CacheBodyDefs( list:XMLList ) : void
		{
			for each( var node:XML in list )
			{
				bodyDefs[ node.@id.toString() ] = node;
			}
		}
		
		private static function CacheBluePrints( list:XMLList ) : void
		{
			for each( var node:XML in list )
			{
				blueprints[ node.@id.toString() ] = node;
			}
		}
		
		private static function CacheUserDatas( list:XMLList ) : void
		{
			for each( var node:XML in list )
			{
				userDatas[ node.@id.toString() ] = XMLUtils.SimpleXmlToObject( node );
			}
		}
		
		private static function CreateStructures( list:XMLList ) : void
		{
			for each( var node:XML in list )
			{
				CheckForBluePrint( node );
				ParseNode( node );
			}
		}
		
		private static function CheckForBluePrint( node:XML ) : void
		{
			var bluePrint:XML = XML( blueprints[ node.@blueprintId.toString() ] ).copy();
			if( !bluePrint || bluePrint.toString() == "" ) return;
			bluePrint.@['x'] = node.@x;
			bluePrint.@['y'] = node.@y;
			ParseNode( bluePrint );
		}
		
		private static function ParseNode( node:XML ) : void
		{
			CreateBoxes( node, node.box );
			CreateCircles( node, node.circle );
			CreateTriangles( node, node.triangle );
			CreateTrapezoids( node, node.trapezoid );
		}
		
		private static function CreateBoxes( structureNode:XML, list:XMLList ) : void
		{
			for each( var node:XML in list )
			{
				PreserveStructurePositions( structureNode, node );
				var body:b2Body = BodyMaker.Box( World.Meters( node.@width ), World.Meters( node.@height ) );
				RenderSkin( body, node, node.@width, node.@height );
			}
		}
		
		private static function CreateCircles( structureNode:XML, list:XMLList ) : void
		{
			for each( var node:XML in list )
			{
				PreserveStructurePositions( structureNode, node );
				var body:b2Body = BodyMaker.Circle( World.Meters( node.@radius ) );
				RenderSkin( body, node, node.@radius * 2, node.@radius * 2 );
			}
		}
		
		private static function CreateTriangles( structureNode:XML, list:XMLList ) : void
		{
			for each( var node:XML in list )
			{
				PreserveStructurePositions( structureNode, node );
				var body:b2Body = BodyMaker.Triangle( World.Meters( node.@width ), World.Meters( node.@height ) );
				RenderSkin( body, node, node.@width, node.@height );
			}
		}
		
		private static function CreateTrapezoids( structureNode:XML, list:XMLList ) : void
		{
			for each( var node:XML in list )
			{
				PreserveStructurePositions( structureNode, node );
				var body:b2Body = BodyMaker.Trapezoid( World.Meters( node.@topWidth ), World.Meters( node.@bottomWidth ), World.Meters( node.@height ) );
				var width:int = Math.max( node.@topWidth, node.@bottomWidth );
				RenderSkin( body, node, width, node.@height );
			}
		}
		
		private static function RenderSkin( body:b2Body, node:XML, width:int, height:int ) : void
		{
			if( node.@skinId != null && node.@skinId.toString() != "" )
			{
				if( body.GetUserData() == null )
					body.SetUserData( {} );
				body.GetUserData().skinId = node.@skinId.toString();
			}
			Box2dGameDraw.Instance.AddBody( body, width, height );
			ResetConfig();
		}
		
		private static function PreserveStructurePositions( structureNode:XML, bodyNode:XML ) : void
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
		
		private static function ResolveNodeSettings( node:XML ) : void
		{
			CheckForCachedBodyDef( node.@bodyDefId[0] );
			CheckForCachedFixtureDef( node.@fixtureDefId[0], node.@userDataId[0] );
			SetInlineValues( node );
		}
		
		private static function CheckForCachedFixtureDef( id:String, userDataId:String ) : void
		{
			var config:XML = id != "" && id != null ? fixtureDefs[ id ] as XML : null;
			var userData:Object = userDataId != null && userDataId != "" ? userDatas[ userDataId ] : null;
			FixtureDefSettings.Instance.Configure( config, userData );
		}
		
		private static function CheckForCachedBodyDef( id:String ) : void
		{
			if( id == "" || id == null ) return;
			var config:XML = bodyDefs[ id ] as XML;
			BodyDefSettings.Instance.Configure( config );
		}
		
		private static function SetInlineValues( node:XML ) : void
		{
			BodyDefSettings.Instance.Configure( node );
			var userDataId:String = node.@userDataId;
			var userData:Object = userDataId != null && userDataId != "" ? userDatas[ userDataId ] : null;
			FixtureDefSettings.Instance.Configure( node, userData );
		}
		
		private static function ResetConfig() : void
		{
			BodyDefSettings.Instance.Reset();
			FixtureDefSettings.Instance.Reset();
		}
	}
}