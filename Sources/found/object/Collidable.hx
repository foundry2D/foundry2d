package found.object;

import echo.data.Data.CollisionData;
import echo.Body;

interface Collidable {
    private function onEnter(me:Body,other:Body, data:Array<CollisionData>):Void;
    private function onStay(me:Body,other:Body, data:Array<CollisionData>):Void;
    private function onExit(me:Body,other:Body):Void;
}