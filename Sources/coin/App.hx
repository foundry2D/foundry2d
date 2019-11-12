package coin;

import kha.Canvas;
import kha.graphics2.ImageScaleQuality;
import kha.input.KeyCode;
import kha.input.Keyboard;
import kha.input.Mouse;
import kha.input.Gamepad;
import kha.input.Surface;
import kha.Image;
import kha.math.FastMatrix3;
import kha.System;
import kha.Scaler;
import kha.ScreenCanvas;

class App {

  	private var _imageQuality:ImageScaleQuality;
	static var traitInits:Array<Void->Void> = [];
	static var traitUpdates:Array<Float->Void> = [];
	static var traitLateUpdates:Array<Void->Void> = [];
	static var traitRenders:Array<kha.graphics4.Graphics->Void> = [];
	static var traitRenders2D:Array<kha.graphics2.Graphics->Void> = [];
	var screenOffsetX(default,set) = 0.0;
	function set_screenOffsetX(value:Float){
		//Have a look here: https://github.com/Kha-Samples/Kha2D/blob/master/Sources/kha2d/Scene.hx#L181
		// if (collisionLayer != null) {
		// 	screenOffsetX = Std.int(Math.min(Math.max(0, camx - width / 2), collisionLayer.getMap().getWidth() * collisionLayer.getMap().getTileset().TILE_WIDTH - width));
		// 	if (getWidth() < width) screenOffsetX = 0;
		// }
		// else 
		screenOffsetX = value;
		return screenOffsetX;
	}
	var screenOffsetY(default,set) = 0.0;
	function set_screenOffsetY(value:Float){
		// Have a look here: https://github.com/Kha-Samples/Kha2D/blob/master/Sources/kha2d/Scene.hx#L193
		// if (collisionLayer != null) {
		// 	screenOffsetY = Std.int(Math.min(Math.max(0, camy - height / 2), collisionLayer.getMap().getHeight() * collisionLayer.getMap().getTileset().TILE_HEIGHT /*+ camyHack*/ - height));
		// 	if (getHeight() < height) screenOffsetY = 0;
		// }
		// else 
		screenOffsetY = value;
		return screenOffsetY;
	}
	public static function init(_appReady:Void->Void) {
		new App(_appReady);
	}

	public function new(_appReady:Void->Void){
		_appReady();
		Coin.backbuffer = Image.createRenderTarget(Coin.BUFFERWIDTH, Coin.BUFFERHEIGHT);
		
    	_imageQuality = Coin.smooth ? ImageScaleQuality.High:ImageScaleQuality.Low;

		coin.State.setup();

		Keyboard.get().notify(onKeyDown, onKeyUp);
		Mouse.get().notify(onMouseDown, onMouseUp, onMouseMove, null);
		Gamepad.get().notify(onGamepadAxis, onGamepadButton);
		Surface.get().notify(onTouchDown, onTouchUp, onTouchMove);
		#if editor
		Coin.uibuffer = Image.createRenderTarget(Coin.BUFFERWIDTH, Coin.BUFFERHEIGHT);
		new EditorUi();
		#end
	}

	public static function reset() {
		traitInits = [];
		traitUpdates = [];
		traitLateUpdates = [];
		traitRenders = [];
		traitRenders2D = [];
	}

	public function update(dt:Float):Void {
		if (State.active != null){
			State.active.update(dt);
			screenOffsetX = State.active.cam.x;
			screenOffsetY = State.active.cam.y;
		}
	}
	
