package found.node;

import found.object.Object;

class OnCollisionNode extends LogicNode {
	var collisionListeners:Array<echo.Listener>;

	public function new(tree:LogicTree) {
		super(tree);

		collisionListeners = [];

		tree.notifyOnInit(function() {
			if (inputs[0].node != null) {
				var selectedCollidingObject:Object = cast(inputs[0].get());

				var collisionDef:CollisionDef = {
					objectName: selectedCollidingObject.raw.name,
					onEnter: onCollisionEnterEvent,
					onStay: onCollisionStayEvent,
					onExit: onCollisionExitEvent
				};

				collisionListeners = collisionListeners.concat(tree.object.onCollision(collisionDef));
			}
			#if debug
			else {
				error("Top-down controller needs the object to have a Rigidbody");
			}
			#end
		});

		tree.notifyOnRemove(function() {
			tree.object.removeCollisionListeners(collisionListeners);
		});
	}

	function onCollisionEnterEvent(body:echo.Body, otherBody:echo.Body, data:Array<echo.data.Data.CollisionData>) {
		runOutput(0);
	}

	function onCollisionStayEvent(body:echo.Body, otherBody:echo.Body, data:Array<echo.data.Data.CollisionData>) {
		runOutput(1);
	}

	function onCollisionExitEvent(body:echo.Body, otherBody:echo.Body) {
		runOutput(2);
	}
}
