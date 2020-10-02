package found.audio;

import found.data.Data;

import kha.audio2.AudioChannel;
import kha.audio1.Audio;

class Music {
    static var musicChannels:Map<String,AudioChannel> = new Map<String,AudioChannel>();
    public static function play(name:String, ?volume:Float = 0.3, ?loop:Bool= false ) {
        Data.getSound(name,function(snd:kha.Sound){
            var chan:AudioChannel = cast(Audio.stream(snd,loop));
            chan.volume = volume;
            musicChannels.set(name,chan);

        });
    }
    public static function setVolume(name:String,volume:Float){
        var chan = musicChannels.get(name);
        if(chan != null && !chan.finished){
            chan.volume = volume;
        }
        #if debug
        else if(chan == null){
            warn('Can\'t set volume, no music with name $name exists');
        }
        #end
    }

    public static function stopAll() {
        for(chan in musicChannels){
            chan.stop();
        }
        musicChannels.clear();
    }
}