package found.node;

import found.object.Object;

class DestroyObjectNode extends LogicNode {
	override function run(from:Int) {
		var objectToDestroy:Object;

		if (inputs[1].node != null) {
			objectToDestroy = cast(inputs[1].get());
		} else {
			objectToDestroy = tree.object;
		}

		found.State.active.remove(objectToDestroy);

		runOutput(0);
	}
}
