package rooms 
{
	import game.Background01;
	import game.Background02;
	import game.Background03;
	import game.Background04;
	import game.Jumper;
	import game.Marcher;
	import game.Mixer;
	import game.MixerCenter;
	import game.Orbiter;
	import game.OrbiterCenter;
	import game.Other;
	import game.Player;
	import game.Sitter;
	import net.flashpunk.graphics.Backdrop;
	import net.flashpunk.World;
	import net.flashpunk.FP;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import net.flashpunk.Sfx;
	
	public class MainWorld extends World
	{
		/**
		 * Size of the level (so it knows where to keep the player + camera in).
		 */
		public static var width:uint;
		public static var height:uint;		
		
		public static var player:Player;	
		
		/**
		 * The loading XML file.
		 */
		public var level:XML;		
		
		/**
		 * Level XML.
		 */
		[Embed(source='../../assets/levels/MainLevel2.oel', mimeType='application/octet-stream')] private static const LEVEL:Class;		
		
		/**
		 * Camera following information.
		 */
		public const FOLLOW_TRAIL:Number = 0;
		public const FOLLOW_RATE:Number = 1;	
		
		/**
		 * Sound
		 */
		[Embed(source='../../assets/sound/Sounds.swf', symbol='blue_paint_loop.mp3')] private const MUSIC:Class;
		public var music:Sfx = new Sfx(MUSIC);			
		
		public function MainWorld() 
		{			
			loadLevel(LEVEL);				
			
			width = 400;
			height = 8000;	
		}
		
		override public function begin():void
		{
			add(new Background01);
			add(new Background02);
			add(new Background03);
			add(new Background04);
			add(player = new Player);
			
			music.loop();
			
			//player.y = FP.height - FP.screen.height * 5;
		}
		
		/**
		 * Update the world.
		 */
		override public function update():void 
		{			
			// update entities
			super.update();
			
			cameraFollow();
			
			// camera following
			//if (classCount(Player) > 0)
			//{
				//trace('not finished');
				//cameraFollow();
			//}
			//else
				//trace('finished');
		}		
		
		/**
		 * Render the world.
		 */
		override public function render():void 
		{
			// render the world
			super.render();
		}				
		
		/**
		 * Makes the camera follow the player object.
		 */
		private function cameraFollow():void
		{
			// make camera follow the player
			FP.point.x = FP.camera.x - targetX;
			FP.point.y = FP.camera.y - targetY;
			var dist:Number = FP.point.length;
			if (dist > FOLLOW_TRAIL) dist = FOLLOW_TRAIL;
			FP.point.normalize(dist * FOLLOW_RATE);
			FP.camera.x = int(targetX + FP.point.x);
			FP.camera.y = int(targetY + FP.point.y);
			
			// keep camera in room bounds
			FP.camera.x = FP.clamp(FP.camera.x, 0, width - FP.width);
			FP.camera.y = FP.clamp(FP.camera.y, 0, height - FP.height);
		}
		
		/**
		 * Getter functions used to get the position to place the camera when following the player.
		 */
		private function get targetX():Number { return player.x - FP.width / 2; }
		private function get targetY():Number { return player.y - FP.height / 2 - 100; }		
		
		
		public function loadLevel(file:Class):void
		{
			// load the level xml
			var bytes:ByteArray = new file;
			level = new XML(bytes.readUTFBytes(bytes.length));

			// load level information
			width = level.width;
			height = level.height;

			// load sitters
			for each (var o:XML in level.actors.sitter)
				add(new Sitter(o.@x, o.@y));
				
			// load mixers
			for each (o in level.actors.mixer_center)
				add(new MixerCenter(o.@x, o.@y));				
			for each (o in level.actors.mixer)
				add(new Mixer(o.@x, o.@y));			
				
			// load orbiters
			for each (o in level.actors.orbiter_center)
				add(new OrbiterCenter(o.@x, o.@y));				
			for each (o in level.actors.orbiter)
				add(new Orbiter(o.@x, o.@y));		
				
			// load jumpers			
			for each (o in level.actors.jumper)
				add(new Jumper(o.@x, o.@y));
				
			// load marchers			
			for each (o in level.actors.marcher)
				add(new Marcher(o.@x, o.@y));					
		}
		
	}

}