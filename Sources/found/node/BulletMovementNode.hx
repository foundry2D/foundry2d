package found.node;

import found.math.Util;
import kha.math.Vector2;

class BulletMovementNode extends LogicNode {
	public function new(tree:LogicTree) {
		super(tree);

		tree.notifyOnInit(setVelocity);
	}
	function setVelocity() {
		if (tree.object.body != null) {
			var speed:Float = inputs[1].get();
			var angle:Float = tree.object.rotation.z;

			var newVelocity:Vector2 = new Vector2();
			var rotationInRadians:Float = Util.degToRad(angle);
			newVelocity.x = Math.cos(rotationInRadians) * speed;
			newVelocity.y = Math.sin(rotationInRadians) * speed;

			tree.object.body.velocity = newVelocity;
		}
		#if debug
		else {
			error("Bullet Movement node needs the object to have a Rigidbody");
		}
		#end
	}
	override function run(from:Int) {
		setVelocity();
	}
}
