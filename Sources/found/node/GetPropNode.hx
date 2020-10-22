package found.node;

import kha.math.Vector2i;

class GetPropNode extends LogicNode {
	public var classname:String;
	public var propertyName:String;
	override function get(from:Int):Dynamic {
		var value:Null<Any> = null;
		for(t in tree.object.raw.traits){
			if(t.classname == classname && t.props != null){
				for(p in t.props){
					if(StringTools.contains(p,propertyName)){
						var prop = p.split("~");
						var type = Std.parseInt(prop[1]);
						value = toType(type,prop[2]);
						break;
					}
				}
			}
		}
		return value;
	}
	function toType(type:Trait.PropertyType,text:String){
		var value:Any;
		switch(type){
			case int:
				value = Std.parseInt(text);
			case bool:
				value = text == "1" ? true : false;
			case float:
				value = Std.parseFloat(text);
			case string:
				value = text;
			case vector2i:
				var values:Array<String> = text.split("|");
				value = new Vector2i(toType(int,values[0]),toType(int,values[1]));
			case vector2b:
				var values:Array<String> = text.split("|");
				value = new Vector2i(toType(int,values[0]),toType(int,values[1]));
			case vector2:
				var values:Array<String> = text.split("|");
				value = new Vector2i(toType(float,values[0]),toType(float,values[1]));
		}
		return value;
	}
}
