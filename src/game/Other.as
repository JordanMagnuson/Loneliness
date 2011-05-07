package game 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	import rooms.MainWorld;
	
	public class Other extends PolarMover
	{
		public static const SCARE_RADIUS:Number = 40;
		public static const INFLUENCE_RADIUS:Number = 40; // If a wanderer gets within this distance of another type, it will become that type			
		
		/**
		 * Movement constants.
		 */
		public static const SPEED_MAX:Number = 140;
		
		/**
		 * Movement properties.
		 */
		public var spdMax:Number = 0;	
		public var speed:Number = 0;
		public var direction:int = 0;		
		
		/**
		 * Graphic
		 */
		[Embed(source='../../assets/gfx/other.png')] private const S_OTHER:Class;
		public var image:Image = new Image(S_OTHER);			
		
		public function Other(x:Number = 0, y:Number = 0) 
		{
			super(x, y);
			
			type = 'other';
			layer = 0;
			
			graphic = image;			
			
			image.originX = image.width / 2;
			image.originY = image.height / 2;
			image.x = -image.originX;
			image.y = -image.originY;	
			setHitbox(image.width, image.height, image.originX, image.originY);	
			
			setSpdMax();
		}
		
		/**
		 * Update the other.
		 */		
		override public function update():void 
		{
			if (offScreen())
				FP.world.remove(this);
			if (distanceFrom(MainWorld.player) <= SCARE_RADIUS)
			{
				leave();
			}
			move(speed * FP.elapsed, direction);	
		}				
		
		public function setSpdMax():void
		{
			spdMax = ((y / MainWorld.height) * (SPEED_MAX * (2 / 3))) + (SPEED_MAX * (1 / 3));
		}		
		
		public function leave():void
		{
			this.type = 'to_leave';
			FP.world.remove(this);
			FP.world.add(new Leaving(this.x, this.y));
		}
		
		public function offScreen():Boolean
		{
			if (y  > MainWorld.height + height / 2 || y  < -height / 2)
				return true;
			else if (x  > MainWorld.width + width / 2 || x  < -width / 2)
				return true;
			else
				return false;
		}
		
		public function destroy():void
		{
			FP.world.remove(this);
		}	
		
	}

}