package found.node;

import found.Input.Keyboard;
import hxmath.math.Vector2;

class TopDownControllerNode extends LogicNode {
	public var inputType:String;
	public var defaultUpKeyCode:String;
	public var defaultDownKeyCode:String;
	public var defaultLeftKeyCode:String;
	public var defaultRightKeyCode:String;

	public function new(tree:LogicTree) {
		super(tree);

		#if debug
		tree.notifyOnInit(function(){
			if (tree.object.body == null){
				error("Top-down controller needs the object to have a Rigidbody");
			}
		});
		#end
		tree.notifyOnUpdate(update);
	}	

	function update(dt:Float) {
		var keyboard:Keyboard = Input.getKeyboard();
		var speed:Float = inputs[1].get();

		if (tree.object.body != null) {
			var movementInput:Vector2 = new Vector2(0, 0);

			if (inputType == "Use default input") {
				if (keyboard.down(defaultUpKeyCode)) {
					movementInput.y += -1;
				}
				if (keyboard.down(defaultDownKeyCode)) {
					movementInput.y += 1;
				}
				if (keyboard.down(defaultLeftKeyCode)) {
					movementInput.x += -1;
				}
				if (keyboard.down(defaultRightKeyCode)) {
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
