package found.data;

import kha.FastFloat;
import kha.math.Vector2;

class RectData{
    var c_width:FastFloat;
	var c_height:FastFloat;
    var c_center:Vector2;
    var shape:Shape;
}

enum abstract Shape(Int) from Int {
    var Rect = 0;
    var Circle = 1;
}