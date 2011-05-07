package game 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.tweens.misc.ColorTween;
	import net.flashpunk.tweens.misc.Alarm;
	import net.flashpunk.FP;

	public class ManyReportText extends Entity
	{
		
		[Embed(source='../../assets/gfx/many_report_text.png')] private const TEXT:Class;
		public var image:Image = new Image(TEXT);			
		
		/**
		 * Fade in
		 */
		public const FADE_IN_DURATION:Number = 4;	
		public var fadeAlarm:Alarm = new Alarm(4, fadeIn); // Time until fade starts
		public var fadeTween:ColorTween = new ColorTween(nextText);
		
		public function ManyReportText() 
		{
			image.alpha = 0;
			fadeTween.alpha = 0;
			graphic = image;
			x = 0;
			y = 195;
			addTween(fadeAlarm, true);
		}
		
		override public function update():void
		{
			super.update();
			(graphic as Image).alpha = fadeTween.alpha;
			//text.alpha = fadeTween.alpha;
		}		
		
		public function fadeIn():void
		{
			addTween(fadeTween, true);		
			fadeTween.tween(FADE_IN_DURATION, Colors.WHITE, Colors.WHITE, 0, 1);				
		}
		
		public function nextText():void
		{
			FP.world.add(new ThisNotgameText);
		}		
		
	}

}