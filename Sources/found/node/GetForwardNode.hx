package found.node;

import kha.math.Vector2;
import found.object.Object;

class GetForwardNode extends LogicNode {
	override function get(from:Int):Dynamic {
		
		if (inputs[0].node == null) {
			return new Vector2(Math.cos(tree.object.rotation.z),Math.sin(tree.object.rotation.z));
		} else {
			var object:Object = cast(inputs[0].get());
			return new Vector2(Math.cos(object.rotation.z),Math.sin(object.rotation.z));
		}
	}
}
