package found.tool;
// #if tile_editor
import found.anim.Tile;
import kha.math.Vector2;
import found.data.SpriteData;
import kha.graphics4.Graphics2;
import found.anim.Tilemap;
import found.math.Util;
import zui.Zui;
import zui.Id;
import zui.Ext;
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
    // var itemList:Array<TTileData> = [];
    var width:Int;
    var height:Int;
    public var x:Int = 512;
    public var y:Int = 256;
    public var visible:Bool;
    static var selectedTilemapIdIndex:Int = -1;
    static var tilemapIds:Array<Int> = []; 
    var curTile:found.anim.Tile;
    var tilesheetListops:ListOpts;

    var map:Tilemap = null;
    var tileSelected:Selection = null;
    var tileHandle = Id.handle({value: 0});
    var unusedIds:Array<Int> = [];
    var canDrawTile:Bool =false;
    var editorWindowHandle:Handle = Id.handle();
    var tilesheets:Array<TTileData> = [];
    var tilsheetListHandle:Handle = Id.handle();
    var fileBrowserOpen:Bool = false;

    public function new(visible = true) {
        this.visible = visible;
        ui = new zui.Zui({font: kha.Assets.fonts.font_default,autoNotifyInput: false});
        width = Std.int(Found.WIDTH*0.175);
        height = Std.int(Found.HEIGHT*0.8);

        tilesheetListops = {
            addLabel: "New Tilesheet",
            addCb: addTilesheet,
            removeCb: removeTilesheet,
            getNameCb: getTilesheetName,
            setNameCb: setTilesheetName,
            itemDrawCb: drawTilesheetItem,
            showRadio: true
        };

        kha.input.Mouse.get().notify(onMouseDownTE, onMouseUpTE, onMouseMoveTE, onMouseWheelTE);
		kha.input.Keyboard.get().notify(onKeyDownTE, onKeyUpTE, onKeyPressTE);
		#if (kha_android || kha_ios)
		if (kha.input.Surface.get() != null) kha.input.Surface.get().notify(onTouchDownTE, onTouchUpTE, onTouchMoveTE);
		#end
    }

    public function redraw() {
        editorWindowHandle.redraws = 2;
    }

    @:access(zui.Zui,found.anim.Tilemap,found.anim.Tile)
    public function render(canvas:kha.Canvas): Void {
        if(!visible || selectedTilemapIdIndex < 0)return;
        ui.begin(canvas.g2);
        
        if(map == null){
            map = cast(found.State.active._entities[tilemapIds[selectedTilemapIdIndex]]);
            curTile = map.tiles[0];
            var raw:TTilemapData = cast(map.raw); 
            tilesheets = raw.images;
        }
        var newSelection = selectedTilemapIdIndex;
        var vec:kha.math.Vector2 =  new Vector2();
        if (ui.window(editorWindowHandle,x,y, width, height, true)) {
            // zui.Popup.showCustom(Found.popupZuiInstance, objectCreationPopupDraw, -1, -1, 600, 500);
            endHeight = ui._y;
			if (ui.panel(Id.handle({selected: true}), "Tilemap editor")) {
				ui.indent();
                ui.text("Tilesheets: ");
                ui.indent();
                var selected = Ext.list(ui,tilsheetListHandle,tilesheets,tilesheetListops);
                ui.unindent();
                if(tilsheetListHandle.nest(0).changed){
                    curTile = map.pivotTiles[selected];
                    tileSelected = null;
                }

                map.w = Std.int(ui.slider(Id.handle({value: map.w}), "Map Width",0,Util.pow(256,2),false,1/map.tw));
                map.h = Std.int(ui.slider(Id.handle({value: map.h}), "Map Height",0,Util.pow(256,2),false,1/map.th));
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

                ui.g.color = kha.Color.fromBytes(0,0,200,128);
                if(tileSelected == null){
                    //We always select the tile at index 0
                    tileSelected = {index:0,x:px,y:py,w:map.tw*ratio,h:map.th*ratio};
                    ui.g.fillRect(tileSelected.x,tileSelected.y,tileSelected.w,tileSelected.h);
                }else{
                    ui.g.fillRect(tileSelected.x,tileSelected.y,tileSelected.w,tileSelected.h);
                }
                if(state == zui.Zui.State.Down || tileHandle.changed ){
                    var x = Math.abs(ui._windowX-ui.inputX);
                    var y = Math.abs(ui._windowY-ui.inputY);
                    var imgX =(x-px)*invRatio;
                    var imgY = (y-py)*invRatio;
                    imgX = Util.snap(imgX,map.tw);
                    imgY = Util.snap(imgY,map.tw);
                    var widthIndicies = Std.int(curImg.width/map.tw);
                    var index = Std.int(tileHandle.value);
                    if(!tileHandle.changed){
                        index = Std.int(Math.max(0.0,(widthIndicies-(curImg.width -imgX)/map.tw)-1));
                        index += widthIndicies*Std.int(curImg.height/map.tw - (curImg.height -imgY)/map.tw-1);
                    }

                    x = (Std.int(index * map.tw) % (curImg.width))*ratio +px;
                    y = (Math.floor(index * map.tw/curImg.width)*(map.th))*ratio+py;
                    tileSelected = {index:index,x:x,y:y,w:map.tw*ratio,h:map.th*ratio};
                    var pivotTile = map.pivotTiles[curTile.dataId];
                    if(!map.tiles.exists(pivotTile.tileId+index)){
                        
                        var value = pivotTile.raw.usedIds.push(pivotTile.tileId+index)-1;
                        unusedIds.push(pivotTile.tileId+index);
                        curTile = found.anim.Tile.createTile(map,pivotTile.raw,value);
                    }
                    
                }
                tileHandle.value = tileSelected.index;
                ui.slider(tileHandle, "Selected Tile",0,currentMaxTiles()-1);

                ui.g.color = kha.Color.White;
                // ui.textInput(Id.handle({text: "Hello"}), "Input");
            
                ui.unindent();
            }
            endHeight = Math.abs(endHeight-ui._y);
        }
        canDrawTile = ui.dragHandle != editorWindowHandle && !fileBrowserOpen && isInScreen();
        ui.end();
        
        if(canDrawTile){
            //Draw mouse Icon
            kha.input.Mouse.get(0).hideSystemCursor();
            canvas.g2.begin(false,0x00000000);
            canvas.g2.color = kha.Color.White;
            canvas.g2.drawScaledImage(kha.Assets.images.basic,Found.mouseX,Found.mouseY,10,10);
            
            //Scale tile w/h
            //Scale image w/h
            var temp = scaleToScreen(1.0,1.0);
            var px:Float = Found.mouseX;//Math.abs(Found.mouseX) < Found.GRID*0.75 ? Found.mouseX-curTile._w*2: Found.mouseX-curTile._w;
            var py:Float = Found.mouseY;//Math.abs(Found.mouseY) < Found.GRID*0.75 ? Found.mouseY-curTile._h*2:Found.mouseY-curTile._h;
            vec.x = px;
            vec.y = py;
            px = Math.floor(px);
            px = Util.snap(px,Found.GRID);
            py = Math.floor(py);
            py = Util.snap(py,Found.GRID);

            curTile.render(canvas,vec,kha.Color.fromBytes(255,255,255,128),new Vector2(temp.width,temp.height));
            canvas.g2.end();
        }
        else{
            kha.input.Mouse.get(0).showSystemCursor();
        }

        if(selectedTilemapIdIndex != newSelection){
            map = null;
            curTile = null;
        }
    }

    @:access(found.anim.Tilemap,found.anim.Tile)
    function currentMaxTiles(?tileToGetMaxOf:Null<Tile>){
        var curTile =  tileToGetMaxOf != null ? tileToGetMaxOf: curTile;
        return Std.int(curTile.data.image.width/curTile.map.tw)*Std.int(curTile.data.image.height/curTile.map.th);
    }
    function drawTilesheetItem(handle:Handle,index:Int){
        var data = tilesheets[index];

        var imagePathHandle = Id.handle();

        imagePathHandle.text = data.imagePath;

        ui.indent();
        ui.row([0.8,0.2]);
        var path = ui.textInput(imagePathHandle);
        if(ui.button("...")){
            fileBrowserOpen = true;
            FileBrowserDialog.open(function(path:String){
                // curTile.data.
                fileBrowserOpen = false;
            });
        }
        if(imagePathHandle.changed){
            data.imagePath = path;
        }

        ui.unindent();

    }

    function getTilesheetName(index:Int){
        return tilesheets[index].name;
    }

    function setTilesheetName(index:Int,name:String){
        if(name == "" || index == -1) return;
        tilesheets[index].name = name;
    }
    @:access(found.anim.Tilemap,found.anim.Tile)
    function addTilesheet(title:String) {
        fileBrowserOpen = true;
        FileBrowserDialog.open(function(path:String){
            var tilesheet:TTileData = found.data.Creator.createType(title,"sprite_object");
            var originId = curTile != null ? currentMaxTiles()+map.pivotTiles[curTile.dataId].tileId : 0;
            tilesheet.usedIds = [originId];
            tilesheet.tileWidth = curTile.raw.tileWidth;
            tilesheet.tileHeight = curTile.raw.tileHeight;
            tilesheet.imagePath = path;
            tilesheets.push(tilesheet);
            tileSelected = null;
            Tile.createTile(map,tilesheet,0,function(tmap:Tilemap){
                fileBrowserOpen = false;
                trace("done with file browser");
            });
        });
    }

    @:access(found.anim.Tilemap)
    function removeTilesheet(index:Int){
        tilesheets.splice(index,1);
        var tile = map.pivotTiles[index];
        for(i in tile.tileId...(tile.tileId+currentMaxTiles(tile))){
            map.tiles.remove(i);
        }
        map.pivotTiles.splice(index,1);
        
    }

    @:access(found.anim.Tilemap,found.anim.Tile,found.App)
    public function addTile(){
        if(!visible || selectedTilemapIdIndex < 0 || !canDrawTile)return;
        
        // @Incomplete: Make sure that we remove the unusedIds from the tile raw usedIds
        // when saving the tilemap.
        for(i in 0...unusedIds.length){
            if(curTile.tileId == unusedIds[i]){
                unusedIds.splice(i,1);
                break;
            }
        }
        var px:Float =0.0;
        var py:Float = 0.0;
        var addX = map.position.x > 0 ? -map.position.x : Math.abs(map.position.x); 
        var addY = map.position.y > 0 ? -map.position.y : Math.abs(map.position.y);  
        #if editor
        if(!Found.fullscreen){
            px = Found.mouseX;
            py = Found.mouseY;
            
            var pos:kha.math.FastVector2 = new kha.math.FastVector2(px,py);  
            pos = utilities.Conversion.ScreenToWorld(pos);
            px = pos.x + addX;
            py = pos.y + addY;
        }
        else{
        #end
        px = Math.abs(Found.mouseX) < Found.GRID*0.75 ? Found.mouseX-curTile._w*2: Found.mouseX-curTile._w;
        py = Math.abs(Found.mouseY) < Found.GRID*0.75 ? Found.mouseY-curTile._h*2:Found.mouseY-curTile._h;
        px = Math.floor(px+addX+found.State.active.cam.position.x);
        px += (Found.GRID-(px % Found.GRID));
        py = Math.floor(py+addY+found.State.active.cam.position.y);
        py += (Found.GRID-(py % Found.GRID));
        #if editor } #end
        var index  = map.posXY2Id(px,py);
        if(index > -1){
            map.data[index] = tileSelected.index;
        }

    }

    public function selectTilemap(uid:Int){
        if(uid < 0){selectedTilemapIdIndex = -1;return;}
        selectedTilemapIdIndex = -1;
        for(i in 0...tilemapIds.length){
            if(tilemapIds[i] == uid){
                selectedTilemapIdIndex = i;
            }
        }
        if(selectedTilemapIdIndex ==-1){
            selectedTilemapIdIndex = tilemapIds.push(uid)-1;
        }
    }

    var endHeight = 0.0;
    @:access(zui.Zui)
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
    //@TODO: We should probably modify how we declare and use this
    // We only ever  use values of 1.0 so...
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

    function onMouseDownTE(button: Int, x: Int, y: Int) {
        ui.onMouseDown(button,x,y);
    }
    function onMouseUpTE(button: Int, x: Int, y: Int) {
        ui.onMouseUp(button,x,y);
    }
    function onMouseMoveTE(x: Int, y: Int, movementX: Int, movementY: Int) {
        ui.onMouseMove(x,y,movementX,movementY);
    }
    function onMouseWheelTE(delta: Int) {
        ui.onMouseWheel(delta);
    }
    function onKeyDownTE(code: kha.input.KeyCode) {
        ui.onKeyDown(code);
    }
    function onKeyUpTE(code: kha.input.KeyCode) {
        ui.onKeyUp(code);
    }
    function onKeyPressTE(char: String) {
        ui.onKeyPress(char);
    }

    #if (kha_android || kha_ios)
	function onTouchDownTE(index: Int, x: Int, y: Int) {
		// Two fingers down - right mouse button
		if (index == 1) { ui.onMouseDown(0, x, y); ui.onMouseDown(1, x, y); }
	}

	function onTouchUpTE(index: Int, x: Int, y: Int) {
		if (index == 1) ui.onMouseUp(1, x, y);
	}

	function onTouchMoveTE(index: Int, x: Int, y: Int) {}
	#end
}
// #end