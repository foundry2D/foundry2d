package found;

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
		Found.backbuffer = Image.createRenderTarget(Found.BUFFERWIDTH, Found.BUFFERHEIGHT);
		
    	_imageQuality = Found.smooth ? ImageScaleQuality.High:ImageScaleQuality.Low;

		found.State.setup();

		Keyboard.get().notify(onKeyPressed, onKeyReleased);
		Mouse.get().notify(onMouseDown, onMouseUp, onMouseMove, null);
		Gamepad.get().notify(onGamepadAxis, onGamepadButton);
		Surface.get().notify(onTouchDown, onTouchUp, onTouchMove);
		#if editor
		editorui = new EditorUi();
			#if kha_html5
			js.Browser.document.addEventListener("contextmenu", function(e){
				e.preventDefault();
			}, false);
			#end
		#end
	}
	@:access(found.object.Executor)
	public static function reset() {
		traitInits = [];
		traitUpdates = [];
		traitLateUpdates = [];
		traitRenders = [];
		traitRenders2D = [];
		for(exe in found.object.Executor.executors){
			var modified:Array<Any> = Reflect.field(found.object.Object,exe.field);
			modified = [];
		}
	}

	public function update(dt:Float):Void {
		if (State.active != null){
			State.active.update(dt);
			if(State.active.cam != null){
				screenOffsetX = State.active.cam.position.x;
				screenOffsetY = State.active.cam.position.y;
			}
		}
		#if editor
		editorui.update(dt);
		#end
		#if tile_editor
		frameCounter.update();
		#end
	}
	
	public function render(canvas:Canvas):Void {

		#if editor
		if(!Found.fullscreen){
			Found.backbuffer.g2.begin();

			if (Found.scenebuffer == null) Found.scenebuffer = kha.Image.createRenderTarget(Found.backbuffer.width, Found.backbuffer.height);
			Found.scenebuffer.g2.pushTransformation(FastMatrix3.translation(-screenOffsetX, -screenOffsetY));
			if(Found.renderfunc != null)
				Found.renderfunc(Found.backbuffer.g2);
			Found.backbuffer.g2.end();
			#if tile_editor
			Found.tileeditor.render(Found.backbuffer);
			frameCounter.addFrame();
			#end

		}else{
			Found.BUFFERWIDTH = Found.backbuffer.width;
			Found.BUFFERHEIGHT = Found.backbuffer.height;
		#end
			Found.backbuffer.g2.begin();
			canvas.g2.color = Found.backgroundcolor;
			canvas.g2.fillRect(0, 0, Found.backbuffer.width, Found.backbuffer.height);
			Found.backbuffer.g2.pushTransformation(FastMatrix3.translation(-screenOffsetX, -screenOffsetY));
			if (State.active != null){
				State.active.render(Found.backbuffer);
			}
			Found.backbuffer.g2.popTransformation();
			Found.backbuffer.g2.end();
			#if tile_editor
			Found.tileeditor.render(Found.backbuffer);
			frameCounter.render(Found.backbuffer);
			frameCounter.addFrame();
			#end
		#if editor }#end
		
		canvas.g2.begin();
		canvas.g2.imageScaleQuality = _imageQuality;
		Scaler.scale(Found.backbuffer, canvas, System.screenRotation);
		canvas.g2.end();
  }

	public function onKeyPressed(keyCode:KeyCode):Void {
		if (State.active != null){
			State.active.onKeyPressed(keyCode);
		}
		#if editor
		editorui.onKeyPressed(keyCode);
		#end
	}

	public function onKeyReleased(keyCode:KeyCode):Void {
		if (State.active != null){
			State.active.onKeyReleased(keyCode);
		}
		#if editor
		editorui.onKeyReleased(keyCode);
		#end
	}
	#if tile_editor
	var drawTile:Bool = false;
	#end
	public function onMouseDown(button:Int, x:Int, y:Int):Void {
		Found.mouseX = Scaler.transformX(x, y, Found.backbuffer, ScreenCanvas.the, System.screenRotation);
		Found.mouseY = Scaler.transformY(x, y, Found.backbuffer, ScreenCanvas.the, System.screenRotation);
		if (State.active != null){
			State.active.onMouseDown(button, Found.mouseX, Found.mouseY);
		}
		#if editor
		editorui.onMouseDown(button,x,y);
		#end
		#if tile_editor
		if(button == 0/* Left */){
			drawTile = true;
		}
		#end
	}

	public function onMouseUp(button:Int, x:Int, y:Int):Void {
		Found.mouseX = Scaler.transformX(x, y, Found.backbuffer, ScreenCanvas.the, System.screenRotation);
		Found.mouseY = Scaler.transformY(x, y, Found.backbuffer, ScreenCanvas.the, System.screenRotation);
		if (State.active != null){
			State.active.onMouseUp(button, Found.mouseX, Found.mouseY);
		}
		#if editor
		editorui.onMouseUp(button,x,y);
		#end
		#if tile_editor
		if(button == 0/* Left */){
			drawTile = false;
		}
		#end
	}

	public function onMouseMove(x:Int, y:Int, cx:Int, cy:Int):Void {
		Found.mouseX = Scaler.transformX(x, y, Found.backbuffer, ScreenCanvas.the, System.screenRotation);
		Found.mouseY = Scaler.transformY(x, y, Found.backbuffer, ScreenCanvas.the, System.screenRotation);
		if (State.active != null){
			State.active.onMouseMove(Found.mouseX, Found.mouseY, cx, cy);
		}
		#if editor
		editorui.onMouseMove(Found.mouseX, Found.mouseY, cx, cy);
		if(EditorUi.activeMouse){
			editorui.updateMouse(Found.mouseX, Found.mouseY, cx, cy);
		}
		#end
		#if tile_editor
		if(drawTile){
			Found.tileeditor.addTile();
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
	var ui:zui.Zui;
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
		if(canvas.g2 == null || State.active.cam == null) return;
		if(ui == null)ui = new zui.Zui({font: kha.Assets.fonts.font_default});
		var oldScale = ui.SCALE();
		var width = 60;
		var height = 20;
		if(inEditor){
			ui.setScale(2.0);
			width*=2;
			height*=2;
		}
		ui.begin(canvas.g2);
		var cam = State.active.cam.position;
		ui.t.ACCENT_COL =ui.t.WINDOW_BG_COL= kha.Color.Transparent;
		if(ui.window( zui.Id.handle(),Std.int(cam.x),Std.int(cam.y), width, height,false))ui.text('Fps: $fps');
		ui.end();
		ui.setScale(oldScale);
	}

	public inline function addFrame():Void frames++;

}