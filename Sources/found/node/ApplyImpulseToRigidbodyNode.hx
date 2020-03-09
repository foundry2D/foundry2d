package found.node;

import found.object.Object;
import kha.math.FastVector2;

class ApplyImpulseToRigidbodyNode extends LogicNode {
	public function new(tree:LogicTree) {
		super(tree);
	}

	override function run(from:Int) {
		var force:FastVector2 = inputs[2].get();

		if (inputs[1].node == null) {
			if (tree.object.body != null) {
				tree.object.body.velocity.x = force.x;
				tree.object.body.velocity.y = force.y;
			}
		} else {
			var objectToApplyImpulseTo:Object = cast(inputs[1].get());
			if (objectToApplyImpulseTo.body != null) {
				objectToApplyImpulseTo.body.velocity.x = force.x;
				objectToApplyImpulseTo.body.velocity.y = force.y;
			}
		}

		runOutput(0);
	}
}
