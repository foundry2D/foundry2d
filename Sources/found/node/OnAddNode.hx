package found.node;

@:keep
@:access(found.Trait)
class OnAddNode extends LogicNode {

	public function new(tree:LogicTree) {
		super(tree);
		tree.notifyOnAdd(add);
	}

	function add() {
		runOutput(0);
	}
}
