package found.trait;

import found.object.Object.RotateData;
import found.object.Object.MoveData;

class TestScript extends found.Trait {
    public function new(){
        super();
        notifyOnInit(function (){
        //     this.object.translate(center);
        //     // this.object.rotate(function (data:RotateData){
        //     //     data._rotations.z+= 10*data.dt;
        //     //     return data;
        //     // },1.0);
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
}