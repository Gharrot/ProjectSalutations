package;

import flixel.math.FlxRandom;

class EnemyWolf 
{
	public var str:Int;
	public var res:Int;
	public var dex:Int;
	
	public function new() 
	{
		var randomNums:FlxRandom = new FlxRandom();
		str = randomNums.int(3, 5);
		res = randomNums.int(3, 5);
		dex = randomNums.int(3, 5);
	}
	
}