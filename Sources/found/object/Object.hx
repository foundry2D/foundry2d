package found.object;

import found.math.Util;
import haxe.ds.Vector;
import kha.simd.Float32x4;
import kha.Canvas;
import kha.math.Vector2;
import kha.math.Vector3;

import found.data.SceneFormat;

import echo.Body;
import echo.data.Data.CollisionData;

#if js
typedef MoveData ={
#else
@:structInit class MoveData{
#end
	public var _positions:Vector2;
	@:optional public var target:Vector2;
	@:optional public var speed:Float;
	@:optional public var step:Float;
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

#if js
typedef CollisionDef ={
#else
@:structInit class CollisionDef{
#end
	public var objectName:String;
	@:optional public var tileId:Int;
	@:optional public var onEnter:Body->Body->Array<CollisionData>->Void;
	@:optional public var onStay:Body->Body->Array<CollisionData>->Void;
	@:optional public var onExit:Body->Body->Void;
} 

class Object {
	#if debug
	public var name:String;
	#end
	#if editor
	public var dataChanged:Bool = false;
	#end
	@:isVar public var raw(get,set):TObj;
	function set_raw(data:TObj) {
		this.raw = data;
		//@TODO: Evaluate if we really need to do this in release mode; if not add an #if editor
		if(Scene.ready && State.active != null && State.active.physics_world != null && data.rigidBody != null){
            makeBody(State.active,data);
		}
		return this.raw;
	}
	function get_raw(){
		return this.raw;
	}
	static var uidCounter = -1;
	public final uid:Int;
	public var active(default, set):Bool;
	private var spawned:Bool = false;

	public var body(default, set):echo.Body = null;
	function set_body(b:echo.Body) {
		if(b != null){
			b.on_move = on_physics_move;
		}
		else if(body != null){
			body.on_move = null;
		}
		if(b == null && body != null){
			State.active.physics_world.remove(body);
		}

		return body = b;
	}

	@:access(found.anim.Tilemap)
	public function onCollision(data:CollisionDef) : Array<echo.Listener> {
		var collisionListeners:Array<echo.Listener> = [];

		if(State.active == null || !Scene.ready) return collisionListeners;

		if(this.body == null){
			#if debug
			error("Current object doesn't have a rigidbody");
			#end
			return collisionListeners;
		}

		var obj:Array<Object> = State.active.getObjects(data.objectName);
		if(obj.length > 0){
			if(data.tileId != null && Std.isOfType(obj,found.anim.Tilemap)){
				var tile:Null<found.anim.Tile> = cast(obj,found.anim.Tilemap).tiles.get(data.tileId);
				if(tile != null){
					for(b in tile.bodies){
						var newCollisionListener:echo.Listener = State.active.physics_world.listen(this.body,b,{enter: data.onEnter,stay: data.onStay,exit: data.onExit});
						collisionListeners.push(newCollisionListener);
					}
					return collisionListeners;
				}
				#if debug
				else {
					var id:Int = data.tileId;
					var name:String = data.objectName;
					error('Tilemap $name did not have a tileId of value $id');
				}
				#end
			}
			else if(obj[0].body != null){
				for(object in obj){
					var newCollisionListener:echo.Listener = State.active.physics_world.listen(this.body,object.body,{enter: data.onEnter,stay: data.onStay,exit: data.onExit});
					collisionListeners.push(newCollisionListener);
				}
				return collisionListeners;
			}
			#if debug
			else{
				var name:String = data.objectName;
				if(data.tileId != null){
					error('Object $name was not of type Tilemap');
				}
				else{
					error('The body of Object $name was null');
				}
			}
			#end
		}
		#if debug
		else{
			var name:String = data.objectName;
			error('Object with name $name was not found in Scene');
		}
		#end
		return collisionListeners;
	}

	public function removeCollisionListeners(collisionListeners:Array<echo.Listener>) {
		for(listener in collisionListeners) {
			State.active.physics_world.listeners.remove(listener);
		}		
	}

	function makeBody(scene:Scene,p_raw:TObj){
		if(body != null)return;
		if(p_raw.rigidBody.x == null) p_raw.rigidBody.x = this.position.x;
		if(p_raw.rigidBody.y == null) p_raw.rigidBody.y = this.position.y;
		if(p_raw.rigidBody.shapes != null) {
			if(p_raw.rigidBody.shapes[0].width == null) p_raw.rigidBody.shapes[0].width = p_raw.width;
			if(p_raw.rigidBody.shapes[0].height == null) p_raw.rigidBody.shapes[0].height = p_raw.height;
		}
		
		this.body = scene.physics_world.add(new echo.Body(p_raw.rigidBody));
		body.object = this;
	}

	function on_physics_move(x:Float,y:Float){
		translate(function(data:MoveData){
			data._positions.x = x;
			data._positions.y = y;

			return data;
		},null,false);
	}

	static final _positions:Array<Vector2> = [];
	static var _translations:Executor<MoveData> = null;
	public var position(get,never):Vector2;
	function get_position() {
		return _positions[uid];
	}
	public var center(get,never):Vector2;
	function get_center() {
		return new Vector2(position.x + 0.5 * width, position.y + 0.5 * height);
	}
	/**
	 * Add a translation function to be executed in another thread. 
	 *
	 * @param	func The function to be executed in the other thread.
	 * @param	dt The delta time to be used; defaults to 1.0.
	 */
	public function translate(func:MoveData->MoveData,?data:MoveData = null,?onPhysics:Bool = true){
		if(data == null){
			data = {_positions:new Vector2(_positions[uid].x,_positions[uid].y),dt:Timer.delta};
		}

		_translations.add(func,data,uid,function(data:MoveData){
			if(body != null && onPhysics){
				body.x = data._positions.x;
				body.y = data._positions.y;
			}
		});
	}
	/**
	 * 	Moves from object position to target by the step. 
	 *	If target is within step units length, object position becomes target.
	 * @param	target Target position to move towards.
	 * @param	step step units to move by.
	 */
	public function moveTowards(target:Vector2,step:Float) {
		var data:MoveData = {
			_positions:new Vector2(_positions[uid].x,_positions[uid].y),
			target:new Vector2(target.x,target.y),
			step:step
		};
		_translations.add(moveTo,data,uid,function(data:MoveData){
			if(body != null){
				body.x = data._positions.x;
				body.y = data._positions.y;
			}
		});
	}
	function moveTo(data:MoveData){
		var delta:Vector2 = data.target.sub(data._positions);      // Gap vector
		var len2:Float =  delta.dot(delta); // Squared length of the gap

		if(len2 < data.step * data.step){
			data._positions = data.target;
			return data;
		}	

		// Unit vector that points from `pos` to `target`
		var direction:Vector2 = delta.div(Math.sqrt(len2));

		// Perform the step
		data._positions = data._positions.add(direction.mult(data.step));
		return data;
	}

	public var rotation(get,never):kha.math.Vector3;
	function get_rotation(){
		return _rotations[uid];
	}
	static var _rotations:Array<kha.math.Vector3> = [];
	static var _rotates:Executor<RotateData> = null;
	public function rotate(func:RotateData->RotateData,?from:Vector2,?towards:Vector2,?onPhysics:Bool = false){
		_rotates.add(func,{_rotations: _rotations[uid],dt: Timer.delta,from: from,towards: towards},uid,function(data:RotateData){
			if(body != null && onPhysics){
				body.rotation = data._rotations.z;
			}
		});
	}

	/**
	 * 	Rotate object to look at target position. 
	 *	If target is within step units length, object position becomes target.
	 * @param	targetPosition Target position to look towards.
	 */
	public function rotateTowardPosition(targetPosition:Vector2,?onPhysics:Bool = false) {
		var data:RotateData = {
			_rotations: new Vector3(_rotations[uid].x,_rotations[uid].y, _rotations[uid].z),
			from: new Vector2(center.x, center.y),
			towards: new Vector2(targetPosition.x, targetPosition.y)
		};
		_rotates.add(rotateToward,data,uid,function(data:RotateData){
			if(body != null && onPhysics){
				body.rotation = data._rotations.z;
			}
		});
	}

	function rotateToward(data:RotateData) {
		var direction = data.towards.sub(data.from);
		var angle = Util.radToDeg(Math.atan2(direction.y, direction.x));
		if(angle < 0){
			angle+=360;
		}
		data._rotations.z = angle;
		return data;
	}

	public var scale(get,never):Vector2;
	function get_scale(){
		return _scales[uid];
	}
	static var _scales:Array<Vector2> = [];
	static var _scaler:Executor<Vector2> = null;
	public function resize(func:Vector2->Vector2,?dt:Float = 1.0) {
		_scaler.add(func,_scales[uid],uid,function(data:Vector2){});
	}

	private var _width:Float =0.0;
	public var width(get,set):Float;
	function get_width(){
		return _width*scale.x;
	}
	function set_width(f:Float){
		_width = f;
		return _width;
	}
	public var height(get,set):Float;
	private var _height:Float =0.0;
	function get_height(){
		return _height*scale.y;
	}
	function set_height(f:Float){
		_height = f;
		return _height;
	}	

	public var layer(get,never):Int;
	function get_layer(){
		return raw.layer;
	}
	public var depth(get,never):Float;
	function get_depth(){
		if(!Scene.zsort)
			return position.y + height;
		return raw.depth;
	}

	var traits:Array<Trait> = [];

	@:access(found.Scene)
	public function new(p_raw:TObj){
		if(_translations == null) _translations = new Executor<MoveData>("_positions");
		if(_rotates == null) _rotates = new Executor<RotateData>("_rotations");
		if(_scaler == null) _scaler = new Executor<Vector2>("_scales");
		
		uid = ++uidCounter;

		if(p_raw.type == "object")
			this.raw = p_raw;

		_positions.push(Reflect.copy(p_raw.position));
		_rotations.push(Reflect.copy(p_raw.rotation));
		_scales.push( p_raw.scale != null ? Reflect.copy(p_raw.scale) : new Vector2(1.0,1.0));

		this.width = p_raw.width;
		this.height = p_raw.height;

		if(p_raw.active)
			activate();
		else
			deactivate();		
	}
	@:access(found.State)
	public function delete() {
		State.active._entities.remove(this);
		State.active.inactiveEntities.remove(this);
		for(t in traits){
			removeTrait(t);
		}
		this.body = null;
	}

	public function render(canvas:Canvas){
		if (!Scene.ready) return;
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
				if(t._awake != null){
					for (f in t._awake) App.notifyOnAwake(f);
				}
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
				if(t._awake != null){
					for (f in t._awake) App.removeAwake(f);
				}
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
}