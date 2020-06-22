package found.data;

import kha.FastFloat;
import kha.math.Vector2;
import kha.math.Vector3;
import kha.arrays.Float32Array;
import kha.arrays.Uint32Array;
import kha.arrays.Int16Array;

// Zui
import zui.Nodes;
import zui.Nodes.TNodeCanvas;

class SceneFormat{

    public static function getData(t:Dynamic):Dynamic{
        var  o= {};
        for(f in Reflect.fields(t)){
            Reflect.setField(o,f,Reflect.field(t,f));
        }
        return o;
    }
}

#if js
typedef TSceneFormat = {
#else
@:structInit class TSceneFormat {
#end
    public var name:String;
    @:optional public var  _entities:Null<Array<TObj>>;
    @:optional public var _depth:Null<Bool>;
    @:optional public var _Zsort:Null<Bool>;
    @:optional public var cullOffset:Null<Int>;
    @:optional public var traits:Null<Array<TTrait>>; // Scene root traits
    @:optional public var layers:Null<Array<TLayer>>;
    @:optional public var physicsWorld: Null<echo.data.Options.WorldOptions>;
}

#if js
typedef TObj = {
#else
@:structInit class TObj {
#end
    public var name:String;
    public var type:String; // object, sprite_object, light_object, camera_object, speaker_object, emitter_object,tilemap_object
    public var position:Vector2;
    public var rotation:Vector3;
    @:optional public var velocity:Vector2;
	public var width:FastFloat;
	public var height:FastFloat;
    @:optional public var scale:Null<Vector2>;
    public var center:Vector2;
    public var layer:Int;
    public var depth:Float;
    public var active:Bool;
    @:optional public var rigidBody: Null<echo.data.Options.BodyOptions>;
    @:optional public var children:Null<Array<TObj>>;
    @:optional public var traits:Null<Array<TTrait>>;
}


#if js
typedef TCollisionData = {
    >TObj,
#else
@:structInit class TCollisionData extends TObj {
#end
    public var shape:Int;// Rect = 0; Circle = 1; Polygon = 2;
    public var points:Array<Vector2>;// Center = 0;
}

#if js
typedef TSpriteData = {
    >TCollisionData,
#else
@:structInit class TSpriteData extends TCollisionData{
#end
    
    public var imagePath: String;
    @:optional public var flip:Null<Vector2>;
    public var anims:Array<TAnimation>;
}
#if js
typedef TTileData = {
    >TSpriteData,
#else
@:structInit class TTileData extends TSpriteData{
#end
    public var id:Int;
    public var usedIds:Array<Int>;
    public var tileWidth: Int;
    public var tileHeight: Int;
    @:optional public var tileAnims:Null<Array<Array<Int>>>;
}
#if js
typedef TTilemapData = {
    >TObj,
#else
@:structInit class TTilemapData extends TObj{
#end
    public var tileWidth: Int;
    public var tileHeight: Int;
    // public var map:Array<Int>;
    //                 Tileid,posId
    public var map:Map<Int,Array<Int>>;
    public var images:Array<TTileData>;
    @:optional public var flip:Null<Vector2>;
}
#if js
typedef TCameraData = {
    >TObj,
#else
@:structInit class TCameraData extends TObj {
#end
    public var speedX:Float;
    public var speedY:Float;
    public var offsetX:Int;
    public var offsetY:Int;
}
#if js
typedef TEmitterData = {
    >TObj,
#else
@:structInit class TEmitterData extends TObj {
#end
    public var amount:Int;
}

#if js
typedef TAnimation = {
#else
@:structInit class TAnimation {
#end
    public var name:String;
    public var time:Float;
    public var fps:Int;
    public var frames:Array<TFrame>;
}
#if js
typedef TFrame = {
#else
@:structInit class TFrame{
#end
    //If no tx and ty are specified, id is considered an index.
    //This is because of how animations work as of now. 
    //@TODO: reevaluate these assumptions later
    public var id:Int;
    public var start:Float;
    @:optional public var end:Null<Float>;
    @:optional public var tx:Null<Int>;
    @:optional public var ty:Null<Int>;
    public var tw:Int;
    public var th:Int;
    @:optional public var movement:Null<Array<TPos>>;
}
#if js
typedef TPos = {
#else
@:structInit class TPos{
#end
    public var position:Vector2;
    public var rotation:Float;
}
#if js
typedef TTrait = {
#else
@:structInit class TTrait {
#end
	public var type:String;
	public var classname:String;
	@:optional public var parameters:Null<Array<String>>; // constructor params
	@:optional public var props:Null<Array<String>>; // name - value list
}

#if js
typedef TLayer = {
#else
@:structInit class TLayer {
#end
    public var name:String;
    public var zIndex:Int;
    public var speed:FastFloat;

}

#if js
typedef LogicTreeData = {
#else
@:structInit class LogicTreeData {
#end
    public var name: String;
    public var nodes: Nodes;
    public var nodeCanvas: TNodeCanvas;
}