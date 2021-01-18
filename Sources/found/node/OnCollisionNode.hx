package found.node;

import found.object.Object;

class OnCollisionNode extends LogicNode {
	var collisionListeners:Array<echo.Listener>;

	public function new(tree:LogicTree) {
		super(tree);

		collisionListeners = [];

		tree.notifyOnRemove(function() {
			tree.object.removeCollisionListeners(collisionListeners);
		});
	}

	override function run(from:Int) {
		if (inputs[1].node != null) {
			var selectedCollidingObject:Object = cast(inputs[1].get());
			var tileid:Null<Int> = inputs[2].get();

			var collisionDef:CollisionDef = {
				objectName: selectedCollidingObject.raw.name,
				onEnter: onCollisionEnterEvent,
				onStay: onCollisionStayEvent,
				onExit: onCollisionExitEvent,
				tileId: tileid
			};

			collisionListeners = collisionListeners.concat(tree.object.onCollision(collisionDef));
		}
		#if debug
		else {
			error("On Collision node needs an object to check collisions with");
		}
		#end
	}
	var lastBody:echo.Body;
	function onCollisionEnterEvent(body:echo.Body, otherBody:echo.Body, data:Array<echo.data.Data.CollisionData>) {
		lastBody = otherBody;
		runOutput(0);
	}

	function onCollisionStayEvent(body:echo.Body, otherBody:echo.Body, data:Array<echo.data.Data.CollisionData>) {
		lastBody = otherBody;
		runOutput(1);
	}

	function onCollisionExitEvent(body:echo.Body, otherBody:echo.Body) {
		lastBody = otherBody;
		runOutput(2);
	}

	@:access(found.anim.Tilemap)
	override function get(from:Int):Dynamic {
		return lastBody.object;
	}
}
