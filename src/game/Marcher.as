package game 
{
	import net.flashpunk.FP;
	import rooms.MainWorld;

	public class Marcher extends Other
	{
		
		public function Marcher(x:Number, y:Number) 
		{
			super(x, y);
			direction = FP.choose(0, 180);
			setSpdMax();
			speed = (spdMax / 2) + (FP.random * spdMax / 2);
		}
		
		override public function update():void
		{
			super.update();
			if (x <= image.width / 2)
				direction = 0;
			else if (x >= MainWorld.width - image.width / 2)
				direction = 180;
		}
		
	}

}