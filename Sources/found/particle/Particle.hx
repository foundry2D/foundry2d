package found.particle;


import kha.Canvas;
import kha.Color;

import found.object.Object;

class Particle extends Object {
	
	public function new(?x:Float, ?y:Float, ?width:Float, ?height:Float){
		super(x, y, width, height);
	}

	override public function update(dt:Float){
		super.update(dt);

		// velocity.y -= acceleration;
	}

	override public function render(canvas:Canvas){
		super.render(canvas);
		canvas.g2.color = Color.White;
		canvas.g2.fillRect(position.x, position.y, width, height);
	}
}