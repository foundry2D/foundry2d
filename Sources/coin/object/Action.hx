package coin.object;

import kha.Worker;

class Action {
    public static function main():Void {
        #if kha_in_worker
        kha.Worker.notifyWorker(function(message:Dynamic){
            var actions:Array<Any> = message.actions;
            for(i in 0...actions.length-1){
                kha.Worker.postFromWorker({out: message.actions[i](message.datas[i]), uid: message.uids[i]});
            }
        });
        #end
    }
}