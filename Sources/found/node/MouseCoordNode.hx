package found.node;

import found.State;

class MouseCoordNode extends LogicNode{

	var coords = new kha.math.FastVector2();
	var move = new kha.math.FastVector2();
	var wheelDelta:Int = 0;
	public function new(tree: LogicTree) {
		super(tree);
		State.active.notifyOnMouseMove(function(x:Int,y:Int,cx:Int,cy:Int){
			move.x = x;
			move.y = y;
		});
	}

	override function get(from: Int): Dynamic {

		if (from == 0) {
			coords.x = Found.mouseX;
			coords.y = Found.mouseY;
			return coords;
		}
        else if (from == 1) {
			return move;
		}
		else {
			return wheelDelta;
		}
	}
}