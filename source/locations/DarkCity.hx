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
	var starCycle:Array<String> = ["Rabbit", "Wolf", "Squirrel", "Goat", "Bird"];
	var componentsNeeded = 3;
	
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
		GameVariables.instance.undergroundCityObservatoryViewed = true;
		var message:Array<String> = new Array<String>();
		message.push("You walk into a small tall room carved into the back wall of the city.");
		message.push("The room is filled with screens and devices connected to a center terminal.");
		message.push("The domed ceiling is lined with diagrams of shining stars that illuminate the room.");
		showChoice(message, ["Terminal"], [observatoryTerminal], deer);
	}
	
	public function observatoryTerminal(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		message.push("As you approach the terminal all of the machines in the room whir to life and the cieling begins to rotate.");
		message.push("After a bit the ceiling stops rotating and an eyepiece slides out of the central terminal.");
		message.push("You look through the eyepiece and see stars in the shape of a " + getCurrentStarCycle() + ".");
		showResult(message);
	}
	
	public function enterChurch(choice:String, deer:Deer)
	{
		GameVariables.instance.undergroundCityChurchViewed = true;
		var message:Array<String> = new Array<String>();
		message.push("You walk into the chapel built into the north wall of the city.");
		message.push("You enter a large stone room. The walls are packed with bookshelves, and the room is filled with aisles of glass pods.");
		if (GameVariables.instance.darkCityGooDiverted)
		{
			message.push("At the far end is an altar with a large monitor on top and a towering vat of green goo on each side.");
		}
		else
		{
			message.push("At the far end is an altar with a large monitor on top and a giant empty glass vat on each side.");
		}
		showChoice(message, ["Altar"], [churchMonitor], deer);
	}
	
	public function churchMonitor(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		message.push("You walk up to the altar and the monitor powers on.");
		if (GameVariables.instance.darkCityGooDiverted)
		{
			message.push("The screen shows a blinking icon of a full vat before swapping to a new screen of 4 icons.");
			message.push("The icons are 2→, 1←, 5→, 6←.");
			message.push("A keyboard in front lights up 5 keys with different animals on them.");
			showChoice(message, starCycle, [pressKey1], deer);
		}
		else
		{
			message.push("The screen displays an icon that looks like a blinking empty vat along with some symbols you don't understand.");
			showResult(message);
		}
	}
	
	public function pressKey1(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		if (choice == getCurrentStarCycle(2))
		{
			message.push("The screen flashes green and the first icon disappears.");
			message.push("The screen displays: 1←, 5→, 6←");
			showChoice(message, starCycle, [pressKey2], deer);
		}
		else
		{
			message.push("The screen flashes red before shutting down, you'll have to try again later.");
			showResult(message);
		}
	}
	
	public function pressKey2(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		if (choice == getCurrentStarCycle(-1))
		{
			message.push("The screen flashes green and the second icon disappears.");
			message.push("The screen displays: 5→, 6←");
			showChoice(message, starCycle, [pressKey3], deer);
		}
		else
		{
			message.push("The screen flashes red before shutting down, you'll have to try again later.");
			showResult(message);
		}
	}
	
	public function pressKey3(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		if (choice == getCurrentStarCycle(5))
		{
			message.push("The screen flashes green and the third icon disappears.");
			message.push("The screen displays: 6←");
			showChoice(message, starCycle, [pressKey4], deer);
		}
		else
		{
			message.push("The screen flashes red before shutting down, you'll have to try again later.");
			showResult(message);
		}
	}
	
	public function pressKey4(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		if (choice == getCurrentStarCycle(-6))
		{
			message.push("The screen flashes green and the fourth icon disappears.");
			message.push("A green button on the keyboard begins to slowly pulse.");
			showChoice(message, ["Press It"], [startTheResurrections], deer);
		}
		else
		{
			message.push("The screen flashes red before shutting down, you'll have to try again later.");
			showResult(message);
		}
	}
	
	public function startTheResurrections(choice:String, deer:Deer)
	{
		
	}
	
	public function enterPods(choice:String, deer:Deer)
	{
		GameVariables.instance.undergroundCityLabsViewed = true;
		var message:Array<String> = new Array<String>();
		message.push("You walk into a large room carved into the wall near a chapel.");
		message.push("The room is filled with giant glass vats filled with a green goo.");
		message.push("In the center of the room is a giant machine connected to all of the vats.");
		if (GameVariables.instance.darkCityWidgetsInstalled < componentsNeeded)
		{
			message.push("It seems like it was made to pump the goo elsewhere, but it's missing some components.");
			showChoice(message, ["Machine"], [podMachine], deer);
		}
		else if (GameVariables.instance.darkCityGooDiverted)
		{
			message.push("The machine is running smoothly and you can see green goo being pumped through the tubes.");
			showResult(message);
		}
		else
		{
			message.push("It seems like it was made to pump the goo elsewhere, it just needs to be turned on.");
			showChoice(message, ["Turn On"], [turnOnGooMachine], deer);
		}
	}
	
	public function podMachine(choice:String, deer:Deer)
	{
		var componentsMissing:Int = componentsNeeded - GameVariables.instance.darkCityWidgetsInstalled;
		
		var message:Array<String> = new Array<String>();
		message.push("You walk forward and inspect the machine closer.");
		
		if (componentsMissing <= 0)
		{
			message.push("It looks ready to go, it just needs to be turned on.");
			showChoice(message, ["Turn On"], [turnOnGooMachine], deer);
		}
		else 
		{
			if (componentsMissing == 1)
			{
				message.push("It looks likes it's missing one last widget.");
			}
			else if (componentsMissing == componentsNeeded)
			{
				message.push("It looks likes it's missing " + componentsMissing + " components.");
			}
			else
			{
				message.push("It looks likes it's still missing " + componentsMissing + " more widgets.");
			}
			
			if (GameVariables.instance.darkCityWidgetsObtained > 0)
			{
				showChoice(message, ["Install Widgets"], [installComponents], deer);
			}
			else
			{
				showResult(message);
			}
		}
	}
	
	public function installComponents(choice:String, deer:Deer)
	{
		var componentsMissing:Int = componentsNeeded - GameVariables.instance.darkCityWidgetsInstalled;
		var completed:Bool = false;
		
		var message:Array<String> = new Array<String>();
		
		if (componentsMissing <= GameVariables.instance.darkCityWidgetsObtained)
		{
			GameVariables.instance.darkCityWidgetsInstalled = componentsNeeded;
			GameVariables.instance.darkCityWidgetsObtained -= componentsMissing;
			
			if (componentsMissing == componentsNeeded)
			{
				message.push("You click all of the widgets into place and a button on the side of the machine begins to blink.");
			}
			else if (componentsMissing > 1)
			{
				message.push("You click the last of the widgets into place and a button on the side of the machine begins to blink.");
			}
			else
			{
				message.push("You click the last widget into place and a button on the side of the machine begins to blink.");
			}
			
			completed = true;
		}
		else
		{
			GameVariables.instance.darkCityWidgetsInstalled += GameVariables.instance.darkCityWidgetsObtained;
			GameVariables.instance.darkCityWidgetsObtained = 0;
			
			componentsMissing = componentsNeeded - GameVariables.instance.darkCityWidgetsInstalled;
			if (GameVariables.instance.darkCityWidgetsObtained > 1)
			{
				message.push("You click the " + GameVariables.instance.darkCityWidgetsObtained + " widgets you've found into place, but you still seem to be missing " + componentsMissing + " more.");
			}
			else
			{
				message.push("You click the widget you found into place, but you still seem to be missing " + componentsMissing + " more.");
			}
		}
		
		if (completed)
		{
			showChoice(message, ["Push the Button"], [turnOnGooMachine], deer);
		}
		else
		{
			showResult(message);
		}
	}
	
	public function turnOnGooMachine(choice:String, deer:Deer)
	{
		GameVariables.instance.darkCityGooDiverted = true;
		var message:Array<String> = new Array<String>();
		message.push("You push the button on the side of the machine and it starts to chug.");
		message.push("Before long a steady stream of green goo is being pumped through the tubes headed elsewhere in the city.");
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
				
				var catchSkill:Int = (currentDeer.dex * 3) + (currentDeer.lck * 2) + randomNums.int(0, 9);
				if (catchSkill > 24)
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
				
				var blockSkill:Int = (currentDeer.res * 3) + currentDeer.dex + currentDeer.lck + randomNums.int(0, 9);
				if (blockSkill > 23)
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
					
					if (vulnerableDeer.length > 0)
					{
						var hitDeer:Deer = vulnerableDeer[randomNums.int(0, vulnerableDeer.length - 1)];
						
						result.push("A projectile strikes " + hitDeer.getName() + "!");
						hitDeer.takeDamage(3);
					}
				}
			}
			
			var originalLength:Int = defendingDeer.length;
			for (i in 1...originalLength) {
				var currentDeer:Deer = defendingDeer[originalLength - i];
				
				if (currentDeer.health <= 0)
				{
					defendingDeer.remove(currentDeer);
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
	
	public function getCurrentStarCycle(offset:Int = 0):String
	{
		var index = GameVariables.instance.currentDay % starCycle.length;
		index = index + offset;
		
		while (index < 0)
		{
			index += starCycle.length;
		}
		
		return starCycle[index % starCycle.length];
	}
}