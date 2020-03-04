package locations;

import flixel.math.FlxRandom;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class AbandonedFields extends Location
{
	public static var instance(default, null):AbandonedFields = new AbandonedFields();
	
	public function new(){
		super();
	}
	
	override public function forage(deer:Deer) {
		var randomNums:FlxRandom = new FlxRandom();
		var forageResult = (deer.int * 2) + (deer.lck) + randomNums.int(0, 10);
		
		if(forageResult <= 6){
			showResult(["You are unable to find any food today."]);
		}else if(forageResult <= 11){
			GameVariables.instance.modifyFood(2);
			showResult(["You find a lush field to graze on (+2 food)."]);
		}else if(forageResult <= 17){
			GameVariables.instance.modifyFood(3);
			showResult(["You find some turnips and dig them up (+3 food)."]);
		}else {
			var cropFound:Int = randomNums.int(0, 1);
			GameVariables.instance.modifyFood(4);
			
			if(cropFound == 0){
				showResult(["You find an overgrown patch of cabbage to munch on (+4 food)."]);
			}else if(cropFound == 1){
				showResult(["You find a cornfield, and gather as much as you can (+4 food)."]);
			}
		}
	}
	
	override public function defend(deer:Array<Deer>) {
		var randomNums:FlxRandom = new FlxRandom();
		randomNums.shuffle(deer);
		
		var thisDefenseNums = randomNums.int(1, 100);
		if(thisDefenseNums >= 50){
			//rabbit attakk
			var resultMessage:String = "A few wandering rabbits find your den";
			if (deer.length == 0) {
				if(GameVariables.instance.currentFood > 5){
					resultMessage += " and crunch away some of your food (-2 food).";
					GameVariables.instance.modifyFood(-2);
				}else if(GameVariables.instance.currentFood > 0){
					resultMessage += " and crunch away some of your food (-1 food).";
					GameVariables.instance.modifyFood(-1);
				}else{
					resultMessage += ", but finding food to crunch on they quickly wander off.";
				}
			}else{
				resultMessage += ", but your defending deer are able to scare them off.";
			}
			showResult([resultMessage]);
		}else{
			setOut();
		}
		
		//Defending mother gets big air bonus
	}
	
	override public function hunt(deer:Array<Deer>) {
		var randomNums:FlxRandom = new FlxRandom();
		randomNums.shuffle(deer);
		
		var thisExplorationNum = randomNums.int(0, 0);
		
		//Rabbit
		if(thisExplorationNum == 0){
			var result:String = "Your hunting pack finds a small rabbit.\n";
			var initialCatch:Bool = false;
			for(i in 0...deer.length){
				//Successful catch
				if (randomNums.int(0, 8) + (deer[i].dex*2) + (deer[i].lck - 2) >= 12)
				{
					initialCatch = true;
					result += deer[i].name + " runs the rabbit down and trips it up. ";
					break;
				}
			}
			
			if (initialCatch) {
				var damageDealth:Int = 0;
				for(i in 0...deer.length){
					//Successful hit
					if (randomNums.int(0, 8) + (deer[i].dex*2) + (deer[i].lck - 2) >= 10)
					{
						var hitStrength:Int = randomNums.int(0, 8) + (deer[i].str * 2) + (deer[i].lck - 1);
						
						if(hitStrength >= 16){
							result += deer[i].name + " lands a critical blow on the rabbit. ";
							damageDealth += 2;
						}else if(hitStrength >= 10){
							result += deer[i].name + " deals a solid blow to the rabbit. ";
							damageDealth += 1;
						}else{
							result += deer[i].name + " lands an ineffective attack on the rabbit. ";
						}
					}else{
						result += deer[i].name + " fails to land their attack. ";
					}
					
					if (damageDealth >= 2) {
						GameVariables.instance.modifyFood(3);
						GameVariables.instance.addUnfamiliarWoodsRabbitFur();
						result += "The rabbit lies defeated. You return it to the den to use as food (+3 food) and bedding.";
						break;
					}
				}
				
				if(damageDealth == 1){
					result += "The rabbit bounds off with a few new scratches.";
				}else{
					result += "The rabbit bounds off unharmed.";
				}
			}else{
				result += "No one is able to keep up to the rabbit and it bounds off.";
			}
			
			showResult([result]);
		}
		//Wolf
		else if(thisExplorationNum == 1){
		}
	}
}