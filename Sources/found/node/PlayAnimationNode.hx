package found.node;

import found.object.Object;

@:keep
class PlayAnimationNode extends LogicNode {
	override function run(from:Int) {
		var selectedObject:Object = null;
		if (inputs[2].node == null) {
			selectedObject = tree.object;
		} else {
			selectedObject = cast(inputs[2].get());
		}

		if (selectedObject.raw.type == "sprite_object" && inputs[1].get() != "") {
			var curSprite:found.anim.Sprite = cast(selectedObject);
			curSprite.setAnimationByName(inputs[1].get());
		} else {
			if (selectedObject.raw.type != "sprite_object") {
				error("\"Play Animation\" node needs to be associated to a sprite_object");
			}
		}

		runOutput(0);
	}
}
