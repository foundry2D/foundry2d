package found.node;

import found.math.Util;

@:keep
class GetRandomObjectNode extends LogicNode {
	public var listOfObjects:Array<Int>;


	public function new(tree:LogicTree) {
		super(tree);
	}
	
	override function get(from:Int):Dynamic {
		var names:Array<String> = State.active.getObjectNames();
		var choice:Int = listOfObjects[Util.randomInt(listOfObjects.length)];
		return State.active.getObject(names[choice]);
	}
}
