package locations;

import statuses.DeerStatusEffect;

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
	
	override public function returnAfterDayEnd()
	{
		if (GameVariables.instance.darkForestTimeRemaining > 0)
		{
			GameVariables.instance.darkForestWolves.push(new EnemyWolf());
			GameVariables.instance.darkForestWolves.push(new EnemyWolf());
			if (GameVariables.instance.darkForestTimeRemaining <= 2)
			{
				GameVariables.instance.darkForestWolves.push(new EnemyWolf());
			}
			
			if (GameVariables.instance.darkForestTimeRemaining > 1)
			{
				showChoice(["As the night begins to end, you hear a bell toll " + GameVariables.instance.darkForestTimeRemaining + " times in the distance."], ["Continue"], [returnToDenChoice], null);
			}
			else
			{
				showChoice(["As the night begins to end, you hear a bell toll once in the distance."], ["Continue"], [returnToDenChoice], null);
			}
			GameVariables.instance.darkForestTimeRemaining--;
		}
		else
		{
			if (!GameVariables.instance.darkForestPedestalRaised)
			{
				//fight a powerful wolf for the medallion
				GameVariables.instance.darkForestPedestalRaised = true;
				showChoice(["As the night begins to end, a great pillar of fire erupts in the distance."], ["Continue"], [returnToDenChoice], null);
			}
			else if(!GameVariables.instance.darkForestMedallionTaken)
			{
				showChoice(["The great pillar of fire continues to shine in the distance."], ["Continue"], [returnToDenChoice], null);
			}
			else
			{
				returnToDen();
			}
		}
	}
	
	override public function explore(deer:Deer)
	{
		continueCount = 0;

		var exploreOptionNames:Array<String> = new Array<String>();
		var exploreOptionFunctions:Array<(String, Deer)->Void> = new Array<(String, Deer)->Void>();

		//Flame
		if (GameVariables.instance.darkForestPedestalRaised)
		{
			exploreOptionNames.push("The Flame");
			exploreOptionFunctions.push(greatFlame);
		}
		
		//Fireflies
		if (GameVariables.instance.darkForestHealingSpringFound)
		{
			exploreOptionNames.push("The Fireflies");
		}
		else
		{
			exploreOptionNames.push("???");
		}
		exploreOptionFunctions.push(healingSpring);
		
		//Berries
		if (GameVariables.instance.darkForestHealingBerriesFound)
		{
			exploreOptionNames.push("The Berry Bushes");
		}
		else
		{
			exploreOptionNames.push("???");
		}
		exploreOptionFunctions.push(healingBerries);
		
		//Herbs
		if (GameVariables.instance.darkForestSpeedHerbsFound)
		{
			exploreOptionNames.push("The Herb Patches");
		}
		else
		{
			exploreOptionNames.push("???");
		}
		exploreOptionFunctions.push(speedHerbs);

		exploreOptionNames.push("Practice");
		exploreOptionFunctions.push(aimlessWandering);

		if (exploreOptionNames.length <= 1)
		{
			wander("", deer);
		}
		else
		{
			showChoice(["Where will you head to?"], exploreOptionNames, exploreOptionFunctions, deer);
		}
	}
	
	public function wander(choice:String, deer:Deer)
	{
		var randomNums:FlxRandom = new FlxRandom();
		var possibilities:Array<String> = new Array<String>();
		
		if (!GameVariables.instance.darkForestHealingSpringFound)
		{
			possibilities.push("The Fireflies");
		}
		
		if (!GameVariables.instance.darkForestHealingBerriesFound)
		{
			possibilities.push("The Berries");
		}
		
		if (!GameVariables.instance.darkForestSpeedHerbsFound)
		{
			possibilities.push("The Herbs");
		}
		
		possibilities.push("Wander Elsewhere");

		var resultingEvent:String = possibilities[randomNums.int(0, possibilities.length - 1)];
		if (resultingEvent == "The Fireflies")
		{
			healingSpring("Fireflies", deer);
		}
		else if (resultingEvent == "The Berries")
		{
			healingBerries("Berries", deer);
		}
		else if (resultingEvent == "The Herbs")
		{
			speedHerbs("Herbs", deer);
		}
		else if (resultingEvent == "Wander Elsewhere")
		{
			aimlessWandering("Elsewhere", deer);
		}
	}
	
	public function greatFlame(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		message.push("The light of the pillar of fire guides you to a large clearing.");
		message.push("The fire burns brightly in the center of the clearing, with no clue of its cause.");
		
		if (!GameVariables.instance.darkForestMedallionTaken)
		{
			message.push("A low stone pedestal stands in front of the fire, a black medallion resting on top.");
			message.push("You step forward and pick up the medallion. (+1 max pack size)");
			
			GameVariables.instance.darkForestMedallionTaken = true;
			GameVariables.instance.maxPackSize++;
		}
		else
		{
			message.push("A low stone pedestal stands in front of the fire, where you took a medallion from.");
		}
		
		showResult(message);
	}
	
	public function healingSpring(choice:String, deer:Deer)
	{
		GameVariables.instance.darkForestHealingSpringFound = true;
		
		var message:Array<String> = new Array<String>();
		message.push("Wandering through the darkness you come across a gathering of fireflies.");
		message.push("The fireflies split up and you decide to follow one.");
		showChoice(message, ["Follow one"], [healingSpringResult], deer);
	}
	
	public function healingSpringResult(choice:String, deer:Deer)
	{
		var randomNums:FlxRandom = new FlxRandom();
		var springFindingSkill:Int = deer.lck + randomNums.int(0, 3);
		
		var message:Array<String> = new Array<String>();
		
		if (springFindingSkill >= 5)
		{
			message.push("The firefly you follow leads to a small spring surrounded by fireflies.");
			message.push("After relaxing in the spring for a while, you feel completely refreshed.");
			message.push("(You are fully healed)");
			message.push("(+3 Resilience for 2 days)");
			deer.fullyHeal();
			deer.addStatusEffect(new DeerStatusEffect("Relaxed", 3, 0, 3, 0, 0, 0));
		}
		else
		{
			message.push("The firefly you follow leads to a smaller group of fireflies surrounding a small puddle.");
			message.push("Disappointed, you head back.");
		}
		
		showResult(message);
	}
	
	public function healingBerries(choice:String, deer:Deer)
	{
		GameVariables.instance.darkForestHealingBerriesFound = true;
		
		var gameVariables:GameVariables = GameVariables.instance;
		
		var randomNums:FlxRandom = new FlxRandom();
		var berryFindingSkill:Int = deer.lck * 2 + deer.int + randomNums.int(0, 3);
		
		var message:Array<String> = new Array<String>();
		message.push("You stumble upon some berry bushes, all of which had already been picked clean.");
		
		if (berryFindingSkill >= 13)
		{
			message.push("Looking around the area for any remaining berries, you manage to find a bush with more than enough for the whole herd.");
			message.push("(+2 health for each deer)");
			message.push("(+1 Food)");
			for (i in 0...gameVariables.controlledDeer.length) {
				gameVariables.controlledDeer[i].heal(2);
			}
			GameVariables.instance.modifyFood(1);
        }
		else if (berryFindingSkill >= 9)
		{
			message.push("Looking around the area for any remaining berries, you manage to find a bush with just enough left for the whole herd to have one.");
			message.push("(+1 health for each deer)");
			for (i in 0...gameVariables.controlledDeer.length) {
				gameVariables.controlledDeer[i].heal(1);
			}
		}
		else
		{
			message.push("You search around for any remaining berries, but aren't able to find any.");
		}
		
		showResult(message);
	}
	
	public function speedHerbs(choice:String, deer:Deer)
	{
		GameVariables.instance.darkForestSpeedHerbsFound = true;
		
		var gameVariables:GameVariables = GameVariables.instance;
		
		var randomNums:FlxRandom = new FlxRandom();
		var monchingSkill:Int = deer.lck + randomNums.int(0, 3);
		
		var message:Array<String> = new Array<String>();
		message.push("While absentmindedly munching on grass, you munch on an herb that's extremely bitter.");
		message.push("It perks you up and you feel compelled to munch everything in the area in search of another.");
		
		if (monchingSkill >= 6)
		{
			message.push("The area around you happens to be full of these herbs, and you monch them all.");
			message.push("(+3 Dexterity for 2 days)");
			deer.addStatusEffect(new DeerStatusEffect("Speediest Herbs", 3, 0, 0, 3, 0, 0));
        }
		else if (monchingSkill >= 3)
		{
			message.push("You munch on everything nearby, finding a few other similar herbs.");
			message.push("(+2 Dexterity for 2 days)");
			deer.addStatusEffect(new DeerStatusEffect("Speedier Herbs", 3, 0, 0, 2, 0, 0));
		}
		else
		{
			message.push("You munch on everything nearby, but don't find any more of that herb.");
			message.push("(+1 Dexterity for 2 days)");
			deer.addStatusEffect(new DeerStatusEffect("Speedy Herbs", 3, 0, 0, 1, 0, 0));
		}
		
		message.push("(+1 Food)");
		GameVariables.instance.modifyFood(1);
		
		showResult(message);
	}
	
	public function aimlessWandering(choice:String, deer:Deer)
	{
		var randomNums:FlxRandom = new FlxRandom();
		var springFindingSkill:Int = deer.lck + randomNums.int(0, 3);
		
		var message:Array<String> = new Array<String>();
		
		message.push("You wander around in the dark, trying to traverse the dark woods as well as you can.");
		message.push("You get a bit more used to navigating the dark and bumping into trees.");
		message.push("(+1 Strength, +1 Resilience, and +1 Dexterity for 2 days)");
		deer.addStatusEffect(new DeerStatusEffect("Relaxed", 3, 1, 1, 1, 0, 0));
		
		showResult(message);
	}
	
	override public function forage(deer:Deer) {
		var randomNums:FlxRandom = new FlxRandom();
		var forageResult = (deer.int * 2) + (deer.lck) + randomNums.int(0, 10);
		
		if(forageResult <= 6){
			showResult(["You are unable to find any food today."]);
		}else if(forageResult <= 11){
			GameVariables.instance.modifyFood(2);
			showResult(["You find a pile of acorns to eat (+2 food)."]);
		}else if(forageResult <= 17){
			GameVariables.instance.modifyFood(3);
			showResult(["You find some turnips and dig them up (+3 food)."]);
		}else{
			GameVariables.instance.modifyFood(4);
			showResult(["You find a tree surrounded by fallen chestnuts and gather as many as you can (+4 food)."]);
		}
	}
	
	override public function defend(deer:Array<Deer>) {
		var gameVariables:GameVariables = GameVariables.instance;
		var randomNums:FlxRandom = new FlxRandom();
		
		randomNums.shuffle(deer);
		
		var enemyWolves:Int = gameVariables.darkForestWolves.length;
		
		var message:Array<String> = new Array<String>();
		
		//if no wolves attacking
		if(enemyWolves < 2 || gameVariables.currentFood <= 0){
			continueOn();
			return;
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
						wolfTarget.hp--;
						
						if (wolfTarget.hp > 0)
						{
							message.push(deerAttacker.getName() + " lands a kick on a wolf. It stumbles backwards, then slowly stands up.");
						}
						else
						{
							message.push(deerAttacker.getName() + " lands a kick on a wolf. It whimpers and backs off into the dark.");
							if(wolvesInAttack.indexOf(wolfTarget) < wolfAttackIndex){
								wolfAttackIndex--;
							}
							wolvesInAttack.remove(wolfTarget);
						}
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
				
				//make sure the wolf always has some chance to hit an attack
				var maxBonusNeededToCatchDeer:Int = deerTarget.dex - wolfAttacker.dex + 1;
				
				//check for accuracy/speed
				if (wolfAttacker.dex + randomNums.int(0, cast(Math.max(maxBonusNeededToCatchDeer, 3), Int)) >= deerTarget.dex + randomNums.int(0, 2)){
					
					//make sure the wolf always has some chance to deal damage
					var maxBonusNeededToDealDamage:Int = deerTarget.res - wolfAttacker.str + 1;
				
					//check for damage (no damage, enough to scare off, or enough to remove)
					var wolfAttackStrength:Int = wolfAttacker.str + randomNums.int(0, cast(Math.max(maxBonusNeededToDealDamage, 2), Int)) - deerTarget.res;
					
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
		
		if (wolvesInAttack.length == 1)
		{
			message.push("The last wolf backs off, not wanting to fight alone.");
			message.push("All the wolves have backed off; the fight is won.");
			showResult(message);
		}
		else if (wolvesInAttack.length == 0)
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
		var message:Array<String> = new Array<String>();
		
		message.push("Your hunting pack comes across a clearing filled with fireflies.");
		
		var firefliesCaught:Int = 0;
		for (i in 0...deer.length)
		{
			var currentDeer:Deer = deer[i];
			var fireflyCatchingSkill:Int = currentDeer.dex * 2 + currentDeer.lck + randomNums.int(0, 5);
			
			if (fireflyCatchingSkill >= 19)
			{
				message.push(currentDeer.getName() + " runs through the clearing, filling their mouth with fireflies until their cheeks bulge out.");
				firefliesCaught += 5;
			}
			else if (fireflyCatchingSkill >= 17)
			{
				message.push(currentDeer.getName() + " runs through the clearing, filling their mouth with fireflies.");
				firefliesCaught += 4;
			}
			else if (fireflyCatchingSkill >= 15)
			{
				message.push(currentDeer.getName() + " walks through the clearing, casually catching a few large clumps of fireflies in their mouth.");
				firefliesCaught += 3;
			}
			else if (fireflyCatchingSkill >= 13)
			{
				message.push(currentDeer.getName() + " manages to catch a good clump of fireflies in their mouth.");
				firefliesCaught += 2;
			}
			else if (fireflyCatchingSkill >= 10)
			{
				message.push(currentDeer.getName() + " manages to catch a couple fireflies in their mouth.");
				firefliesCaught += 1;
			}
			else
			{
				message.push(currentDeer.getName() + " fails to catch any fireflies.");
			}
		}
		
		var gameVariables:GameVariables = GameVariables.instance;
		
		var thisRoundsDefenders:Array<Deer> = new Array();
		for (i in 0...gameVariables.controlledDeer.length) {
			if (gameVariables.controlledDeer[i].currentAction == "Defending") {
				thisRoundsDefenders.push(gameVariables.controlledDeer[i]);
			}
        }
		
		var dexToGive:Int = 0;
		if (firefliesCaught == 0)
		{
			message.push("Unable to catch any fireflies, your hunting pack heads back to the den.");
		}
		else if (firefliesCaught <= 2)
		{
			message.push("Your hunting pack catches some fireflies, but not enough to be of any use.");
		}
		else if (firefliesCaught >= 3)
		{
			message.push("Your hunting pack catches enough fireflies to dimly light a small area, which should make it a bit easier for your defenders to maneuver tonight.");
			message.push("(+1 Dexterity for defending deer tonight)");
			dexToGive = 1;
		}
		else if (firefliesCaught >= 5)
		{
			message.push("Your hunting pack catches enough fireflies to light up most of the area around your den, which should make it easier for your defenders to maneuver tonight.");
			message.push("(+2 Dexterity for defending deer tonight)");
			dexToGive = 2;
		}
		else if (firefliesCaught >= 8)
		{
			message.push("Your hunting pack catches enough fireflies to completely light up the area around your den; your defenders should have no trouble maneuvering tonight.");
			message.push("(+3 Dexterity for defending deer tonight)");
			dexToGive = 3;
		}
		
		if (dexToGive > 0)
		{
			for (i in 0...thisRoundsDefenders.length) {
				thisRoundsDefenders[i].addStatusEffect(new DeerStatusEffect("FireFlight", 1, 0, 0, dexToGive, 0, 0));
			}
		}
		
		randomNums.shuffle(deer);
		showResult(message);
	}
}