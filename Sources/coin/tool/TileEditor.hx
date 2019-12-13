package coin.tool;
// #if tile_editor
import coin.anim.Tilemap;
import coin.zui.Zui;
import coin.zui.Id;
import coin.zui.Ext;
import coin.data.SceneFormat;
import kha.Assets;

typedef Selection = {
    var x:Float;
    var y:Float;
    var w:Float;
    var h:Float;
}

class TileEditor {
    var ui: Zui;
    var itemList:Array<TTileData> = [];
    var width:Int;
    var height:Int;
    public var x:Int = 10;
    public var y:Int = 10;
    public var visible:Bool;
    public static var selectedMap:Int = -1;
    public static var tilemapIds:Array<Int> = [];

    public function new(visible = true) {
        this.visible = visible;
        ui = new Zui({font: Assets.fonts.font_default});
        width = Std.int(Coin.WIDTH*0.175);
        height = Std.int(Coin.HEIGHT*0.8);
    }
    var map:Tilemap = null;
    var tileSelected:Selection = null;
    @:access(coin.zui.Zui)
    public function render(canvas:kha.Canvas): Void {
        if(!visible || selectedMap < 0)return;
        ui.begin(canvas.g2);
        if(map == null){
            map = cast(coin.State.active._entities[tilemapIds[selectedMap]]);
        }
        var newSelection = selectedMap;
        if (ui.window(Id.handle(),x,y, width, height, true)) {
			if (ui.panel(Id.handle({selected: true}), "Tilemap editor")) {
				ui.indent();
				ui.text("Text");
                newSelection = Ext.list(ui, Id.handle(), tilemapIds);
                map.w = Std.int(ui.slider(Id.handle({value: map.tw}), "Map Width",-1000,1000));
                map.h = Std.int(ui.slider(Id.handle({value: map.th}), "Map Height",-1000,1000));
                map.tw = Std.int(Ext.floatInput(ui, Id.handle({value: 64.0}), "Tile Width"));
                map.th = Std.int(Ext.floatInput(ui, Id.handle({value: 64.0}), "Tile Height"));
				
                var px = ui._x;
                var py = ui._y;
                var curImg = map.imageData[0].image;
                var state = ui.image(curImg);
                var ratio = Math.abs((py-ui._y)/curImg.height);
                ui.g.color = kha.Color.fromBytes(0,0,200,128);
                if(tileSelected == null){
                    //We always select the tile at index 0
                    tileSelected = {x:px,y:py,w:map.tw*ratio,h:map.th*ratio};
                    ui.g.fillRect(tileSelected.x,tileSelected.y,tileSelected.w,tileSelected.h);
                }else{
                    ui.g.fillRect(tileSelected.x,tileSelected.y,tileSelected.w,tileSelected.h);
                }
                if(state == coin.zui.Zui.State.Down){
                    trace("Mouse input X is: "+ui.inputX+"Y is: "+ui.inputY);
                    var x = ui._x-ui.inputX-ui.arrowOffsetX;
                    var y = ui._y-ui.inputY-ui.arrowOffsetY;
                    trace(x,y);
                    tileSelected = {x:x,y:y,w:map.tw*ratio,h:map.th*ratio};
                }
                ui.g.color = kha.Color.White;
                // ui.textInput(Id.handle({text: "Hello"}), "Input");
				

                ui.check(Id.handle(), "Cull");
                ui.slider(Id.handle({value: 1.0}), "Cull offset", 0, 500);
                // var hradio = Id.handle();
                // ui.radio(hradio, 0, "Radio 1");
                // ui.radio(hradio, 1, "Radio 2");
                // ui.radio(hradio, 2, "Radio 3");
                // Ext.inlineRadio(ui, Id.handle(), ["High", "Medium", "Low"]);
                // ui.combo(Id.handle(), ["Item 1", "Item 2", "Item 3"], "Combo", true);
                // if (ui.panel(Id.handle({selected: false}), "Nested Panel")) {
                //     ui.indent();
                //     ui.text("Row");
                //     ui.row([2/5, 2/5, 1/5]);
                //     ui.button("A");
                //     ui.button("B");
                //     ui.check(Id.handle(), "C");
                //     ui.text("Simple list");
                    
                //     ui.unindent();
                // }
                // Ext.floatInput(ui, Id.handle({value: 42.0}), "Float Input");
                // ui.slider(Id.handle({value: 0.2}), "Slider", 0, 1);
                // if (ui.isHovered) ui.tooltip("Slider tooltip");
                // ui.slider(Id.handle({value: 0.4}), "Slider 2", 0, 1.2, true);
                // Ext.colorPicker(ui, Id.handle());
                ui.separator();
                ui.unindent();
            }
        }
        ui.end();
        if(selectedMap != newSelection){
            map = null;
        }
    }
    public function selectMap(uid:Int){
        selectedMap = -1;
        for(i in 0...tilemapIds.length){
            if(tilemapIds[i] == uid){
                selectedMap = i;
            }
        }
        if(selectedMap ==-1){
            selectedMap = tilemapIds.push(uid)-1;
        }
    }
}
// #end