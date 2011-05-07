﻿package net.flashpunk
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Input;
	
	/**
	 * Main game Sprite class, added to the Flash Stage. Manages the game loop.
	 */
	public class Engine extends MovieClip
	{
		/**
		 * If the game should stop updating/rendering.
		 */
		public var paused:Boolean = false;
		
		/**
		 * Constructor. Defines startup information about your game.
		 * @param	width			The width of your game.
		 * @param	height			The height of your game.
		 * @param	frameRate		The game framerate, in frames per second.
		 * @param	fixed			If a fixed-framerate should be used.
		 */
		public function Engine(width:uint, height:uint, frameRate:Number = 60, fixed:Boolean = false) 
		{
			// global game properties
			FP.width = width;
			FP.height = height;
			FP.assignedFrameRate = frameRate;
			FP.fixed = fixed;
			
			// global game objects
			FP.engine = this;
			FP.screen = new Screen;
			FP.bounds = new Rectangle(0, 0, width, height);
			FP._world = new World;
			
			// miscellanious startup stuff
			if (FP.randomSeed == 0) FP.randomizeSeed();
			FP.entity = new Entity;
			FP._time = getTimer();
			
			// on-stage event listener
			addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		/**
		 * Override this, called after Engine has been added to the stage.
		 */
		public function init():void
		{
			
		}
		
		/**
		 * Updates the game, updating the World and Entities.
		 */
		public function update():void
		{
			if (FP._world.active)
			{
				if (FP._world._tween) FP._world.updateTweens();
				FP._world.update();
			}
			FP._world.updateLists();
			if (FP._goto) checkWorld();
		}
		
		/**
		 * Renders the game, rendering the World and Entities.
		 */
		public function render():void
		{
			// timing stuff
			var t:Number = getTimer();
			if (!_frameLast) _frameLast = t;
			
			// render loop
			FP.screen.swap();
			Draw.resetTarget();
			FP.screen.refresh();
			if (FP._world.visible) FP._world.render();
			FP.screen.redraw();
			
			// more timing stuff
			t = getTimer();
			_frameListSum += (_frameList[_frameList.length] = t - _frameLast);
			if (_frameList.length > 10) _frameListSum -= _frameList.shift();
			FP.frameRate = 1000 / (_frameListSum / _frameList.length);
			_frameLast = t;
		}
		
		/**
		 * Sets the game's stage properties. Override this to set them differently.
		 */
		public function setStageProperties():void
		{
			stage.frameRate = FP.assignedFrameRate;
			stage.align = StageAlign.TOP_LEFT;
			stage.quality = StageQuality.HIGH;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.displayState = StageDisplayState.NORMAL;
		}
		
		/** @private Event handler for stage entry. */
		private function onStage(e:Event = null):void
		{
			// remove event listener
			removeEventListener(Event.ADDED_TO_STAGE, onStage);
			
			// set stage properties
			FP.stage = stage;
			setStageProperties();
			
			// enable input
			Input.enable();
			
			// switch worlds
			if (FP._goto) checkWorld();
			
			// game start
			init();
			
			// start game loop
			_rate = 1000 / FP.assignedFrameRate;
			if (FP.fixed)
			{
				// fixed framerate
				_skip = _rate * MAX_FRAMESKIP;
				_last = _prev = getTimer();
				_timer = new Timer(TICK_RATE);
				_timer.addEventListener(TimerEvent.TIMER, onTimer);
				_timer.start();
			}
			else
			{
				// nonfixed framerate
				_last = getTimer();
				addEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}
		
		/** @private Framerate independent game loop. */
		private function onEnterFrame(e:Event):void
		{
			// update timer
			_time = _gameTime = getTimer();
			FP._flashTime = _time - _flashTime;
			_updateTime = _time;
			FP.elapsed = (_time - _last) / 1000;
			if (FP.elapsed > MAX_ELAPSED) FP.elapsed = MAX_ELAPSED;
			FP.elapsed *= FP.rate;
			_last = _time;
			
			// update console
			if (FP._console) FP._console.update();
			
			// update loop
			if (!paused) update();
			
			// update input
			Input.update();
			
			// update timer
			_time = _renderTime = getTimer();
			FP._updateTime = _time - _updateTime;
			
			// render loop
			if (!paused) render();
			
			// update timer
			_time = _flashTime = getTimer();
			FP._renderTime = _time - _renderTime;
			FP._gameTime = _time - _gameTime;
		}
		
		/** @private Fixed framerate game loop. */
		private function onTimer(e:TimerEvent):void
		{
			// update timer
			_time = getTimer();
			_delta += (_time - _last);
			_last = _time;
			
			// quit if a frame hasn't passed
			if (_delta < _rate) return;
			
			// update timer
			_gameTime = _time;
			FP._flashTime = _time - _flashTime;
			
			// update console
			if (FP._console) FP._console.update();
			
			// update loop
			if (_delta > _skip) _delta = _skip;
			while (_delta > _rate)
			{
				// update timer
				_updateTime = _time;
				_delta -= _rate;
				FP.elapsed = (_time - _prev) / 1000;
				if (FP.elapsed > MAX_ELAPSED) FP.elapsed = MAX_ELAPSED;
				FP.elapsed *= FP.rate;
				_prev = _time;
				
				// update loop
				if (!paused) update();
				
				// update input
				Input.update();
				
				// update timer
				_time = getTimer();
				FP._updateTime = _time - _updateTime;
			}
			
			// update timer
			_renderTime = _time;
			
			// render loop
			if (!paused) render();
			
			// update timer
			_time = _flashTime = getTimer();
			FP._renderTime = _time - _renderTime;
			FP._gameTime =  _time - _gameTime;
		}
		
		/** @private Switch Worlds if they've changed. */
		private function checkWorld():void
		{
			if (!FP._goto) return;
			FP._world.end();
			FP._world.updateLists();
			if (FP._world && FP._world.autoClear && FP._world._tween) FP._world.clearTweens();
			FP._world = FP._goto;
			FP._goto = null;
			FP.camera = FP._world.camera;
			FP._world.updateLists();
			FP._world.begin();
			FP._world.updateLists();
		}
		
		// Timing information.
		/** @private */ private var _delta:Number = 0;
		/** @private */ private var _time:Number;
		/** @private */ private var _last:Number;
		/** @private */ private var _timer:Timer;
		/** @private */ private var	_rate:Number;
		/** @private */ private var	_skip:Number;
		/** @private */ private var _prev:Number;
		
		// Debug timing information.
		/** @private */ private var _updateTime:uint;
		/** @private */ private var _renderTime:uint;
		/** @private */ private var _gameTime:uint;
		/** @private */ private var _flashTime:uint;
		
		// Game constants.
		/** @private */ private const MAX_ELAPSED:Number = 0.0333;
		/** @private */ private const MAX_FRAMESKIP:Number = 5;
		/** @private */ private const TICK_RATE:uint = 4;
		
		// FrameRate tracking.
		/** @private */ private var _frameLast:uint = 0;
		/** @private */ private var _frameListSum:uint = 0;
		/** @private */ private var _frameList:Vector.<uint> = new Vector.<uint>;
	}
}