package game 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;

	public class MixerCenter extends CenterGuide
	{
		public var radius:Number = 20 + FP.rand(40);
		
		public function MixerCenter(x:Number, y:Number) 
		{
			super(x, y);
			type = 'mixer_center';
		}
		
	}

}