package found.tool;

import haxe.Constraints.Constructible;
import kha.Canvas;
import found.object.Object;
import found.data.SceneFormat;

@:generic
class Pool<O:(Constructible<TObj->Void> & Object)> extends Object {
	public var entity:Array<O>;
	public var max:Int;

	private var objectData:TObj;
	private var _count:Int = 0;

	public function new(data:TPool, objectData:TObj) {
		super(data);

		this.max = data.maxAmount;
		this.objectData = objectData;
		entity = [];
	}

	override public function update(dt:Float) {
		var i:Int = 0;
		while (i < entity.length) {
			var member = entity[i];
			if (member != null) {
				if (member.active) {
					member.update(dt);
					if (!member.active) {
						if (i < _count) {
							_count = i;
						}
					}
				}
			}
			i++;
		}
		super.update(dt);
	}

	override public function render(canvas:Canvas) {
		for (member in entity) {
			if (member != null && member.active) {
				member.render(canvas);
			}
		}
	}

	private function first():Int {
		var i = _count;
		while (i < entity.length + _count) {
			var h = i % entity.length;
			if (entity[h] == null || !entity[h].active) {
				if (i < entity.length) {
					_count++;
				}
			}
			i++;
		}
		return -1;
	}

	public function add():O {
		var object:O = new O(objectData);
		var full:Bool = entity.length >= max;

		if (!full) {
			entity.push(object);
		} else {
			var index = first();
			entity[index] = object;
		}

		return object;
	}
}
