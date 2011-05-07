package game 
{
	import net.flashpunk.tweens.misc.Alarm;
	import net.flashpunk.FP;

	public class Jumper extends Other
	{
		public const GRAV:Number = 500;
		public var gravity:Number = 0;
		
		public var spdY:Number = 0;
		public var yOrig:Number;
		
		public const JUMP_TIME:Number = 0.5 + (FP.random * 1.5);
		public var jumpAlarm:Alarm = new Alarm(JUMP_TIME, jump);
		
		public function Jumper(x:Number, y:Number) 
		{
			super(x, y);
			yOrig = y;
			setSpdMax();
			spdMax *= 1;
		}
		
		override public function added():void
		{
			addTween(jumpAlarm, true);
		}
		
		override public function update():void
		{
			super.update();
			
			// Don't go too far down with gravity
			if (y >= yOrig && spdY > 0)
			{
				y = yOrig;
				gravity = 0;
				spdY = 0;
			}
			
			// Gravity
			spdY += gravity * FP.elapsed;
			
			// Move
			if (y + spdY * FP.elapsed <= yOrig)
				y += spdY * FP.elapsed;
			else
				y = yOrig;
		}
		
		public function jump():void
		{
			if (y == yOrig)
			{
				spdY = -1 * (spdMax * 1.25) + (FP.random * spdMax * (0.50));
				gravity = GRAV;
			}
			jumpAlarm.reset(JUMP_TIME);
		}
		
	}

}