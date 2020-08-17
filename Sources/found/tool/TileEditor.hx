package found.tool;
// #if tile_editor
import found.math.Vec2;
import echo.Body;
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

class TileEditorState {
    public static var Draw = 0;
    public static var Erase = 1;
}

class TileEditor {
    static var ui: Zui;
    static var editorStates:Array<String> = [for(field in Type.getClassFields(TileEditorState))field];
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
    var state:Int = TileEditorState.Draw;
    var editorWindowHandle:Handle = Id.handle();
    var tilesheets:Array<TTileData> = [];
    var tilsheetListHandle:Handle = Id.handle();

    var mouse:found.Input.Mouse;

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
        mouse = Input.getMouse();
    }

    public function redraw() {
        editorWindowHandle.redraws = 2;
    }

    var mapWidthHandle:Handle = Id.handle();
    var mapHeightHandle:Handle = Id.handle();
    var editorStateHandle:Handle = Id.handle();
    var limit = 10048;
    @:access(zui.Zui,found.anim.Tilemap,found.anim.Tile)
    public function render(canvas:kha.Canvas): Void {
        if(!visible || selectedTilemapIdIndex < 0 || mouse == null)return;
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
                var changed = false;
				ui.indent();
                ui.text("Tilesheets: ");
                ui.indent();
                var lastSelectedTilesheet = tilsheetListHandle.nest(0).position;
                var tilesheetSelected = Ext.list(ui,tilsheetListHandle,tilesheets,tilesheetListops);
                ui.unindent();
                if(lastSelectedTilesheet != tilesheetSelected){
                    curTile = map.pivotTiles[tilesheetSelected];
                    tileSelected = null;
                }

                mapWidthHandle.value = map.w;
                var w = Ext.floatInput(ui,mapWidthHandle, "Map Width");
                if(mapWidthHandle.changed){
                    var w = Std.int(Util.snap(w,map.tw));
                    if(w > limit) w = limit;
                    resizeMapdata(w,map.h);
                    changed = true;  
                                   
                }
                mapHeightHandle.value = map.h;
                var h = Ext.floatInput(ui,mapHeightHandle, "Map Height");
                if(mapHeightHandle.changed){
                    var h = Std.int(Util.snap(h,map.tw));
                    if(h > limit) h = limit;
                    resizeMapdata(map.w,h);
                    changed = true;
                }
                
                if(ui.button("Change Tilemap Grid Size")){
                    GridSizeDialog.open(map);
                }
                editorStateHandle.position = state;
                ui.combo(editorStateHandle,editorStates,"Draw State",true);
                if(editorStateHandle.changed){
                    state = editorStateHandle.position;
                }
				if(curTile != null){
                    //Tilemap drawing with selection
                    var r = ui.curRatio == -1 ? 1.0 : ui.ratios[ui.curRatio];
                    var px = ui._x+ui.buttonOffsetY;
                    var py = ui._y;
                    var curImg = curTile.data.image;
                    var state = ui.image(curImg);
                    var scroll = ui.currentWindow != null ? ui.currentWindow.scrollEnabled : false;
                    if (!scroll) {
                        px += ui.SCROLL_W() * r * 0.5;
                    }

                    var ratio = Math.abs((py-ui._y)/curImg.height);
                    var invRatio = Math.abs(curImg.height/(py-ui._y));

                    ui.g.color = kha.Color.fromBytes(0,0,200,128);
                    var scrollOffset = ui.currentWindow.scrollOffset;
                    if(tileSelected == null){
                        //We always select the tile at index 0
                        tileSelected = {index:0,x:px,y:py,w:map.tw*ratio,h:map.th*ratio};
                        ui.g.fillRect(tileSelected.x,tileSelected.y+scrollOffset,tileSelected.w,tileSelected.h);
                    }else{
                        ui.g.fillRect(tileSelected.x,tileSelected.y+scrollOffset,tileSelected.w,tileSelected.h);
                    }
                    py -= scrollOffset * 1.5;
                    if(state == zui.Zui.State.Down || tileHandle.changed ){
                        var x = Math.abs(ui._windowX-ui.inputX);
                        var y = Math.abs(ui._windowY-ui.inputY);
                        var imgX =(x-px)*invRatio;
                        var imgY = (y-py)*invRatio;
                        var grid = map.tw;
                        imgX = Util.snap(imgX,grid);
                        imgY = Util.snap(imgY,grid)-grid;
                        var imgW = Util.snap(curImg.width,grid);
                        var imgH = Util.snap(curImg.height,grid);
                        var widthIndicies = Std.int(imgW/map.tw);
                        var index = Std.int(tileHandle.value);
                        if(!tileHandle.changed){
                            index = Std.int(widthIndicies-(imgW -imgX)/grid);
                            index += widthIndicies*Std.int(imgH/map.tw - (imgH -imgY)/grid)-1;
                        }

                        x = (Std.int(index * grid) % (imgW))*ratio +px;
                        y = (Math.floor(index * grid/imgW)*(map.th))*ratio+py;
                        tileSelected = {index:index,x:x,y:y,w:map.tw*ratio,h:map.th*ratio};
                        var pivotTile = map.pivotTiles[curTile.dataId];
                        if(!map.tiles.exists(pivotTile.tileId+index)){
                            
                            var id = pivotTile.tileId+index;
                            pivotTile.raw.usedIds.push(id)-1;
                            unusedIds.push(id);
                            curTile = found.anim.Tile.createTile(map,Reflect.copy(pivotTile.raw),id);
                        }
                        else if(pivotTile.tileId+tileSelected.index != curTile.tileId){
                            curTile = map.tiles.get(pivotTile.tileId+tileSelected.index);
                        }
                        
                    }
                    tileHandle.value = tileSelected.index;
                    ui.slider(tileHandle, "Selected Tile",0,currentMaxTiles()-1);
                    if(tileHandle.changed){
                        var index = Math.floor(tileHandle.value);
                        var x = (Std.int(index * map.tw) % (curImg.width))*ratio +px;
                        var y = (Math.floor(index * map.tw/curImg.width)*(map.th))*ratio+py;
                        tileSelected = {index:index,x:x,y:y,w:map.tw*ratio,h:map.th*ratio};
                        changed = true;
                    }
                    ui.g.color = kha.Color.White;
                    if(found.State.active.physics_world != null){
                        if(ui.button("Edit Selected Tile Collisions") && curTile != null && !tileHandle.changed){
                            if(curTile.body == null || !curTile.raw.rigidBodies.exists(curTile.tileId)){
                                if(!curTile.raw.rigidBodies.exists(curTile.tileId)){
                                    var body = echo.Body.defaults;
                                    body.mass = 0;//Make the body static
                                    body.shapes = [];
                                    curTile.raw.rigidBodies.set(curTile.tileId,body);
                                }
                                curTile.body = new echo.Body(curTile.raw.rigidBodies.get(curTile.tileId));
                            }
                            CollisionEditorDialog.open(null,cast(curTile));
                            changed = true;
                        }
                    }
                    else {
                        ui.text("Tile collisions:");
                        if (ui.button("Create Physics World")) {
                            App.editorui.inspector.inspector.selectScene();
                        }
                    }
                }
                if(changed){
                    #if editor
                    EditorHierarchy.makeDirty();
                    map.dataChanged = true;
                    #end 
                }
                ui.unindent();
            }
            endHeight = Math.abs(endHeight-ui._y);
        }
        canDrawTile = ui.dragHandle != editorWindowHandle && !zui.Popup.show && isInScreen() && curTile != null;
        ui.end();
        
        if(canDrawTile){
            //Draw mouse Icon
            kha.input.Mouse.get(0).hideSystemCursor();
            canvas.g2.begin(false,0x00000000);
            canvas.g2.color = kha.Color.White;
            canvas.g2.drawScaledImage(kha.Assets.images.basic,mouse.x,mouse.y,10,10);
            
            //Scale tile w/h
            //Scale image w/h
            var scaled = scaleToScreen(1.0,1.0);
            var px:Float = mouse.x;//Math.abs(mouse.x) < Found.GRID*0.75 ? mouse.x-curTile._w*2: mouse.x-curTile._w;
            var py:Float = mouse.y;//Math.abs(mouse.y) < Found.GRID*0.75 ? mouse.y-curTile._h*2:mouse.y-curTile._h;
            vec.x = px;
            vec.y = py;
            // px = Math.floor(px);
            // px = Util.snap(px,Found.GRID);
            // py = Math.floor(py);
            // py = Util.snap(py,Found.GRID);

            curTile.render(canvas,vec,kha.Color.fromBytes(255,255,255,128),new Vector2(scaled.width,scaled.height));
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

    function resizeMapdata(w:Int,h:Int){
        var tiles:Array<{pos:Vector2,tileId:Int}> = [];       
        for(i in 0...map.data.length){
            if(map.data[i] != -1){
                tiles.push({pos: new Vector2(map.x2p(map.x(i)),map.y2p(map.y(i))),tileId:map.data[i]});
            }
        }
        if(map.w != w || map.h != h){
            map.w = w;
            map.h = h;
        }
        map.data = [for(i in 0...w*h)-1];
        var rawData:TTilemapData = cast(map.raw);
        rawData.map.clear();
        for(tile in tiles){
            var index = map.posXY2Id(tile.pos.x,tile.pos.y);
            map.data[index] = tile.tileId;
            if(rawData.map.exists(tile.tileId)){
                rawData.map.get(tile.tileId).push(index);
            }
            else {
                rawData.map.set(tile.tileId,[index]);
            }
        }
        rawData.width = w;
        rawData.height = h;
    }
    @:access(found.anim.Tilemap,found.anim.Tile)
    function currentMaxTiles(?tileToGetMaxOf:Null<Tile>){
        var curTile =  tileToGetMaxOf != null ? tileToGetMaxOf: curTile;
        return Std.int(curTile.data.image.width/curTile.map.tw)*Std.int(curTile.data.image.height/curTile.map.th);
    }
    function drawTilesheetItem(handle:Handle,index:Int){
        if(index == -1)return;
        var data = tilesheets[index];

        var imagePathHandle = Id.handle();

        imagePathHandle.text = data.imagePath;

        ui.indent();
        ui.row([0.8,0.2]);
        var path = ui.textInput(imagePathHandle);
        if(ui.button("...")){
            FileBrowserDialog.open(function(path:String){
                if(path == "")return;
                // curTile.data.
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
        FileBrowserDialog.open(function(path:String){
            if(path == "")return;
            
            found.data.Data.getImage(path,function(image:kha.Image){
                var tilesheet:TTileData = found.data.Creator.createType(title,"sprite_object");
                var curPivot = map.pivotTiles[map.pivotTiles.length-1];
                var originId = curPivot != null ? currentMaxTiles(curPivot)+curPivot.tileId : 0;
                tilesheet.id = originId;
                tilesheet.usedIds = [originId];
                tilesheet.width = image.width;
                tilesheet.height = image.height;
                tilesheet.tileWidth = map.tw;
                tilesheet.tileHeight = map.th;
                tilesheet.imagePath = path;
                tilesheets.push(tilesheet);
                trace(tilesheet);
                tileSelected = null;
                var tile = Tile.createTile(map,tilesheet,originId,true);
                if(curTile == null){
                    curTile  = tile;
                    tilsheetListHandle.nest(0).position = -1;
                }
                #if editor
                map.dataChanged = true;
                #end
            });
        });
    }

    @:access(found.anim.Tilemap,found.anim.Tile)
    function removeTilesheet(index:Int){
        
        tilesheets.splice(index,1);
        var tile = map.pivotTiles[index];
        tile.map.removeBodies(found.State.active);
        var indicies:Array<Int> = [];
        for(i in tile.tileId...(tile.tileId+currentMaxTiles(tile))){
            map.tiles.remove(i);
            indicies.push(i);
        }
        for(i in 0...map.data.length){
            for(y in 0...indicies.length){
                if(indicies[y] == map.data[i]){
                    map.data[i] = -1;
                }
            }
        }
        map.pivotTiles.splice(index,1);
        map.imageData.splice(index,1);
        if(curTile != null && curTile.dataId == index){
            curTile = null;
        }
    }

    @:access(found.anim.Tile)
    function getTilePos() {
        var px:Float =0.0;
        var py:Float = 0.0;
        var addX = map.position.x > 0 ? -map.position.x : Math.abs(map.position.x); 
        var addY = map.position.y > 0 ? -map.position.y : Math.abs(map.position.y);  
        #if editor
        if(!Found.fullscreen){
            px = mouse.x;
            py = mouse.y;
            
            var pos:kha.math.FastVector2 = new kha.math.FastVector2(px,py);  
            pos = utilities.Conversion.ScreenToWorld(pos);
            px = pos.x + addX;
            py = pos.y + addY;
        }
        else{
        #end
        px = Math.abs(mouse.x) < Found.GRID*0.75 ? mouse.x-curTile._w*2: mouse.x-curTile._w;
        py = Math.abs(mouse.y) < Found.GRID*0.75 ? mouse.y-curTile._h*2:mouse.y-curTile._h;
        px = Math.floor(px+addX+found.State.active.cam.position.x);
        px = Util.snap(px,Found.GRID);
        py = Math.floor(py+addY+found.State.active.cam.position.y);
        py = Util.snap(py,Found.GRID);
        #if editor } #end
        return new Vec2(px,py);
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
        var pos = getTilePos();
        var index  = map.pos2Id(cast(pos));
        
        if(index > -1 && curTile.tileId != null){
            var lastId = map.data[index];
            #if editor
            var changed =false;
            #end
            var rawData:TTilemapData = cast(map.raw);
            if(state == TileEditorState.Draw){
                map.data[index] = curTile.tileId;
                if(rawData.map.exists(curTile.tileId)){
                    var indicies = rawData.map.get(curTile.tileId);
                    if(indicies[indicies.length-1] == index)return;
                    indicies.push(index);
                }
                else {
                    rawData.map.set(curTile.tileId,[index]);
                }
                if(curTile.raw.rigidBodies.exists(curTile.tileId)){
                    var body = curTile.raw.rigidBodies.get(curTile.tileId);
                    body.x = map.x2p(map.x(index))+map.position.x;
                    body.y = map.y2p(map.y(index))+map.position.y;
                    curTile.bodies.push(found.State.active.physics_world.add(new echo.Body(body)));
                }
                #if editor
                changed = true;
                #end
            }
            if(state == TileEditorState.Erase && lastId != -1){
                map.data[index] = -1;
                var arr = rawData.map.get(lastId);
                var bodies = map.tiles.get(lastId).bodies;
                var body = null;
                for(i in 0...arr.length){
                    if(arr[i] == index){
                        arr.splice(i,1);
                        body = bodies.splice(i,1)[0];
                    }
                }
                
                if(found.State.active.physics_world != null && body != null){
                    found.State.active.physics_world.remove(body);
                    body.dispose();
                }
                #if editor
                changed = true;
                #end
            }
            #if editor
            if(changed){
                EditorHierarchy.makeDirty();
                map.dataChanged = true;
            }
            #end
        }

    }

    public function selectTilemap(uid:Int){
        if(uid < 0){selectedTilemapIdIndex = -1;map = null;return;}
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
        var out = mouse.x > x &&
                mouse.x < x+w &&
                mouse.y > y &&
                mouse.y < y+h &&
                (mouse.y < ui._windowY ||
                mouse.y > ui._windowY+endHeight ||
                mouse.x < ui._windowX ||
                mouse.x > ui._windowX+width);
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