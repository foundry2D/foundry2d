package found.node;

import kha.math.Vector2;

class SetCameraTargetPositionNode extends LogicNode {
	public function new(tree:LogicTree) {
		super(tree);
	}

	override function run(from:Int) {
		var position:Vector2 = inputs[1].get();

		State.active.cam.setCameraTargetPosition(position);

		runOutput(0);
	}
}
