package coin.data;

import kha.FastFloat;
import kha.math.Vector2;
import kha.arrays.Float32Array;
import kha.arrays.Uint32Array;
import kha.arrays.Int16Array;


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
}

#if js
typedef TObj = {
#else
@:structInit class TObj {
#end
    public var type:String; // object, mesh_object, light_object, camera_object, speaker_object, decal_object
	public var name:String;
    public var position:Vector2;
    public var rotation:Float = 0;
    @:optional public var velocity:Vector2;
	public var width:FastFloat;
	public var height:FastFloat;
    @:optional public var scale:Vector2;
	public var center:Vector2;
    public var depth:Float;
	public var active:Bool;
    @:optional public var traits:Array<TTrait>;
}


#if js
typedef TRectData = {
#else
@:structInit class TRectData {
#end
    >TObj,
    public var shape:String;
}

#if js
typedef TSpriteData = {
#else
@:structInit class TSpriteData {
#end
    >TRectData,
    public var _imagePath: String;
    public var flip:Vector2;
    @:optional public var _animPath: String;
    @:optional public var anim:TAnimation;
}

#if js
typedef TAnimation = {
#else
@:structInit class TAnimation {
#end
    
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