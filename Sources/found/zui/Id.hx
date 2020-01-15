package found.zui;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.ExprTools;

class Id {

	static var i = 0;
	macro public static function pos(): Expr { return macro $v{i++}; }

	macro public static function handle(ops: Expr = null): Expr {
		var code = "found.zui.Zui.Handle.global.nest(found.zui.Id.pos()," + ExprTools.toString(ops) + ")";
	    return Context.parse(code, Context.currentPos());
	}
}
