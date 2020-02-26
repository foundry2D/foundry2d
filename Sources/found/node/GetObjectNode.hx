package found.node;

@:keep
class GetObjectNode extends LogicNode {
	public var selectedObjectName:String = "";

	public function new(tree:LogicTree) {
		super(tree);
	}

	override function get(from:Int):Dynamic {
		return State.active.getObject(selectedObjectName);
	}
}
