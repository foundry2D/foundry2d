package found.node;

import kha.math.Vector2;
import found.object.Object;

class GetPositionNode extends LogicNode {
	override function get(from:Int):Dynamic {
		
		if (inputs[0].node == null) {
			return new Vector2(tree.object.position.x,tree.object.position.y);
		} else {
			var object:Object = cast(inputs[0].get());
			return new Vector2(object.position.x,object.position.y);
		}
	}
}
