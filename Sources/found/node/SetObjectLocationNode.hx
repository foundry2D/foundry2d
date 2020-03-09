package found.node;

import found.object.Object;
import found.object.Object.MoveData;
import kha.math.FastVector2;

class SetObjectLocationNode extends LogicNode {
	var newPositionVector:FastVector2 = new FastVector2();

	public function new(tree:LogicTree) {
		super(tree);
	}

	override function run(from:Int) {
		newPositionVector = inputs[2].get();

		if (inputs[1].node == null) {
			tree.object.translate(setObjectLocation);
		} else {
			var objectToSetLocation:Object = cast(inputs[1].get());
			objectToSetLocation.translate(setObjectLocation);
		}

		runOutput(0);
	}

	function setObjectLocation(data:MoveData) {
		data._positions.x = newPositionVector.x;
		data._positions.y = newPositionVector.y;
		return data;
	}
}
