package game
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import rooms.*;
	
	/**
	 * Base class for moving Entities to handle collision.
	 */
	public class Moveable extends Entity
	{
		/**
		 * Entity -type- to consider solid when colliding.
		 */
		public var solid:String = "solid";
		
		/**
		 * Constructor.
		 */
		public function Moveable() 
		{
			
		}
		
		/**
		 * Moves the entity by the specified amount horizontally and vertically.
		 */
		public function move(moveX:Number = 0, moveY:Number = 0):void
		{
			// movement counters
			_moveX += moveX;
			_moveY += moveY;
			moveX = Math.round(_moveX);
			moveY = Math.round(_moveY);
			_moveX -= moveX;
			_moveY -= moveY;
			
			// movement vars
			var sign:int, e:Entity;
			
			// horizontal
			if (moveX != 0)
			{
				sign = moveX > 0 ? 1 : -1;
				while (moveX != 0)
				{
					moveX -= sign;
					if ((e = collide(solid, x + sign, y)))
					{
						collideX(e);
						moveX = 0;
					}
					// edge of screen
					else if (x + sign < width / 2 || x + sign > MainWorld.width - width / 2)
					{
						moveX = 0;
					}
					else x += sign;
				}
			}
			
			// vertical
			if (moveY != 0)
			{
				sign = moveY > 0 ? 1 : -1;
				while (moveY != 0)
				{
					moveY -= sign;
					if ((e = collide(solid, x, y + sign)))
					{
						collideY(e);
						moveY = 0;
					}
					// edge of screen
					else if (y + sign < height / 2 || y + sign > MainWorld.height - height / 2)
					{
						moveY = 0;
					}				
					else y += sign;
				}
			}
		}
		
		/**
		 * Horizontal collision (override for specific behaviour).
		 */
		protected function collideX(e:Entity):void
		{
			
		}
		
		/**
		 * Vertical collision (override for specific behaviour).
		 */
		protected function collideY(e:Entity):void
		{
			
		}
		
		/**
		 * Helper vars used by move().
		 */
		private var _moveX:Number = 0;
		private var _moveY:Number = 0;
	}
}