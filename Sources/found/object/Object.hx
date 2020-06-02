package found.object;

import echo.data.Options.ShapeOptions;
import kha.simd.Float32x4;
import found.math.Vec2;
import kha.Canvas;
import kha.math.Vector2;
import kha.math.Vector3;
import found.data.SceneFormat;

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
	public var _rotations:kha.math.Vector3;
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
	#end
	public var raw(default,set):TObj;
	function set_raw(data:TObj) {
		this.raw = data;
		//@TODO: Evaluate if we really need to do this in release mode; if not add an #if editor
		if(State.active != null && State.active.physics_world != null && data.rigidBody != null){
            makeBody(State.active,data);
		}
		return this.raw;
	}
	static var uidCounter = -1;
	public final uid:Int;
	public var active(default, set):Bool;

	public var body(default, set):echo.Body = null;
	function set_body(b:echo.Body) {
		if(b != null){
			b.on_move = on_physics_move;
		}
		else if(body != null){
			body.on_move = null;
		}

		return body = b;
	}

	function makeBody(scene:Scene,p_raw:TObj){
		if(body != null)return;
		if(p_raw.rigidBody.x == null) p_raw.rigidBody.x = p_raw.position.x;
		if(p_raw.rigidBody.y == null) p_raw.rigidBody.y = p_raw.position.y;
		if(p_raw.rigidBody.shapes != null) {
			if(p_raw.rigidBody.shapes[0].width == null) p_raw.rigidBody.shapes[0].width = p_raw.width;
			if(p_raw.rigidBody.shapes[0].height == null) p_raw.rigidBody.shapes[0].height = p_raw.height;
		}
		this.body = scene.physics_world.add(new echo.Body(p_raw.rigidBody));
	}

	function on_physics_move(x:Float,y:Float){
		translate(function(data:MoveData){
			data._positions.x = x;
			data._positions.y = y;

			return data;
		});
	}

	static final _positions:Array<Vector2> = [];
	static var _translations:Executor<MoveData> = null;
	public var position(get,never):Vector2;
	function get_position() {
		return _positions[uid];
	}
	function getCenterPosition() {
		return new Vector2(get_position().x + 0.5 * get_width(), get_position().y + 0.5 * get_height());
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

	public var rotation(get,never):kha.math.Vector3;
	function get_rotation(){
		return _rotations[uid];
	}
	static var _rotations:Array<kha.math.Vector3> = [];
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

	public var layer:Int = 0;
	public var depth:Float = 0.0;

	var traits:Array<Trait> = [];

	public function new(p_raw:TObj){
		if(_translations == null) _translations = new Executor<MoveData>("_positions");
		if(_rotates == null) _rotates = new Executor<RotateData>("_rotations");
		if(_scaler == null) _scaler = new Executor<Vector2>("_scales");
		
		uid = ++uidCounter;

		_positions.push(Reflect.copy(p_raw.position));
		_rotations.push(Reflect.copy(p_raw.rotation));
		_scales.push( p_raw.scale != null ? Reflect.copy(p_raw.scale) : new Vector2(1.0,1.0));

		this.width = p_raw.width;
		this.height = p_raw.height;

		this.layer = p_raw.layer;
		this.depth = p_raw.depth;
		
		
		
		

		center = new Vector2(width * 0.5, height * 0.5);
		if(p_raw.active)
			activate();
		else
			deactivate();
	}

	public function update(dt:Float){
		if (!Scene.ready) return;
		
		if(body != null){
			body.x = position.x;
			body.y = position.y;
		}
		
		if(!Scene.zsort)
			depth = position.y + height;

		center.x = position.x+width * 0.5;
		center.y = position.y+height * 0.5;

	}

	public function render(canvas:Canvas){
		if (!Scene.ready) return;
		#if debug
    	if(body != null){
			Object.physicsDraw(canvas,raw.rigidBody.shapes,position);
		}
		#end
	}

	public function isVisible(offset:Int,cam:Float32x4): Bool {
		if (!Scene.ready) return false;
		
		var layers = State.active.raw.layers;
		var cullSpeed = layers != null && layers.length > 0 && raw.type != "camera_object" ? layers[this.layer]: {name: "No layers",zIndex: 0, speed:1.0}
		var x = Float32x4.get(cam,0) * cullSpeed.speed;
		var y = Float32x4.get(cam,1) * cullSpeed.speed;
		var w = Float32x4.get(cam,2);
		var h = Float32x4.get(cam,3);
		if(position.x < x + offset + w && position.x > x - offset - width && position.y > y-offset -height && position.y < y +h+offset) return true;

		return false;
	}

	public function activate(){
		active = true;
	}

	public function deactivate(){
		active = false;
	}
	@:access(found.Trait,found.App,found.Scene)
	function set_active(value:Bool):Bool {
		if(body != null)
			body.active = value;
		if(value && active != value){
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
			if(Scene.ready){
				State.active.inactiveEntities.remove(this);
				State.active.activeEntities.push(this);
			}
		}
		else if(!value && active != value){
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
			if(Scene.ready){
				State.active.activeEntities.remove(this);
				State.active.inactiveEntities.push(this);
			}
		}
		return active = value;
	}

	@:access(found.Trait)
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
	@:access(found.Trait)
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
	public function getTrait<T:Trait>(c:Class<T>,?name:String):T {
		for (t in traits) {
			if (Type.getClass(t) == cast c) {
				if(name == null || (name != null && t.name == name)) {
					return cast t;
				} 			
			}
		}
		return null;
	}

	#if debug
	static public function physicsDraw(canvas:kha.Canvas,shapes:Array<ShapeOptions>,position:Vector2){
		if(!Found.collisionsDraw || State.active.physics_world == null) return;
		canvas.g2.color = kha.Color.fromBytes(255,0,0,64);
		for(shape in shapes) {
			drawShape(canvas.g2,shape,position.x + shape.offset_x,position.y + shape.offset_y);
		}
		canvas.g2.color = kha.Color.White;
	}
	static function drawShape(g:kha.graphics2.Graphics,shape:ShapeOptions,x:Float,y:Float){
		switch(shape.type){
			case echo.data.Types.ShapeType.RECT:
			g.fillRect(x,y,shape.width,shape.height);
			default:
		}
	} 
	#end
}