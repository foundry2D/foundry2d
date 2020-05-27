package found.node;

import kha.math.FastVector2;

class SetCameraTargetPositionNode extends LogicNode {
	public function new(tree:LogicTree) {
		super(tree);
	}

	override function run(from:Int) {
		var position:FastVector2 = inputs[1].get();

		State.active.cam.setCameraTargetPosition(position);

		runOutput(0);
	}
}
