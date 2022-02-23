package sound;

import flixel.FlxG;
import flixel.util.FlxSave;
import flixel.system.FlxSound;
import flixel.FlxObject;

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
	
	public function initializeSoundManager()
	{
		FlxG.sound.soundTrayEnabled = false;
		
		FlxG.sound.changeVolume(1);
		updateVolumes();
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
		updateVolumes();
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
		updateVolumes();
	}
	
	public function updateVolumes()
	{
		FlxG.sound.defaultMusicGroup.volume = (cast(currentMusicVol, Float) / 100.0);
		FlxG.sound.defaultSoundGroup.volume = (cast(currentSFXVol, Float) / 100.0);
	}
	
	public function setBackgroundSong(songName:String)
	{
		if (songName != currentSongName)
		{
			var songPath:String = "";
			
			if (songName == "MainMenu")
			{
				songPath = "assets/music/shimmer.ogg";
			}
			else if (songName == "Forest")
			{
				songPath = "assets/music/NoMoon.ogg";
			}
			else if (songName == "Trail")
			{
				songPath = "assets/music/NoMoon.ogg";
			}
			else if (songName == "StoneOverlook")
			{
				songPath = "assets/music/NoMoon.ogg";
			}
			else if (songName == "UndergroundCity")
			{
				songPath = "assets/music/reNovation.ogg";
			}
			else if (songName == "DarkWoods")
			{
				songPath = "assets/music/NoMoon.ogg";
			}
			else if (songName == "SquirrelVillage")
			{
				songPath = "assets/music/SoloAcousticBlues.ogg";
			}
			else if (songName == "Mountain")
			{
				songPath = "assets/music/SoloAcousticBlues.ogg";
			}
			else if (songName == "Peak")
			{
				songPath = "assets/music/SoloAcousticBlues.ogg";
			}
			else if (songName == "DarkCity")
			{
				songPath = "assets/music/SoloAcousticBlues.ogg";
			}
			else if (songName == "Credits")
			{
				songPath = "assets/music/SoloAcousticBlues.ogg";
			}
			
			FlxG.sound.playMusic(songPath);
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