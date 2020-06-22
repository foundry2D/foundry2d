package found.data;

import haxe.Serializer;
import haxe.Unserializer;
import haxe.Json;
import Type;


class DataLoader {
	public static var version(default,null)	: Float;

	var objVersion		: Float;
	var obj				: Null<Dynamic>;
	var serialized		: Null<String>;


	public function new(?dataVersion:Null<Float>) {
        if(dataVersion != null)
		    version = dataVersion;
		objVersion = -1.0;
	}


	public function serialize(o:Dynamic, ?pretty=false) : Void {
		var raw = Json.stringify(o/*, function(k:Dynamic, v:Dynamic) : Dynamic {
			switch( Type.typeof(v) ) {
				case TEnum(_) :
					return "__hser__" + Serializer.run(v);

				case TClass(List) :
					return "__hser__" + Serializer.run(v);

				case TClass(haxe.ds.StringMap), TClass(haxe.ds.IntMap), TClass(haxe.ds.EnumValueMap) :
					return "__hser__" + Serializer.run(v);
				case TClass(kha.math.Vector2) | TClass(kha.math.Vector3):
					return "__hser__" + Serializer.run(v);
				case TClass(String), TClass(Array) :
					return v;

				case TNull, TInt, TFloat, TBool, TObject :
					return v;

				default :
					throw k+" has an unsupported type ("+Type.typeof(v)+")";
			}
		}*/);

		raw = '{"version":$version, "data":$raw}';

		serialized = pretty ? prettify(raw) : raw;
	}

	public inline function getSerialized() : String {
		if( serialized==null )
			throw 'serialize() must be called first';

		return serialized;
	}


	//@TODO: We have issues with the data loader when saving scenes.... with new objects 
	//it says cannot access read only field ???!!
	public function unserialize(raw:String) : Void {
		var o = Json.parse(raw);
		objVersion = Reflect.field(o, "version");
		// parseRec(o, function(k:String, v:Dynamic) : Dynamic {

		// 	switch( Type.typeof(v) ) {

		// 		case TClass(String) :
		// 			// Rebuild special types
		// 			var s : String = cast v;

		// 			// Serialized field
		// 			if( s.indexOf("__hser__")==0 )
		// 				return Unserializer.run( s.substr(8) );

		// 		default :
		// 	}

		// 	return v;

		// });

		o = Reflect.field(o, "data");

		obj = o;
	}

	public function getCurrentUnserializedDataVersion() {
		return objVersion;
	}


	public function getUnserialized() : Dynamic {
		if(objVersion == -1 && obj != null) return obj;
		if( version>objVersion )
			throw 'Unserialized object version mismatch, a patch is required (object version:$objVersion, current:$version)';

		if( version<objVersion )
			throw 'Unserialized object version mismatch, object created using a more recent version of this app  (object version:$objVersion, current:$version)';

		if( obj==null )
			throw "unserialize() must be called first";

		return obj;
	}



	public function patch(from:Int, to:Int, operation:Dynamic->Void) {
		if( objVersion==from ) {
			operation(obj);
			objVersion = to;
		}
	}



	static function parseRec(o:Dynamic, replacer:String->Dynamic->Dynamic) {
		for(k in Reflect.fields(o)) {

			var v = Reflect.field(o,k);

			Reflect.setField(o, k, replacer(k,v));

			switch( Type.typeof(v) ) {

				case TObject :
					parseRec(v, replacer);

				case TClass(c) :
					switch(c) {

						case Array :
							// Parse sub array
							var arr : Array<Dynamic> = cast v;
							for(e in arr)
								parseRec(e, replacer);

					}
				default :
			}

		}
	}


	public static function parse(raw:String) {
		var hj = new DataLoader(Data.version);
		hj.unserialize(raw);
		return hj.getUnserialized();
	}

	public static function stringify(o:Dynamic,#if something ?pretty=true #else?pretty=false#end) {
		var hj = new DataLoader(Data.version);
		hj.serialize(o, pretty);
		return hj.getSerialized();
	}


	public static function prettify(json:String) {
		var strBuff = new StringBuf();
		var inString = false;
		var indent = 0;
		var jumpBefore : Bool;
		var jumpAfter : Bool;
		var cid : Int;

		for(c in json.split("")) {
			cid = c.charCodeAt(0);
			jumpBefore = jumpAfter = false;
			if( inString ) {
				if( c=="\"" )
					inString = false;
			}
			else
				switch( c ) {
					case " " :
						c = "";

					case "," :
						jumpAfter = true;

					case ":" :
						c = " : ";

					case "{" :
						if( !inString ) {
							jumpAfter = true;
							indent++;
						}

					case "}" :
						jumpBefore = true;
						indent--;

					case "[" :
						if( !inString ) {
							jumpAfter = true;
							indent++;
						}

					case "]" :
						jumpBefore = true;
						indent--;

					case "\"" : inString = true;
				}
			if( jumpBefore ) {
				strBuff.addChar(10); // new line
				for(i in 0...indent)
					strBuff.addChar(9); // tab
			}
			strBuff.addChar(cid);
			if( jumpAfter ) {
				strBuff.addChar(10); // new line
				for(i in 0...indent)
					strBuff.addChar(9); // tab
			}
		}
		return strBuff.toString();
	}

}