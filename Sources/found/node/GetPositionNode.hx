package found.node;

import found.object.Object;

class GetPositionNode extends LogicNode {
	override function get(from:Int):Dynamic {
		if (inputs[0].node == null) {
			return tree.object.position;
		} else {
			var object:Object = cast(inputs[0].get());
			return object.position;
		}
	}
}
