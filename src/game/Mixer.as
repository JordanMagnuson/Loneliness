package game 
{
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;

	public class Mixer extends Other
	{
		
		public var mixCenter:MixerCenter;
		
		public var radius:Number;
		
		public function Mixer(x:Number, y:Number) 
		{
			super(x, y);
			direction = FP.rand(360);
			setSpdMax();
			speed = (spdMax / 2) + (FP.random * spdMax / 2);
		}
		
		override public function added():void
		{
			// Can't do this in the constructor, because there are no center guides yet
			mixCenter = (FP.world.nearestToEntity('mixer_center', this) as MixerCenter);
			radius = distanceFrom(mixCenter);
		}
		
		override public function update():void
		{
			super.update();
			if (distanceFrom(mixCenter) >= radius)
			{
				direction = pointDirection(x, y, mixCenter.x, mixCenter.y);
			}
		}
	}

}