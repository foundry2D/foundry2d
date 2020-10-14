package found.node;

import kha.math.Vector2;

class MultiplyVec2sNode extends LogicNode {

    public function new(tree:LogicTree) {
		super(tree);
	}

    override function get(from: Int): Dynamic {
        var one:Vector2 = inputs[0].get();
        var two:Vector2 = inputs[1].get();
        
        return new Vector2(one.x * two.x, two.y * one.y);
	}
}