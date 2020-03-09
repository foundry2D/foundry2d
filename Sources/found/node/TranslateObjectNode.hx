package found.node;

import found.object.Object;
import found.object.Object.MoveData;
import kha.math.FastVector2;

class TranslateObjectNode extends LogicNode {
	var direction:FastVector2 = new FastVector2();
	var speed:Float = 0; 

	public function new(tree:LogicTree) {
		super(tree);
	}

	override function run(from:Int) {
		direction = inputs[2].get();
		speed = inputs[3].get();

		if (inputs[1].node == null) {
			tree.object.translate(translateObject);
		} else {
			var objectToTranslate:Object = cast(inputs[1].get());
			objectToTranslate.translate(translateObject);
		}

		runOutput(0);
	}

	function translateObject(data:MoveData) {
		data._positions.x += direction.x * speed;
		data._positions.y += direction.y * speed;
		return data;
	}
}
