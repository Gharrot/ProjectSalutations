package locations;

import statuses.DeerStatusEffect;

import flixel.math.FlxRandom;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class TheTrail extends Location
{

	public function new(){
		super();
		
		name = "The Trail";
		backgroundImageFile = "assets/images/LocationImages/AbandonedFields.png";
		backgroundImageFileNoFrame = "assets/images/LocationImages/AbandonedFieldsNoFrame.png";
		backgroundImageFileMiniFramed = "assets/images/LocationImages/AbandonedFieldsEmptyDeerTile.png";
	}
	
	override public function returnAfterDayEnd()
	{
		
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
		deer.addStatusEffect(new DeerStatusEffect("Stone Stepper", 3, 0, 0, 2, 0, 0));
		
		var message:Array<String> = new Array<String>();
		message.push("You come across a small river with some stones leading across it.");
		message.push("You hop back and forth across them a bit, getting better at not slipping as you do.");
		message.push("(+2 Dexterity for 2 days).");
		showResult(message);
	}
	
	public function gettingRopes(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		message.push("You come across a bundle of ropes washed up on the side of creek.");
		message.push("Taking some will make the journey harder, but you might find some use for them.");
		showChoice(message, ["Take some", "Leave"], [takePlanks, continueOnChoice], deer);
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
			deer.addStatusEffect(new DeerStatusEffect("Mountain's Rest", 1, 0, 0, 0, 0, 0));
			message.push("The path to the spring is steep and crumbling, but you eventually get there and spend the rest of the day relaxing within it.");
			message.push("(You are fully healed and wont lose health while travelling today).");
			deer.fullyHeal();
		}
		else
		{
			message.push("The path to the spring is steep and crumbling, and you aren't able to make it up to the spring.");
		}
		
		showResult(message);
	}
	
	public function lowerSpring(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		message.push("The path leads through some mountains, and you pass by a warm pond fed from above.");
		
		deer.addStatusEffect(new DeerStatusEffect("Mountain's Rest", 1, 0, 0, 0, 0, 0));
		message.push("You step into the warm pond and relax for a while.");
		message.push("(You wont lose health while travelling today).");
		
		showResult(message);
	}
	
	public function diplomacyZone(choice:String, deer:Deer)
	{
		
	}
	
	public function screamingZone(choice:String, deer:Deer)
	{
		
	}
	
	public function theRavine(choice:String, deer:Deer)
	{
		
	}
	
	public function theRelaxingWalk(choice:String, deer:Deer)
	{
		
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
		
	}
	
	override public function hunt(deer:Array<Deer>) {
		var randomNums:FlxRandom = new FlxRandom();
		var message:Array<String> = new Array<String>();
		
		showResult(message);
	}
}