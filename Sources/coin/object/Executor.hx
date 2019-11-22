package coin.object;

import kha.Worker;
import coin.object.Action;

class Executor<T> {
    public var threads:Int = 2;
    var field:String = "";
    var actions:Array<T->T> = [];
    var datas:Array<T> = [];
    var dataSets:Array<T->Void> = [];
    var uids:Array<Int> = [];
    var action:T->Void;
    var workers:Array<Worker> = [];
    var rest:Worker;
    public function new(p_field:String){
        field = p_field;
        for(i in 0...threads){
            var worker = Worker.create(Action);
            worker.notify(set);
            workers.push(worker);
        }
        rest = Worker.create(Action);
        rest.notify(set);

    }
    function set(data:Dynamic) {
        var modified:Array<T> = Reflect.getProperty(Object,field);
        modified[data.uid] = data.out;
    }
    public function add(func:T->T,data:T,uid:Int){
        actions.push(func);
        datas.push(data);
        uids.push(uid);
    }
    public function execute(){
        if(actions.length % threads == 0){
            var len:Int = Std.int(actions.length/threads);
            for(i in 0...threads){
                workers[i].post({actions: actions.splice(0,len),datas: datas.splice(0,len), uids: uids.splice(0,len)});
            }
        }
        else{
            var len:Int = Math.ceil(actions.length/threads);
            var rlen = actions.length % threads;
            for(i in 0...threads){
                workers[i].post({actions: actions.splice(0,len),datas: datas.splice(0,len), uids: uids.splice(0,len)});
            }
            rest.post({actions: actions.splice(0,rlen),datas: datas.splice(0,rlen), uids: uids.splice(0,rlen)});
        }
    }
}