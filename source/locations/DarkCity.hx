package locations;

import haxe.Int64Helper;
import statuses.DeerStatusEffect;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.FlxAxes;
import flixel.math.FlxRandom;


class DarkCity extends Location
{

	public function new(){
		super();
		
		name = "Dark City";
		backgroundImageFile = "assets/images/LocationImages/OnsenTop.png";
		backgroundImageFileNoFrame = "assets/images/LocationImages/OnsenTopNoFrame.png";
		backgroundImageFileMiniFramed = "assets/images/LocationImages/OnsenTopEmptyDeerTile.png";
	}
	
	override public function explore(deer:Deer)
	{
		var exploreOptionNames:Array<String> = new Array<String>();
		var exploreOptionFunctions:Array<(String, Deer)->Void> = new Array<(String, Deer)->Void>();

		//Astronomy Lab 
		if (GameVariables.instance.undergroundCityObservatoryViewed)
		{
			exploreOptionNames.push("The Observatory");
		}
		else
		{
			exploreOptionNames.push("???");
		}
		exploreOptionFunctions.push(enterObservatory);

		//The Church 
		if (GameVariables.instance.undergroundCityChurchViewed)
		{
			exploreOptionNames.push("The Chapel");
		}
		else
		{
			exploreOptionNames.push("???");
		}
		exploreOptionFunctions.push(enterChurch);

		//The Pods 
		if (GameVariables.instance.undergroundCityLabsViewed)
		{
			exploreOptionNames.push("The Lab");
		}
		else
		{
			exploreOptionNames.push("???");
		}
		exploreOptionFunctions.push(enterPods);

		showChoice(["Where will you head to?"], exploreOptionNames, exploreOptionFunctions, deer);
	}
	
	public function enterObservatory(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		message.push("You walk into the observatory.");
		showResult(message);
	}
	
	public function enterChurch(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		message.push("You walk into the church.");
		showResult(message);
	}
	
	public function enterPods(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		message.push("You walk into the lab filled with pods.");
		showResult(message);
	}
	
	override public function forage(deer:Deer) 
	{
		var message:Array<String> = new Array<String>();
		message.push("You can either forage for food, or scavenge up some sticks for defenders to build barricades with.");
		
		var exploreOptionNames:Array<String> = new Array<String>();
		var exploreOptionFunctions:Array<(String, Deer)->Void> = new Array<(String, Deer)->Void>();
		
		//Food
		exploreOptionNames.push("Food");
		exploreOptionFunctions.push(foodForaging); 
		
		//Sticks
		exploreOptionNames.push("Sticks");
		exploreOptionFunctions.push(stickForaging); 

		showChoice(message, exploreOptionNames, exploreOptionFunctions, deer);
	}
	
	public function foodForaging(choice:String, deer:Deer)
	{
		var randomNums:FlxRandom = new FlxRandom();
		var forageResult = (deer.int * 2) + (deer.lck) + randomNums.int(0, 10);
		
		if(forageResult <= 6){
			showResult(["You are unable to find any food today."]);
		}else if(forageResult <= 11){
			GameVariables.instance.modifyFood(2);
			showResult(["You find some shrubs growing in the empty greenhouses (+2 food)."]);
		}else if(forageResult <= 17){
			GameVariables.instance.modifyFood(3);
			showResult(["You find a large patch of shrubbery growing next to a broken water fountain (+3 food)."]);
		}else{
			GameVariables.instance.modifyFood(4);
			showResult(["You find a giant stash of chestnuts buried behind a house (+4 food)."]);
		}
	}
	
	public function stickForaging(choice:String, deer:Deer)
	{
		var randomNums:FlxRandom = new FlxRandom();
		var forageResult = (deer.int * 2) + (deer.lck) + randomNums.int(0, 10);
		
		if (forageResult <= 6){
			GameVariables.instance.darkCitySticks += 1;
			showResult(["You find a stick (+1 stick)."]);
		}else if(forageResult <= 11){
			GameVariables.instance.darkCitySticks += 2;
			showResult(["You gather a couple good sticks from a barren shrub (+2 sticks)."]);
		}else if(forageResult <= 17){
			GameVariables.instance.darkCitySticks += 3;
			showResult(["You gather a few nice sticks from a hidden patch of shrubbery (+3 sticks)."]);
		}else{
			GameVariables.instance.darkCitySticks += 4;
			showResult(["You find what seems to be an abandoned tiny barricade and collect the sticks (+4 sticks)."]);
		}
	}
	
	override public function defend(deer:Array<Deer>)
	{
		if (deer.length > 0)
		{
			showResult(["The mountain peak is peaceful, and nothing attacks your den."]);
		}
		else
		{
			setOut();
		}
	}
	
	override public function hunt(deer:Array<Deer>) {
		var randomNums:FlxRandom = new FlxRandom();
		randomNums.shuffle(deer);

		var result:Array<String> = new Array<String>();

		//Human
		result.push("Your hunting pack finds a small rabbit.\n");
		var initialCatch:Bool = false;
		for (i in 0...deer.length)
		{
			//Successful catch
			if (randomNums.int(0, 6) + (deer[i].dex*2) + deer[i].lck >= 16)
			{
				initialCatch = true;
				result.push(deer[i].name + " runs the rabbit down and trips it up.");
				break;
			}
		}

		if (initialCatch)
		{
			var damageDealt:Int = 0;
			for (i in 0...deer.length)
			{
				//Successful hit
				if (randomNums.int(0, 8) + (deer[i].dex*2) + (deer[i].lck - 2) >= 8)
				{
					var hitStrength:Int = randomNums.int(0, 8) + (deer[i].str * 2) + (deer[i].lck - 1);

					if (hitStrength >= 15)
					{
						result.push(deer[i].name + " lands a critical blow on the rabbit.");
						damageDealt += 2;
					}
					else if (hitStrength >= 10)
					{
						result.push(deer[i].name + " deals a solid blow to the rabbit.");
						damageDealt += 1;
					}
					else
					{
						result.push(deer[i].name + " lands an ineffective attack on the rabbit.");
					}
				}
				else
				{
					result.push(deer[i].name + " fails to land their attack.");
				}

				if (damageDealt >= 2)
				{
					GameVariables.instance.modifyFood(5);
					result.push("The rabbit lies defeated for a moment, then bounds off happily.");
					
					if (GameVariables.instance.rabbitFurBeddingMade)
					{
						result.push("The rabbit leads you to its den, where it offers you some food (+5 food).");
					}
					else
					{
						GameVariables.instance.addUnfamiliarWoodsRabbitFur();
						result.push("The rabbit leads you to its den, where it offers you some food and some of its fluffy shed fur (+5 food) (+1 rabbit fur).");
						
						if (GameVariables.instance.rabbitFur >= 2)
						{
							GameVariables.instance.rabbitFur = 0;
							GameVariables.instance.rabbitFurBeddingMade = true;
							result.push("With the rabbit fur you just got you now have enough to make some bedding with it, so you go ahead and do so.");
							result.push("(+1 Health and +1 Fortune for deer when resting)");
						}
						else 
						{
							result.push("If you had a bit more rabbit fur you could make some bedding from it.");
						}
					}
					break;
				}
			}
			
			if (damageDealt < 2)
			{
				if (damageDealt == 1)
				{
					result.push("The rabbit bounds off with a few new scratches.");
				}
				else
				{
					result.push("The rabbit bounds off unharmed.");
				}
			}
		}
		else
		{
			result.push("No one is able to keep up to the rabbit and it bounds off.");
		}

		showResult(result);
	}
}