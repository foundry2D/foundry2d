package found.object;

import kha.Canvas;
import found.data.SceneFormat.TCameraData;
import found.math.Util;

class Camera extends Object {

    public var viewX(get, null):Float;
    public var viewY(get, null):Float;
    var camSpeedX:Float = 3;
    var camSpeedY:Float = 5;
    public var offsetX:Float =15;
    public var offsetY:Float =25;

    var target:Null<Object> = null;

    public function new(data:TCameraData) {
        super(data.position.x,data.position.y,data.width,data.height);
        offsetX = data.offsetX;
        offsetY = data.offsetY;
        camSpeedX = data.speedX;
        camSpeedY = data.speedY;
    }
    public function setTarget(p:Object){
        this.position.x = 0.5 * Found.WIDTH - p.position.x;
        this.position.y = 0.5 * Found.HEIGHT - p.position.y;
        target = p;
    }

    private function get_viewX():Float
    {
        return 0.5 * Found.WIDTH - this.position.x;
    }
    private function get_viewY():Float
    {
        return 0.5 * Found.HEIGHT - this.position.y;
    }

    public override function update(dt:Float){
        if(target == null)
            return;
        if( offsetX < Math.abs(Math.abs(this.viewX)-target.position.x)){
            this.position.x = Util.lerp(this.position.x,0.5 * Found.WIDTH - target.position.x,camSpeedX*dt);
        }
        if(offsetY < Math.abs(Math.abs(this.viewY)-target.position.y)){
            this.position.y = Util.lerp(this.position.y,0.5 * Found.HEIGHT - target.position.y,camSpeedY*dt);
        }
    }
    public override function render(canvas:Canvas) {
        if (!active || !Scene.ready) return;
        #if debug
        canvas.g2.color = kha.Color.Red;
        canvas.g2.drawRect(0.5*Found.WIDTH-this.position.x,0.5*Found.HEIGHT-this.position.y,offsetX,offsetX);
        canvas.g2.color = kha.Color.White;
        #end
    }
}