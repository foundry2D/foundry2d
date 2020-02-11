package found.node;

import found.State;
import kha.input.KeyCode;

class OnKeyboardNode extends LogicNode {

	public var keyboardEventType: String;
	public var keyCode: String;
    var func:KeyCode->Void;
	public function new(tree: LogicTree) {
        super(tree);
        
        tree.notifyOnUpdate(update);
        func = function(p_keyCode:KeyCode){
            if(getKeyboard(keyCode)==p_keyCode){
                runOutput(0);
            }
        };
        
	}

	function update(dt:Float) {
		switch (keyboardEventType) {
            case "Released":
                State.active.notifyOnKeyUp(func);
                State.active.removeOnKeyDown(func);
            case "Down":
                State.active.notifyOnKeyDown(func);
                State.active.removeOnKeyUp(func);
		}
	}

    function getKeyboard(string:String):KeyCode {
        var key: KeyCode = null;
        switch (string){
            case "Up": key = Up;
            case "Down": key = Down;
            case "Left": key = Left;
            case "Right": key = Right;
            case "Space": key = Space;
            case "Return": key = Return;
            case "Shift": key = Shift;
            case "Tab": key = Tab;
            case "A": key = A;
            case "B": key = B;
            case "C": key = C;
            case "D": key = D;
            case "E": key = E;
            case "F": key = F;
            case "G": key = G;
            case "H": key = H;
            case "I": key = I;
            case "J": key = J;
            case "K": key = K;
            case "L": key = L;
            case "M": key = M;
            case "N": key = N;
            case "O": key = O;
            case "P": key = P;
            case "Q": key = Q;
            case "R": key = R;
            case "S": key = S;
            case "T": key = T;
            case "U": key = U;
            case "V": key = V;
            case "W": key = W;
            case "X": key = X;
            case "Y": key = Y;
            case "Z": key = Z;
        }
        return key;
    }
}