package found.node;

import kha.math.Vector2;

class MultiplyVec2Node extends LogicNode {

    public function new(tree:LogicTree) {
		super(tree);
	}

    override function get(from: Int): Dynamic {
        var one:Vector2 = inputs[0].get();
        var two:Float = inputs[1].get();
        
        return one.mult(two);
	}
}