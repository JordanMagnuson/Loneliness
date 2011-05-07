package game 
{
	import net.flashpunk.Entity;
	import Math;
	import net.flashpunk.FP;

	public class PolarMover extends Entity
	{
		
		public function PolarMover(x:Number, y:Number) 
		{
			super(x, y);		
		}
		
		/**
		 * Moves the entity using polar coordinates
		 * @param	distance	Distance to move (use distance * FP.elapsed for variable time)
		 * @param	direction	Direction to move, in degrees (0 is to the right, ccw)
		 */
		public function move(distance:Number, direction:Number):void
		{
			// Need to convert degrees to radians for sin/cos functions, hence multiplying by Math.PI/180
			x += distance * Math.cos(direction * Math.PI/180);
			y -= distance * Math.sin(direction * Math.PI/180);	// Minus here, because negative is up	
		}
		
		/**
		 * Returns the direction of point(x1,y1) towards point(x2,y2) in degrees
		 */
		public function pointDirection(x1:Number, y1:Number, x2:Number, y2:Number):Number
		{
			// This is slightly different than the standard cartesian implementation atan2(x2 - x1, y2 - y1)
			// due to the orientation of the game's coordinate system, where 0,0 is at the upper left
			return (Math.atan2(y1 - y2, x2 - x1) * 180 / Math.PI);
		}
		
	}

}