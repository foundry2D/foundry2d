package coin.object;

import kha.Canvas;
import kha.math.Vector2;
import coin.data.SceneFormat;

#if js
typedef MoveData ={
#else
@:structInit class MoveData{
#end
	public var _positions:Vector2;
	@:optional public var dt:Float;
	@:optional public var collider:Float;
} 
#if js
typedef RotateData ={
#else
@:structInit class RotateData{
#end
	public var _rotations:Float;
	@:optional public var dt:Float;
	@:optional public var from:Vector2;
	@:optional public var towards:Vector2;
}

class Object {
	#if debug
	public var name:String;
	#end
	#if editor
	public var dataChanged:Bool = false;
	public var raw(default,set):TObj = null;
	@:access(coin.Scene)
	function set_raw(data:TObj){
		if(!Scene.ready)return this.raw = data;

		refreshObjectData(data);
		this.raw = data;
		dataChanged = true;
		return this.raw;
	}
	@:access(coin.Scene)
	function refreshObjectData(data:TObj){
		for(f in Reflect.fields(data)){
			switch(f){
				case "traits":
					var trts:Array<TTrait> = Reflect.getProperty(data,f);
					if(traits.length == trts.length)continue;
					Scene.createTraits(trts.splice(traits.length+1,trts.length-traits.length),this);
				case "position":
				 	_positions[uid] = Reflect.getProperty(data,f);
				case "rotation":
					_rotations[uid] = Reflect.getProperty(data,f);
				case "scale":
					_scales[uid] = Reflect.getProperty(data,f);
				default:
					Reflect.setProperty(this,f,Reflect.getProperty(data,f));
			}
		}
	}
	#else
	public var raw:TObj = null;
	#end
	static var uidCounter = 0;
	public var uid:Int;
	public var active(default, set):Bool = true;

	static var _positions:Array<Vector2> = [];
	static var _translations:Executor<MoveData> = null;
	public var position(get,never):Vector2;
	function get_position() {
		return _positions[uid];
	}
	/**
	 * Add a translation function to be executed in another thread. 
	 *
	 * @param	func The function to be executed in the other thread.
	 * @param	dt The delta time to be used; defaults to 1.0.
	 */
	public function translate(func:MoveData->MoveData, ?dt:Float = 1.0){
		_translations.add(
		func,
		{_positions:new Vector2(_positions[uid].x,_positions[uid].y),dt: dt}
		,uid);
	}

	public var rotation(get,never):Float;
	function get_rotation(){
		return _rotations[uid];
	}
	static var _rotations:Array<Float> = [];
	static var _rotates:Executor<RotateData> = null;
	public function rotate(func:RotateData->RotateData, ?dt:Float = 1.0, ?from:Vector2,?towards:Vector2){
		_rotates.add(func,{_rotations: _rotations[uid],dt: dt,from: from,towards: towards},uid);
	}

	public var scale(get,never):Vector2;
	function get_scale(){
		return _scales[uid];
	}
	static var _scales:Array<Vector2> = [];
	static var _scaler:Executor<Vector2> = null;
	public function resize(func:Vector2->Vector2,?dt:Float = 1.0) {
		_scaler.add(func,_scales[uid],uid);
	}

	private var _width:Float =0.0;
	public var width(get,set):Float;
	function get_width(){
		return _width*scale.x;
	}
	function set_width(f:Float){
		_width = f;
		// if(center != null)
		// 	center.x = _width*0.5;
		return _width;
	}
	public var height(get,set):Float;
	private var _height:Float =0.0;
	function get_height(){
		return _height*scale.y;
	}
	function set_height(f:Float){
		_height = f;
		// if(center != null)
		// 	center.y = _height*0.5;
		return _height;
	}
	public var center:Vector2;
	public var velocity:Vector2 = new Vector2();
	// public var speed = 3.0;
	// public var acceleration = 0.3;
	// public var friction = 3.6;

	public var depth:Float;

	var traits:Array<Trait> = [];

	public function new(?x:Float, ?y:Float, ?width:Float, ?height:Float){
		if(_translations == null) _translations = new Executor<MoveData>("_positions");
		if(_rotates == null) _rotates = new Executor<RotateData>("_rotations");
		if(_scaler == null) _scaler = new Executor<Vector2>("_scales");
		
		uid = uidCounter++;

		_positions.push(new Vector2(x, y));
		_rotations.push(0.0);
		_scales.push(new Vector2(1.0,1.0));

		this.width = width;
		this.height = height;
		
		
		
		

		center = new Vector2(width / 2, height / 2);
		if(depth == null)
			depth = position.y + height;


		activate(x, y);
	}

	public function update(dt:Float){
		if (!active || !Scene.ready) return;

		if(!Scene.zsort)
			depth = position.y + height;

		center.x = width / 2;
		center.y = height / 2;

	}

	public function render(canvas:Canvas){
		if (!active || !Scene.ready) return;
	}

	public function activate(?x:Float, ?y:Float){
		active = true;
	}

	public function deactivate(){
		active = false;
	}
	@:access(coin.Trait,coin.App)
	function set_active(value:Bool):Bool {
		if(value && active != value){
			trace("Before add traits"+App.traitUpdates.length);
			for(t in traits){
				if (t._init != null) {
					for (f in t._init) App.notifyOnInit(f);
				}
				if (t._update != null) {
					for (f in t._update) App.notifyOnUpdate(f);
				}
				if (t._lateUpdate != null) {
					for (f in t._lateUpdate) App.notifyOnLateUpdate(f);
				}
				if (t._render != null) {
					for (f in t._render) App.notifyOnRender(f);
				}
				if (t._render2D != null) {
					for (f in t._render2D) App.notifyOnRender2D(f);
				}
			}
			trace("Should of add  traits"+App.traitUpdates.length);
		}
		else if(!value && active != value){
			trace("Before remove traits"+App.traitUpdates.length);
			for(t in traits){
				if (t._init != null) {
					for (f in t._init) App.removeInit(f);
				}
				if (t._update != null) {
					for (f in t._update) App.removeUpdate(f);
				}
				if (t._lateUpdate != null) {
					for (f in t._lateUpdate) App.removeLateUpdate(f);
				}
				if (t._render != null) {
					for (f in t._render) App.removeRender(f);
				}
				if (t._render2D != null) {
					for (f in t._render2D) App.removeRender2D(f);
				}
			}
			trace("Should of removed traits"+App.traitUpdates.length);
		}
		return active = value;
	}

	@:access(coin.Trait)
	public function addTrait(t:Trait) {
		traits.push(t);
		t.object = this;

		if (t._add != null) {
			for (f in t._add) f();
			t._add = null;
		}
	}

	/**
	 * Remove the Trait from the Object. 
	 *
	 * @param	t The Trait to be removed from the game Object.
	 */
	@:access(coin.Trait)
	public function removeTrait(t:Trait) {
		if (t._init != null) {
			for (f in t._init) App.removeInit(f);
			t._init = null;
		}
		if (t._update != null) {
			for (f in t._update) App.removeUpdate(f);
			t._update = null;
		}
		if (t._lateUpdate != null) {
			for (f in t._lateUpdate) App.removeLateUpdate(f);
			t._lateUpdate = null;
		}
		if (t._render != null) {
			for (f in t._render) App.removeRender(f);
			t._render = null;
		}
		if (t._render2D != null) {
			for (f in t._render2D) App.removeRender2D(f);
			t._render2D = null;
		}
		if (t._remove != null) {
			for (f in t._remove) f();
			t._remove = null;
		}
		traits.remove(t);
	}

	/**
	 * Get the Trait instance that is attached to this game Object. 
	 *
	 * @param	c The class of type Trait to attempt to retrieve.
	 * @return	Trait or null
	 */
	public function getTrait<T:Trait>(c:Class<T>):T {
		for (t in traits) if (Type.getClass(t) == cast c) return cast t;
		return null;
	}
}