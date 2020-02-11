package found.data;

import kha.FastFloat;
import kha.math.Vector2;
import kha.math.Vector3;
import kha.arrays.Float32Array;
import kha.arrays.Uint32Array;
import kha.arrays.Int16Array;

// Zui
import found.zui.Nodes;
import found.zui.Nodes.TNodeCanvas;

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
    @:optional public var name:String;
    @:optional public var  _entities:Array<TObj>;
    @:optional public var _depth:Bool;
    @:optional public var _Zsort:Bool;
    @:optional public var traits:Array<TTrait>; // Scene root traits
    @:optional public var physicsWorld: echo.data.Options.WorldOptions;
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
    @:optional public var scale:Vector2;
	public var center:Vector2;
    public var depth:Float;
    public var active:Bool;
    @:optional public var rigidBody: echo.data.Options.BodyOptions;
    @:optional public var children:Array<TObj>;
    @:optional public var traits:Array<TTrait>;
}


#if js
typedef TRectData = {
    >TObj,
#else
@:structInit class TRectData extends TObj {
#end
    public var c_width:FastFloat;
	public var c_height:FastFloat;
    public var c_center:Vector2;
    public var shape:String;
}

#if js
typedef TSpriteData = {
    >TRectData,
#else
@:structInit class TSpriteData extends TRectData{
#end
    
    public var imagePath: String;
    @:optional public var flip:Vector2;
    @:optional public var animsPath:Array<String>;
}
#if js
typedef TTileData = {
    >TSpriteData,
#else
@:structInit class TTileData extends TSpriteData{
#end
    public var usedIds:Array<Int>;
    public var tileWidth: Int;
    public var tileHeight: Int;
    @:optional public var tileAnims:Array<Array<Int>>;
}
#if js
typedef TTilemapData = {
    >TObj,
#else
@:structInit class TTilemapData extends TObj{
#end
    
    public var tileWidth: Int;
    public var tileHeight: Int;
    public var map:Array<Int>;
    public var images:Array<TTileData>;
    public var cull:Bool;
    public var cullOffset:Int;
    @:optional public var flip:Vector2;
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
    public var min:Int;
    public var max:Int;
    public var fps:Int;
}
#if js
typedef TTrait = {
#else
@:structInit class TTrait {
#end
	public var type:String;
	public var class_name:String;
	@:optional public var parameters:Array<String>; // constructor params
	@:optional public var props:Array<String>; // name - value list
}

#if js
typedef LogicTreeData = {
#else
@:structInit class LogicTreeData {
#end
	var name: String;
	var nodes: Nodes;
	var nodeCanvas: TNodeCanvas;
}