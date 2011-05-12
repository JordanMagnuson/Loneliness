package game 
{
	import net.flashpunk.Entity;
	import net.flashpunk.utils.Input;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Key;
	import net.flashpunk.FP;
	import rooms.MainWorld;
	import rooms.MessageScreen;

	public class Player extends Moveable
	{
		
		/**
		 * Movement constants.
		 */
		public const SPEED_MAX:Number = 70;	//100
		public const ACCEL:Number = 800;
		public const DRAG:Number = 800;
		
		/**
		 * Movement properties.
		 */
		public var spdMax:Number = 0;
		public var spdX:Number = 0;
		public var spdY:Number = 0;		
		
		/**
		 * Player graphic
		 */
		[Embed(source='../../assets/gfx/player.png')] private const S_PLAYER:Class;
		public var image:Image = new Image(S_PLAYER);		
		
		public function Player() 
		{
			x = FP.screen.width / 2;
			//y = 800;
			y = MainWorld.height - 50;			
			
			type = "player";
			graphic = image;
			layer = 0;
			
			image.originX = image.width / 2;
			image.originY = image.height / 2;
			image.x = -image.originX;
			image.y = -image.originY;	
			
			setHitbox(image.width, image.height, image.originX, image.originY);
			
			Input.define("U", Key.UP, Key.W);
			Input.define("D", Key.DOWN, Key.S);			
			Input.define("L", Key.LEFT, Key.A);	
			Input.define("R", Key.RIGHT, Key.D);		
		}
		
		/**
		 * Update the player.
		 */		
		override public function update():void 
		{
			setSpdMax();
			acceleration();
			move(spdX * FP.elapsed, spdY * FP.elapsed);	
			if (y <= 200)
			{
				FP.world.remove(this);
				//FP.world.add(new ChildrenAndText);
				FP.world = new MessageScreen;
			}
		}		
		
		/**
		 * Speed
		 */
		private function setSpdMax():void
		{
			//spdMax = ((y / MainWorld.height) * (SPEED_MAX * (2 / 3))) + (SPEED_MAX * (1 / 3));
			spdMax = ((y / MainWorld.height) * (SPEED_MAX * (1 / 3))) + (SPEED_MAX * (2 / 3));
		}
		
		/**
		 * Accelerates the player based on input.
		 */
		private function acceleration():void
		{
			// evaluate input
			var accelX:Number = 0;
			var accelY:Number = 0;
			if (y <= FP.screen.height * 2.5)	// Force player up at end of game
			{
				accelY -= ACCEL;
			}
			else
			{
				if (Input.check("U")) accelY -= ACCEL;
				if (Input.check("D")) accelY += ACCEL;
				if (Input.check("L")) accelX -= ACCEL;				
				if (Input.check("R")) accelX += ACCEL;		
			}
			
			// handle acceleration
			if (accelX != 0)
			{
				if (accelX > 0)
				{
					// accelerate right
					if (spdX < spdMax)
					{
						spdX += accelX * FP.elapsed;
						if (spdX > spdMax) spdX = spdMax;
					}
					else accelX = 0;
				}
				else
				{
					// accelerate left
					if (spdX > -spdMax)
					{
						spdX += accelX * FP.elapsed;
						if (spdX < -spdMax) spdX = -spdMax;
					}
					else accelX = 0;
				}
			}
			if (accelY != 0)
			{
				if (accelY > 0)
				{
					// accelerate right
					if (spdY < spdMax)
					{
						spdY += accelY * FP.elapsed;
						if (spdY > spdMax) spdY = spdMax;
					}
					else accelY = 0;
				}
				else
				{
					// accelerate left
					if (spdY > -spdMax)
					{
						spdY += accelY * FP.elapsed;
						if (spdY < -spdMax) spdY = -spdMax;
					}
					else accelY = 0;
				}
			}		
			
			// handle decelleration
			if (accelX == 0)
			{
				if (spdX > 0)
				{
					spdX -= DRAG * FP.elapsed;
					if (spdX < 0) spdX = 0;
				}
				else
				{
					spdX += DRAG * FP.elapsed;
					if (spdX > 0) spdX = 0;
				}
			}
			if (accelY == 0)
			{
				if (spdY > 0)
				{
					spdY -= DRAG * FP.elapsed;
					if (spdY < 0) spdY = 0;
				}
				else
				{
					spdY += DRAG * FP.elapsed;
					if (spdY > 0) spdY = 0;
				}
			}			
		}			
		
	}

}