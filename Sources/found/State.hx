package found;

import kha.Assets;
import found.data.SceneFormat;
import found.data.Data;

class State extends Scene {
	public static var active:State;
	private static var loadingState:State;
	private static var _states:Map<String, String>;

	public function new(raw:TSceneFormat){
		super(raw);
		
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
		if(_states == null)State.setup();
		_states.set(name, state);
		return state;
	}

	public static function removeState(name:String){
		_states.remove(name);
	}
	
	static var lastState:State;
	public static function set(name:String,onDone:Void->Void=null){
		Scene.ready = false;
		var file = _states.get(name);
		lastState = active;
		active = loadingState;
		var loaded = onDone == null ? loadState : function(raw:TSceneFormat){
			loadState(raw);
			onDone();
		};
		#if debug
		if(file == null){
			active = lastState;
			error('State with name $name does not exist in State list. Use AddState to add it.');
		}
		#end
		Data.getSceneRaw(file,loaded);
		
		
	}
	private static function loadState(raw:TSceneFormat){
		App.reset();
		//@TODO: Evaluate if we need a dispose function for the Scene class to dispose the last created Scene ?
		if(lastState != null && lastState.physics_world != null){
			lastState.physicsUpdate = null;
			lastState.physics_world.dispose();
		}
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