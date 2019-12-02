package coin.object;

import kha.Scheduler;
import kha.Worker;

class Executor<T> {
    public static var executors:Array<Executor<Dynamic>> = [];
    public var threads:Int = 2;
    var field:String = "";
    var actions:Array<T->T> = [];
    var datas:Array<T> = [];
    var uids:Array<Int> = [];
    var workers:Array<Worker> = [];
    var rest:Worker;
    public function new(p_field:String){
        #if debug
        if(Scheduler.time() == 0) trace("You cant create Executors before the Scheduler has been created");
        #end
        field = p_field;
        #if kha_kore
        for(i in 0...threads){
            var worker = Worker.create(coin.object.Action);
            worker.notify(function(d:Dynamic){
                set(d);
            });
            workers.push(worker);
        }
        rest = Worker.create(coin.object.Action);
        rest.notify(function(d:Dynamic){
            set(d);
        });
        #end
        executors.push(this);

    }
    function set(data:Dynamic) {
        //@:Incomplete: we should test that the condition after the || is needed
        // It was added to potentially avoid threaded calls trying to set the 
        //data after the scene has changed
        if(!coin.Scene.ready || State.active._entities.length == 0) return;

        var modified:Array<T> = Reflect.field(Object,field);
        if(Reflect.hasField(data.out,field)){
            modified[data.uid] = Reflect.field(data.out,field);
        }
        else{
            modified[data.uid] = data.out;
        }
        #if editor
        if(EditorHierarchy.inspector != null)
            EditorHierarchy.inspector.updateField(data.uid,field,modified[data.uid]);
        #end
    }
    public function add(func:T->T,data:T,uid:Int){
        actions.push(func);
        datas.push(data);
        uids.push(uid);
    }
    // @:Incomplete. We should use webworkers in the futur for html5(fixing khamake creation of workers)
    // And look at adding multithreading in Krom. As of now this would take too much time
    // So we will just have it singlethreaded on these targets since they are not the 
    // final targets anyways
    public function execute(){
        if(!coin.Scene.ready || State.active._entities.length == 0) return;
        #if (kha_html5 || kha_krom)
        for(i in 0...actions.length){
            set({out: actions[i](datas[i]),uid: uids[i]});
        }
        actions = [];
        datas= [];
        uids= [];
        #else
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
                if(actions.length < len)continue;
                workers[i].post({actions: actions.splice(0,len),datas: datas.splice(0,len), uids: uids.splice(0,len)});
            }
            if(len > 1)
                rest.post({actions: actions.splice(0,rlen),datas: datas.splice(0,rlen), uids: uids.splice(0,rlen)});
        }
        #end
    }
}