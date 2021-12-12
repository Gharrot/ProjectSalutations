package locations;

import statuses.DeerStatusEffect;

import flixel.math.FlxRandom;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class TheTrail extends Location
{

	var rabbitAttackReduction:Int = 0;
	var planksPlaced:Bool = false;
	var ropesPlaced:Bool = false;
	
	public function new(){
		super();
		
		name = "The Trail";
		backgroundImageFile = "assets/images/LocationImages/AbandonedFields.png";
		backgroundImageFileNoFrame = "assets/images/LocationImages/AbandonedFieldsNoFrame.png";
		backgroundImageFileMiniFramed = "assets/images/LocationImages/AbandonedFieldsEmptyDeerTile.png";
	}
	
	public function updateBackgroundImages()
	{
		if (GameVariables.instance.theTrailDayNumber == 1)
		{
			backgroundImageFile = "assets/images/LocationImages/AbandonedFields.png";
			backgroundImageFileNoFrame = "assets/images/LocationImages/AbandonedFieldsNoFrame.png";
			backgroundImageFileMiniFramed = "assets/images/LocationImages/AbandonedFieldsEmptyDeerTile.png";
			//backgroundImageFile = "assets/images/LocationImages/TheTrailDay2.png";
			//backgroundImageFileNoFrame = "assets/images/LocationImages/TheTrailDay2NoFrame.png";
			//backgroundImageFileMiniFramed = "assets/images/LocationImages/TheTrailDay2EmptyDeerTile.png";
		}
		else if (GameVariables.instance.theTrailDayNumber == 2)
		{
			backgroundImageFile = "assets/images/LocationImages/TheTrailDay25.png";
			backgroundImageFileNoFrame = "assets/images/LocationImages/TheTrailDay25NoFrame.png";
			backgroundImageFileMiniFramed = "assets/images/LocationImages/TheTrailDay25EmptyDeerTile.png";
		}
		else if (GameVariables.instance.theTrailDayNumber == 3)
		{
			backgroundImageFile = "assets/images/LocationImages/TheTrailDay3.png";
			backgroundImageFileNoFrame = "assets/images/LocationImages/TheTrailDay3NoFrame.png";
			backgroundImageFileMiniFramed = "assets/images/LocationImages/TheTrailDay3EmptyDeerTile.png";
		}
		else if (GameVariables.instance.theTrailDayNumber == 4)
		{
			backgroundImageFile = "assets/images/LocationImages/TheTrailDay4.png";
			backgroundImageFileNoFrame = "assets/images/LocationImages/TheTrailDay4NoFrame.png";
			backgroundImageFileMiniFramed = "assets/images/LocationImages/TheTrailDay4EmptyDeerTile.png";
		}
		else if (GameVariables.instance.theTrailDayNumber == 5)
		{
			backgroundImageFile = "assets/images/LocationImages/TheTrailDay5.png";
			backgroundImageFileNoFrame = "assets/images/LocationImages/TheTrailDay5NoFrame.png";
			backgroundImageFileMiniFramed = "assets/images/LocationImages/TheTrailDay5EmptyDeerTile.png";
		}
	}
	
	override public function returnAfterDayEnd()
	{
		var gameVariables:GameVariables = GameVariables.instance;
		var message:Array<String> = new Array<String>();
		
		if (GameVariables.instance.theTrailDayNumber == 1)
		{
			damageEveryone(message, 2);
			message.push("The trail ahead for today looks to be no tougher than yesterday's journey.");
		}
		else if (GameVariables.instance.theTrailDayNumber == 2)
		{
			damageEveryone(message, 2);
			message.push("The trail ahead for today looks to be much tougher than today's.");
		}
		else if (GameVariables.instance.theTrailDayNumber == 3)
		{
			for (i in 0...gameVariables.controlledDeer.length)
			{
				if (gameVariables.controlledDeer[i].checkForStatusByName("Mountain's Rest"))
				{
					//we chillin
				}
				else if (gameVariables.controlledDeer[i].currentAction == "Resting")
				{
					gameVariables.controlledDeer[i].takeDamage(2);
				}
				else
				{
					gameVariables.controlledDeer[i].takeDamage(4);
				}
			}
			
			message.push("The trail heads uphill all day, draining the energy of your deer.");
			message.push("(4 damage to all non-resting deer)");
			message.push("(2 damage to all resting deer)");
			
			message.push("The trail ahead seems easy enough, but you can see many packs of rabbits wandering around.");
			message.push("You should prepare to have your food stores attacked tonight.");
		}
		else if (GameVariables.instance.theTrailDayNumber == 4)
		{
			damageEveryone(message, 2);
			message.push("The trail ahead seems kinder, and you feel like you've almost reached the end.");
			message.push("As long as you gather enough food for tonight you should be able to complete your journey.");
		}
		else if (GameVariables.instance.theTrailDayNumber == 5)
		{
			
			message.push("After a short hike through some rocky terrain, you come to a small hill overlooking the surrounding area.");
			message.push("Your journey is finished.");
			
			if (!GameVariables.instance.theTrailCompleted)
			{
				message.push("(You can now spend food to travel back here without going through the whole trail)");
			}
			
			GameVariables.instance.theTrailCompleted = true;
			showChoice(message, ["Continue"], [finishingTheTrail], gameVariables.getPlayerDeer());
		}
		
		
		if (ropesPlaced && !planksPlaced)
		{
			ropesPlaced = false;
			message.push("You hear the distinct sound of some ropes falling off a ravine.");
		}
		else if (planksPlaced && !ropesPlaced)
		{
			planksPlaced = false;
			message.push("You hear the distinct sound of some planks falling off a ravine.");
		}
		
		
		if (GameVariables.instance.theTrailDayNumber < 5)
		{
			GameVariables.instance.theTrailDayNumber++;
			showChoice(message, ["Continue"], [returnToDenChoice], null);
			updateBackgroundImages();
		}
	}
	
	public function finishingTheTrail(choice:String, deer:Deer)
	{
		GameVariables.instance.changeLocation("Stone Stronghold Entrance");
		resetDailyVariables();
		returnToDen();
	}
	
	public function damageEveryone(message:Array<String>, amount:Int)
	{
		var gameVariables:GameVariables = GameVariables.instance;
		message.push("The trail continues onwards, draining the energy of your deer.");
		message.push("(2 damage to all non-resting deer)");
		
		for (i in 0...gameVariables.controlledDeer.length)
		{
			if (gameVariables.controlledDeer[i].currentAction != "Resting")
			{
				gameVariables.controlledDeer[i].takeDamage(amount);
				
				if (gameVariables.controlledDeer[i].checkForStatusByName("Carrying Planks") && gameVariables.controlledDeer[i].checkForStatusByName("Carrying Ropes"))
				{
					gameVariables.controlledDeer[i].takeDamage(2);
					message.push("(+2 damage to " + gameVariables.controlledDeer[i].getName() + " from carrying planks and ropes)");
				}
				else if (gameVariables.controlledDeer[i].checkForStatusByName("Carrying Planks"))
				{
					gameVariables.controlledDeer[i].takeDamage(1);
					message.push("(+1 damage to " + gameVariables.controlledDeer[i].getName() + " from carrying planks)");
				}
				else if (gameVariables.controlledDeer[i].checkForStatusByName("Carrying Ropes"))
				{
					gameVariables.controlledDeer[i].takeDamage(1);
					message.push("(+1 damage to " + gameVariables.controlledDeer[i].getName() + " from carrying ropes)");
				}
			}
		}
	}
	
	override public function explore(deer:Deer)
	{
		var gameVariables:GameVariables = GameVariables.instance;
		
		var exploreOptionNames:Array<String> = new Array<String>();
		var exploreOptionFunctions:Array<(String, Deer)->Void> = new Array<(String, Deer)->Void>();
		
		if (gameVariables.theTrailDayNumber == 1)
		{
			//Planks
			if (gameVariables.theTrailDayPlanksFound)
			{
				exploreOptionNames.push("Plank Pile");
			}
			else
			{
				exploreOptionNames.push("???");
			}
			exploreOptionFunctions.push(gettingPlanks);
			
			//Dex Training
			if (gameVariables.theTrailDayStonesFound)
			{
				exploreOptionNames.push("Stepping Stones");
			}
			else
			{
				exploreOptionNames.push("???");
			}
			exploreOptionFunctions.push(trainingDexterity);
		}
		else if (gameVariables.theTrailDayNumber == 2)
		{
			//Ropes
			if (gameVariables.theTrailDayRopesFound)
			{
				exploreOptionNames.push("Rope Pile");
			}
			else
			{
				exploreOptionNames.push("???");
			}
			exploreOptionFunctions.push(gettingRopes);
			
			//Int Training
			if (gameVariables.theTrailDayStreamFound)
			{
				exploreOptionNames.push("Calming Stream");
			}
			else
			{
				exploreOptionNames.push("???");
			}
			exploreOptionFunctions.push(trainingIntellect);
		}
		else if (gameVariables.theTrailDayNumber == 3)
		{
			//Spring
			exploreOptionNames.push("Mountain Spring");
			exploreOptionFunctions.push(mountainSpring);
			
			//Puddle
			exploreOptionNames.push("Lower Spring");
			exploreOptionFunctions.push(lowerSpring);
		}
		else if (gameVariables.theTrailDayNumber == 4)
		{
			//Diplomacy
			exploreOptionNames.push("Diplomacy Zone");
			exploreOptionFunctions.push(diplomacyZone);
			
			//Screaming
			exploreOptionNames.push("Screaming Zone");
			exploreOptionFunctions.push(screamingZone);
		}
		else if (gameVariables.theTrailDayNumber == 5)
		{
			//Bridge Building
			if (gameVariables.theTrailDayBridgeFound)
			{
				if (gameVariables.theTrailDayMedallionTaken)
				{
					exploreOptionNames.push("Bridged Ravine");
				}
				else
				{
					exploreOptionNames.push("Un-bridged Ravine");
				}
			}
			else
			{
				exploreOptionNames.push("???");
			}
			exploreOptionFunctions.push(theRavine);
			
			//Relaxing Walk
			exploreOptionNames.push("Relaxing Walk");
			exploreOptionFunctions.push(theRelaxingWalk);
		} 

		showChoice(["Where will you head to?"], exploreOptionNames, exploreOptionFunctions, deer);
	}
	
	public function gettingPlanks(choice:String, deer:Deer)
	{
		GameVariables.instance.theTrailDayPlanksFound = true;
		
		var message:Array<String> = new Array<String>();
		message.push("You come across a large pile of planks sitting by an empty shed.");
		message.push("Taking some will make the journey harder, but you might find some use for them.");
		showChoice(message, ["Take some", "Leave"], [takePlanks, continueOnChoice], deer);
	}
	
	public function takePlanks(choice:String, deer:Deer)
	{
		deer.addStatusEffect(new DeerStatusEffect("Carrying Planks", 5, 0, 0, 0, 0, 0));
		
		var message:Array<String> = new Array<String>();
		message.push("You gather up some planks to bring with you.");
		message.push("(This deer will lose more health while travelling the trail)");
		showResult(message);
	}
	
	public function trainingDexterity(choice:String, deer:Deer)
	{
		GameVariables.instance.theTrailDayStonesFound = true;
		
		deer.addStatusEffect(new DeerStatusEffect("Stone Stepper", 3, 0, 0, 2, 0, 0));
		
		var message:Array<String> = new Array<String>();
		message.push("You come across a small river with some stones leading across it.");
		message.push("You hop back and forth across them a bit, getting better at not slipping as you do.");
		message.push("(+2 Dexterity for 2 days).");
		showResult(message);
	}
	
	public function gettingRopes(choice:String, deer:Deer)
	{
		GameVariables.instance.theTrailDayRopesFound = true;
		
		var message:Array<String> = new Array<String>();
		message.push("You come across a bundle of ropes washed up on the side of creek.");
		message.push("Taking some will make the journey harder, but you might find some use for them.");
		showChoice(message, ["Take some", "Leave"], [takeRopes, continueOnChoice], deer);
	}
	
	public function takeRopes(choice:String, deer:Deer)
	{
		deer.addStatusEffect(new DeerStatusEffect("Carrying Ropes", 4, 0, 0, 0, 0, 0));
		
		var message:Array<String> = new Array<String>();
		message.push("You gather up some ropes to bring with you.");
		message.push("(This deer will lose more health while travelling the trail)");
		showResult(message);
	}
	
	public function trainingIntellect(choice:String, deer:Deer)
	{
		GameVariables.instance.theTrailDayStreamFound = true;
		
		deer.addStatusEffect(new DeerStatusEffect("Creek Watcher", 3, 0, 0, 0, 2, 0));
		
		var message:Array<String> = new Array<String>();
		message.push("You come across a small creek flowing between some trees.");
		message.push("You walk along it and calm your mind.");
		message.push("(+2 Intellect for 2 days).");
		showResult(message);
	}
	
	public function mountainSpring(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		message.push("The path leads through some mountains, and you see an inviting hot spring on a cliffside above you.");
		
		if (deer.dex >= 4)
		{
			deer.addStatusEffect(new DeerStatusEffect("Mountain's Rest", 3, 0, 0, 0, 0, 0));
			message.push("The path to the spring is steep and crumbling, but you eventually get there and spend the rest of the day relaxing within it.");
			message.push("(You are fully healed and wont lose health while travelling today).");
			deer.fullyHeal();
		}
		else
		{
			message.push("The path to the spring is steep and crumbling, and you aren't able to make it up.");
		}
		
		showResult(message);
	}
	
	public function lowerSpring(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		message.push("The path leads through some mountains, and you pass by a warm pond fed from above.");
		
		deer.addStatusEffect(new DeerStatusEffect("Mountain's Rest", 3, 0, 0, 0, 0, 0));
		message.push("You step into the warm pond and relax for a while.");
		
		deer.heal(1);
		message.push("(+1 health, You wont lose health while travelling today).");
		
		showResult(message);
	}
	
	public function diplomacyZone(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		message.push("You head to an open area where a group of highstanding rabbits have gathered.");
		message.push("You can attempt to convince them not to attack tonight through discussion, or try bribing them with food.");
		
		showChoice(message, ["Discussion", "Bribery (-1 food)"], [diplomaticChoice, briberyChoice], deer);
	}
	
	public function diplomaticChoice(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		var randomNums:FlxRandom = new FlxRandom();
		
		var diplomacySkill:Int = deer.int * 2 + deer.lck - randomNums.int(0, 4);
		
		if (diplomacySkill >= 10)
		{
			rabbitAttackReduction += 3;
			message.push("You converse with the rabbits for some time, discussing many things of great importance to rabbits.");
			message.push("You expect that few rabbits will attack tonight, if any.");
		}
		else if (diplomacySkill >= 8)
		{
			rabbitAttackReduction += 2;
			message.push("You converse with the rabbits for some time, discussing the harm that their attacks would cause you.");
			message.push("You expect that at least this group of rabbits and anyone they can convince wont attack tonight.");
		}
		else if (diplomacySkill >= 6)
		{
			rabbitAttackReduction += 1;
			message.push("You converse with the rabbits for some time, discussing the weather and such.");
			message.push("You expect that at least their group wont attack tonight.");
		}
		else
		{
			message.push("You try to converse with the rabbits but they keep cutting you off and turning away.");
			message.push("You expect that you had no effect on their decision to attack tonight.");
		}
		
		showResult(message);
	}
	
	public function briberyChoice(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		
		if (GameVariables.instance.currentFood > 0)
		{
			GameVariables.instance.modifyFood(-1);
			message.push("You hand over a small bundle of food to the group of rabbits.");
			message.push("The rabbits take the food, look at you for a moment, then scurry away.");
			message.push("You expect that at least their group wont attack tonight.");
			
			rabbitAttackReduction++;
		}
		else
		{
			message.push("You step forward to offer some food to the rabbits, then realize you don't have any.");
			message.push("The rabbits look at you for a moment, then scurry away.");
		}
		
		showResult(message);
	}
	
	public function screamingZone(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		var randomNums:FlxRandom = new FlxRandom();
		
		message.push("You walk up to a group of rabbits and scream as loud as you can.");
		var screamingSkill:Int = deer.str * 2 + deer.res - randomNums.int(0, 5);
		
		if (screamingSkill >= 10)
		{
			rabbitAttackReduction += 3;
			message.push("The rabbits stare at you in terror as you roar in front of them; then quickly run away.");
			message.push("You expect that few rabbits will attack tonight, if any.");
		}
		else if (screamingSkill >= 8)
		{
			rabbitAttackReduction += 2;
			message.push("The rabbits quickly bound off as you run after them screaming.");
			message.push("You expect that at least this group of rabbits and any others they warn of you wont be attacking tonight.");
		}
		else if (screamingSkill >= 6)
		{
			rabbitAttackReduction += 1;
			message.push("The rabbits slowly back away from you before bounding off as you screech towards them.");
			message.push("You expect that at least their group wont attack tonight.");
		}
		else
		{
			message.push("The rabbits stand around and watch as you try to scream, but moreso just squawk in their direction.");
			message.push("You expect that you had no effect on their decision to attack tonight.");
		}
		
		showResult(message);
	}
	
	public function theRavine(choice:String, deer:Deer)
	{
		GameVariables.instance.theTrailDayBridgeFound = true;
		var message:Array<String> = new Array<String>();
		
		if (!GameVariables.instance.theTrailDayMedallionTaken)
		{
			message.push("You walk up to a small ravine. A small piece of land juts out of the cliff on the other side, a pedestal with a medallion on it stands there.");
			
			if (planksPlaced)
			{
				if (deer.checkForStatusByName("Carrying Ropes"))
				{
					message.push("A pile of planks sits by the edge, using the rope you're carrying you should have enough to make a makeshift bridge.");
					showChoice(message, ["Build bridge"], [crossingTheRavine], deer);
				}
				else
				{
					message.push("A pile of planks sits by the edge, there would be enough to make a bridge if you had some rope.");
					showResult(message);
				}
			}
			else if (ropesPlaced)
			{
				if (deer.checkForStatusByName("Carrying Planks"))
				{
					message.push("A pile of ropes sits by the edge, using the planks you're carrying you should have enough to make a makeshift bridge.");
					showChoice(message, ["Build bridge"], [crossingTheRavine], deer);
				}
				else
				{
					message.push("A pile of ropes sits by the edge, there would be enough to make a bridge if you had some planks.");
					showResult(message);
				}
			}
			else
			{
				if (deer.checkForStatusByName("Carrying Planks") && deer.checkForStatusByName("Carrying Ropes"))
				{
					message.push("Using the planks and the rope you're carrying you should have enough to make a makeshift bridge across.");
					showChoice(message, ["Build bridge"], [crossingTheRavine], deer);
				}
				else if (deer.checkForStatusByName("Carrying Planks"))
				{
					message.push("You could build a bridge across using your planks if you had some rope.");
					showChoice(message, ["Dropoff Planks"], [dropoffPlanks], deer);
				}
				else if (deer.checkForStatusByName("Carrying Ropes"))
				{
					message.push("You could build a bridge across using your ropes if you had some planks.");
					showChoice(message, ["Dropoff Ropes"], [dropoffRope], deer);
				}
				else
				{
					message.push("There's no way of getting across it without any way to build a bridge.");
					showResult(message);
				}
			}
		}
		else
		{
			message.push("You walk up to a small ravine. A suspension bridge leads across it to a small piece of land jutting out of the cliff on the other side.");
			message.push("A pedestal stands on the other side where you once took a medallion from.");
			showResult(message);
		}
	}
	
	public function dropoffPlanks(choice:String, deer:Deer)
	{
		planksPlaced = true;
		var message:Array<String> = new Array<String>();
		message.push("You drop off the planks by the ravine. They should be helpful if someone comes by with some rope.");
		showResult(message);
	}
	
	public function dropoffRope(choice:String, deer:Deer)
	{
		ropesPlaced = true;
		var message:Array<String> = new Array<String>();
		message.push("You drop off the ropes by the ravine. They should be helpful if someone comes by with some planks.");
		showResult(message);
	}
	
	public function crossingTheRavine(choice:String, deer:Deer)
	{
		GameVariables.instance.theTrailDayMedallionTaken = true;
		GameVariables.instance.maxPackSize++;
		
		var message:Array<String> = new Array<String>();
		message.push("You put the ropes and planks together and make a suspension bridge over the ravine.");
		message.push("After a comfortable walk across, you take the medallion off the pedestal. (+1 max pack size)");
		showResult(message);
	}
	
	public function theRelaxingWalk(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		message.push("You wander around during the day just off the trail you've been following.");
		message.push("Walking through some less travelled areas lets you munch on some berries as you walk.");
		message.push("(+2 food, +1 health).");
		
		GameVariables.instance.modifyFood(2);
		deer.heal(1);
		
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
	
	override public function defend(deer:Array<Deer>)
	{
		if (GameVariables.instance.theTrailDayNumber == 4)
		{			
			var randomNums:FlxRandom = new FlxRandom();
			var message:Array<String> = new Array<String>();
			
			if (rabbitAttackReduction >= 8)
			{
				message.push("The night comes and no rabbits show up to your den.");
				message.push("Your interactions with the rabbit gangs have paid off.");
			}
			else
			{
				if (rabbitAttackReduction >= 6)
				{
					message.push("A few rabbits approach your den.");
				}
				else if (rabbitAttackReduction >= 4)
				{
					message.push("A group of rabbits approaches your den.");
				}
				else if (rabbitAttackReduction >= 2)
				{
					message.push("A large group of rabbits approach your den.");
				}
				else
				{
					message.push("A horde of rabbits approaches your den.");
				}
				
				for (i in 0...deer.length)
				{
					var rabbitScaringSkill:Int = deer[i].dex * 2 + deer[i].lck + randomNums.int(0, 5);
					var currentDeer:Deer = deer[i];
					
					if (rabbitScaringSkill >= 19)
					{
						message.push(currentDeer.getName() + " dashes around the den, scaring away any rabbit they come across.");
						rabbitAttackReduction += 5;
					}
					else if (rabbitScaringSkill >= 17)
					{
						message.push(currentDeer.getName() + " dashes around the den, scaring off most of the rabbits they come across.");
						rabbitAttackReduction += 4;
					}
					else if (rabbitScaringSkill >= 15)
					{
						message.push(currentDeer.getName() + " chases after some rabbits, and scares off a large group of them.");
						rabbitAttackReduction += 3;
					}
					else if (rabbitScaringSkill >= 13)
					{
						message.push(currentDeer.getName() + " chases after some rabbits, and scares off a bunch of them.");
						rabbitAttackReduction += 2;
					}
					else if (rabbitScaringSkill >= 10)
					{
						message.push(currentDeer.getName() + " chases after some rabbits, but only manages to catch and scare off a couple of them.");
						rabbitAttackReduction += 1;
					}
					else
					{
						message.push(currentDeer.getName() + " chases after some rabbits, but can't catch up to any of them.");
					}
				}
				
				if (rabbitAttackReduction >= 8)
				{
					message.push("When all is said and done you lose none of your food to the rabbits.");
				}
				else if (rabbitAttackReduction >= 6)
				{
					message.push("You stopped most of the rabbits from stealing your food, but still lose some scraps.");
					message.push("(-2 food)");
					GameVariables.instance.modifyFood(-2);
				}
				else if (rabbitAttackReduction >= 4)
				{
					message.push("You stopped some of the rabbits from stealing your food, but still lose plenty.");
					message.push("(-4 food)");
					GameVariables.instance.modifyFood(-5);
				}
				else if (rabbitAttackReduction >= 2)
				{
					message.push("You barely managed to hinder the rabbits' attempts to steal your food.");
					message.push("(-6 food)");
					GameVariables.instance.modifyFood(-8);
				}
				else
				{
					message.push("The rabbits end up taking as much food as they want.");
					message.push("(-" + GameVariables.instance.currentFood + " food)");
					GameVariables.instance.modifyFood(-1 * GameVariables.instance.currentFood);
				}
			}
			
			showResult(message);
		}
		else if(deer.length > 0)
		{
			showResult(["On at least this part of the trail there are no animals looking to attack your den."]);
		}
		else
		{
			setOut();
		}
	}
	
	override public function hunt(deer:Array<Deer>) {
		var randomNums:FlxRandom = new FlxRandom();
		var message:Array<String> = new Array<String>();
		
		randomNums.shuffle(deer);
		
		//Rabbit
		message.push("Your hunting pack finds a small rabbit.");
		var initialCatch:Bool = false;
		for(i in 0...deer.length){
			//Successful catch
			if (randomNums.int(0, 8) + (deer[i].dex*2) + (deer[i].lck - 2) >= 12)
			{
				initialCatch = true;
				message.push(deer[i].name + " runs the rabbit down and trips it up.");
				break;
			}
		}
		
		if (initialCatch) {
			var damageDealth:Int = 0;
			for(i in 0...deer.length){
				//Successful hit
				if (randomNums.int(0, 8) + (deer[i].dex*2) + (deer[i].lck - 1) >= 10)
				{
					var hitStrength:Int = randomNums.int(0, 8) + (deer[i].str * 2) + (deer[i].lck - 1);
					
					if(hitStrength >= 16){
						message.push(deer[i].name + " lands a critical blow on the rabbit.");
						damageDealth += 2;
					}else if(hitStrength >= 10){
						message.push(deer[i].name + " deals a solid blow to the rabbit.");
						damageDealth += 1;
					}else{
						message.push(deer[i].name + " lands an ineffective attack on the rabbit.");
					}
				}else{
					message.push(deer[i].name + " fails to land their attack.");
				}
				
				if (damageDealth >= 2) {
					GameVariables.instance.modifyFood(3);
					GameVariables.instance.addUnfamiliarWoodsRabbitFur();
					message.push("The rabbit lies defeated. You return it to the den to use as food (+3 food) and bedding.");
					break;
				}
			}
			
			if(damageDealth == 1){
				message.push("The rabbit bounds off with a few new scratches.");
			}else{
				message.push("The rabbit bounds off unharmed.");
			}
		}else{
			message.push("No one is able to keep up to the rabbit and it bounds off.");
		}
		
		showResult(message);
	}
}