package coin.tool;
// #if tile_editor
import kha.math.Vector2;
import coin.data.SpriteData;
import kha.graphics4.Graphics2;
import coin.anim.Tilemap;
import coin.zui.Zui;
import coin.zui.Id;
import coin.zui.Ext;
import coin.data.SceneFormat;
import kha.Assets;

typedef Selection = {
    var index:Int;
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
    public var x:Int = 512;
    public var y:Int = 256;
    public var visible:Bool;
    static var selectedMap:Int = -1;
    static var tilemapIds:Array<Int> = []; 
    var curTile:coin.anim.Tile;
    public function new(visible = true) {
        this.visible = visible;
        ui = new coin.zui.Zui({font: kha.Assets.fonts.font_default});
        width = Std.int(Coin.WIDTH*0.175);
        height = Std.int(Coin.HEIGHT*0.8);
    }
    var map:Tilemap = null;
    var tileSelected:Selection = null;
    var tileHandle = Id.handle({value: 0});
    @:access(coin.zui.Zui,coin.anim.Tilemap,coin.anim.Tile)
    public function render(canvas:kha.Canvas): Void {
        if(!visible || selectedMap < 0)return;
        ui.begin(canvas.g2);
        
        if(map == null){
            map = cast(coin.State.active._entities[tilemapIds[selectedMap]]);
            curTile = map.tiles[0];
        }
        var newSelection = selectedMap;
        if (ui.window(coin.zui.Id.handle(),x,y, width, height, true)) {

            endHeight = ui._y;
			if (ui.panel(Id.handle({selected: true}), "Tilemap editor")) {
				ui.indent();
				ui.text("Text");
                newSelection = Ext.list(ui, Id.handle(), tilemapIds);
                map.w = Std.int(ui.slider(Id.handle({value: map.tw}), "Map Width",0,Math.pow(256,2),false,100,true,Right,true,map.tw));
                map.h = Std.int(ui.slider(Id.handle({value: map.th}), "Map Height",0,Math.pow(256,2),false,100,true,Right,true,map.th));
                map.tw = Std.int(Ext.floatInput(ui, Id.handle({value: 64.0}), "Tile Width"));
                map.th = Std.int(Ext.floatInput(ui, Id.handle({value: 64.0}), "Tile Height"));
				
                //Tilemap drawing with selection
                var r = ui.curRatio == -1 ? 1.0 : ui.ratios[ui.curRatio];
                var px = ui._x+ui.buttonOffsetY+ui.SCROLL_W() * r*0.5;
                var py = ui._y;
                var curImg = curTile.data.image;
                var state = ui.image(curImg);
                var ratio = Math.abs((py-ui._y)/curImg.height);
                var invRatio = Math.abs(curImg.height/(py-ui._y));
                var maxTiles = (curImg.width /map.tw) * (curImg.height/map.th)-1;

                ui.g.color = kha.Color.fromBytes(0,0,200,128);
                if(tileSelected == null){
                    //We always select the tile at index 0
                    tileSelected = {index:0,x:px,y:py,w:map.tw*ratio,h:map.th*ratio};
                    ui.g.fillRect(tileSelected.x,tileSelected.y,tileSelected.w,tileSelected.h);
                }else{
                    ui.g.fillRect(tileSelected.x,tileSelected.y,tileSelected.w,tileSelected.h);
                }
                if(state == coin.zui.Zui.State.Down || tileHandle.changed ){
                    var x = Math.abs(ui._windowX-ui.inputX);
                    var y = Math.abs(ui._windowY-ui.inputY);
                    var imgX =(x-px)*invRatio;
                    var imgY = (y-py)*invRatio;
                    imgX += map.tw - Math.floor(imgX) % map.tw;
                    imgY += map.tw - Math.floor(imgY) % map.tw;
                    var widthIndicies = Std.int(curImg.width/map.tw);
                    var index = Std.int(tileHandle.value);
                    if(!tileHandle.changed){
                        index = Std.int(widthIndicies-(curImg.width -imgX)/map.tw)-1;
                        index += widthIndicies*Std.int(curImg.height/map.tw - (curImg.height -imgY)/map.tw-1);
                    }   
                    x = (Std.int(index * map.tw) % (curImg.width))*ratio +px;
                    y = (Math.floor(index * map.tw/curImg.width)*(map.th))*ratio+py;
                    tileSelected = {index:index,x:x,y:y,w:map.tw*ratio,h:map.th*ratio};
                }
                tileHandle.value = tileSelected.index;
                ui.slider(tileHandle, "Selected Tile",0,maxTiles,false,100,true,Right,true,1);

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
            endHeight = Math.abs(endHeight-ui._y);
        }
        ui.end();
        //Draw mouse Icon
        if(isInScreen()){
            kha.input.Mouse.get(0).hideSystemCursor();
            canvas.g2.begin(false,0x00000000);
            canvas.g2.color = kha.Color.White;
            canvas.g2.drawScaledImage(kha.Assets.images.basic,Coin.mouseX,Coin.mouseY,10,10);
            
            //Scale tile w/h
            var w = curTile._w;
            var h = curTile._h;
            var temp = scaleToScreen(w,h);
            curTile._w = temp.width;
            curTile._h = temp.height;
            //Scale map tile w/h
            var tw = map.tw;
            var th = map.th;
            var tempMap = scaleToScreen(tw,th);
            map.tw = Std.int(tempMap.width);
            map.th = Std.int(tempMap.height);
            //Scale image w/h
            var wNh = scaleToScreen(curTile.data.image.width,curTile.data.image.height);
            vec.x=Coin.mouseX-curTile._w;
            vec.y = Coin.mouseY;
            
            curTile.render(canvas,vec,wNh,kha.Color.fromBytes(255,255,255,128));
            canvas.g2.end();
            curTile._w = w;
            curTile._h = h;
            map.tw = tw;
            map.th= th;
        }
        else{
            kha.input.Mouse.get(0).showSystemCursor();
        }

        if(selectedMap != newSelection){
            map = null;
            curTile = null;
        }
    }
    var vec:kha.math.Vector2 =  new Vector2();
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

    var endHeight = 0.0;
    @:access(coin.zui.Zui)
    function isInScreen(){
        #if editor
        var gv = App.editorui.gameView;
        var x = Coin.fullscreen ? 0: gv.screenX;
        var y = Coin.fullscreen ? 0:gv.screenY;
        var w = Coin.fullscreen ? Coin.WIDTH:gv.width;
        var h = Coin.fullscreen ? Coin.HEIGHT:gv.height;
        #else
        var x = State.active.cam.x;
        var y = State.active.cam.y;
        var w = Coin.WIDTH;
        var h = Coin.HEIGHT;
        #end
        var out = Coin.mouseX > x &&
                Coin.mouseX < x+w &&
                Coin.mouseY > y &&
                Coin.mouseY < y+h &&
                (Coin.mouseY < ui._windowY ||
                Coin.mouseY > ui._windowY+endHeight ||
                Coin.mouseX < ui._windowX ||
                Coin.mouseX > ui._windowX+width);
        return out;
    }
    function scaleToScreen(w:Float,h:Float){
        #if editor
        var gv = App.editorui.gameView;
        var outW = Coin.fullscreen ? w : w*(gv.width/Coin.WIDTH);
        var outH = Coin.fullscreen ? h : h*(gv.height/Coin.HEIGHT);
        return {width: outW, height: outH};
        #else
        return {width: w, height: h};
        #end
    }
}
// #end