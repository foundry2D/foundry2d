package found.math;

import kha.math.FastVector2; 

// @:TODO Investigate using import kha.simd.Float32x4; 
// We could store scale and or center vector; 
// We actually need to determine which of them will be used often for calculations

@:forward(dot,normalized,angle,toString,x,y)
abstract Vec2(FastVector2) from  FastVector2 to FastVector2 {
    inline public function new(x= 0.0,y=0.0) {
        this = new FastVector2(x,y);
    }
    
    @:op(A + B)
    public function addition(other:Vec2):Vec2 {
        return inline this.add(other);
    }

    @:op(A - B)
    public function subtract(other:Vec2):Vec2 {
        return inline this.sub(other);
    }

    @:op(A * B)
    public function multiply(f:Float):Vec2 {
        return inline this.mult(f);
    }

    @:op(A / B)
    public function divide(f:Float):Vec2 {
        return inline this.div(f);
    }
}