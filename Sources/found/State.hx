package found;

import kha.Assets;
import found.data.SceneFormat;
import found.data.Data;
import kha.Canvas;
import kha.input.KeyCode;

class State extends Scene {
	public static var active:State;
	private static var loadingState:State;
	private static var _states:Map<String, String>;

	public function new(raw:TSceneFormat){
		super(raw);
		
	}

	override public function update(dt:Float){
		super.update(dt);
	}

	override public function render(canvas:Canvas){
		super.render(canvas);
	}

	var keyDown:Array<KeyCode->Void> =[];
	public function notifyOnKeyDown(fn:KeyCode->Void) {
		keyDown.push(fn);
	}
	public function removeOnKeyDown(fn:KeyCode->Void){
		keyDown.remove(fn);
	}
	public function onKeyDown(keyCode:KeyCode){
		for(fn in keyDown){
			fn(keyCode);
		}
	}


	var keyUp:Array<KeyCode->Void> =[];
	public function notifyOnKeyUp(fn:KeyCode->Void) {
		keyUp.push(fn);
	}
	public function removeOnKeyUp(fn:KeyCode->Void){
		keyUp.remove(fn);
	}
	public function onKeyUp(keyCode:KeyCode){
		for(fn in keyUp){
			fn(keyCode);
		}
	}

	var mouseDown:Array<(Int,Int,Int)->Void> =[];
	public function notifyOnMouseDown(fn:(Int,Int,Int)->Void) {
		mouseDown.push(fn);
	}
	public function removeOnMouseDown(fn:(Int,Int,Int)->Void){
		mouseDown.remove(fn);
	}
	public function onMouseDown(button:Int, x:Int, y:Int){
		for(fn in mouseDown){
			fn(button, x, y);
		}
	}

	var mouseUp:Array<(Int,Int,Int)->Void> =[];
	public function notifyOnMouseUp(fn:(Int,Int,Int)->Void) {
		mouseUp.push(fn);
	}
	public function removeOnMouseUp(fn:(Int,Int,Int)->Void){
		mouseUp.remove(fn);
	}
	public function onMouseUp(button:Int, x:Int, y:Int){
		for(fn in mouseUp){
			fn(button, x, y);
		}
	}

	var mouseMove:Array<(Int,Int,Int,Int)->Void> =[];
	public function notifyOnMouseMove(fn:(Int,Int,Int,Int)->Void) {
		mouseMove.push(fn);
	}
	public function removeOnMouseMove(fn:(Int,Int,Int,Int)->Void){
		mouseMove.remove(fn);
	}
	public function onMouseMove(x:Int, y:Int, cx:Int, cy:Int){
		for(fn in mouseMove){
			fn(x, y, cx, cy);
		}
	}

	var touchDown:Array<(Int,Int,Int)->Void> =[];
	public function notifyOnTouchDown(fn:(Int,Int,Int)->Void) {
		touchDown.push(fn);
	}
	public function onTouchDown(id:Int, x:Int, y:Int){
		for(fn in touchDown){
			fn(id, x, y);
		}
	}

	var touchUp:Array<(Int,Int,Int)->Void> =[];
	public function notifyOnTouchUp(fn:(Int,Int,Int)->Void) {
		touchUp.push(fn);
	}
	public function onTouchUp(id:Int, x:Int, y:Int){
		for(fn in touchUp){
			fn(id, x, y);
		}
	}

	var touchMove:Array<(Int,Int,Int)->Void> =[];
	public function notifyOnTouchMove(fn:(Int,Int,Int)->Void) {
		touchMove.push(fn);
	}
	public function onTouchMove(id:Int, x:Int, y:Int){
		for(fn in touchMove){
			fn(id, x, y);
		}
	}

	var gamepadAxis:Array<(Int,Float)->Void> =[];
	public function notifyOnGamepadAxis(fn:(Int,Float)->Void) {
		gamepadAxis.push(fn);
	}
	public function onGamepadAxis(axis:Int, value:Float){
		for(fn in gamepadAxis){
			fn(axis, value);
		}
	}

	var gamepadButton:Array<(Int,Float)->Void> =[];
	public function notifyOnGamepadButton(fn:(Int,Float)->Void) {
		gamepadButton.push(fn);
	}
	public function onGamepadButton(button:Int, value:Float){
		for(fn in gamepadButton){
			fn(button, value);
		}
	}

	public static function setup(?loadingPath:String = ""){
		_states = new Map<String, String>();
		if(loadingPath != ""){
			Data.getSceneRaw(loadingPath, function(raw:TSceneFormat){
				loadingState = new State(raw);
			});
		}else {
			var b:kha.Blob = Reflect.field(Assets.blobs, "loading_json");
			loadingState = new State(haxe.Json.parse(b.toString()));
		}
	}

	public static function addState(name:String, state:String):String {
		_states.set(name, state);
		return state;
	}

	public static function removeState(name:String){
		_states.remove(name);
	}

	public static function set(name:String,onDone:Void->Void=null){
		Scene.ready = false;
		var file = _states.get(name);
		active = loadingState;
		var loaded = onDone == null ? loadState : function(raw:TSceneFormat){
			loadState(raw);
			onDone();
		};
		Data.getSceneRaw(file,loaded);
		
		
	}
	private static function loadState(raw:TSceneFormat){
		active = new State(raw);
	}
	// Hooks
	public function notifyOnInit(f:Void->Void) {
		if (Scene.ready) f(); // Scene already running
		else traitInits.push(f);
	}

	public function removeInit(f:Void->Void) {
		traitInits.remove(f);
	}

	public function notifyOnRemove(f:Void->Void) {
		traitRemoves.push(f);
	}
}