package coin.object;

import kha.Canvas;
import kha.math.Vector2;
import coin.data.SceneFormat;

class Object {
	#if debug
	public var name:String;
	#end
	static var uidCounter = 0;
	public var uid:Int;
	public var raw:TObj = null;

	public var active(default, set):Bool = true;
	public var position:Vector2;
	public var scale:Vector2;
	public var width(get,set):Float;
	private var _width:Float =0.0;
	function get_width(){
		return _width;
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
		return _height;
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

	public var traits:Array<Trait> = [];

	public function new(?x:Float, ?y:Float, ?width:Float, ?height:Float){
		uid = uidCounter++;
		position = new Vector2(x, y);

		this.width = width;
		this.height = height;
		
		trace(Coin.BUFFERWIDTH != Coin.WIDTH);
		if(Coin.BUFFERWIDTH != Coin.WIDTH || Coin.BUFFERHEIGHT != Coin.HEIGHT){
			scale = new Vector2(Coin.BUFFERWIDTH/Coin.WIDTH,Coin.BUFFERHEIGHT/Coin.HEIGHT);
		} else{
			scale = new Vector2(1.0,1.0);
		}
		

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

	function set_active(value:Bool):Bool {
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