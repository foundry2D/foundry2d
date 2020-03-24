package found.node;

import found.State;
import kha.input.KeyCode;

class OnKeyboardNode extends LogicNode {
	public var keyboardEventType:String;
	public var keyCode:String;

	var keyDown:Bool = false;

	public function new(tree:LogicTree) {
		super(tree);

		tree.notifyOnInit(function() {
			switch (keyboardEventType) {
				case "Released":
					State.active.notifyOnKeyReleased(onKeyEvent);
				case "Pressed":
					State.active.notifyOnKeyPressed(onKeyEvent);
				case "Down":
					State.active.notifyOnKeyPressed(updateKeyDownPressed);
					State.active.notifyOnKeyReleased(updateKeyDownReleased);
					tree.notifyOnUpdate(update);
			}
		});

		tree.notifyOnRemove(function() {
			State.active.removeOnKeyPressed(onKeyEvent);
			State.active.removeOnKeyReleased(onKeyEvent);
			State.active.removeOnKeyPressed(updateKeyDownPressed);
			State.active.removeOnKeyReleased(updateKeyDownReleased);
		});
	}

	function update(dt:Float) {
		if (keyDown) {
			runOutput(0);
		}
	}

	function onKeyEvent(p_keyCode:KeyCode) {
		if (getKeyboard(keyCode) == p_keyCode) {
			runOutput(0);
		}
	}

	function updateKeyDownPressed(p_keyCode:KeyCode) {
		if (getKeyboard(keyCode) == p_keyCode) {
			keyDown = true;
		}
	}

	function updateKeyDownReleased(p_keyCode:KeyCode) {
		if (getKeyboard(keyCode) == p_keyCode) {
			keyDown = false;
		}
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
