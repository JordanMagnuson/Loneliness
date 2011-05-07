package game 
{
	
	import net.flashpunk.Entity;
	import net.flashpunk.World;
	import rooms.MainWorld;
	import flash.geom.Point;
	import net.flashpunk.FP;
	import net.flashpunk.tweens.misc.Alarm;
	import net.flashpunk.tweens.misc.ColorTween;
	import net.flashpunk.graphics.Image;
	
	public class Leaving extends Other
	{	
		/**
		 * Movement constants.
		 */
		public const LEAVING_SPEED_MAX:Number = SPEED_MAX / 2;		
		
		/**
		 * Fade out
		 */
		public const FADE_OUT_DURATION:Number = 3;
		public var fadeAlarm:Alarm = new Alarm(1, fadeOut); // Time until fade starts
		public var fadeTween:ColorTween = new ColorTween(destroy);; // Controls actual fade out
		
		public function Leaving(x:Number = 0, y:Number = 0)
		{
			super(x, y);
			type = 'leaving';
			
			// Run!
			speed = ((y / MainWorld.height) * (LEAVING_SPEED_MAX * (2 / 3))) + (LEAVING_SPEED_MAX * (1 / 3));
			direction = pointDirection(x, y, MainWorld.player.x, MainWorld.player.y) + 180;
			
			// Scare nearby
			scareNearby();
			
			// Start time until fade
			addTween(fadeAlarm, true);			
		}
		
		override public function update():void
		{
			if (offScreen())
				FP.world.remove(this);
			move(speed * FP.elapsed, direction);
			(graphic as Image).alpha = fadeTween.alpha;
		}
		
		public function scareNearby():void
		{
			var toScare:Array = [];
			FP.world.collideRectInto('other', x - SCARE_RADIUS, y - SCARE_RADIUS, SCARE_RADIUS * 2, SCARE_RADIUS * 2, toScare);

			for each (var other:Other in toScare)
				other.leave();
		}		
		
		public function fadeOut():void
		{
			addTween(fadeTween, true);		
			fadeTween.tween(FADE_OUT_DURATION, Colors.WHITE, Colors.WHITE, image.alpha, 0);				
		}
		
	}

}