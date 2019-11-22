package coin.object;

import kha.Canvas;
import kha.math.Vector2;
import coin.data.SceneFormat;
import coin.Scene;

class Object {
	#if debug
	public var name:String;
	#end
	static var uidCounter = 0;
	public var uid:Int;
	#if editor
	public var dataChanged:Bool = false;
	public var raw(default,set):TObj = null;
	@:access(coin.Scene)
	function set_raw(data:TObj){
		if(!Scene.ready)return this.raw = data;

		refreshObjectData(data);
		this.raw = data;
		// trace(Reflect.getProperty(State.active.raw._entities[uid],"imagePath"));
		// trace(Reflect.getProperty(State.active._entities[uid].raw,"imagePath"));
		dataChanged = true;
		return this.raw;
	}
	@:access(coin.Scene)
	function refreshObjectData(data:TObj){
		for(f in Reflect.fields(data)){
			if(f == "traits"){
				var trts:Array<TTrait> = Reflect.getProperty(data,f);
				if(traits.length == trts.length)continue;
				Scene.createTraits(trts.splice(traits.length+1,trts.length-traits.length),this);
				continue;
			}
			Reflect.setProperty(this,f,Reflect.getProperty(data,f));
		}
	}
	var e:haxe.ui.events.UIEvent = null;
	var ds = new haxe.ui.data.ListDataSource<haxe.ui.extended.InspectorNode.InspectorData>();
	@:access(EditorInspector,haxe.ui.extended.InspectorView,coin.Scene)
	function refreshDataObject(){
		if(App.editorui.inspector.wait.length > 0)return;
		if(e == null ) e = new haxe.ui.events.UIEvent(haxe.ui.events.UIEvent.CHANGE);
		//Update raw
		for(f in Reflect.fields(this.raw)){
			if(f == "traits"){
				var trts:Array<TTrait> = Reflect.getProperty(this.raw,f);
				if(traits.length == trts.length)continue;
				Scene.createTraits(trts.splice(traits.length+1,trts.length-traits.length),this);
				continue;
			}
			if(Reflect.hasField(this,f)){
				Reflect.setProperty(this.raw,f,Reflect.getProperty(this,f));
			}

		}
		//Update Inspector
		if(App.editorui.inspector.tree.curNode != null && App.editorui.inspector.tree.curNode.data.name == this.name){
			App.editorui.inspector.tree.curNode.updateNode(EditorHierarchy.getIDataFrom(this.raw));
		}
		
			
	}
	#else
	public var raw:TObj = null;
	#end
	public var active(default, set):Bool = true;
	static var _positions:Array<Vector2> = [];
	public var position(get,never):Vector2;
	function get_position() {
		return _positions[uid];
	}
	public function translate(func:Vector2->Vector2){
		_translations.add(func,_positions[uid],uid);
	}
	static var _translations:Executor<Vector2> = new Executor<Vector2>("_positions");
	public var scale:Vector2;
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
	public var rotation:Float = 0;

	public var velocity:Vector2 = new Vector2();
	public var speed = 3.0;
	public var acceleration = 0.3;
	public var friction = 3.6;

	public var depth:Float;

	public var life:Int = 3;

	public var invincible = false;
	public var invincibleTimerMax = 3.0;
	public var invincibleTimer:Float;
	public var invincibleTimerSpeed = 0.05;

	var traits:Array<Trait> = [];

	public function new(?x:Float, ?y:Float, ?width:Float, ?height:Float){
		uid = uidCounter++;
		_positions.push(new Vector2(x, y));

		this.width = width;
		this.height = height;
		
		scale = new Vector2(1.0,1.0);
		
		

		center = new Vector2(width / 2, height / 2);
		if(depth == null)
			depth = position.y + height;

		invincibleTimer = invincibleTimerMax;

		activate(x, y);
	}

	public function update(dt:Float){
		if (!active || !Scene.ready) return;

		if(!Scene.zsort)
			depth = position.y + height;

		center.x = width / 2;
		center.y = height / 2;

		if (invincible == true){
			invincibleTimer -= invincibleTimerSpeed;
		}

		if (invincibleTimer <= 0.0){
			invincible = false;
			invincibleTimer = invincibleTimerMax;
		}
		#if editor
		refreshDataObject();
		#end
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