package Utils 
{	
	import flash.display.Sprite;

	/**
	 *@author ghostmonk - Apr 17, 2011
	 */
	public class MaterialsMaker 
	{
		private static const clipReferences:Object = 
			{ 
				"broadcast" : BroadCastingTarget, 
				"budget" : BudgetTarget, 
				"charter" : CharterTarget, 
				"clock" : ClockFaceView, 
				"environment" : EnvironmentTarget, 
				"gun" : GunControlTarget,
				"health" : HealthTarget,
				"public" : PublicTarget,
				"student" : StudentTarget,
				"un" : UNTarget,
				"verterans" : Vetrans,
				"wheat" : WheatBoard,
				"women" : WomenTarget,
				"gazebo" : GazeboRoof, 
				"parlsteeple" : ParliamentSteeple, 
				"parlroof" : ParlianmentRoof, 
				"sign" : Sign, 
				"supremeroof" : SupremeCourtRoof, 
				"sumpremesteeple" : SupremeCourtSteeple 
			};
		
		private static const materialFunctions:Object = 
			{
				"wood" : WoodBlock,
				"concrete" : ConcreteBlock,
				"stone" : StoneBlock
			}
		
		public static function GetMaterial( id:String, width:int, height:int ) : Sprite
		{
			return materialFunctions[id]( width, height );
		}
		
		public static function GetClip( id:String ) : Sprite
		{
			var StructureClass:Class = clipReferences[id] as Class;
			return new StructureClass();
		}
		
		private static function WoodBlock( width:int, height:int ) : Sprite
		{
			return DrawBlock( width, height, 0x754C29, 0x231F20 );
		}
		
		private static function ConcreteBlock( width:int, height:int ) : Sprite
		{
			return DrawBlock( width, height, 0xC2C1BF, 0xC2C1BF );
		}
		
		private static function StoneBlock( width:int, height:int ) : Sprite
		{
			return DrawBlock( width, height, 0x988F67, 0x231F20 );	
		}
		
		private static function DrawBlock( width:int, height:int, color:uint, lineColor:uint ) : Sprite
		{
			var output:Sprite = new Sprite();
			output.graphics.lineStyle( 0.5, lineColor);
			output.graphics.beginFill( color );
			output.graphics.drawRect( -width, -height, width*2, height*2 );
			output.graphics.endFill();
			return output;
		}
	}
}