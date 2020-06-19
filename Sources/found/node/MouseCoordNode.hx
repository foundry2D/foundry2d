package found.node;

class MouseCoordNode extends LogicNode {
	var coords = new kha.math.FastVector2();
	var move = new kha.math.FastVector2();

	public function new(tree:LogicTree) {
		super(tree);
	}

	override function get(from:Int):Dynamic {
		var mouse = Input.getMouse();

		if (from == 0) {
			coords.x = mouse.x;
			coords.y = mouse.y;
			return coords;
		} else if (from == 1) {
			move.x = mouse.movementX;
			move.y = mouse.movementY;
			return move;
		} else {
			return mouse.wheelDelta;
		}
	}
}
