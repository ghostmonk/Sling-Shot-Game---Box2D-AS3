package Utils 
{	
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;

	/**
	 *@author ghostmonk - Apr 10, 2011
	 */
	public class KeyPressController extends EventDispatcher
	{
		public static const KEY_PRESS:String = "keyPress";
		
		private static var controller:KeyPressController;
		
		public function KeyPressController()
		{
			controller = this;
		}
		
		public static function get Instance() : KeyPressController
		{
			return controller || new KeyPressController();
		}
		
		public function Enable() : void
		{
			StageRef.stage.addEventListener( KeyboardEvent.KEY_DOWN, OnKeyDown );
		}
		
		public function Disable() : void
		{
			StageRef.stage.removeEventListener( KeyboardEvent.KEY_DOWN, OnKeyDown );	
			StageRef.stage.removeEventListener( KeyboardEvent.KEY_UP, OnKeyUp );
		}
		
		private function OnKeyDown( e:KeyboardEvent ) : void
		{
			dispatchEvent( 
				new KeyboardEvent( KEY_PRESS, true, false, e.charCode, e.keyCode, e.keyLocation, e.ctrlKey, e.altKey, e.shiftKey ) );
			StageRef.stage.removeEventListener( KeyboardEvent.KEY_DOWN, OnKeyDown );
			StageRef.stage.addEventListener( KeyboardEvent.KEY_UP, OnKeyUp );
		}
		
		private function OnKeyUp( e:KeyboardEvent ) : void
		{
			dispatchEvent( e );
			Enable();
			StageRef.stage.removeEventListener( KeyboardEvent.KEY_UP, OnKeyUp );
		}
	}
}