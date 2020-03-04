package found.node;

import kha.math.FastVector2;

class ApplyImpulseToRigidbodyNode extends LogicNode {
	public function new(tree:LogicTree) {
		super(tree);
	}

	override function run(from:Int) {
		var force:FastVector2 = inputs[2].get();

		if (tree.object.body != null) {
			tree.object.body.velocity.x = force.x;
			tree.object.body.velocity.y = force.y;
		}

		runOutput(0);
	}
}