package found.node;

import kha.math.FastVector2;

class ApplyForceToRigidbodyNode extends LogicNode {
	public function new(tree:LogicTree) {
		super(tree);
	}

	override function run(from:Int) {
		var force:FastVector2 = inputs[2].get();

		if (tree.object.body != null) {
			tree.object.body.push(force.x, force.y);
		}

		runOutput(0);
	}
}
