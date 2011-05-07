package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import net.flashpunk.Engine;
	import rooms.MainWorld;
	import net.flashpunk.FP;
	import flash.ui.Mouse;
	
	/**
	 * ...
	 * @author Jordan Magnuson
	 */
	public class Main extends Engine 
	{
		
		public function Main()
		{
			// Initiate the game with a 400x300 screen.
			super(400, 300, 60, false);
			
			// Scale by 150%, resulting in a 600x450 display.
			FP.screen.scale = 1.5;		
			FP.screen.color = Colors.WHITE;
			
			// Console for debugging
			//FP.console.enable();					
			
			FP.world = new MainWorld;
			Mouse.hide();
		}
		
		override public function init():void
		{
			super.init();
		}
		
	}
	
}