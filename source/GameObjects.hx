package;

import flixel.FlxObject;
import locations.Location;
import flixel.util.FlxSave;

class GameObjects
{
	public var save:FlxSave;
    public var mainGameMenu:MainGame;
	public var gameVariables:GameVariables;
	
    public static var instance(default, null):GameObjects = new GameObjects();
	
	public function new() 
	{
		
	}
	
}