	public function render(canvas:Canvas):Void {

		#if editor
		if(!Coin.fullscreen){
			Coin.backbuffer.g2.begin();

			if (Coin.scenebuffer == null) Coin.scenebuffer = kha.Image.createRenderTarget(Coin.backbuffer.width, Coin.backbuffer.height);
			Coin.scenebuffer.g2.pushTransformation(FastMatrix3.translation(-screenOffsetX, -screenOffsetY));
			Coin.renderfunc(Coin.backbuffer.g2);

			Coin.backbuffer.g2.end();
			
		}else{
			Coin.BUFFERWIDTH = Coin.backbuffer.width;
			Coin.BUFFERHEIGHT = Coin.backbuffer.height;
		#end
			Coin.backbuffer.g2.begin();
			canvas.g2.color = Coin.backgroundcolor;
			canvas.g2.fillRect(0, 0, Coin.backbuffer.width, Coin.backbuffer.height);
			Coin.backbuffer.g2.pushTransformation(FastMatrix3.translation(-screenOffsetX, -screenOffsetY));
			if (State.active != null){
				State.active.render(Coin.backbuffer);
			}
			Coin.backbuffer.g2.popTransformation();
			Coin.backbuffer.g2.end();
		#if editor }#end

		canvas.g2.begin();
		canvas.g2.imageScaleQuality = _imageQuality;
		Scaler.scale(Coin.backbuffer, canvas, System.screenRotation);
		canvas.g2.end();
  }

	public function onKeyDown(keyCode:KeyCode):Void {
		if (State.active != null){
			State.active.onKeyDown(keyCode);
		}
		#if editor
		if(keyCode == KeyCode.F11){
			Coin.fullscreen = !Coin.fullscreen;
		}
		#end
	}

	public function onKeyUp(keyCode:KeyCode):Void {
		if (State.active != null){
			State.active.onKeyUp(keyCode);
		}
	}

	public function onMouseDown(button:Int, x:Int, y:Int):Void {
		Coin.mouseX = Scaler.transformX(x, y, Coin.backbuffer, ScreenCanvas.the, System.screenRotation);
		Coin.mouseY = Scaler.transformY(x, y, Coin.backbuffer, ScreenCanvas.the, System.screenRotation);
		if (State.active != null){
			State.active.onMouseDown(button, Coin.mouseX, Coin.mouseY);
		}
	}

	public function onMouseUp(button:Int, x:Int, y:Int):Void {
		Coin.mouseX = Scaler.transformX(x, y, Coin.backbuffer, ScreenCanvas.the, System.screenRotation);
		Coin.mouseY = Scaler.transformY(x, y, Coin.backbuffer, ScreenCanvas.the, System.screenRotation);
		if (State.active != null){
			State.active.onMouseUp(button, Coin.mouseX, Coin.mouseY);
		}
	}

	public function onMouseMove(x:Int, y:Int, cx:Int, cy:Int):Void {
		Coin.mouseX = Scaler.transformX(x, y, Coin.backbuffer, ScreenCanvas.the, System.screenRotation);
		Coin.mouseY = Scaler.transformY(x, y, Coin.backbuffer, ScreenCanvas.the, System.screenRotation);
		if (State.active != null){
			State.active.onMouseMove(Coin.mouseX, Coin.mouseY, cx, cy);
		}
	}

	public function onTouchDown(id:Int, x:Int, y:Int):Void {
		if (State.active != null){
			State.active.onTouchDown(id, x, y);
		}
	}

	public function onTouchUp(id:Int, x:Int, y:Int):Void {
		if (State.active != null){
			State.active.onTouchUp(id, x, y);
		}
	}

	public function onTouchMove(id:Int, x:Int, y:Int):Void {
		if (State.active != null){
			State.active.onTouchMove(id, x, y);
		}
	}

	public function onGamepadAxis(axis:Int, value:Float):Void {
		if (State.active != null){
			State.active.onGamepadAxis(axis, value);
		}
	}

	public function onGamepadButton(button:Int, value:Float):Void {
		if (State.active != null){
			State.active.onGamepadButton(button, value);
		}
	}

	// Hooks
	public static function notifyOnInit(f:Void->Void) {
		for(func in traitInits){
			if(Reflect.compareMethods(func,f)) return;
		}
		traitInits.push(f);
	}

	public static function removeInit(f:Void->Void) {
		traitInits.remove(f);
	}

	public static function notifyOnUpdate(f:Float->Void) {
		for(func in traitUpdates){
			if(Reflect.compareMethods(func,f)) return;
		}
		traitUpdates.push(f);
	}

	public static function removeUpdate(f:Float->Void) {
		traitUpdates.remove(f);
	}
	
	public static function notifyOnLateUpdate(f:Void->Void) {
		for(func in traitLateUpdates){
			if(Reflect.compareMethods(func,f)) return;
		}
		traitLateUpdates.push(f);
	}

	public static function removeLateUpdate(f:Void->Void) {
		traitLateUpdates.remove(f);
	}

	public static function notifyOnRender(f:kha.graphics4.Graphics->Void) {
		for(func in traitRenders){
			if(Reflect.compareMethods(func,f)) return;
		}
		traitRenders.push(f);
	}

	public static function removeRender(f:kha.graphics4.Graphics->Void) {
		traitRenders.remove(f);
	}

	public static function notifyOnRender2D(f:kha.graphics2.Graphics->Void) {
		for(func in traitRenders2D){
			if(Reflect.compareMethods(func,f)) return;
		}
		traitRenders2D.push(f);
	}

	public static function removeRender2D(f:kha.graphics2.Graphics->Void) {
		traitRenders2D.remove(f);
	}

	// public static function notifyOnReset(f:Void->Void) {
	// 	if (onResets == null) onResets = [];
	// 	onResets.push(f);
	// }

	// public static function removeReset(f:Void->Void) {
	// 	onResets.remove(f);
	// }

	// public static function notifyOnEndFrame(f:Void->Void) {
	// 	if (onEndFrames == null) onEndFrames = [];
	// 	onEndFrames.push(f);
	// }

	// public static function removeEndFrame(f:Void->Void) {
	// 	onEndFrames.remove(f);
	// }
}