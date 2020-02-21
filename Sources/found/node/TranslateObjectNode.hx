package found.node;

import found.object.Object.MoveData;
import kha.math.FastVector2;

class TranslateObjectNode extends LogicNode {
	public function new(tree:LogicTree) {
		super(tree);
	}

	override function run(from:Int) {
		var direction:FastVector2 = inputs[2].get();
		var speed:Float = inputs[3].get();
		tree.object.translate(function(data:MoveData) {
			data._positions.x += direction.x * speed;
			data._positions.y += direction.y * speed;
			return data;
		});

		runOutput(0);
	}
}
