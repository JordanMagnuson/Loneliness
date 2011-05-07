package game 
{
	import net.flashpunk.tweens.motion.CircularMotion;
	import net.flashpunk.FP;

	public class Orbiter extends Other
	{
		
		public var orbitCenter:OrbiterCenter;
		
		public var motionTween:CircularMotion = new CircularMotion(continueOrbit);
		
		public function Orbiter(x:Number, y:Number) 
		{
			super(x, y);
			setSpdMax();
			speed = (spdMax / 2) + (FP.random * spdMax / 2);	
		}
		
		override public function added():void
		{
			// Can't do this in the constructor, because there are no center guides yet
			orbitCenter = (FP.world.nearestToEntity('orbiter_center', this) as OrbiterCenter);		
			
			
			motionTween.setMotionSpeed(orbitCenter.x, orbitCenter.y, distanceFrom(orbitCenter), getAngle(), orbitCenter.clockWise, speed);
			FP.world.addTween(motionTween, true);
		}
		
		override public function update():void 
		{
			super.update();
			x = motionTween.x;
			y = motionTween.y;
		}
		
		public function continueOrbit():void
		{
			motionTween.setMotionSpeed(orbitCenter.x, orbitCenter.y, distanceFrom(orbitCenter), getAngle(), orbitCenter.clockWise, speed);
		}	
		
		public function getAngle():Number
		{
			return pointDirection(orbitCenter.x, orbitCenter.y, x, y);
		}
	}

}