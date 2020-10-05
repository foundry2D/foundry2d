package found.node;

import kha.math.Vector2;
import kha.math.FastVector2;
import found.object.Object;

class RotateTowardPositionNode extends LogicNode {
	override function run(from:Int) {
		var fastTargetPosition:FastVector2 = inputs[2].get();
		var targetPosition:Vector2 = new Vector2(fastTargetPosition.x, fastTargetPosition.y);

		var objectToRotate:Object;
		if (inputs[1].node == null) {
			objectToRotate = tree.object;
		} else {
			objectToRotate = cast(inputs[1].get());
		}

		objectToRotate.rotateTowardPosition(targetPosition);

		runOutput(0);
	}
}
