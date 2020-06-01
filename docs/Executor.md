# Executor

**(This documentation may not reflect the reality as this is beta software)**

### Goal:
The Executor class was developped to simplify multithreading code, have data locality and avoid data races.Basically, enable data oriented design by default. Even if it is the goal of this construct to avoid these issues, it is still the responsibility of the user to make sure they don't happen. 

### How it works:

The general workflow is to first determine what data you would like to work on. Here is an example of a data structure(1) to process translations in batch:
```
typedef MoveData ={
	public var _positions:Vector2;
	@:optional public var dt:Float;
} 
```
After we have our data definition we can create a static var of type Executor that uses the data structure in our script:
```

typedef MoveData ={
	public var _positions:Vector2;
	@:optional public var dt:Float;
} 

class EnemyAi: extends Trait {
    //Here be new code
    static var _moves:Executor<MoveData> = null;
}
```
Always initialize the var to a null. The reason is calling an inline new on a variable happens before the engine Scheduler as been created. You can use the new function of your script to create your executor variable:
```
 public function new(){
        super();
        if(_moves == null) _moves = new Executor<MoveData>("_positions");
 }
```
The string passed to the constructor of your executor is the name of the variable that you want to be set when the thread is finished processing it. In our situation, we would declare a variable `static final _positions:Array<Vector2> = [];` in the script.

Remark that the variable in the data structure `MoveData` we created and the variable set by the thread have the same name. This is to give the user the ability to set variables of different types easily. So the executor class effectivaly uses the name `"_positions"` to get the modified data we want from the data structure and sets the data we want in our script based on that same name.

After we have this setup, we can finaly declare a function to send to the Executor our custom code(func) and the data we want to act on:
```
public function translate(func:MoveData->MoveData, ?dt:Float = 1.0){
    _moves.add(
    func,
    {_positions:new Vector2(_positions[uid].x,_positions[uid].y),dt: dt}
    ,uid);
}
```
The above mention step is necessary because we want to bundle the data in the `OnUpdate` of our script and the Executor will be processed after the `OnUpdate` has been called.

Then you or your code's users can define a function and pass it to the Executor. 
```
function doIt(data:MoveData){
    data._positions.x+=1;
    data._positions.y+=1;
    return data;
}
```
In the end the class could look like this:
```

typedef MoveData ={
	public var _positions:Vector2;
	@:optional public var dt:Float;
} 

class EnemyAi: extends Trait {
    //Here be new code
    static var _moves:Executor<MoveData> = null;

    public function new(){
        super();
        if(_moves == null) _moves = new Executor<MoveData>("_positions");
        notifyOnUpdate(function(dt:Float){
            this.move(doIt,dt);
        });
    }

        public function move(func:MoveData->MoveData, ?dt:Float = 1.0){
        _moves.add(
        func,
        {_positions:new Vector2(_positions[uid].x,_positions[uid].y),dt: dt}
        ,uid);
    }

    function doIt(data:MoveData){
        data._positions.x+=1;
        data._positions.y+=1;
        return data;
    }
}
```
This will enable the `doIt` function to be called on multiple threads and set the data to the respective objects based on the objects uid.
 






















-----------------------------------------------------------
#### (1): 
If ever you would like that structure to be fast on both the js target and the native targets you can add these defines:
```
#if js
typedef MoveData ={
#else
@:structInit class MoveData{
#end
	public var _positions:Vector2;
	@:optional public var dt:Float;
	@:optional public var collider:Float;
} 
```
The reasoning here is that classes perform better then typedef's on native platforms. 