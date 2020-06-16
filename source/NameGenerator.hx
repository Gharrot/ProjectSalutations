package;

import flixel.math.FlxRandom;

class NameGenerator  
{
	private static var names:Array<String>;
	
	public static function getRandomName(?gender:String):String
	{
		if(names == null){
			setupNames();
		}
		
		var randomNums:FlxRandom = new FlxRandom();
		
		return names[randomNums.int(0, names.length - 1)];
	}
	
	private static function setupNames()
	{
		names = new Array<String>();
		names.push("Tomato");
		names.push("Anchovy");
		names.push("Derth");
		names.push("Bancho");
		names.push("Bittles");
		names.push("Vegle");
		names.push("Marbe");
		names.push("Rote");
		names.push("Leaf");
		names.push("Fleam");
		names.push("Gilpie");
		names.push("Flacks");
		names.push("Sticks");
	}
}
