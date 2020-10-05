package found.node;

import found.object.Object;

class GetRotationNode extends LogicNode {
	override function get(from:Int):Dynamic {
		if (inputs[0].node == null) {
			return tree.object.rotation.z;
		} else {
			var object:Object = cast(inputs[0].get());
			return object.rotation.z;
		}
	}
}
