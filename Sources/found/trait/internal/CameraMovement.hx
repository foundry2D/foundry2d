package found.trait.internal;

import kha.math.Vector2;
import found.object.Camera;
import found.math.Util;

@:access(found.object.Camera)
class CameraMovement extends found.Trait {
    var camera:Camera;
    public var considerRotation:Bool = false;
    public function new(){
        super();
        this.notifyOnInit(function(){
            this.camera = cast(this.object,Camera);
        });
        notifyOnUpdate(update);
    }
    function update(dt:Float){
		if (camera.target != null){
            var pos = camera.target.center.mult(camera.zoom);
            var center = camera.origin;
            var lpos = new Vector2(camera.position.x,camera.position.y);
			if (camera.offsetX < Math.abs(Math.abs(camera.position.x - center.x) - pos.x)) {
				lpos.x = Util.lerp(camera.position.x, pos.x - center.x, camera.camSpeedX * Timer.delta);
			}
			if (camera.offsetY < Math.abs(Math.abs(camera.position.y - center.y) - pos.y)) {
				lpos.y = Util.lerp(camera.position.y, pos.y - center.y, camera.camSpeedY * Timer.delta);
            }
            camera.move(lpos.sub(camera.position),considerRotation);
            
        }
        
        if(Input.getKeyboard().down("w") && camera.zoom <= 2.0){
            camera.zoom += 0.1;
        }
        else if(Input.getKeyboard().down("s") && camera.zoom >= 0.1){
            camera.zoom -= 0.1;
        }
	}
}