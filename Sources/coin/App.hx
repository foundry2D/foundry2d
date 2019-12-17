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
	#if editor
	public static var editorui:EditorUi = null;
	#end
	#if tile_editor
	public static var frameCounter:FPS = new FPS();
	#end
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
		editorui = new EditorUi();
		#end
	}
	@:access(coin.object.Executor)
	public static function reset() {
		traitInits = [];
		traitUpdates = [];
		traitLateUpdates = [];
		traitRenders = [];
		traitRenders2D = [];
		for(exe in coin.object.Executor.executors){
			var modified:Array<Any> = Reflect.field(coin.object.Object,exe.field);
			modified = [];
		}
	}

	public function update(dt:Float):Void {
		if (State.active != null){
			State.active.update(dt);
			screenOffsetX = State.active.cam.x;
			screenOffsetY = State.active.cam.y;
		}
		#if tile_editor
		frameCounter.update();
		#end
	}
	
	public function render(canvas:Canvas):Void {

		#if editor
		if(!Coin.fullscreen){
			Coin.backbuffer.g2.begin();

			if (Coin.scenebuffer == null) Coin.scenebuffer = kha.Image.createRenderTarget(Coin.backbuffer.width, Coin.backbuffer.height);
			Coin.scenebuffer.g2.pushTransformation(FastMatrix3.translation(-screenOffsetX, -screenOffsetY));
			Coin.renderfunc(Coin.backbuffer.g2);
			Coin.backbuffer.g2.end();
			#if tile_editor
			Coin.tileeditor.render(Coin.backbuffer);
			frameCounter.addFrame();
			#end

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
			#if tile_editor
			Coin.tileeditor.render(Coin.backbuffer);
			frameCounter.render(Coin.backbuffer);
			frameCounter.addFrame();
			#end
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
		if(keyCode == KeyCode.F1){
			EditorUi.arrowMode = 0;
		}
		if(keyCode == KeyCode.F2){
			EditorUi.arrowMode = 1;
		}
		if(keyCode == KeyCode.S && editorui.keys.ctrl)
			editorui.saveSceneData();
		if(keyCode == KeyCode.Control)
			editorui.keys.ctrl = true;
		if(keyCode == KeyCode.Alt)
			editorui.keys.alt = true;
		if(keyCode == KeyCode.Shift)
			editorui.keys.shift = true;
		#end
	}

	public function onKeyUp(keyCode:KeyCode):Void {
		if (State.active != null){
			State.active.onKeyUp(keyCode);
		}
		#if editor
		if(keyCode == KeyCode.Control)
			editorui.keys.ctrl = false;
		if(keyCode == KeyCode.Alt)
			editorui.keys.alt = false;
		if(keyCode == KeyCode.Shift)
			editorui.keys.shift = false;
		#end
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
		#if editor
		if(EditorUi.activeMouse && button == 0/* Left */){
			EditorUi.activeMouse = false;
		}
		#end
	}

	public function onMouseMove(x:Int, y:Int, cx:Int, cy:Int):Void {
		Coin.mouseX = Scaler.transformX(x, y, Coin.backbuffer, ScreenCanvas.the, System.screenRotation);
		Coin.mouseY = Scaler.transformY(x, y, Coin.backbuffer, ScreenCanvas.the, System.screenRotation);
		if (State.active != null){
			State.active.onMouseMove(Coin.mouseX, Coin.mouseY, cx, cy);
		}
		#if editor
		if(EditorUi.activeMouse){
			editorui.updateMouse(Coin.mouseX, Coin.mouseY, cx, cy);
		}
		#end
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

private class FPS {

	public var fps(default, null) = 0;
	var frames = 0;
	var time = 0.0;
	var lastTime = 0.0;
	var ui:coin.zui.Zui;
	public function new() {	}

	public function update():Int {
		var deltaTime = kha.Scheduler.realTime() - lastTime;
		lastTime = kha.Scheduler.realTime();
		time += deltaTime;

		if (time >= 1) {
			fps = frames;
			frames = 0;
			time = 0;
		}
		return fps;
	}
	
	public function render(canvas:kha.Canvas,inEditor = true): Void {
		if(canvas.g2 == null) return;
		if(ui == null)ui = new coin.zui.Zui({font: kha.Assets.fonts.font_default});
		var oldScale = ui.SCALE();
		var width = 60;
		var height = 20;
		if(inEditor){
			ui.setScale(2.0);
			width*=2;
			height*=2;
		}
		ui.begin(canvas.g2);
		if(ui.window( coin.zui.Id.handle(),0,0, width, height,false,0x00000000))ui.text('Fps: $fps');
		ui.end();
		ui.setScale(oldScale);
	}

	public inline function addFrame():Void frames++;

}