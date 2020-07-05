package;

import flixel.math.FlxRandom;

class EnemyWolf 
{
	public var str:Int;
	public var res:Int;
	public var dex:Int;
	
	public var hp:Int;
	
	public function new(?str:Int = 3, ?res:Int = 3, ?dex:Int = 3) 
	{
		/*var randomNums:FlxRandom = new FlxRandom();
		str = randomNums.int(3, 5);
		res = randomNums.int(3, 5);
		dex = randomNums.int(3, 5);*/
		
		this.str = str;
		this.res = res;
		this.dex = dex;
		
		this.hp = 2;
	}
	
}