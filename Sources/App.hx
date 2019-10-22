package ;

import kha.Canvas;
import kha.graphics2.ImageScaleQuality;
import kha.input.KeyCode;
import kha.input.Keyboard;
import kha.input.Mouse;
import kha.input.Gamepad;
import kha.input.Surface;
import kha.Image;
import kha.System;
import kha.Scaler;
import kha.ScreenCanvas;

import State;

class App {
  private var _imageQuality:ImageScaleQuality;

	public function new(){
		Coin.backbuffer = Image.createRenderTarget(Coin.BUFFERWIDTH, Coin.BUFFERHEIGHT);

    _imageQuality = Coin.smooth ? ImageScaleQuality.High:ImageScaleQuality.Low;

		State.setup();

		Keyboard.get().notify(onKeyDown, onKeyUp);
		Mouse.get().notify(onMouseDown, onMouseUp, onMouseMove, null);
		Gamepad.get().notify(onGamepadAxis, onGamepadButton);
		Surface.get().notify(onTouchDown, onTouchUp, onTouchMove);
	}

	public function update():Void {
		if (State.activeState != null){
			State.activeState.update();
		}
	}

	public function render(canvas:Canvas):Void {
		Coin.backbuffer.g2.begin();
    canvas.g2.color = Coin.backgroundcolor;
    canvas.g2.fillRect(0, 0, Coin.backbuffer.width, Coin.backbuffer.height);
		if (State.activeState != null){
			State.activeState.render(Coin.backbuffer);
		}
		Coin.backbuffer.g2.end();

		canvas.g2.begin();
    canvas.g2.imageScaleQuality = _imageQuality;
		Scaler.scale(Coin.backbuffer, canvas, System.screenRotation);
		canvas.g2.end();
  }

	public function onKeyDown(keyCode:KeyCode):Void {
		if (State.activeState != null){
			State.activeState.onKeyDown(keyCode);
		}
	}

	public function onKeyUp(keyCode:KeyCode):Void {
		if (State.activeState != null){
			State.activeState.onKeyUp(keyCode);
		}
	}

	public function onMouseDown(button:Int, x:Int, y:Int):Void {
		Coin.mouseX = Scaler.transformX(x, y, Coin.backbuffer, ScreenCanvas.the, System.screenRotation);
		Coin.mouseY = Scaler.transformY(x, y, Coin.backbuffer, ScreenCanvas.the, System.screenRotation);
		if (State.activeState != null){
			State.activeState.onMouseDown(button, Coin.mouseX, Coin.mouseY);
		}
	}

	public function onMouseUp(button:Int, x:Int, y:Int):Void {
		Coin.mouseX = Scaler.transformX(x, y, Coin.backbuffer, ScreenCanvas.the, System.screenRotation);
		Coin.mouseY = Scaler.transformY(x, y, Coin.backbuffer, ScreenCanvas.the, System.screenRotation);
		if (State.activeState != null){
			State.activeState.onMouseUp(button, Coin.mouseX, Coin.mouseY);
		}
	}

	public function onMouseMove(x:Int, y:Int, cx:Int, cy:Int):Void {
		Coin.mouseX = Scaler.transformX(x, y, Coin.backbuffer, ScreenCanvas.the, System.screenRotation);
		Coin.mouseY = Scaler.transformY(x, y, Coin.backbuffer, ScreenCanvas.the, System.screenRotation);
		if (State.activeState != null){
			State.activeState.onMouseMove(Coin.mouseX, Coin.mouseY, cx, cy);
		}
	}

	public function onTouchDown(id:Int, x:Int, y:Int):Void {
		if (State.activeState != null){
			State.activeState.onTouchDown(id, x, y);
		}
	}

	public function onTouchUp(id:Int, x:Int, y:Int):Void {
		if (State.activeState != null){
			State.activeState.onTouchUp(id, x, y);
		}
	}

	public function onTouchMove(id:Int, x:Int, y:Int):Void {
		if (State.activeState != null){
			State.activeState.onTouchMove(id, x, y);
		}
	}

	public function onGamepadAxis(axis:Int, value:Float):Void {
		if (State.activeState != null){
			State.activeState.onGamepadAxis(axis, value);
		}
	}

	public function onGamepadButton(button:Int, value:Float):Void {
		if (State.activeState != null){
			State.activeState.onGamepadButton(button, value);
		}
	}
}