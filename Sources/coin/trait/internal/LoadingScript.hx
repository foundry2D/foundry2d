package coin.trait.internal;


class LoadingScript extends coin.Trait {
    public function new(){
        super();
        notifyOnInit(function (){
            // this.object.position.x = Coin.BUFFERWIDTH*0.5-(this.object.width*this.object.scale.x)*0.5;
            // this.object.position.y = Coin.BUFFERHEIGHT*0.5-(this.object.height*this.object.scale.y)*0.5;
            this.object.position.x = (Coin.WIDTH*0.5-(this.object.width)*0.5);
            this.object.position.y = (Coin.HEIGHT*0.5+(this.object.height)*0.5)*this.object.scale.y;
            trace(this.object.position);
        });
        notifyOnUpdate(function(dt:Float){
            // State.active.cam.x+=0.01;
            // trace(this.object.scale.x);
            this.object.rotation+= 10*dt;
        });
    }
}