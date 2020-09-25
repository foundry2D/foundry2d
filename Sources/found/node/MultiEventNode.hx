package found.node;



class MultiEventNode extends LogicNode {

	public function new(tree:LogicTree) {
		super(tree);
	}

	override function run(from:Int) {
        runOutput(0);
    }
}