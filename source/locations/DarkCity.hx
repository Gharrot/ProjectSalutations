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
		}else if(forageResult <= 19){
			GameVariables.instance.modifyFood(5);
			showResult(["You find a giant stash of chestnuts buried behind a house (+5 food)."]);
		}else{
			GameVariables.instance.modifyFood(8);
			showResult(["You find a hidden greenhouse completely overgrown with leafy vegetables (+8 food)."]);
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
		var randomNums:FlxRandom = new FlxRandom();
		randomNums.shuffle(deer);

		var result:Array<String> = new Array<String>();
		
		if (GameVariables.instance.darkCityScurriers > 0)
		{
			if (GameVariables.instance.darkCityScurriers <= 3)
			{
				result.push("You hear a few creatures gathering in the dark outside your den.");
			}
			else if (GameVariables.instance.darkCityScurriers <= 5)
			{
				result.push("You hear a group of creatures gathering in the dark outside your den.");
			}
			else
			{
				result.push("You hear a mass of creatures gathering in the dark outside your den.");
			}
			
			if (GameVariables.instance.darkCitySticks > 0)
			{
				if (GameVariables.instance.darkCitySticks == 1)
				{
					result.push("You've gathered a stick to build a barricade.");
				}
				else
				{
					result.push("You've gathered up " + GameVariables.instance.darkCitySticks + " sticks for building barricades.");
				}
				
				if (deer.length > 0)
				{
					showChoiceMultipleDeer(result, ["Build"], [buildBarricades], deer);
				}
				else
				{
					result.push("But there aren't any deer defending available to build any.");
				}
			}
		}
		
		result.push("The creatures in the dark start to launch a volley of stones and sharpened sticks.");
		
		if (GameVariables.instance.darkCityBarricades > 0)
		{
			result.push("Will your defending deer block and deflect the attacks, or hide behind the barricades with the rest?");
		}
		else
		{
			result.push("Will your defending deer block and deflect the attacks, or hide in the den with the rest?");
		}
		
		showChoiceMultipleDeer(result, ["Deflect", "Hide"], [defendVolley, defendVolley], deer);
	}
	
	public function buildBarricades(choice:String, deer:Array<Deer>)
	{
		var barricadesBuilt = GameVariables.instance.darkCitySticks;
		GameVariables.instance.darkCityBarricades += GameVariables.instance.darkCitySticks;
		GameVariables.instance.darkCitySticks = 0;
		
		var result:Array<String> = new Array<String>();
		if (barricadesBuilt == GameVariables.instance.darkCityBarricades)
		{
			if (GameVariables.instance.darkCityBarricades == 1)
			{
				result.push("Your herd builds up a barricade.");
			}
			else
			{
				result.push("Your herd builds up " + barricadesBuilt + " barricades.");
			}
		}
		else
		{
			result.push("Your herd builds up " + barricadesBuilt + " barricades, leaving you with " + GameVariables.instance.darkCityBarricades + " standing.");
		}
		
		result.push("The creatures in the dark start to launch a volley of stones and sharpened sticks.");
		
		if (GameVariables.instance.darkCityBarricades == 1)
		{
			result.push("Will your defending deer block and deflect the attacks, or hide behind the barricade with the rest?");
		}
		else
		{
			result.push("Will your defending deer block and deflect the attacks, or hide behind the barricades with the rest?");
		}
		showChoiceMultipleDeer(result, ["Deflect", "Hide"], [defendVolley, defendVolley], deer);
	}
	
	public function defendVolley(choice:String, deer:Array<Deer>)
	{
		var randomNums:FlxRandom = new FlxRandom();
		var result:Array<String> = new Array<String>();
		
		var defendingDeer:Array<Deer> = new Array<Deer>();
		if (choice == "Deflect")
		{
			defendingDeer = activeDeer;
		}
		
		for (i in 0...GameVariables.instance.darkCityScurriers)
		{
			var dealtWith:Bool = false;
			
			for (j in 0...defendingDeer.length)
			{
				var currentDeer = defendingDeer[j];
				
				var catchSkill:Int = (currentDeer.dex * 3) + (currentDeer.lck * 2) + randomNums.int(0, 7);
				if (catchSkill > 22)
				{
					var landingSkill:Int = (currentDeer.dex * 2) + currentDeer.lck + randomNums.int(0, 4);
					if (landingSkill > 12)
					{
						result.push(currentDeer.getName() + " catches an arrow midair.");
					}
					else
					{
						result.push(currentDeer.getName() + " catches an arrow midair, but stumbles to the ground on landing.");
						currentDeer.takeDamage(1);
					}
					
					dealtWith = true;
					break;
				}
				
				var blockSkill:Int = (currentDeer.res * 3) + currentDeer.dex + currentDeer.lck + randomNums.int(0, 7);
				if (blockSkill > 20)
				{
					var absorbingSkill:Int = (currentDeer.res * 2) + currentDeer.lck + randomNums.int(0, 4);
					if (absorbingSkill > 16)
					{
						result.push(currentDeer.getName() + " blocks a projectile and safely absorbs the blow.");
					}
					else
					{
						result.push(currentDeer.getName() + " blocks a projectile and is only slightly harmed.");
						currentDeer.takeDamage(1);
					}
					
					dealtWith = true;
					break;
				}
			}
			
			if (!dealtWith)
			{
				if (GameVariables.instance.darkCityBarricades > 0)
				{
					GameVariables.instance.darkCityBarricades--;
					result.push("A projectile strikes one of the barricades and destroys it.");
				}
				else
				{
					var vulnerableDeer:Array<Deer> = GameVariables.instance.getConsciousDeer();
					var hitDeer:Deer = randomNums.getObject<Deer>(vulnerableDeer);
					
					result.push("A projectile strikes " + currentDeer.getName() + "!");
					hitDeer.takeDamage(3);
				}
			}
		}
		
		showResult(result);
	}
	
	override public function hunt(deer:Array<Deer>) {
		var randomNums:FlxRandom = new FlxRandom();
		randomNums.shuffle(deer);

		var result:Array<String> = new Array<String>();

		//Human
		result.push("Your hunting pack heads into the darkness, tracking one of the figures through the unlit streets of the city.\n");
		var initialCatch:Bool = false;
		for (i in 0...deer.length)
		{
			//Successful catch
			if (randomNums.int(0, 6) + (deer[i].dex*2) + deer[i].lck >= 16)
			{
				initialCatch = true;
				result.push(deer[i].name + " catches up to the figure and trips them up.");
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
						result.push(deer[i].name + " lands a powerful blow on the creature.");
						damageDealt += 2;
					}
					else if (hitStrength >= 10)
					{
						result.push(deer[i].name + " deals a solid blow to the creature.");
						damageDealt += 1;
					}
					else
					{
						result.push(deer[i].name + " lands an ineffective attack on the creature.");
					}
				}
				else
				{
					result.push(deer[i].name + " fails to land their attack.");
				}

				if (damageDealt >= 4)
				{
					GameVariables.instance.darkCityWidgetsObtained++;
					result.push("The figure stumbles for a moment, dropping a widget.");
					result.push("You pick it up as they bolt further into the dark (+1 widget).");
					break;
				}
			}
			
			if (damageDealt < 4)
			{
				if (damageDealt >= 1)
				{
					result.push("The creature bolts into the darkness with barely a scratch.");
				}
				else
				{
					result.push("The creature bolts into the darkness unharmed.");
				}
			}
		}
		else
		{
			result.push("No one is able to keep up with the creature as they weave through the dark city streets.");
		}

		showResult(result);
	}
}