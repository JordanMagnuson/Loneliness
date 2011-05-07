package game 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;

	public class CenterGuide extends Entity
	{	
		/**
		 * Graphic
		 */
		[Embed(source='../../assets/gfx/debug.png')] private const S_DEBUG:Class;
		public var debug_image:Image = new Image(S_DEBUG);
		
		public function CenterGuide(x:Number, y:Number) 
		{
			super(x, y);
			//graphic = debug_image;
		}
		
	}

}