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

	public function onKeyDown(keyCode:KeyCode){}

	public function onKeyUp(keyCode:KeyCode){}

	public function onMouseDown(button:Int, x:Int, y:Int){}

	public function onMouseUp(button:Int, x:Int, y:Int){}

	public function onMouseMove(x:Int, y:Int, cx:Int, cy:Int){}

	public function onTouchDown(id:Int, x:Int, y:Int){}

	public function onTouchUp(id:Int, x:Int, y:Int){}

	public function onTouchMove(id:Int, x:Int, y:Int){}

	public function onGamepadAxis(axis:Int, value:Float){}

	public function onGamepadButton(button:Int, value:Float){}

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