package found.node;

@:keep
@:access(found.Trait)
class InitNode extends LogicNode {

	public function new(tree:LogicTree) {
		super(tree);
		tree.notifyOnInit(init);
	}

	function init() {
		runOutput(0);
	}
}
