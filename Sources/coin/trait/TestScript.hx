package coin.trait;

import coin.object.Object.RotateData;
import coin.object.Object.MoveData;

class TestScript extends coin.Trait {
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