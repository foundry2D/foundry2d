package found;

import found.object.Object;

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
