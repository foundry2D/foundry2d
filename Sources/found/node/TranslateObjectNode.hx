package found.node;

import found.object.Object.MoveData;
import kha.math.FastVector2;

class TranslateObjectNode extends LogicNode {
    
    public function new(tree:LogicTree) {
		super(tree);
	}

	override function run(from:Int) {
        var direction:FastVector2 = inputs[1].get();
        var speed:Float = inputs[2].get();
        
        tree.object.translate(function(data:MoveData){
            data._positions.x += direction.x*speed;
            data._positions.y += direction.y*speed;
            return data;
        });

		runOutput(0);
	}
}