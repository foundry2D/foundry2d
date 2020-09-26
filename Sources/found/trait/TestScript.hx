package found.trait;

import found.object.Object.RotateData;
import found.object.Object.MoveData;

class TestScript extends found.Trait {
    public function new(){
        super();
        notifyOnInit(function(){
            this.object.onCollision({tileId: 70,objectName: "Tilemap",onEnter:onCollisionEnter });
        });
    }
    function onCollisionEnter(body:echo.Body,otherBody:echo.Body,data:Array<echo.data.Data.CollisionData>){
        if(body == this.object.body){
            trace(body.x +" "+body.y+ "x Y from current Object");
        }
        trace("Collided on spikes");
    }
}