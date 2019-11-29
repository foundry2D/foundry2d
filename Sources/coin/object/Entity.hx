package coin.object;

import kha.math.Vector2;

import coin.collide.Rectangle;
import coin.tool.Direction;

class Entity extends Rectangle {
	public function new(x:Float, y:Float, ?width:Float, ?height:Float){
		super(x, y, width, height);
	}

	override public function update(dt:Float){
		super.update(dt);

		// position.x += velocity.x * speed;
		// position.y += velocity.y * speed;
		// velocity.x *= (1 - Math.min(1 / 60 * friction, 1));
		// velocity.y *= (1 - Math.min(1 / 60 * friction, 1));
	}
}