package found.node;

import kha.input.KeyCode;
import found.Input.Keyboard;
import hxmath.math.Vector2;

class Platformer2DControllerNode extends LogicNode {
	public var inputType:String;
	public var defaultLeftKeyCode:KeyCode;
	public var defaultRightKeyCode:KeyCode;
	public var defaultJumpKeyCode:KeyCode;

	public function new(tree:LogicTree) {
		super(tree);

		tree.notifyOnUpdate(update);
	}

	function update(dt:Float) {
		var keyboard:Keyboard = Input.getKeyboard();
		var speed:Float = inputs[1].get();
		var jumpForce:Float = inputs[2].get();

		if (tree.object.body != null) {
			var movementInput:Vector2 = new Vector2(0, 0);

			if (inputType == "Use default input") {
				if (keyboard.down(Input.Keyboard.keyCode(defaultLeftKeyCode))) {
					movementInput.x += -1;
				}
				if (keyboard.down(Input.Keyboard.keyCode(defaultRightKeyCode))) {
					movementInput.x += 1;
				}
			} else {
				movementInput.x = inputs[0].get().x;
			}

			tree.object.body.velocity.x = movementInput.x * speed;

			if (keyboard.started(Input.Keyboard.keyCode(defaultJumpKeyCode))) {
				tree.object.body.velocity.y = -jumpForce;
			}
		}

		runOutput(0);
	}
}
