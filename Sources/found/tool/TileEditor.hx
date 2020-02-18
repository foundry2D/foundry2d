package found.tool;
// #if tile_editor
import kha.math.Vector2;
import found.data.SpriteData;
import kha.graphics4.Graphics2;
import found.anim.Tilemap;
import found.zui.Zui;
import found.zui.Id;
import found.zui.Ext;
import found.data.SceneFormat;
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
    var curTile:found.anim.Tile;
    public function new(visible = true) {
        this.visible = visible;
        ui = new found.zui.Zui({font: kha.Assets.fonts.font_default});
        width = Std.int(Found.WIDTH*0.175);
        height = Std.int(Found.HEIGHT*0.8);
    }
    var map:Tilemap = null;
    var tileSelected:Selection = null;
    var tileHandle = Id.handle({value: 0});
    var unusedIds:Array<Int> = [];
    @:access(found.zui.Zui,found.anim.Tilemap,found.anim.Tile)
    public function render(canvas:kha.Canvas): Void {
        if(!visible || selectedMap < 0)return;
        ui.begin(canvas.g2);
        
        if(map == null){
            map = cast(found.State.active._entities[tilemapIds[selectedMap]]);
            curTile = map.tiles[0];
        }
        var newSelection = selectedMap;
        var vec:kha.math.Vector2 =  new Vector2();
        if (ui.window(found.zui.Id.handle(),x,y, width, height, true)) {

            endHeight = ui._y;
			if (ui.panel(Id.handle({selected: true}), "Tilemap editor")) {
				ui.indent();
				ui.text("Text");
                newSelection = Ext.list(ui, Id.handle(), tilemapIds);
                map.w = Std.int(ui.slider(Id.handle({value: map.w}), "Map Width",0,Math.pow(256,2),false,1/map.tw));
                map.h = Std.int(ui.slider(Id.handle({value: map.h}), "Map Height",0,Math.pow(256,2),false,1/map.th));
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
                if(state == found.zui.Zui.State.Down || tileHandle.changed ){
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
                    if(!map.tiles.exists(index)){
                        var value = curTile.raw.usedIds.push(index)-1;
                        unusedIds.push(index);
                        curTile = found.anim.Tile.createTile(map,curTile.raw,value);
                    }
                    
                }
                tileHandle.value = tileSelected.index;
                ui.slider(tileHandle, "Selected Tile",0,maxTiles);

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
        
        if(isInScreen()){
            //Draw mouse Icon
            kha.input.Mouse.get(0).hideSystemCursor();
            canvas.g2.begin(false,0x00000000);
            canvas.g2.color = kha.Color.White;
            canvas.g2.drawScaledImage(kha.Assets.images.basic,Found.mouseX,Found.mouseY,10,10);
            
            //Scale tile w/h
            //Scale image w/h
            var temp = scaleToScreen(1.0,1.0);
            var px:Float = Math.abs(Found.mouseX) < Found.GRID*0.75 ? Found.mouseX-curTile._w*2: Found.mouseX-curTile._w;
            var py:Float = Math.abs(Found.mouseY) < Found.GRID*0.75 ? Found.mouseY-curTile._h*2:Found.mouseY-curTile._h;
            #if editor
            var gv = App.editorui.gameView;
            if(!Found.fullscreen){
                px = Found.mouseX+curTile._w; //This seems hacky
                py = Found.mouseY+curTile._h*0.5; //This seems hacky
                px = ((px-gv.x)/gv.w)*Found.WIDTH;
                py = ((py-gv.y)/gv.h)*Found.HEIGHT;
                px = Math.floor(px);
                px += (Found.GRID-(px % Found.GRID));
                py = Math.floor(py);
                py += (Found.GRID-(py % Found.GRID));
                px = ((px+gv.x)/Found.WIDTH)*gv.w;
                var value = Math.floor(px);
                px = Math.floor(value-(px-value));
                py = ((py+gv.y-gv.bar.height)/Found.HEIGHT)*gv.h;
                value = Math.floor(py);
                py = Math.floor(value-(py-value));
            }
            else{
            #end
            px = Math.floor(px);
            px += (Found.GRID-(px % Found.GRID));
            py = Math.floor(py);
            py += (Found.GRID-(py % Found.GRID));
            #if editor } #end
            
            vec.x = px;
            vec.y = py;

            curTile.render(canvas,vec,kha.Color.fromBytes(255,255,255,128),new Vector2(temp.width,temp.height));
            canvas.g2.end();
        }
        else{
            kha.input.Mouse.get(0).showSystemCursor();
        }

        if(selectedMap != newSelection){
            map = null;
            curTile = null;
        }
    }
    @:access(found.anim.Tilemap,found.anim.Tile)
    public function addTile(){
        if(!visible || selectedMap < 0 || !isInScreen())return;
        
        // @Incomplete: Make sure that we remove the unusedIds from the tile raw usedIds
        // when saving the tilemap.
        for(i in 0...unusedIds.length){
            if(curTile.tileId == unusedIds[i]){
                unusedIds.splice(i,1);
                break;
            }
        }

        var px:Float = Math.abs(Found.mouseX) < Found.GRID*0.75 ? Found.mouseX-curTile._w*2: Found.mouseX-curTile._w;
        var py:Float = Math.abs(Found.mouseY) < Found.GRID*0.75 ? Found.mouseY-curTile._h*2:Found.mouseY-curTile._h;
        
        #if editor
        var gv = App.editorui.gameView;
        if(!Found.fullscreen){
            px = Found.mouseX+curTile._w; //This seems hacky
            py = Found.mouseY+curTile._h; //This seems hacky
            //Find position in scene size
            px = ((px-gv.x)/gv.w)*Found.WIDTH;
            py = ((py-gv.y)/gv.h)*Found.HEIGHT;
            px = Math.floor(px);
            px += (Found.GRID-(px % Found.GRID));
            py = Math.floor(py);
            py += (Found.GRID-(py % Found.GRID));
            //Convert back to scene preview size
            px = ((px+gv.x)/Found.WIDTH)*gv.w;
            var value = Math.floor(px);
            px = Math.floor(value-(px-value));
            py = ((py+gv.y-gv.bar.height)/Found.HEIGHT)*gv.h;
            value = Math.floor(py);
            py = Math.floor(value-(py-value));
            //Back to scene size
            // @:Incomplete We should be able to avoid this step.
            // But doing it makes drawing in-editor mode more robust
            px = ((px-gv.x)/gv.w)*Found.WIDTH;
            py = ((py-gv.y)/gv.h)*Found.HEIGHT;
        }
        else{
        #end
        px = Math.floor(px);
        px += (Found.GRID-(px % Found.GRID));
        py = Math.floor(py);
        py += (Found.GRID-(py % Found.GRID));
        #if editor } #end

        map.data[map.posXY2Id(px,py)] = tileSelected.index;

    }

    public function selectMap(uid:Int){
        if(uid < 0){selectedMap = -1;return;}
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
    @:access(found.zui.Zui)
    function isInScreen(){
        #if editor
        var gv = App.editorui.gameView;
        var x = Found.fullscreen ? 0: gv.x;//@TODO: Maybe we should use the current camera or tilemap x and y
        var y = Found.fullscreen ? 0:gv.y;
        var w = Found.fullscreen ? Found.WIDTH:gv.width;
        var h = Found.fullscreen ? Found.HEIGHT:gv.height;
        #else
        var x = State.active.cam.x;
        var y = State.active.cam.y;
        var w = Found.WIDTH;
        var h = Found.HEIGHT;
        #end
        var out = Found.mouseX > x &&
                Found.mouseX < x+w &&
                Found.mouseY > y &&
                Found.mouseY < y+h &&
                (Found.mouseY < ui._windowY ||
                Found.mouseY > ui._windowY+endHeight ||
                Found.mouseX < ui._windowX ||
                Found.mouseX > ui._windowX+width);
        return out;
    }
    function scaleToScreen(w:Float,h:Float){
        #if editor
        var gv = App.editorui.gameView;
        var outW = Found.fullscreen ? w : w*(gv.width/Found.WIDTH);
        var outH = Found.fullscreen ? h : h*(gv.height/Found.HEIGHT);
        return {width: outW, height: outH};
        #else
        return {width: w, height: h};
        #end
    }
}
// #end