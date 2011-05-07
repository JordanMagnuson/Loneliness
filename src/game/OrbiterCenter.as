package game 
{
	import net.flashpunk.FP;
	
	public class OrbiterCenter extends CenterGuide
	{
		public var clockWise:Boolean = FP.choose(true, false);
		
		public function OrbiterCenter(x:Number, y:Number) 
		{
			super(x, y);
			type = 'orbiter_center';			
		}
		
	}

}