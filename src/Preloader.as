package 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.text.Font;
	import flash.utils.getDefinitionByName;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	import flash.events.MouseEvent;
	
	[SWF(width = "600", height = "450")]
	
	/**
	 * ...
	 * @author Noel Berry
	 */	
	public class Preloader extends MovieClip 
	{
		private const CLICK_TO_CONTINUE:Boolean = true;
		
		private var square:Sprite = new Sprite();
		private var border:Sprite = new Sprite();
		private var size:Number = 256;
		private var text:TextField = new TextField();

		private var txtColor:uint = 0xFFFFFF;
		private var loaderColor:uint = 0xD8D8D8;
		
		// Backdrop
		[Embed(source='../assets/gfx/loading_background.png')] static private var imgBackground:Class;
		private var backdrop:Bitmap = new imgBackground;			
		
		// Click to continue
		[Embed(source='../assets/gfx/click_to_continue.png')] static private var imgClick:Class;
		private var clickSprite:Bitmap = new imgClick;	
		
		public function Preloader() 
		{					
			// background
			addChild(backdrop);			
			
			addEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			// show loader
			addChild(square);
			square.x = (stage.stageWidth / 2) -((size-8)/2);
			square.y = stage.stageHeight / 2 + 40;
			
			addChild(border);
			border.x = (stage.stageWidth / 2) - (size/2);
			border.y = stage.stageHeight / 2 - 4 + 40;
		
			addChild(text);
			text.x = (stage.stageWidth / 2) - (size/2);
			text.y = stage.stageHeight / 2 - 30 + 40;
	
		}
		
		private function progress(e:ProgressEvent):void 
		{
			// update loader
			square.graphics.beginFill(loaderColor);
			square.graphics.drawRect(0,0,(loaderInfo.bytesLoaded / loaderInfo.bytesTotal) * (size-8),20);
			square.graphics.endFill();
			
			border.graphics.lineStyle(2, loaderColor);
			border.graphics.drawRect(0, 0, size, 28);
			
			text.textColor = txtColor;
			text.text = "Loading: " + Math.ceil((loaderInfo.bytesLoaded/loaderInfo.bytesTotal)*100) + "%";
			
		}
		
		private function checkFrame(e:Event):void 
		{
			//if we're done, run the startup function, remove event listener
			if (currentFrame == totalFrames) 
			{
				removeEventListener(Event.ENTER_FRAME, checkFrame);
				loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
				if (CLICK_TO_CONTINUE)
				{
					addChild(clickSprite);
					clickSprite.x = (stage.stageWidth / 2) - clickSprite.width / 2;
					clickSprite.y = 360;
					stage.addEventListener(MouseEvent.CLICK, clickStartup);
				}
				else
					startup();
			}
		}
		
		private function clickStartup(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.CLICK, clickStartup);
			startup();
		}
		
		private function startup():void 
		{	
			// hide loader
			stop();
			
			//remove all the children
			var i:int = numChildren;
			while (i --) removeChildAt(i)				
			
			//go to the main class
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			var mainClass:Class = getDefinitionByName("Main") as Class;
			addChild(new mainClass as DisplayObject);
		}
		
	}
	
}