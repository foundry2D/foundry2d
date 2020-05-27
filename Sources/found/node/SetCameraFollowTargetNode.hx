package found.node;

import found.object.Object;

class SetCameraFollowTargetNode extends LogicNode {
	public function new(tree:LogicTree) {
		super(tree);
	}

	override function run(from:Int) {
		if (inputs[1].node == null) {
			State.active.cam.setCameraFollowTarget(tree.object);
		} else {
			var objectToFollow:Object = cast(inputs[1].get());
			State.active.cam.setCameraFollowTarget(objectToFollow);
		}

		runOutput(0);
	}
}
