package;

import flixel.math.FlxRandom;

class NameGenerator  
{
	private static var names:Array<String>;
	
	public static function getRandomName():String
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
		names.push("Veebe");
		names.push("Marbe");
		names.push("Rote");
		names.push("Leaf");
		names.push("Fleam");
		names.push("Grass");
		names.push("Flacks");
		names.push("Sticks");
		names.push("Glim");
		names.push("Deft");
		names.push("Ronoa");
		names.push("Narmelon");
		names.push("Jube");
		names.push("Ingo");
		names.push("Stones");
		names.push("Ruge");
		names.push("Ferf");
		names.push("Lump");
	}
}
