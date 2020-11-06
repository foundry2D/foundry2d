package found.trait.internal;

import found.object.Camera;
import found.math.Util;

@:access(found.object.Camera)
class CameraMovement extends found.Trait {
    var camera:Camera;
    public function new(){
        super();
        this.notifyOnInit(function(){
            this.camera = cast(this.object,Camera);
        });
        notifyOnUpdate(update);
    }
    function update(dt:Float){
		if (camera.target != null){
			if (camera.offsetX < Math.abs(Math.abs(camera.viewX) - camera.target.center.x)) {
				camera.position.x = Util.lerp(camera.position.x, camera.target.center.x - 0.5 * Found.WIDTH, camera.camSpeedX * Timer.delta);
			}
			if (camera.offsetY < Math.abs(Math.abs(camera.viewY) - camera.target.center.y)) {
				camera.position.y = Util.lerp(camera.position.y, camera.target.center.y - 0.5 * Found.HEIGHT, camera.camSpeedY * Timer.delta);
			}
		}
	}
}