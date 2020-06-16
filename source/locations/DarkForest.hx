package locations;

import flixel.math.FlxRandom;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class DarkForest extends Location
{
	public static var instance(default, null):DarkForest = new DarkForest();
	
	private var wolvesInAttack:Array<EnemyWolf>;
	
	public function new(){
		super();
		
		name = "Darkened Woods";
		backgroundImageFile = "assets/images/LocationImages/DarkForest.png";
		backgroundImageFileNoFrame = "assets/images/LocationImages/DarkForestNoFrame.png";
		backgroundImageFileMiniFramed = "assets/images/LocationImages/DarkForestEmptyDeerTile.png";
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
		var gameVariables:GameVariables = GameVariables.instance;
		var randomNums:FlxRandom = new FlxRandom();
		
		randomNums.shuffle(deer);
		var restingDeer:Array<Deer> = gameVariables.getRestingDeer();
		randomNums.shuffle(restingDeer);
		
		var enemyWolves:Int = gameVariables.darkForestWolves.length;
		
		var message:Array<String> = new Array<String>();
		
		//if no wolves attacking
		if(enemyWolves < 2 || gameVariables.currentFood <= 0){
			setOut();
		}
		
		//if no defending deer
		if(deer.length == 0){
			var foodStolen:Int = enemyWolves * 2;
			if(foodStolen > gameVariables.currentFood){
				foodStolen = gameVariables.currentFood;
			}
			
			message.push("A pack of " + enemyWolves + " wolves arrives at your undefended den");
			
			message.push("The pack gathers up " + foodStolen + " food and runs off.");
			gameVariables.modifyFood(-1 * foodStolen);
			showResult(message);
		}
		else
		{
			message.push("A pack of " + enemyWolves + " wolves arrives at your den");
			
			wolvesInAttack = gameVariables.darkForestWolves;
			showChoiceMultipleDeer(message, ["Attack", "Back off for the night"], [continuedAttack, backOffFromAttack], deer);
		}
	}
	
	public function continuedAttack(choice:String, deer:Array<Deer>){
		var message:Array<String> = new Array<String>();
		var randomNums:FlxRandom = new FlxRandom();
		
		//sort wolves by their dexterity
        wolvesInAttack.sort(function(a:EnemyWolf, b:EnemyWolf) {
           if(a.dex < b.dex) return -1;
           else if(a.dex > b.dex) return 1;
           else return 0;
        });
		
		//sort deer by their dexterity
        deer.sort(function(a:Deer, b:Deer) {
           if(a.dex < b.dex) return -1;
           else if(a.dex > b.dex) return 1;
           else return 0;
        });
		
		var wolfAttackIndex:Int = 0;
		var deerAttackIndex:Int = 0;
		while(wolfAttackIndex < wolvesInAttack.length || deerAttackIndex < deer.length){
			var deerAttacking:Bool = false;
			
			if (wolfAttackIndex >= wolvesInAttack.length){
				deerAttacking = true;
			}
			else if(deerAttackIndex < deer.length)
			{
				if(deer[deerAttackIndex].dex > wolvesInAttack[wolfAttackIndex].dex){
					deerAttacking = true;
				}
				else if(deer[deerAttackIndex].dex == wolvesInAttack[wolfAttackIndex].dex){
					deerAttacking = randomNums.bool();
				}
			}
			
			if (deerAttacking){
				var deerAttacker:Deer = deer[deerAttackIndex];
				var wolfTarget:EnemyWolf = wolvesInAttack[randomNums.int(0, wolvesInAttack.length - 1)];
				
				//check for accuracy/speed
				if(deerAttacker.dex + randomNums.int(0,3) >= wolfTarget.dex + randomNums.int(0,2)){
					//check for damage (no damage, enough to scare off, or enough to remove)
					var deerAttackStrength:Int = deerAttacker.str - wolfTarget.res + randomNums.int(0, 2);
					
					if(deerAttackStrength < 0){
						message.push(deerAttacker.getName() + " lands a kick on a wolf, but it seems unfazed.");
					}
					else if(deerAttackStrength <= 2)
					{
						message.push(deerAttacker.getName() + " lands a kick on a wolf. It whimpers and backs off into the dark.");
						
						if(wolvesInAttack.indexOf(wolfTarget) < wolfAttackIndex){
							wolfAttackIndex--;
						}
						wolvesInAttack.remove(wolfTarget);
					}
					else
					{
						message.push(deerAttacker.getName() + " lands a solid kick on a wolf, sending them tumbling into the dark.");
						
						if(wolvesInAttack.indexOf(wolfTarget) < wolfAttackIndex){
							wolfAttackIndex--;
						}
						wolvesInAttack.remove(wolfTarget);
						GameVariables.instance.darkForestWolves.remove(wolfTarget);
					}
				}
				else
				{
					message.push(deerAttacker.getName() + " attempts to kick the wolf, but it dodges to the side.");
				}
				
				deerAttackIndex++;
			}
			else
			{
				var wolfAttacker:EnemyWolf = wolvesInAttack[wolfAttackIndex];
				var deerTarget:Deer = deer[randomNums.int(0, deer.length - 1)];
				
				//check for accuracy/speed
				if(wolfAttacker.dex + randomNums.int(0,3) >= deerTarget.dex + randomNums.int(0,2)){
					//check for damage (no damage, enough to scare off, or enough to remove)
					var wolfAttackStrength:Int = wolfAttacker.str - deerTarget.res + randomNums.int(0, 2);
					
					if(wolfAttackStrength < 0){
						message.push("A wolf lunges at " + deerTarget.getName() + ", but gets knocked aside.");
					}
					else if(wolfAttackStrength <= 2)
					{
						message.push("A wolf lunges at " + deerTarget.getName() + ", scratching their side.");
						deerTarget.takeDamage(1);
					}
					else
					{
						message.push("A wolf lunges at " + deerTarget.getName() + ", biting deeply into them.");
						deerTarget.takeDamage(2);
					}
					
					if (deerTarget.health <= 0){
						message.push(deerTarget.getName() + " is too injured to fight and stumbles back.");
						
						if(deer.indexOf(deerTarget) < deerAttackIndex){
							deerAttackIndex--;
						}
						deer.remove(deerTarget);
					}
				}
				else
				{
					message.push("A wolf lunges at " + deerTarget.getName() + ", narrowly missing.");
				}
				
				wolfAttackIndex++;
			}
			
			if(wolvesInAttack.length == 0 || deer.length == 0){
				break;
			}
		}
		
		if (wolvesInAttack.length <= 1)
		{
			message.push("All the wolves have backed off; the fight is won.");
			showResult(message);
		}
		else if (deer.length == 0)
		{
			message.push("None of you are in any condition to keep fighting");
			showChoiceMultipleDeer(message, ["Abandon the fight"], [backOffFromAttack], deer);
		}
		else
		{
			message.push(wolvesInAttack.length + " wolves remain.");
			showChoiceMultipleDeer(message, ["Attack", "Abandon the fight"], [continuedAttack, backOffFromAttack], deer);
		}
		
		setActiveDeer(deer);
	}
	
	public function backOffFromAttack(choice:String, deer:Array<Deer>){
		var gameVariables:GameVariables = GameVariables.instance;
		var message:Array<String> = new Array<String>();
		
		var foodStolen:Int = wolvesInAttack.length * 2;
		if(foodStolen > gameVariables.currentFood){
			foodStolen = gameVariables.currentFood;
		}
		
		message.push("Your defending deer back away from the den into the woods.");
		message.push("The wolves do not persue, and instead gather up " + foodStolen + " food and run off.");
		GameVariables.instance.modifyFood(-1 * foodStolen);
		
		showResult(message);
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