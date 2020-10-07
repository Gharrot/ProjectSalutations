package sound;

import flixel.FlxG;

class SoundManager 
{
    public static var instance(default, null):SoundManager = new SoundManager();
	
	var currentSongName:String = "";

	public function new() 
	{
		
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
			
			FlxG.sound.playMusic(songPath);
		}
	}
	
}