package found.node;

import kha.math.Vector2;

class SetCameraTargetPositionNode extends LogicNode {
	public function new(tree:LogicTree) {
		super(tree);
	}
	//@TODO: We should test this; I doubt it works.
	override function run(from:Int) {
		var position:Vector2 = inputs[1].get();
		var camPos = State.active.cam.position;
		var direction = position.sub(camPos).normalized();
		var move= new Vector2();
		if(direction.x > 0)
		{
			move.x = position.x - camPos.x;
		}
		else 
		{
			move.x = camPos.x - position.x;
		}
		if(direction.y > 0)
		{
			move.y = position.y - camPos.y;
		}
		else 
		{
			move.y = camPos.y - position.y;
		}
		State.active.cam.move(move);

		runOutput(0);
	}
}
