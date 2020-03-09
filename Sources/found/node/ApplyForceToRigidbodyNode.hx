package found.node;

import found.object.Object;
import kha.math.FastVector2;

class ApplyForceToRigidbodyNode extends LogicNode {
	public function new(tree:LogicTree) {
		super(tree);
	}

	override function run(from:Int) {
		var force:FastVector2 = inputs[2].get();

		if (inputs[1].node == null) {
			if (tree.object.body != null) {
				tree.object.body.push(force.x, force.y);
			}
		} else {
			var objectToApplyForceTo:Object = cast(inputs[1].get());
			if (objectToApplyForceTo.body != null) {
				objectToApplyForceTo.body.push(force.x, force.y);
			}
		}

		runOutput(0);
	}
}
