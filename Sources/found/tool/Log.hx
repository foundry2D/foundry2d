package found.tool;

import found.math.Util.Cli;

class Log {
    static var  oldTrace:Dynamic->Null<haxe.PosInfos>->Void;
    static var customLogs:Array<Dynamic->Null<haxe.PosInfos>->Void> = [];
    public static function warn(v:Dynamic, ?infos:Null<haxe.PosInfos>) {
        if(oldTrace == null)
            initialize();
        if(infos != null){
            log(Cli.byellow+"WARNING: "+Cli.reset+v,infos);
            if(infos.customParams == null)
                infos.customParams = [];
            infos.customParams.push("Warn");
            for(logger in customLogs){
                logger(v,infos);
            }
        }
        else {
            log(Cli.byellow+"WARNING: "+Cli.reset+v);
        }
    }
    public static function error(v:Dynamic, ?infos:Null<haxe.PosInfos>) {
        if(oldTrace == null)
            initialize();
        if(infos != null){
            log(Cli.bred+"ERROR: "+Cli.reset+v,infos);
            if(infos.customParams == null)
                infos.customParams = [];
            infos.customParams.push("Error");
            for(logger in customLogs){
                logger(v,infos);
            }
        }
        else {
            log(Cli.bred+"ERROR: "+Cli.reset+v);
        }
             
    }
    static function log(v:Dynamic, ?infos:Null<haxe.PosInfos>){
        oldTrace(v,infos);
    }
    static function initialize() {
        oldTrace = haxe.Log.trace;
        haxe.Log.trace = log;
        
    }
    public static function addCustomLogging(logger:Dynamic->Null<haxe.PosInfos>->Void){
        if(oldTrace == null)
            initialize();
        customLogs.push(logger);
    }
}