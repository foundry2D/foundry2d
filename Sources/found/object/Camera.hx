package found.object;


import kha.math.Vector4;
import found.math.Util;
import kha.math.FastMatrix3;
import kha.Canvas;
import kha.math.Vector2;
import found.data.SceneFormat.TCameraData;

class Camera extends Object {
	public var origin(get,null):Vector2 = new Vector2();
	function get_origin(){
		origin.x = width * 0.5;
		origin.y = height * 0.5; 
		return origin;
	}

	var camSpeedX:Float = 3;
	var camSpeedY:Float = 5;

	public var offsetX:Float = 15;
	public var offsetY:Float = 25;

	public var zoom:Float = 1.0;
	var lastParallax = 1.0;
	public function getTransformation(parallax:Float) {
		lastParallax = parallax;
		var center = origin;
		var transformation = FastMatrix3.identity();
		transformation.setFrom(FastMatrix3.scale(zoom,zoom).multmat(transformation));
		transformation.setFrom(FastMatrix3.translation(center.x, center.y).multmat(FastMatrix3.rotation(-Util.degToRad(rotation.z))).multmat(FastMatrix3.translation(-center.x, -center.y)).multmat(transformation));
		transformation.setFrom(FastMatrix3.translation(center.x, center.y).multmat(transformation));
		transformation.setFrom(FastMatrix3.translation(-position.x*parallax, -position.y*parallax).multmat(transformation));
		return transformation;
    }

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
		this.width = data.width < 1.0 ? Found.WIDTH : data.width;
		this.height = data.height < 1.0 ? Found.HEIGHT : data.height;
	}

	public function move(movement:Vector2,considerRotation = false) {
		if (considerRotation)
		{
			movement = cast(FastMatrix3.rotation(Util.degToRad(rotation.z)).multvec(cast(movement)));
		}
		this.position.x += movement.x;
		this.position.y += movement.y;
		
		
	}

    public function lookAt(obj:Object){
		this.position.x = (obj.position.x + obj.width * 0.5) * zoom;
		this.position.y = (obj.position.y + obj.height * 0.5) * zoom;
	}
	public override function moveTowards(target:Vector2, step:Float) {
		warn("Use the move function instead for the camera.");
	}

	public function setCameraFollowTarget(p:Object) {
		target = p;
	}

	public function worldToScreen( worldPosition:Vector2, ?parallaxSpeed:Float = null ):Vector2
	{
		var speed = parallaxSpeed != null ? parallaxSpeed : lastParallax;
	   return cast(getTransformation(speed).multvec(cast(worldPosition)));
	}
  
	public function screenToWorld(screenPosition:Vector2, ?parallaxSpeed:Float = null):Vector2
	{
		var speed = parallaxSpeed != null ? parallaxSpeed : lastParallax;
	   return cast(getTransformation(speed).inverse().multvec(cast(screenPosition)));
	}

	public override function render(canvas:Canvas) {
		if (!Scene.ready)
			return;
		super.render(canvas);
		#if debug
		canvas.g2.color = kha.Color.Red;
		var center = origin;
		canvas.g2.drawRect(center.x, center.y, offsetX, offsetX);
		canvas.g2.color = kha.Color.White;
		#end
	}
}
