package found.trait.internal;

import kha.math.Vector2;
import found.Input.Mouse;
import kha.graphics2.Graphics;

class Arrows extends Trait {
    public static var instance(get,null):Arrows;
    public var visible:Bool =false;
    var mouse:Mouse;
    static function get_instance() {
        if(instance == null) instance = new Arrows();
        return instance;
    }
    public function new() {
        super();
        mouse = Input.getMouse();
        notifyOnRender2D(render);
    }
    var rectSize:Float;
    var height:Float;
    var width:Float;
    var rectPos:Vector2 = new Vector2();
    var hPos:Vector2 = new Vector2();
    var vPos:Vector2 = new Vector2();
    function update(){
        var pos = new Vector2(this.object.position.x,this.object.position.y);
        var mpos = State.active.cam.screenToWorld(new Vector2(mouse.x,mouse.y));

        var hpos = pos.add(hPos);
        if(mouse.down("left") && mpos.x > hpos.x && mpos.x < hpos.x + width && mpos.y > hpos.y && mpos.y < hpos.y + rectSize){
            #if editor
            EditorUi.arrow = 0;
            #end
        }
        var vpos = pos.add(vPos);
        if(mouse.down("left") && mpos.x > vpos.x && mpos.x < vpos.x + rectSize && mpos.y > vpos.y && mpos.y < vpos.y + width){
            #if editor
            EditorUi.arrow = 1;
            #end
        }
        var rpos = pos.add(rectPos);
        if(mouse.down("left") && mpos.x > rpos.x && mpos.x < rpos.x + rectSize && mpos.y > rpos.y && mpos.y < rpos.y + rectSize){
            #if editor
            EditorUi.arrow = 2;
            #end
        }
    }
    function render(g:Graphics){
        if(!visible || this.object == State.active.cam #if editor || found.App.editorui.currentView != 0#end)return;
        height = rectSize = Found.popupZuiInstance.ELEMENT_H() * 0.5;
        width = Found.popupZuiInstance.ELEMENT_W();
        rectPos.x = 0;
        rectPos.y = -rectSize;
        hPos.x = rectSize;
        hPos.y =  -rectSize;
        vPos.x = 0;
        vPos.y =  -rectSize - width;
        update();
        var size = rectSize * 0.33;
        g.color  = kha.Color.Yellow;
        g.fillRect(rectPos.x,rectPos.y,rectSize,rectSize);
        g.color  = kha.Color.Green;
        var w = width-rectSize; 
        g.fillRect(hPos.x,hPos.y + rectSize * 0.5 - size *0.5,w,size);
        g.fillTriangle(hPos.x+w,hPos.y,hPos.x+width,hPos.y + rectSize * 0.5,hPos.x + w,hPos.y+rectSize);
        g.color  = kha.Color.Red;
        g.fillRect(vPos.x + rectSize * 0.5 -size *0.5,vPos.y+rectSize,size,w);
        g.fillTriangle(vPos.x,vPos.y+rectSize,vPos.x+rectSize,vPos.y+rectSize,vPos.x+rectSize * 0.5,vPos.y);
    }
}