package coin.trait.internal;


class LoadingScript extends coin.Trait {
    public function new(){
        super();
        notifyOnInit(function (){
            this.object.position.x = Coin.WIDTH*0.5-this.object.width*0.5;
            this.object.position.y = Coin.HEIGHT*0.5-this.object.height*0.5;
        });
        notifyOnUpdate(function(dt:Float){
            
            this.object.rotation+= 10*dt;
        });
    }
}