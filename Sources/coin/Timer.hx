package coin;

import kha.Scheduler;

class Timer {
    public static var delta:Float;
    static var current:Float;

    public static function update() {
        delta = Scheduler.time() -current;
        current =  Scheduler.time();
    }
}