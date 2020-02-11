package found.node;

import found.object.Object.MoveData;
import kha.math.FastVector2;

class SetObjLocNode extends LogicNode{

	
    public function new(tree:LogicTree) {
		super(tree);
	}

	override function run(from:Int) {
		var pos:FastVector2 = inputs[1].get();

        tree.object.translate(function(data:MoveData){
            data._positions.x = pos.x;
            data._positions.y = pos.y;
            return data;
        });

		runOutput(0);
	}
}