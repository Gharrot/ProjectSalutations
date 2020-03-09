package statuses;

import flixel.math.FlxRandom;

class BabyStatusEffect extends DeerStatusEffect 
{

	public function new(?name="Buff", ?duration:Int=1, ?strChange=0, ?resChange=0, ?dexChange=0, ?intChange=0, ?lckChange=0) 
	{
		super(name, duration, strChange, resChange, dexChange, intChange, lckChange);
	}
	
	override public function progressStatusEffect(){
		super.progressStatusEffect();
		var randomizer:FlxRandom = new FlxRandom();
		
		strChange += randomizer.int(0, (strChange * -1));
		resChange += randomizer.int(0, (resChange * -1));
		dexChange += randomizer.int(0, (dexChange * -1));
		intChange += randomizer.int(0, (intChange * -1));
		lckChange += randomizer.int(0, (lckChange * -1));
	}
}