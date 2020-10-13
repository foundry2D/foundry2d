package found.node;

import found.object.Object;

class IsObjectOutsideViewNode extends LogicNode {
	public function new(tree:LogicTree) {
		super(tree);

		tree.notifyOnUpdate(update);
	}

	function update(dt:Float) {
        var object:Object;
        var maxViewOffset:Int = inputs[1].get();

		if (inputs[0].node != null) {
			object = cast(inputs[0].get());
		} else {
			object = tree.object;
		}

		if (!object.isVisible(maxViewOffset, found.State.active.getCameraView())) {
			runOutput(0);
		}
	}
}
