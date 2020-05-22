package found.node;

import hxmath.math.Vector2;
import found.State;
import kha.input.KeyCode;

class TopDownControllerNode extends LogicNode {
	public var inputType:String;

	var defaultUpKeyCode:KeyCode = Up;
	var defaultDownKeyCode:KeyCode = Down;
	var defaultLeftKeyCode:KeyCode = Left;
	var defaultRightKeyCode:KeyCode = Right;

	var defaultUpKeyDown:Bool = false;
	var defaultDownKeyDown:Bool = false;
	var defaultLeftKeyDown:Bool = false;
	var defaultRightKeyDown:Bool = false;

	public function new(tree:LogicTree) {
		super(tree);

		tree.notifyOnInit(function() {
			State.active.notifyOnKeyPressed(updateKeyDownPressed);
			State.active.notifyOnKeyReleased(updateKeyDownReleased);
			tree.notifyOnUpdate(update);
		});

		tree.notifyOnRemove(function() {
			State.active.removeOnKeyPressed(updateKeyDownPressed);
			State.active.removeOnKeyReleased(updateKeyDownReleased);
		});
	}

	function updateKeyDownPressed(p_keyCode:KeyCode) {
		if (p_keyCode == defaultUpKeyCode) {
			defaultUpKeyDown = true;
		} else if (p_keyCode == defaultDownKeyCode) {
			defaultDownKeyDown = true;
		} else if (p_keyCode == defaultLeftKeyCode) {
			defaultLeftKeyDown = true;
		} else if (p_keyCode == defaultRightKeyCode) {
			defaultRightKeyDown = true;
		}
	}

	function updateKeyDownReleased(p_keyCode:KeyCode) {
		if (p_keyCode == defaultUpKeyCode) {
			defaultUpKeyDown = false;
		} else if (p_keyCode == defaultDownKeyCode) {
			defaultDownKeyDown = false;
		} else if (p_keyCode == defaultLeftKeyCode) {
			defaultLeftKeyDown = false;
		} else if (p_keyCode == defaultRightKeyCode) {
			defaultRightKeyDown = false;
		}
	}

	function update(dt:Float) {
		var speed:Float = inputs[1].get();

		if (tree.object.body != null) {
			var movementInput:Vector2 = new Vector2(0, 0);

			if (inputType == "Use default input") {
				if (defaultUpKeyDown) {
					movementInput.y += -1;
				}
				if (defaultDownKeyDown) {
					movementInput.y += 1;
				}
				if (defaultLeftKeyDown) {
					movementInput.x += -1;
				}
				if (defaultRightKeyDown) {
					movementInput.x += 1;
				}
			} else {
				movementInput.x = inputs[0].get().x;
				movementInput.y = inputs[0].get().y;
			}

			var normalizedMovementInput:Vector2 = movementInput.normalize();
			tree.object.body.velocity = normalizedMovementInput * speed;
		}

		runOutput(0);
	}
}
