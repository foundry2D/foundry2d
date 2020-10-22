package found;

import found.object.Object;

enum abstract PropertyType(Int) from Int to Int
{
	var int;
	var bool;
	var float;
	var string;
	var vector2i;
	var vector2b;
	var vector2;
}
#if editor
@:autoBuild(ListTraits.build())
#end
@:keepSub 
class Trait {

	public var name:String = "";
	/**
	 * Object this trait belongs to.
	 */
	public var object:Object;

	static var props:Map<String,Array<String>> = new Map<String,Array<String>>();

	public static function hasTrait(classname:String) {
		return props.exists(classname);
	}
	public static function getProps(classname:String):Array<String> {
		if(props.exists(classname)){
			var temp:Array<String> = props.get(classname);
			var out:Array<String> = [];
			if(Std.isOfType(temp,Array)){
				return out.concat(temp);
			}
			else{
				for(f in Reflect.fields(temp)){
					out.push(Reflect.field(temp,f));
				}
				return out;
			}
		}
		else {
			return [];	
		}
	}
	public static function addProps(classname:String,props:Array<String>){
		if(Trait.props.exists(classname)){
			Trait.props.set(classname,Trait.getProps(classname).concat(props));
		}
		else {
			Trait.props.set(classname,Reflect.copy(props));
		}
	}
	public static function removeProps(classname:String,props:Array<String>){
		if(Trait.props.exists(classname)){
			for(p in props){
				Trait.props.get(classname).remove(p);
			}
		}
	}

	var _add:Array<Void->Void> = null;
	var _awake:Array<Void->Void> = null;
	var _init:Array<Void->Void> = null;
	var _remove:Array<Void->Void> = null;
	var _update:Array<Float->Void> = null;
	var _lateUpdate:Array<Void->Void> = null;
	var _render:Array<kha.graphics4.Graphics->Void> = null;
	var _render2D:Array<kha.graphics2.Graphics->Void> = null;
	
	public function new() {}

	public function remove() {
		object.removeTrait(this);
	}

	public function notifyOnAdd(f:Void->Void) {
		if (_add == null) _add = [];
		_add.push(f);
	}

	public function notifyOnAwake(f:Void->Void) {
		if (_awake == null) _awake = [];
		_awake.push(f);
	}

	public function notifyOnInit(f:Void->Void) {
		if (_init == null) _init = [];
		_init.push(f);		
	}

	public function notifyOnRemove(f:Void->Void) {
		if (_remove == null) _remove = [];
		_remove.push(f);
	}

	public function notifyOnUpdate(f:Float->Void) {
		if (_update == null) _update = [];
		_update.push(f);
	}

	public function removeUpdate(f:Float->Void) {
		_update.remove(f);
	}
	
	public function notifyOnLateUpdate(f:Void->Void) {
		if (_lateUpdate == null) _lateUpdate = [];
		_lateUpdate.push(f);
	}

	public function removeLateUpdate(f:Void->Void) {
		_lateUpdate.remove(f);
	}

	public function notifyOnRender(f:kha.graphics4.Graphics->Void) {
		if (_render == null) _render = [];
		_render.push(f);
	}

	public function removeRender(f:kha.graphics4.Graphics->Void) {
		_render.remove(f);
	}

	public function notifyOnRender2D(f:kha.graphics2.Graphics->Void) {
		if (_render2D == null) _render2D = [];
		_render2D.push(f);
	}

	public function removeRender2D(f:kha.graphics2.Graphics->Void) {
		_render2D.remove(f);
	}
}
