package found.trait.internal;

import found.object.Object.RotateData;
import found.object.Object.MoveData;

class LoadingScript extends found.Trait {
    public function new(){
        super();
        notifyOnInit(doStuff);
        notifyOnInit(function (){
            this.object.translate(center);
            // this.object.rotate(function (data:RotateData){
            //     data._rotations.z+= 10*data.dt;
            //     return data;
            // },1.0);
        });
        notifyOnUpdate(function(dt:Float){
            // this.object.rotate(function (data:RotateData){
            //     data._rotations.z+= 10*data.dt;
            //     return data;
            // },dt);
            // State.active.cam.x-=1.0;
            // this.object.translate(move,dt);
            // this.object.rotation+= 10*dt;
        });
    }
    function doStuff(){
        trace("Hello World !");
    }
    function center(data:MoveData){
        data._positions.x = (Found.WIDTH*0.5-(this.object.width)*0.5);
        data._positions.y = (Found.HEIGHT*0.5-(this.object.height)*0.5);
        return data;
    }
    function move(data:MoveData){
        var speed = 25.0;
        data._positions.x += speed*data.dt;
        return data;
    }
}