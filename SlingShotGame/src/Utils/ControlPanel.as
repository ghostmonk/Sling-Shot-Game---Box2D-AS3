package Utils 
{	
	import com.ghostmonk.ui.interactive.buttons.ClickableSprite;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	/**
	 *@author ghostmonk - Apr 6, 2011
	 */
	public class ControlPanel extends Sprite
	{
		public static const RESET_GAME:String = "resetGame";
		public static const NEW_MAN:String = "newMan";
		
		public function ControlPanel()
		{
			var reset:Sprite = CreateButton( "RESET" );
			var newMan:Sprite = CreateButton( "NEWMAN" );
			reset.addEventListener( MouseEvent.CLICK, function( e:Event ):void { dispatchEvent( new Event( RESET_GAME ) ) } );
			newMan.addEventListener( MouseEvent.CLICK, function( e:Event ):void { dispatchEvent( new Event( NEW_MAN ) ) } );
			
			newMan.x = reset.width + 10;
			
			addChild( reset );
			addChild( newMan );
		}
		
		private function CreateButton( text:String ) : Sprite
		{
			var button:Sprite = new Sprite();
			button.graphics.lineStyle( 1, 0xaa1144, 1 );
			button.graphics.beginFill( 0xaa1144, 0.3 );
			button.graphics.drawRoundRect( 0, 0, 100, 20, 5, 5 );
			button.graphics.endFill();
			button.mouseEnabled = true;
			button.mouseChildren = false;
			button.buttonMode = true;
			
			var textBox:TextField = new TextField();
			textBox.textColor = 0xFFFFFF;
			textBox.text = text;
			textBox.mouseEnabled = false;
			textBox.autoSize = TextFieldAutoSize.LEFT;
			
			textBox.x = ( button.width - textBox.width ) * 0.5;
			textBox.y = ( button.height - textBox.height ) * 0.5;
			
			button.addChild( textBox );
			return button;
		}
	}
}