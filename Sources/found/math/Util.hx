package found.math;

import haxe.macro.Expr;

/**
 * Some copy pasta from: https://github.com/deepnight/deepnightLibs/blob/master/src/dn/M.hx
*/

class Util {
	public static function randomInt(value:Int):Int {
		return Math.floor(Math.random() * value);
	}

	public static function randomFloat(value:Float):Float {
		return Math.random() * value;
	}

	public static function randomRangeInt(min:Int, max:Int):Int {
		return Math.floor(Math.random() * (1 + max - min)) + min;
	}

	public static function randomRangeFloat(min:Float, max:Float):Float {
		return Math.random() * (max - min) + min;
	}

	public static function lerp(min:Float, max:Float, value:Float):Float {
		return min + (max - min) * value;
	}

	inline public static var PI = 3.141592653589793;

	inline static var d2r = PI / 180 ;
	public static function degToRad(degrees:Float):Float {
		return degrees * d2r;
	}

	inline static var r2d = 180 / PI;
	public static function radToDeg(radians:Float):Float {
		return radians * r2d;
	}

	public static function fround( value : Float, precision : Int): Float {
		value = value * Math.pow(10, precision);
		value = Math.round( value ) / Math.pow(10, precision);
		return value;
	}

	inline public static function fclamp(x:Float, min:Float, max:Float):Float
	{
		return (x < min) ? min : (x > max) ? max : x;
	}

	/**
	 * Default system epsilon.
	 */
	inline public static var EPS = 1e-6;

	inline public static function slerp(from:Float, to:Float, t:Float)
	{
		var m = Math;

		var c1 = m.sin(from * .5);
		var r1 = m.cos(from * .5);
		var c2 = m.sin(to * .5);
		var r2 = m.cos(to * .5);

		var c = r1 * r2 + c1 * c2;

		if( c < 0.)
		{
			if( (1. + c) > Util.EPS)
			{
				var o = m.acos(-c);
				var s = m.sin(o);
				var s0 = m.sin((1 - t) * o) / s;
				var s1 = m.sin(t * o) / s;
				return m.atan2(s0 * c1 - s1 * c2, s0 * r1 - s1 * r2) * 2.;
			}
			else
			{
				var s0 = 1 - t;
				var s1 = t;
				return m.atan2(s0 * c1 - s1 * c2, s0 * r1 - s1 * r2) * 2;
			}
		}
		else
		{
			if( (1 - c) > Util.EPS)
			{
				var o = m.acos(c);
				var s = m.sin(o);
				var s0 = m.sin((1 - t) * o) / s;
				var s1 = m.sin(t * o) / s;
				return m.atan2(s0 * c1 + s1 * c2, s0 * r1 + s1 * r2) * 2.;
			}
			else
			{
				var s0 = 1 - t;
				var s1 = t;
				return m.atan2(s0 * c1 + s1 * c2, s0 * r1 + s1 * r2) * 2;
			}
		}
	}

	/**
	 * Replaces pow(v, 3) by v * v * v at compilation time (macro), 17x faster results
	 * Limitations: "power" must be a constant Int [0-256], no variable allowed
	 */
	 macro public static function pow(v:Expr, power:Expr) {
		var pos = haxe.macro.Context.currentPos();
		var v = { expr:EParenthesis(v), pos:pos }

		var ipow = switch( power.expr ) {
			case EConst(CInt(v)) : Std.parseInt(v);
			default : haxe.macro.Context.error("You can only use a constant Int here", power.pos);
		}

		if( ipow<=0 || ipow>256 )
			haxe.macro.Context.error("Only values between [0-256] are supported", power.pos);

		function recur(n:Int) : Expr {
			if( n>1 )
				return {expr:EBinop(OpMult, v, recur(n-1)), pos:pos}
			else
				return v;
		}
		return recur(ipow);
	}

	/**
	 * Snaps value to the grid.
	 */
	 inline public static function snap(value:Float, grid:Float):Float
	{	if(value % grid == 0) return value;
		return value += grid - Math.floor(value) % grid;
	}

	/**
	 * Returns the sign of x.
	 * sgn(0) = 0.
	 */
	 inline public static function sign(x:Float):Int {
		return (x > 0) ? 1 : (x < 0 ? -1 : 0);
	}
	inline public static function signEq(x:Float,y:Float):Bool {
		return Util.sign(x)==Util.sign(y);
	}
	
}

/**
 * Cli util for coloring the console. Vars that start with b are BOLD.
 * Don't forget to use the reset after coloring to avoid coloring the whole string.
 */
class Cli{
	public static final red =  "\033[31m";
	public static final green =  "\033[32m";
	public static final yellow =  "\033[33m";
	public static final bred =  "\033[1m\033[31m";
	public static final bgreen =  "\033[1m\033[32m";
	public static final byellow =  "\033[1m\033[33m";
	public static final reset =  "\033[0m";
}
/** the following are UBUNTU/LINUX, and MacOS ONLY terminal color codes. As of 2019 they should work in windows 10: https://stackoverflow.com/a/52063884
#define RESET   "\033[0m"
#define BLACK   "\033[30m"      
#define RED     "\033[31m"      
#define GREEN   "\033[32m"      
#define YELLOW  "\033[33m"      
#define BLUE    "\033[34m"      
#define MAGENTA "\033[35m"      
#define CYAN    "\033[36m"      
#define WHITE   "\033[37m"      
#define BOLDBLACK   "\033[1m\033[30m"      
#define BOLDRED     "\033[1m\033[31m"      
#define BOLDGREEN   "\033[1m\033[32m"      
#define BOLDYELLOW  "\033[1m\033[33m"      
#define BOLDBLUE    "\033[1m\033[34m"      
#define BOLDMAGENTA "\033[1m\033[35m"      
#define BOLDCYAN    "\033[1m\033[36m"      
#define BOLDWHITE   "\033[1m\033[37m"      
**/