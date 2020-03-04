package;

import flixel.FlxGame;
import openfl.display.Sprite;
import flixel.FlxG;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(480, 640, PlayState, 1, 60, 60, true));
		FlxG.sound.volume = 0;
		FlxG.mouse.visible = true;
	}
}
