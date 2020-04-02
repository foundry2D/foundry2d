package found.data;

typedef TProject = {
    var name:String;
    var dataVersion:Float;
    var path:String;
    var scenes:Array<String>;//path
    var type:Project.Type;
}
enum abstract Type(Int) from Int to Int {
    var twoD = 0;
    var threeD = 1;
}