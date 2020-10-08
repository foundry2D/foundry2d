package found.object;


import kha.Canvas;
import kha.math.Vector2;
import found.data.SceneFormat.TCameraData;
import found.math.Util;

class Camera extends Object {
	public var viewX(get, null):Float;
	public var viewY(get, null):Float;

	var camSpeedX:Float = 3;
	var camSpeedY:Float = 5;

	public var offsetX:Float = 15;
	public var offsetY:Float = 25;

	var target:Null<Object> = null;

	public function new(data:TCameraData) {
		super(data);
		if (data.offsetX != null)
			offsetX = data.offsetX;
		if (data.offsetY != null)
			offsetY = data.offsetY;
		if (data.speedX != null)
			camSpeedX = data.speedX;
		if (data.speedY != null)
			camSpeedY = data.speedY;
	}

	public function setCameraTargetPosition(position:Vector2) {
		this.position.x = position.x - 0.5 * Found.WIDTH;
		this.position.y = position.y - 0.5 * Found.HEIGHT;
	}

	public function setCameraFollowTarget(p:Object) {
		target = p;
	}

	private function get_viewX():Float {
		return this.position.x + 0.5 * Found.WIDTH;
	}

	private function get_viewY():Float {
		return this.position.y + 0.5 * Found.HEIGHT;
	}

	public override function render(canvas:Canvas) {
		if (!Scene.ready)
			return;
		if (target != null #if editor && App.editorui.isPlayMode#end ){
			if (offsetX < Math.abs(Math.abs(this.viewX) - target.center.x)) {
				this.position.x = Util.lerp(this.position.x, target.center.x - 0.5 * Found.WIDTH, camSpeedX * Timer.delta);
			}
			if (offsetY < Math.abs(Math.abs(this.viewY) - target.center.y)) {
				this.position.y = Util.lerp(this.position.y, target.center.y - 0.5 * Found.HEIGHT, camSpeedY * Timer.delta);
			}
		}
		#if debug
		canvas.g2.color = kha.Color.Red;
		canvas.g2.drawRect(0.5 * Found.WIDTH - this.position.x, 0.5 * Found.HEIGHT - this.position.y, offsetX, offsetX);
		canvas.g2.color = kha.Color.White;
		#end
	}
}
