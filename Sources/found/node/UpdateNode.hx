package found.node;

@:keep
@:access(found.Trait)
class UpdateNode extends LogicNode {

	public function new(tree:LogicTree) {
		super(tree);
        tree.notifyOnUpdate(update);
	}

	function update() {
		runOutput(0);
	}
}
