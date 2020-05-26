package found.node;

import hxmath.math.Vector2;
import found.State;
import kha.input.KeyCode;

class Platformer2DControllerNode extends LogicNode {
	public var inputType:String;
	public var defaultLeftKeyCode:String;
	public var defaultRightKeyCode:String;
	public var defaultJumpKeyCode:String;

	var defaultLeftKeyDown:Bool = false;
	var defaultRightKeyDown:Bool = false;

	public function new(tree:LogicTree) {
		super(tree);

		tree.notifyOnInit(function() {
			State.active.notifyOnKeyPressed(updateKeyDownPressed);
			State.active.notifyOnKeyReleased(updateKeyDownReleased);
			State.active.notifyOnKeyPressed(addJumpForce);
			tree.notifyOnUpdate(update);
		});

		tree.notifyOnRemove(function() {
			State.active.removeOnKeyPressed(updateKeyDownPressed);
			State.active.removeOnKeyReleased(updateKeyDownReleased);
			State.active.removeOnKeyPressed(addJumpForce);
		});
	}

	function updateKeyDownPressed(p_keyCode:KeyCode) {
		if (p_keyCode == getKeyboard(defaultLeftKeyCode)) {
			defaultLeftKeyDown = true;
		} else if (p_keyCode == getKeyboard(defaultRightKeyCode)) {
			defaultRightKeyDown = true;
		}
	}

	function updateKeyDownReleased(p_keyCode:KeyCode) {
		if (p_keyCode == getKeyboard(defaultLeftKeyCode)) {
			defaultLeftKeyDown = false;
		} else if (p_keyCode == getKeyboard(defaultRightKeyCode)) {
			defaultRightKeyDown = false;
		}
	}

	function addJumpForce(p_keyCode:KeyCode) {
		var jumpForce:Float = inputs[2].get();

		if (p_keyCode == getKeyboard(defaultJumpKeyCode)) {
			if (tree.object.body != null) {
				tree.object.body.velocity.y = -jumpForce;
			}
		}
	}

	function update(dt:Float) {
		var speed:Float = inputs[1].get();

		if (tree.object.body != null) {
			var movementInput:Vector2 = new Vector2(0, 0);

			if (inputType == "Use default input") {
				if (defaultLeftKeyDown) {
					movementInput.x += -1;
				}
				if (defaultRightKeyDown) {
					movementInput.x += 1;
				}
			} else {
				movementInput.x = inputs[0].get().x;
			}

			var normalizedMovementInput:Vector2 = movementInput.normalize();
			tree.object.body.velocity.x = normalizedMovementInput.x * speed;
		}

		runOutput(0);
	}

	function getKeyboard(string:String):KeyCode {
		var key:KeyCode = KeyCode.Unknown;
		switch (string) {
			case "Up":
				key = Up;
			case "Down":
				key = Down;
			case "Left":
				key = Left;
			case "Right":
				key = Right;
			case "Space":
				key = Space;
			case "Return":
				key = Return;
			case "Shift":
				key = Shift;
			case "Tab":
				key = Tab;
			case "A":
				key = A;
			case "B":
				key = B;
			case "C":
				key = C;
			case "D":
				key = D;
			case "E":
				key = E;
			case "F":
				key = F;
			case "G":
				key = G;
			case "H":
				key = H;
			case "I":
				key = I;
			case "J":
				key = J;
			case "K":
				key = K;
			case "L":
				key = L;
			case "M":
				key = M;
			case "N":
				key = N;
			case "O":
				key = O;
			case "P":
				key = P;
			case "Q":
				key = Q;
			case "R":
				key = R;
			case "S":
				key = S;
			case "T":
				key = T;
			case "U":
				key = U;
			case "V":
				key = V;
			case "W":
				key = W;
			case "X":
				key = X;
			case "Y":
				key = Y;
			case "Z":
				key = Z;
		}
		return key;
	}
}
