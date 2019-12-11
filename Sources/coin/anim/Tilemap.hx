package coin.anim;

import kha.Canvas;
import coin.anim.Tile;
import coin.object.Object;
import coin.data.SpriteData;
import coin.data.SceneFormat;
import kha.math.Vector2;

class Tilemap extends Object{
    
    /* width */         public var w : Int;
    /* height */        public var h : Int;
    /* tile width */    public var tw : Int;
    /* tile height */   public var th : Int;
    public var data : Array<Int>;
    var tiles:Array<Tile>;
    public var imageData:Array<SpriteData>;
    var tileCounter:Array<Int>= [];
    
    public function new(data:TTilemapData) {
        super(data.position.x,data.position.y,data.width,data.height);
        this.w = data.width;
        this.h = data.height;
        this.tw = data.tileWidth;
        this.th = data.tileHeight;
        this.data = [for (i in 0...w * h) v];
        this.imageData = [];
        for(tile in data.tiles){
            new Tile(this,tile,function(data:Tile){
                tiles.push(data);
            });
        }
    }
    
    public inline function x(id : Int) : Int {
        return id % w;
    }
    
    public inline function y(id : Int) : Int {
        return Std.int(id / w);
    }
    
    public inline function i(x : Int, y : Int) : Int {
        if (x < 0) return -1;
        else if (x >= w) return -1;
        else if (y < 0) return -1;
        else if (y >= h) return -1;
        else return y * w + x;
    }

    // tile -> pixel
    public inline function x2p(x : Float) : Float {
        return x * tw;
    }
    
    public inline function y2p(y : Float) : Float {
        return y * th;
    }
    
    // pixel -> tile
    public inline function p2x(p : Float) : Float {
        return p / tw;
    }
    
    public inline function p2y(p : Float) : Float {
        return p / th;
    }

    public inline function pos2Id(pos:Vector2) : Int {
        var tx = Std.int(pos.x / tw);
        var ty = Std.int(pos.y / th);
        return i(tx, ty);
    }

    public inline function posXY2Id(x : Float, y : Float) : Int {
        var tx = Std.int(x / tw);
        var ty = Std.int(y / th);
        return i(tx, ty);
    }
    public function addData(data:SpriteData):Int {
        var id = -1;
        for(i in 0...imageData.length){
            if(imageData[i] == data){
                id = i;
                tileCounter[id]+=1;
                break;
            }
        }
        if(id == -1){
            id = imageData.push(data)-1;
            tileCounter.push(0);
        }
        return {dataId:id,tileId:tileCounter[id]};
    }
    override public function render(canvas:Canvas) {
        
    }
}