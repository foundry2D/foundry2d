package found.node;

import found.object.Object;

class DestroyObjectOutsideViewNode extends LogicNode {
	public function new(tree:LogicTree) {
		super(tree);

		tree.notifyOnUpdate(update);
	}

	function update(dt:Float) {
        var objectToDestroy:Object;
        var viewOffsetToDestroyAt:Int = inputs[1].get();

		if (inputs[0].node != null) {
			objectToDestroy = cast(inputs[0].get());
		} else {
			objectToDestroy = tree.object;
		}

		if (!objectToDestroy.isVisible(viewOffsetToDestroyAt, found.State.active.getCameraView())) {
			found.State.active.remove(objectToDestroy);
		}
	}
}
