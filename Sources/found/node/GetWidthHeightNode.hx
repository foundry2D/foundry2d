package found.node;

import kha.math.Vector2;
import found.object.Object;

class GetWidthHeightNode extends LogicNode {
	override function get(from:Int):Dynamic {
		
		if (inputs[0].node == null) {
			return new Vector2(tree.object.width,tree.object.height);
		} else {
			var object:Object = cast(inputs[0].get());
			return new Vector2(object.width,object.height);
		}
	}
}
