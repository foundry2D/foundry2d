package found.node;

import found.object.Object;

@:keep
class GetObjectNode extends LogicNode {
	public var selectedObjectName:String = "";

	var lastSelectedObjectName:String = "";
	var selectedObject:Object = null;

	public function new(tree:LogicTree) {
		super(tree);
	}

	override function run(from:Int) {
		get(0);
		runOutput(0);
	}

	override function get(from:Int):Dynamic {
		if (selectedObject == null || lastSelectedObjectName != selectedObjectName) {
			lastSelectedObjectName = selectedObjectName;
			selectedObject = State.active.getObject(selectedObjectName);
		}
		return selectedObject;
	}
}
