package found.tool;

class Log {
    public static function warn(v:Dynamic, ?infos:Null<haxe.PosInfos>) {
        if(infos != null){
            if(infos.customParams == null)
                infos.customParams = [];
            infos.customParams.push("Warn");
            trace(v,infos);
        }
        else {
            trace(v,"Warn");
        }
    }
    public static function error(v:Dynamic, ?infos:Null<haxe.PosInfos>) {
        if(infos != null){
            if(infos.customParams == null)
                infos.customParams = [];
            infos.customParams.push("Error");
            trace(v,infos);
        }
        else {
            trace(v,"Error");
        }
             
    }
}