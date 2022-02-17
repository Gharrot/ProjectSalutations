package sound;

import flixel.FlxG;
import flixel.util.FlxSave;

class SoundManager 
{
    public static var instance(default, null):SoundManager = new SoundManager();
	
	var currentSongName:String = "";

	public var currentMusicVol:Int;
	public var currentSFXVol:Int;
	public var muted:Bool;
	
	public function new() 
	{
		currentMusicVol = 100;
		currentSFXVol = 100;
		muted = false;
		
		loadSoundSettings();
	}
	
	public function modifyMusicVol(amount:Int)
	{
		currentMusicVol += amount;
		
		if (currentMusicVol < 0)
		{
			currentMusicVol = 0;
		}
		
		if (currentMusicVol > 100)
		{
			currentMusicVol = 100;
		}
		
		saveSoundSettings();
	}
	
	public function modifySFXVol(amount:Int)
	{
		currentSFXVol += amount;
		
		if (currentSFXVol < 0)
		{
			currentSFXVol = 0;
		}
		
		if (currentSFXVol > 100)
		{
			currentSFXVol = 100;
		}
		
		saveSoundSettings();
	}
	
	public function setBackgroundSong(songName:String)
	{
		if (songName != currentSongName)
		{
			var songPath:String = "";
			if (songName == "DarkWoods")
			{
				songPath = "assets/music/NoMoon.ogg";
			}
			else if (songName == "SquirrelVillage")
			{
				songPath = "assets/music/SoloAcousticBlues.ogg";
			}
			
			//FlxG.sound.playMusic(songPath);
		}
	}
	
	public function playSoundEffect(soundName:String)
	{
		if (soundName != currentSongName)
		{
			var songPath:String = "";
			if (soundName == "Rockfall")
			{
				songPath = "assets/sounds/NoMoon.ogg";
			}
			else if (soundName == "SquirrelVillage")
			{
				songPath = "assets/music/SoloAcousticBlues.ogg";
			}
			
			//FlxG.sound.playMusic(songPath);
		}
	}
	
	private function loadSoundSettings()
	{
		var save:FlxSave = new FlxSave();
		save.bind("settings");
		
		if (save.data.muted != null)
		{
			currentMusicVol = save.data.currentMusicVol;
			currentSFXVol = save.data.currentSFXVol;
			muted = save.data.muted;
		}
		
		save.close();
	}
	
	private function saveSoundSettings()
	{
		var save:FlxSave = new FlxSave();
		save.bind("settings");
		
		save.data.currentMusicVol = currentMusicVol;
		save.data.currentSFXVol = currentSFXVol;
		save.data.muted = muted;
		
		save.flush();
		save.close();
	}
}