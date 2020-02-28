package found.node;

class OnMouseNode extends LogicNode {
	public var mouseEventType:String;
	public var mouseButton:String;

	var mouseDown:Bool = false;

	public function new(tree:LogicTree) {
		super(tree);

		tree.notifyOnInit(function() {
			switch (mouseEventType) {
				case "Released":
					State.active.notifyOnMouseReleased(onMouseEvent);
				case "Pressed":
					State.active.notifyOnMousePressed(onMouseEvent);
				case "Down":
					State.active.notifyOnMousePressed(updateMouseDownPressed);
					State.active.notifyOnMouseReleased(updateMouseDownReleased);
					tree.notifyOnUpdate(update);
				case "Moved":
					State.active.notifyOnMouseMove(onMouseMovedEvent);
			}
		});

		tree.notifyOnRemove(function() {
			State.active.removeOnMouseReleased(onMouseEvent);
			State.active.removeOnMousePressed(onMouseEvent);
			State.active.removeOnMousePressed(updateMouseDownPressed);
			State.active.removeOnMouseReleased(updateMouseDownReleased);
			State.active.removeOnMouseMove(onMouseMovedEvent);
		});
	}

	function update(dt:Float) {
		if (mouseDown) {
			runOutput(0);
		}
	}

	function onMouseEvent(button:Int, x:Int, y:Int) {
		if (getMouseButton(mouseButton) == button) {
			runOutput(0);
		}
	}

	function updateMouseDownPressed(button:Int, x:Int, y:Int) {
		if (getMouseButton(mouseButton) == button) {
			mouseDown = true;
		}
	}

	function updateMouseDownReleased(button:Int, x:Int, y:Int) {
		if (getMouseButton(mouseButton) == button) {
			mouseDown = false;
		}
	}

	function onMouseMovedEvent(x:Int, y:Int, cx:Int, cy:Int) {
		runOutput(0);
	}

	function getMouseButton(string:String):Int {
		var btn:Int = 0;
		switch (string) {
			case "Left":
				btn = 0;
			case "Right":
				btn = 1;
			case "Middle":
				btn = 2;
		}
		return btn;
	}
}
