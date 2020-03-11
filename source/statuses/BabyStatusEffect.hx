package statuses;

import flixel.math.FlxRandom;

class BabyStatusEffect extends DeerStatusEffect 
{

	public function new(?statusName="Baby", ?duration:Int=1, ?strChange=0, ?resChange=0, ?dexChange=0, ?intChange=0, ?lckChange=0) 
	{
		super(statusName, duration, strChange, resChange, dexChange, intChange, lckChange);
	}
	
	override public function progressStatusEffect(){
		super.progressStatusEffect();
		var randomizer:FlxRandom = new FlxRandom();
		
		//Slowly remove the lowered stats, max of 2 per update
		strChange += cast(Math.min(2, randomizer.int(0, (strChange * -1))), Int);
		resChange += cast(Math.min(2, randomizer.int(0, (resChange * -1))), Int);
		dexChange += cast(Math.min(2, randomizer.int(0, (dexChange * -1))), Int);
		intChange += cast(Math.min(2, randomizer.int(0, (intChange * -1))), Int);
		lckChange += cast(Math.min(2, randomizer.int(0, (lckChange * -1))), Int);
	}
}