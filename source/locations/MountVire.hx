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

class MountVire extends Location
{
	var movingUpwards:String = "No";
	var coldPhaseCompleted:Bool = false;
	var currentColdness:Int = 0;
	
	public function new(){
		super();
		
		name = "Mount Vire";
		backgroundImageFile = "assets/images/LocationImages/TheTrailDay5.png";
		backgroundImageFileNoFrame = "assets/images/LocationImages/TheTrailDay5NoFrame.png";
		backgroundImageFileMiniFramed = "assets/images/LocationImages/TheTrailDay5EmptyDeerTile.png";
	}
	
	public function updateBackgroundImages()
	{
		if (GameVariables.instance.mountVireLocation == "Base camp")
		{
			backgroundImageFile = "assets/images/LocationImages/AbandonedFields.png";
			backgroundImageFileNoFrame = "assets/images/LocationImages/AbandonedFieldsNoFrame.png";
			backgroundImageFileMiniFramed = "assets/images/LocationImages/AbandonedFieldsEmptyDeerTile.png";
		}
		else if (GameVariables.instance.mountVireLocation == "Goat plateau")
		{
			backgroundImageFile = "assets/images/LocationImages/TheTrailDay2.png";
			backgroundImageFileNoFrame = "assets/images/LocationImages/TheTrailDay2NoFrame.png";
			backgroundImageFileMiniFramed = "assets/images/LocationImages/TheTrailDay2EmptyDeerTile.png";
		}
		else if (GameVariables.instance.mountVireLocation == "The long windy path")
		{
			backgroundImageFile = "assets/images/LocationImages/TheTrailDay3.png";
			backgroundImageFileNoFrame = "assets/images/LocationImages/TheTrailDay3NoFrame.png";
			backgroundImageFileMiniFramed = "assets/images/LocationImages/TheTrailDay3EmptyDeerTile.png";
		}
		else if (GameVariables.instance.mountVireLocation == "Bird land")
		{
			backgroundImageFile = "assets/images/LocationImages/TheTrailDay4.png";
			backgroundImageFileNoFrame = "assets/images/LocationImages/TheTrailDay4NoFrame.png";
			backgroundImageFileMiniFramed = "assets/images/LocationImages/TheTrailDay4EmptyDeerTile.png";
		}
	}
	
	override public function startDay()
	{
		coldPhaseCompleted = false;
	}
	
	override public function returnAfterDayEnd()
	{
		dayEnd("dummy", GameVariables.instance.getPlayerDeer());
	}
	
	public function dayEnd(choice:String, deer:Deer)
	{
		var gameVariables:GameVariables = GameVariables.instance;
		var message:Array<String> = new Array<String>();
		
		if (!coldPhaseCompleted)
		{
			coldPhaseCompleted = true;
			coldAndFire();
			return;
		}
		
		if (gameVariables.mountVireLocation == "Base camp")
		{
			if (movingUpwards == "Yes")
			{
				mountainMovement("Goat plateau");
			}
		}
		else if (gameVariables.mountVireLocation == "Goat plateau")
		{
			if (movingUpwards == "Yes")
			{
				mountainMovement("The long windy path");
			}
			else if (movingUpwards == "Secret")
			{
				mountainMovement("Bird land");
			}
		}
		else if (gameVariables.mountVireLocation == "The long windy path")
		{
			if (movingUpwards == "Yes")
			{
				mountainMovement("Mountaintop");
			}
		}
		else if (gameVariables.mountVireLocation == "Bird land")
		{
			if (movingUpwards == "Yes")
			{
				mountainMovement("Squirrel fortress");
			}
		}
		
		movingUpwards = "No";
		
		returnToDen();
	}
	
	public function coldAndFire()
	{
		var gameVariables:GameVariables = GameVariables.instance;
		var message:Array<String> = new Array<String>();
		
		if (gameVariables.mountVireLocation == "Base camp")
		{
			currentColdness = 1;
		}
		else if (gameVariables.mountVireLocation == "Goat plateau")
		{
			currentColdness = 2;
		}
		else if (gameVariables.mountVireLocation == "The long windy path")
		{
			currentColdness = 3;
		}
		else if (gameVariables.mountVireLocation == "Bird land")
		{
			currentColdness = 2;
		}
		
		var exploreOptionNames:Array<String> = new Array<String>();
		var exploreOptionFunctions:Array < (String, Deer)->Void > = new Array < (String, Deer)->Void > ();
		
		if (gameVariables.mountVirePineLogs > 0)
		{
			exploreOptionNames.push("Burn some pine logs");
			exploreOptionFunctions.push(burnLogs);
		}
		else if (gameVariables.mountVireMapleLogs > 0)
		{
			exploreOptionNames.push("Burn some maple logs");
			exploreOptionFunctions.push(burnLogs);
		}
		
		exploreOptionNames.push("Sleep without a fire");
		exploreOptionFunctions.push(burnLogs);
		
		if (exploreOptionNames.length > 1)
		{
			if (currentColdness == 1)
			{
				message.push("It's a bit cold tonight, will you light a fire?");
			}
			else if (currentColdness == 2)
			{
				message.push("It's fairly cold tonight, will you light a fire?");
			}
			else if (currentColdness == 3)
			{
				message.push("It's very cold tonight, will you light a fire?");
			}
			else if (currentColdness == 4)
			{
				message.push("It's extremely cold tonight, will you light a fire?");
			}
			
			showChoice(message, exploreOptionNames, exploreOptionFunctions, gameVariables.getPlayerDeer());
		}
		else
		{
			coldDamage();
		}
	}
	
	public function burnLogs(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		
		if (choice == "Burn some pine logs")
		{
			currentColdness -= 1;
			GameVariables.instance.mountVirePineLogs--;
			
			if (currentColdness > 0)
			{
				message.push("You light a pine fire and huddle around it, but the night is still cold.");
			}
			else
			{
				message.push("You light a pine fire and huddle around it.");
			}
		}
		else if (choice == "Burn some maple logs")
		{
			currentColdness -= 3;
			GameVariables.instance.mountVireMapleLogs--;
			
			if (currentColdness > 0)
			{
				message.push("You light a maple fire and huddle around it, but the night is still chilling.");
			}
			else
			{
				message.push("You light a maple fire and huddle around it.");
			}
		}
		
		coldDamage(message);
	}
	
	public function coldDamage(?currentMessage:Array<String>)
	{
		var gameVariables:GameVariables = GameVariables.instance;
		var message:Array<String> = new Array<String>();
		
		if (currentMessage != null)
		{
			message = currentMessage;
		}
		
		if (currentColdness > 0)
		{
			message.push("The cold night weakens your herd.");
			message.push("(" + currentColdness + " damage to all deer)");
			
			for (i in 0...gameVariables.controlledDeer.length)
			{
				gameVariables.controlledDeer[i].takeDamage(currentColdness);
			}
			
			showChoice(message, ["Continue"], [dayEnd], gameVariables.getPlayerDeer());
		}
		else
		{
			message.push("Your warm fire staves off all of the cold.");
			showChoice(message, ["Continue"], [dayEnd], gameVariables.getPlayerDeer());
		}
	}
	
	public function mountainMovement(destination:String)
	{
		var gameVariables:GameVariables = GameVariables.instance;
		var message:Array<String> = new Array<String>();
		if (destination == "Goat plateau")
		{
			gameVariables.mountVireLocation = "Goat plateau";
			gameVariables.mountVireMountainPathBlockage = 6;
			
			message.push("Your herd treks up the mountain for a while and comes to a large plateau filled with goats.");
			message.push("The goats stare at you for a moment then bound off and up the nearby cliffsides.");
			showChoice(message, ["Continue"], [returnToDenChoice], gameVariables.getPlayerDeer());
		}
		else if (destination == "The long windy path")
		{
			gameVariables.mountVireLocation = "The long windy path";
			gameVariables.mountVireMountainPathBlockage = 8;
			
			message.push("Your herd treks up the mountain for a while and comes to a small plateau.");
			message.push("The mountain path continues upwards, growing colder and colder.");
			showChoice(message, ["Continue"], [returnToDenChoice], gameVariables.getPlayerDeer());
		}
		else if (destination == "Bird land")
		{
			gameVariables.mountVireLocation = "Bird land";
			gameVariables.mountVireMountainPathBlockage = 7;
			
			message.push("You lead your herd through the secret tunnel and onto the other side of the mountain.");
			message.push("This side is covered with flat plateaus scattered with trees.");
			message.push("Almost every tree has a few birds sitting on its branches. They eye your food supplies hungrily.");
			showChoice(message, ["Continue"], [returnToDenChoice], gameVariables.getPlayerDeer());
		}
		else if (destination == "Mountaintop")
		{
			message.push("Up.");
			showChoice(message, ["Continue"], [returnToDenChoice], gameVariables.getPlayerDeer());
		}
		else if (destination == "Squirrel fortress")
		{
			message.push("In.");
			showChoice(message, ["Continue"], [returnToDenChoice], gameVariables.getPlayerDeer());
		}
	}
	
	override public function explore(deer:Deer)
	{
		var gameVariables:GameVariables = GameVariables.instance;
		
		var exploreOptionNames:Array<String> = new Array<String>();
		var exploreOptionFunctions:Array<(String, Deer)->Void> = new Array<(String, Deer)->Void>();
		
		if (gameVariables.mountVireLocation == "Base camp")
		{
			//Mountain trail
			exploreOptionNames.push("Mountain trail");
			exploreOptionFunctions.push(mountainTrail);
			
			//Coffee tent
			exploreOptionNames.push("Coffee tent");
			exploreOptionFunctions.push(coffeeTent);
		}
		else if (gameVariables.mountVireLocation == "Goat plateau")
		{
			//The upward trail
			exploreOptionNames.push("Mountain trail");
			exploreOptionFunctions.push(mountainTrail);
			
			//The cave
			exploreOptionNames.push("The cave");
			exploreOptionFunctions.push(mountainTrail);
			
			//The smaller rocks
			exploreOptionNames.push("Small rocks");
			exploreOptionFunctions.push(smallRocks);
		}
		else if (gameVariables.mountVireLocation == "The long windy path")
		{
			//The upward trail
			exploreOptionNames.push("Windy trail");
			exploreOptionFunctions.push(windyTrail);
			
			//The smaller rocks
			exploreOptionNames.push("Small rocks");
			exploreOptionFunctions.push(smallRocks);
		}
		else if (gameVariables.mountVireLocation == "Bird land")
		{
			//The upward trail
			exploreOptionNames.push("Mountain trail");
			exploreOptionFunctions.push(mountainTrail);
			
			//The smaller rocks
			exploreOptionNames.push("Small rocks");
			exploreOptionFunctions.push(smallRocks);
		}

		showChoice(["Where will you head to?"], exploreOptionNames, exploreOptionFunctions, deer);
	}
	
	public function windyTrail(choice:String, deer:Deer)
	{
		var gameVariables:GameVariables = GameVariables.instance;
		var message:Array<String> = new Array<String>();
		
		if (gameVariables.mountVireMountainPathBlockage > 0)
		{
			if (gameVariables.mountVireMountainPathBlockage >= 5)
			{
				message.push("You continue to trek further up the mountain, but run into more rocks blocking the path.");
				message.push("The wind up here is fierce, and you'll need to be well-balanced enough to clear the path ahead.");
				message.push("The path ahead is blocked by many moderate-sized rocks.");
			}
			else if (gameVariables.mountVireMountainPathBlockage >= 3)
			{
				message.push("You continue to trek further up the mountain, but run into more rocks blocking the path.");
				message.push("The wind up here is fierce, and you'll need to be well-balanced enough to clear the path ahead.");
				message.push("The path ahead is blocked by a few moderate-sized rocks.");
			}
			else if (gameVariables.mountVireMountainPathBlockage == 2)
			{
				message.push("You continue to trek further up the mountain, but run into more rocks blocking the path.");
				message.push("The wind up here is fierce, and you'll need to be well-balanced enough to clear the path ahead.");
				message.push("The path ahead is blocked by a couple moderate-sized rocks.");
			}
			else if (gameVariables.mountVireMountainPathBlockage == 1)
			{
				message.push("You continue to trek further up the mountain, but run into more rocks blocking the path.");
				message.push("The wind up here is fierce, and you'll need to be well-balanced enough to clear the path ahead.");
				message.push("The path ahead is blocked by a moderate-sized rock.");
			}
			
			if (gameVariables.mountVireExplosives > 0)
			{
				message.push(SquirrelVillage.getExplosivesStatus(false));
				showChoice(message, ["Set off an explosive", "Maneuver some rocks", "Head back"], [setoffExplosionMoutainPath, moveRocksMountainPath, continueOnChoice], deer);
			}
			else
			{
				showChoice(message, ["Maneuver some rocks", "Head back"], [moveRocksMountainPath, continueOnChoice], deer);
			}
		}
		else
		{
			message.push("You trek up the mountain for a bit, running into no obstacles.");
			
			if (movingUpwards == "No")
			{
				message.push("Will you head further up the mountain? Your herd will follow you at the end of the day.");
				showChoice(message, ["Head up the mountain", "Head back"], [continueUpTheMountainPath, continueOnChoice], deer);
			}
			else
			{
				message.push("Another deer is already headed further up the path, will you call them back?");
				message.push("(This would stop the whole herd from heading up the mountain at the end of the day)");
				showChoice(message, ["Call them back", "Follow along"], [cancelMountainPathTrek, continueOnChoice], deer);
			}
		}
	}
	
	public function setoffExplosionWindyPath(choice:String, deer:Deer)
	{
		var gameVariables:GameVariables = GameVariables.instance;
		var message:Array<String> = new Array<String>();
		gameVariables.mountVireMountainPathBlockage -= 3;
		message.push("KABLAM!");
		
		if (gameVariables.mountVireMountainPathBlockage > 0)
		{
			message.push("You set off an explosive and it destroys most of the rocks on the path.");
			
			if (gameVariables.mountVireMountainPathBlockage >= 3)
			{
				message.push("The path is still blocked by a bunch of moderate-sized rocks.");
			}
			else if (gameVariables.mountVireMountainPathBlockage == 2)
			{
				message.push("The path is still blocked by another couple moderate-sized rocks.");
			}
			else if (gameVariables.mountVireMountainPathBlockage == 1)
			{
				message.push("The path is still blocked by another moderate-sized rock.");
			}
			
			message.push(SquirrelVillage.getExplosivesStatus(true));
			showResult(message);
		}
		else
		{
			gameVariables.mountVireMountainPathBlockage = 0;
			message.push("You set off an explosive and it destroys all of the rocks on the path.");
			message.push(SquirrelVillage.getExplosivesStatus(true));
			message.push("Will you head further up the mountain? Your herd will follow you at the end of the day.");
			showChoice(message, ["Head up the mountain", "Head Back"], [continueUpTheMountainPath, continueOnChoice], deer);
		}
	}
	
	public function moveRocksWindyPath(choice:String, deer:Deer)
	{
		var randomNums:FlxRandom = new FlxRandom();
		var gameVariables:GameVariables = GameVariables.instance;
		var message:Array<String> = new Array<String>();
		var rockMovingSkill:Int = deer.str + deer.dex*2 + deer.res + randomNums.int(0, 5);
		
		if (rockMovingSkill >= 24)
		{
			message.push(deer.getName() + " spends the day pushing rocks out of the way, managing to move a few of the large rocks.");
			gameVariables.mountVireMountainPathBlockage -= 3;
		}
		else if (rockMovingSkill >= 19)
		{
			message.push(deer.getName() + " spends the day pushing rocks out of the way, managing to move a couple of the large rocks.");
			gameVariables.mountVireMountainPathBlockage -= 2;
		}
		else if (rockMovingSkill >= 15)
		{
			message.push(deer.getName() + " spends the day pushing rocks out of the way, managing to move one of the large rocks.");
			gameVariables.mountVireMountainPathBlockage -= 1;
		}
		else
		{
			message.push(deer.getName() + " spends the day trying to push rocks out of the way, but isn't strong enough to make any real progress.");
		}
		
		if (gameVariables.mountVireMountainPathBlockage >= 5)
		{
			message.push("The path ahead remains blocked by many large rocks.");
		}
		else if (gameVariables.mountVireMountainPathBlockage >= 3)
		{
			message.push("The path ahead remains blocked by a few large rocks.");
		}
		else if (gameVariables.mountVireMountainPathBlockage == 2)
		{
			message.push("The path ahead remains blocked by a couple large rocks.");
		}
		else if (gameVariables.mountVireMountainPathBlockage == 1)
		{
			message.push("The path ahead remains blocked by a large rock.");
		}
		
		if (gameVariables.mountVireMountainPathBlockage <= 0)
		{
			gameVariables.mountVireMountainPathBlockage = 0;
			message.push("The path ahead has been successfully cleared.");
			message.push("Will you head further up the mountain? Your herd will follow you at the end of the day.");
			showChoice(message, ["Head up the mountain", "Head Back"], [continueUpTheMountainPath, continueOnChoice], deer);
		}
		else
		{
			showResult(message);
		}
	}
	
	public function theCaveEntrance(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		if (choice == "Step back")
		{
			message.push("You take a step back from the blanket squirrel.");
			message.push("A few squirrels are still wandering about.");
		}
		else if (choice == "Head back")
		{
			message.push("You head back to the entrance of the cave.");
			message.push("A few squirrels are still wandering about, and one is sitting on a blanket surrounded by trinkets.");
		}
		else
		{
			message.push("You walk into a large cavern leading into the mountain.");
			message.push("A few squirrels are wandering about the cave, one is sitting on a blanket surrounded by trinkets.");
		}
		message.push("Torches lining the walls light the way deeper into the mountain.");
		
		var exploreOptionNames:Array<String> = new Array<String>();
		var exploreOptionFunctions:Array<(String, Deer)->Void> = new Array<(String, Deer)->Void>();

		//Head deeper
		exploreOptionNames.push("Head deeper");
		exploreOptionFunctions.push(mountainTunnelFirstRoom);
		
		//Squirrel guide 
		exploreOptionNames.push("Visit the blanket squirrel");
		exploreOptionFunctions.push(blanketSquirrel);
		
		//Back
		exploreOptionNames.push("Head back");
		exploreOptionFunctions.push(continueOnChoice); 

		showChoice(message, exploreOptionNames, exploreOptionFunctions, deer);
	}
	
	public function mountainTunnelFirstRoom(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		message.push("You walk further into the cave as it twists into the mountain.");
		message.push("The tunnel leads into a small chamber, lit by a small flame.");
		message.push("In front of the flame sits a tiny stone pedestal; you feel like you should put something on it.");
		message.push("Some nearby squirrels are watching you anxiously.");
		
		var exploreOptionNames:Array<String> = new Array<String>();
		var exploreOptionFunctions:Array<(String, Deer)->Void> = new Array<(String, Deer)->Void>();
		
		//Back
		exploreOptionNames.push("Head back");
		exploreOptionFunctions.push(theCaveEntrance); 
		
		//Trinkets
		addTrinketOptions(exploreOptionNames);
		if (exploreOptionNames.length > 1)
		{
			exploreOptionFunctions.push(useTrinketFirstRoom); 
		}

		showChoice(message, exploreOptionNames, exploreOptionFunctions, deer);
	}
	
	public function useTrinketFirstRoom(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		if (choice == "Wolf")
		{
			message.push("You place the wolf totem on the pedestal. After waiting a few moments the room begins to shake.");
			message.push("The room slowly rotates, revealing a new path forward.");
			showChoice(message, ["Continue onwards"], [mountainTunnelSecondRoom], deer);
		}
		else
		{
			message.push("You place the " + choice.toLowerCase() + " on the pedestal. After waiting a few moments nothing seems to be happening.");
			message.push("The squirrels watching you disappointly usher you back out of the cave.");
			message.push("You'll have to try again some other time.");
			showResult(message);
		}
	}
	
	public function mountainTunnelSecondRoom(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		message.push("You follow the tunnel as it continues into the mountain.");
		message.push("After a while you hop over a small gap and step into another small chamber, with another pedestal in its center. A plank leans against its side.");
		message.push("Some squirrels seem to have followed you and watch intently.");
		
		var exploreOptionNames:Array<String> = new Array<String>();
		var exploreOptionFunctions:Array<(String, Deer)->Void> = new Array<(String, Deer)->Void>();
		
		//Back
		exploreOptionNames.push("Head back");
		exploreOptionFunctions.push(theCaveEntrance); 
		
		//Trinkets
		addTrinketOptions(exploreOptionNames);
		if (exploreOptionNames.length > 1)
		{
			exploreOptionFunctions.push(useTrinketSecondRoom); 
		}

		showChoice(message, exploreOptionNames, exploreOptionFunctions, deer);
	}
	
	public function useTrinketSecondRoom(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		if (choice == "String")
		{
			message.push("You place the piece of string on the pedestal. After waiting a few moments the room begins to shake.");
			message.push("The room slowly rotates, revealing a new path forward.");
			showChoice(message, ["Continue onwards"], [mountainTunnelThirdRoom], deer);
		}
		else
		{
			message.push("You place the " + choice.toLowerCase() + " on the pedestal. After waiting a few moments nothing seems to be happening.");
			message.push("The squirrels watching you disappointly usher you back trough the tunnel and out of the cave.");
			message.push("You'll have to try again some other time.");
			showResult(message);
		}
	}
	
	public function mountainTunnelThirdRoom(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		message.push("You follow the tunnel as it continues into the mountain.");
		message.push("After a while come to a dead end. When you walk up to it however the wall slides into the ground, revealing another chamber with another pedestal.");
		message.push("The squirrels following you watch excitedly.");
		
		var exploreOptionNames:Array<String> = new Array<String>();
		var exploreOptionFunctions:Array<(String, Deer)->Void> = new Array<(String, Deer)->Void>();
		
		//Back
		exploreOptionNames.push("Head back");
		exploreOptionFunctions.push(theCaveEntrance); 
		
		//Trinkets
		addTrinketOptions(exploreOptionNames);
		if (exploreOptionNames.length > 1)
		{
			exploreOptionFunctions.push(useTrinketThirdRoom); 
		}

		showChoice(message, exploreOptionNames, exploreOptionFunctions, deer);
	}
	
	public function useTrinketThirdRoom(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		if (choice == "Star")
		{
			message.push("You place the star-shaped gem on the pedestal. After waiting a few moments the room begins to shake.");
			message.push("The room slowly rotates, revealing an opening back outside.");
			showChoice(message, ["Step outside"], [mountainTunnelExit], deer);
		}
		else
		{
			message.push("You place the " + choice.toLowerCase() + " on the pedestal. After waiting a few moments nothing seems to be happening.");
			message.push("The squirrels watching you disappointly usher you back trough the tunnel and out of the cave.");
			message.push("You'll have to try again some other time.");
			showResult(message);
		}
	}
	
	public function mountainTunnelExit(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		message.push("You step outside onto the cold mountainside.");
		message.push("The tunnel seems to have led to a secret path up the mountain.");
		
		if (movingUpwards == "No")
		{
			message.push("Will you follow the path? You'll go back to lead your herd here at the end of the day.");
			showChoice(message, ["Follow the path", "Head back"], [continueUpTheSecretPath, continueOnChoice], deer);
		}
		else if (movingUpwards == "Secret")
		{
			message.push("You're already planning to follow the secret path tomorrow. Will you change your mind?");
			showChoice(message, ["Don't follow the path", "Follow the path"], [cancelTheSecretPath, continueOnChoice], deer);
		}
		else if (movingUpwards == "Yes")
		{
			message.push("You're already planning to follow the other non-secret path tomorrow. Will you change your mind?");
			showChoice(message, ["Follow this path instead", "Follow the normal path", "Don't follow any path"], [continueOnChoice, continueOnChoice, cancelTheSecretPath], deer);
		}
	}
	
	public function continueUpTheSecretPath(choice:String, deer:Deer)
	{
		movingUpwards = "Secret path";
		continueOn();
	}
	
	public function cancelTheSecretPath(choice:String, deer:Deer)
	{
		movingUpwards = "No";
		continueOn();
	}
	
	private function addTrinketOptions(optionNames:Array<String>, ?getUnownedTrinkets:Bool = false)
	{
		var statNames = ["Paperclip", "String", "Cube", "Goat", "Ball", "Squirrel", "Wolf", "Bottlecap", "Stone acorn", "Cow", "Star"];
		
		for (i in 0...statNames.length)
		{
			if (getUnownedTrinkets)
			{
				if (!GameVariables.instance.inventory.checkForItemByName(statNames[i]))
				{
					optionNames.push(statNames[i]);
				}
			}
			else
			{
				if (GameVariables.instance.inventory.checkForItemByName(statNames[i]))
				{
					optionNames.push(statNames[i]);
				}
			}
		}
	}
	
	public function blanketSquirrel(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		message.push("You walk up to the squirrel and they gesture at the trinkets surrounding them.");
		message.push("It seems like the squirrel is selling them in exchange for stone acorns.");
		message.push("Each trinket costs 1 stone acorn.");
		
		var exploreOptionNames:Array<String> = new Array<String>();
		var exploreOptionFunctions:Array<(String, Deer)->Void> = new Array<(String, Deer)->Void>();
		
		//Back
		exploreOptionNames.push("Step back");
		exploreOptionFunctions.push(theCaveEntrance); 
		
		//Trinkets
		addTrinketOptions(exploreOptionNames, true);
		exploreOptionFunctions.push(buyTrinket); 

		showChoice(message, exploreOptionNames, exploreOptionFunctions, deer);
	}
	
	public function buyTrinket(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		
		if (GameVariables.instance.mountVireStoneAcorns > 0)
		{
			if (choice == "Stone acorn")
			{
				message.push("You give the squirrel a stone acorn and they hand another one back to you.");
				message.push(getStoneAcornStatus());
			}
			else
			{
				GameVariables.instance.mountVireStoneAcorns--;
				message.push("You give the squirrel a stone acorn and they hand you the " + choice.toLowerCase() + ".");
				message.push(getStoneAcornStatus());
			}
		}
		else
		{
			message.push("You don't have any stone acorns to trade for the trinket.");
		}
		
		var exploreOptionNames:Array<String> = new Array<String>();
		var exploreOptionFunctions:Array<(String, Deer)->Void> = new Array<(String, Deer)->Void>();
		
		//Back
		exploreOptionNames.push("Step back");
		exploreOptionFunctions.push(theCaveEntrance); 
		
		//Trinkets
		addTrinketOptions(exploreOptionNames, true);
		exploreOptionFunctions.push(buyTrinket); 

		showChoice(message, exploreOptionNames, exploreOptionFunctions, deer);
	}
	
	public function smallRocks(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		message.push("Walking around the plateau you find an area with small rocks scattered around.");
		message.push("You push the rocks around for a while, building up some strength.");
		message.push("(+2 Strength for 3 days).");
		
		deer.addStatusEffect(new DeerStatusEffect("Stone Pusher", 4, 2, 0, 0, 0, 0));
		
		showResult(message);
	}
	
	public function coffeeTent(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		message.push("You walk into one of the camps larger tents and find a dozen or so squirrels sitting around a fire sipping on warm drinks.");
		message.push("A few kettles are brewing beverages on the fire; one of the squirrels motions for you to pour yourself something.");
		
		var drinkNames:Array<String> = new Array<String>();

		drinkNames.push("Acorn Brew");
		drinkNames.push("Sleepy Spruce Tea");
		drinkNames.push("Chucklebean Blend");

		showChoice(message, drinkNames, [coffeeDrinking], deer);
	}
	
	public function coffeeDrinking(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		
		if (choice == "Acorn Brew")
		{
			//+2 luck for 4 days
			message.push("You grab a kettle off the fire and pour yourself a cup of coffee.");
			message.push("The flavour tastes just like munching on acorns.");
			message.push("(+2 luck for 4 days).");
			deer.addStatusEffect(new DeerStatusEffect("Lucky as an Acorn", 4, 0, 0, 0, 0, 3));
		}
		else if (choice == "Sleepy Spruce Tea")
		{
			//+2 health while resting for 4 days
			message.push("You grab a kettle off the fire and pour yourself a cup of tea.");
			message.push("The flavour tastes just like munching on spruce needles.");
			message.push("(+2 health while resting for 4 days).");
			deer.addStatusEffect(new DeerStatusEffect("Sleepy as a Spruce Tree", 4, 0, 0, 0, 0, 0));
		}
		else if (choice == "Chucklebean Blend")
		{
			//+2 dexterity for 4 days
			message.push("You grab a kettle off the fire and pour yourself a cup of coffee.");
			message.push("The flavour tastes just like munching on beans.");
			message.push("(+2 dexterity for 4 days).");
			deer.addStatusEffect(new DeerStatusEffect("Chuckled as a Bean", 4, 0, 0, 2, 0, 0));
		}
		
		showResult(message);
	}
	
	public function mountainTrail(choice:String, deer:Deer)
	{
		var gameVariables:GameVariables = GameVariables.instance;
		var message:Array<String> = new Array<String>();
		
		if (gameVariables.mountVireMountainPathBlockage > 0)
		{
			if (gameVariables.mountVireMountainPathBlockage >= 5)
			{
				message.push("You start to trek up the mountain, but are quickly stopped by a blockage on the path.");
				message.push("The path ahead is blocked by many large rocks.");
			}
			else if (gameVariables.mountVireMountainPathBlockage >= 3)
			{
				message.push("You start to trek up the mountain, but are stopped by a blockage on the path.");
				message.push("The path ahead is blocked by a few large rocks.");
			}
			else if (gameVariables.mountVireMountainPathBlockage == 2)
			{
				message.push("You trek up the mountain for a bit, but are eventually stopped by a blockage on the path.");
				message.push("The path ahead is blocked by a couple large rocks.");
			}
			else if (gameVariables.mountVireMountainPathBlockage == 1)
			{
				message.push("You trek up the mountain for a bit, but are eventually stopped by a blockage on the path.");
				message.push("The path ahead is blocked by a large rock.");
			}
			
			if (gameVariables.mountVireExplosives > 0)
			{
				message.push(SquirrelVillage.getExplosivesStatus(false));
				showChoice(message, ["Set off an explosive", "Move some rocks", "Head back"], [setoffExplosionMoutainPath, moveRocksMountainPath, continueOnChoice], deer);
			}
			else
			{
				showChoice(message, ["Move some rocks", "Head back"], [moveRocksMountainPath, continueOnChoice], deer);
			}
		}
		else
		{
			message.push("You start to trek up the mountain a bit, running into no obstacles.");
			
			if (movingUpwards == "No")
			{
				message.push("Will you head further up the mountain? Your herd will follow you at the end of the day.");
				showChoice(message, ["Head up the mountain", "Head back"], [continueUpTheMountainPath, continueOnChoice], deer);
			}
			else
			{
				message.push("Another deer is already headed further up the path, will you call them back?");
				message.push("(This would stop the whole herd from heading up the mountain at the end of the day)");
				showChoice(message, ["Call them back", "Follow along"], [cancelMountainPathTrek, continueOnChoice], deer);
			}
		}
	}
	
	public function setoffExplosionMoutainPath(choice:String, deer:Deer)
	{
		var gameVariables:GameVariables = GameVariables.instance;
		var message:Array<String> = new Array<String>();
		gameVariables.mountVireMountainPathBlockage -= 3;
		message.push("KABLAM!");
		
		if (gameVariables.mountVireMountainPathBlockage > 0)
		{
			message.push("You set off an explosive and it destroys most of the rocks on the path.");
			
			if (gameVariables.mountVireMountainPathBlockage >= 3)
			{
				message.push("The path is still blocked by plenty of large rocks.");
			}
			else if (gameVariables.mountVireMountainPathBlockage == 2)
			{
				message.push("The path is still blocked by another couple large rocks.");
			}
			else if (gameVariables.mountVireMountainPathBlockage == 1)
			{
				message.push("The path is still blocked by another large rock.");
			}
			
			message.push(SquirrelVillage.getExplosivesStatus(true));
			showResult(message);
		}
		else
		{
			gameVariables.mountVireMountainPathBlockage = 0;
			message.push("You set off an explosive and it destroys all of the rocks on the path.");
			message.push(SquirrelVillage.getExplosivesStatus(true));
			message.push("Will you head further up the mountain? Your herd will follow you at the end of the day.");
			showChoice(message, ["Head up the mountain", "Head Back"], [continueUpTheMountainPath, continueOnChoice], deer);
		}
	}
	
	public function moveRocksMountainPath(choice:String, deer:Deer)
	{
		var randomNums:FlxRandom = new FlxRandom();
		var gameVariables:GameVariables = GameVariables.instance;
		var message:Array<String> = new Array<String>();
		var rockMovingSkill:Int = deer.str*2 + deer.res + randomNums.int(0, 5);
		
		if (rockMovingSkill >= 19)
		{
			message.push(deer.getName() + " spends the day pushing rocks out of the way, managing to move a few of the large rocks.");
			gameVariables.mountVireMountainPathBlockage -= 3;
		}
		else if (rockMovingSkill >= 14)
		{
			message.push(deer.getName() + " spends the day pushing rocks out of the way, managing to move a couple of the large rocks.");
			gameVariables.mountVireMountainPathBlockage -= 2;
		}
		else if (rockMovingSkill >= 10)
		{
			message.push(deer.getName() + " spends the day pushing rocks out of the way, managing to move one of the large rocks.");
			gameVariables.mountVireMountainPathBlockage -= 1;
		}
		else
		{
			message.push(deer.getName() + " spends the day trying to push rocks out of the way, but isn't strong enough to make any real progress.");
		}
		
		if (gameVariables.mountVireMountainPathBlockage >= 5)
		{
			message.push("The path ahead remains blocked by many large rocks.");
		}
		else if (gameVariables.mountVireMountainPathBlockage >= 3)
		{
			message.push("The path ahead remains blocked by a few large rocks.");
		}
		else if (gameVariables.mountVireMountainPathBlockage == 2)
		{
			message.push("The path ahead remains blocked by a couple large rocks.");
		}
		else if (gameVariables.mountVireMountainPathBlockage == 1)
		{
			message.push("The path ahead remains blocked by a large rock.");
		}
		
		if (gameVariables.mountVireMountainPathBlockage <= 0)
		{
			gameVariables.mountVireMountainPathBlockage = 0;
			message.push("The path ahead has been successfully cleared.");
			message.push("Will you head further up the mountain? Your herd will follow you at the end of the day.");
			showChoice(message, ["Head up the mountain", "Head Back"], [continueUpTheMountainPath, continueOnChoice], deer);
		}
		else
		{
			showResult(message);
		}
	}
	
	public function continueUpTheMountainPath(choice:String, deer:Deer)
	{
		movingUpwards = "Yes";
		continueOn();
	}
	
	public function cancelMountainPathTrek(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		
		movingUpwards = "No";
		
		message.push("You call the deer further up the mountain back and you head to camp together.");		
		showResult(message);
	}
	
	override public function forage(deer:Deer) {
		var randomNums:FlxRandom = new FlxRandom();
		var message:Array<String> = new Array<String>();
		
		if (GameVariables.instance.mountVireLocation == "Base camp")
		{
			var forageResult = (deer.int * 2) + (deer.lck) + randomNums.int(0, 10);

			if (forageResult <= 9)
			{
				//Found nothing
				message.push("You are unable to find any food today.");
			}
			else if (forageResult <= 14)
			{
				GameVariables.instance.modifyFood(1);
				message.push("You find a small patch of herbs growing on the mountainside (+1 food).");
			}
			else if (forageResult <= 19)
			{
				GameVariables.instance.modifyFood(2);
				message.push("You find a blueberry bush just off a mountain trail (+2 food).");
			}
			else if (forageResult <= 23)
			{
				GameVariables.instance.modifyFood(3);
				message.push("You find a small crabapples tree just off a mountain trail (+3 food).");
			}
			else
			{
				GameVariables.instance.modifyFood(4);
				message.push("You find a tree filled with chestnuts in a small mountain grove (+4 food).");
			}
		}
		
		showResult(message);
	}
	
	override public function defend(deer:Array<Deer>)
	{
		var randomNums:FlxRandom = new FlxRandom();
		var message:Array<String> = new Array<String>();
		if (GameVariables.instance.mountVireLocation == "Base camp")
		{
			if (deer.length > 0)
			{
				showResult(["It seems there's nothing that will attack your den on this part of the mountain."]);
			}
			else
			{
				setOut();
			}
		}
		else if (GameVariables.instance.mountVireLocation == "Bird land")
		{
			message.push("Night draws and the birds start to flock over your food supplies.");
			var birdAttackReduction:Int = 0;
			
			for (i in 0...deer.length)
			{
				var birdDefendingSkill:Int = deer[i].dex * 2 + deer[i].lck + randomNums.int(0, 5);
				var currentDeer:Deer = deer[i];
				
				if (birdDefendingSkill >= 19)
				{
					message.push(currentDeer.getName() + " swats at the birds as they dive at the food, bopping every one of them.");
					birdAttackReduction += 5;
				}
				else if (birdDefendingSkill >= 17)
				{
					message.push(currentDeer.getName() + " swats at the birds as they dive at the food, bopping almost all of them.");
					birdAttackReduction += 4;
				}
				else if (birdDefendingSkill >= 15)
				{
					message.push(currentDeer.getName() + " jumps up at the birds as they dive at the food, scaring off a bunch of them.");
					birdAttackReduction += 3;
				}
				else if (birdDefendingSkill >= 13)
				{
					message.push(currentDeer.getName() + " jumps up at the birds as they dive at the food, scaring off some of them.");
					birdAttackReduction += 2;
				}
				else if (birdDefendingSkill >= 10)
				{
					message.push(currentDeer.getName() + " can't keep up with the birds and barely manages to prevent them from stealing food.");
					birdAttackReduction += 1;
				}
				else
				{
					message.push(currentDeer.getName() + " can't keep up with the birds and isn't any use of all in defending the food pile.");
				}
			}
			
			if (birdAttackReduction >= 5)
			{
				message.push("The defending deer successfully scared off all of the birds.");
			}
			else if (birdAttackReduction >= 4)
			{
				message.push("The defending deer warded off most of the birds, but still lost some scraps.");
				message.push("(-1 food)");
				GameVariables.instance.modifyFood(-1);
			}
			else if (birdAttackReduction >= 2)
			{
				message.push("The defending deer only managed to ward off some of the birds.");
				message.push("(-2 food)");
				GameVariables.instance.modifyFood(-2);
			}
			else if (birdAttackReduction >= 1)
			{
				message.push("The defending deer barely managed to ward off any of the birds.");
				message.push("(-3 food)");
				GameVariables.instance.modifyFood(-3);
			}
			else
			{
				if (deer.length == 0)
				{
					message.push("With no one defending the food stores the birds take as much as they want.");
					message.push("(-4 food)");
				}
				else
				{
					message.push("Your defenders' defense was completely ineffective, and the birds take as much food as they want.");
					message.push("(-4 food)");
				}
				GameVariables.instance.modifyFood(-4);
			}
			showResult(message);
		}
		else
		{
			if (deer.length > 0)
			{
				showResult(["It seems there's nothing that will attack your den on this part of the mountain."]);
			}
			else
			{
				setOut();
			}
		}
	}
	
	override public function hunt(deer:Array<Deer>) {
		var randomNums:FlxRandom = new FlxRandom();
		var message:Array<String> = new Array<String>();
		
		if (GameVariables.instance.mountVireLocation == "Base camp")
		{
			if (deer.length > 0)
			{
				showResult(["It seems there's nothing to hunt on this area of the mountain."]);
			}
			else
			{
				setOut();
			}
		}
		else if (GameVariables.instance.mountVireLocation == "Goat plateau")
		{
			if (deer.length > 0)
			{
				message.push("Your hunting pack comes across a single mountain goat, bleating at you from the top of a small cliff.");
				randomNums.shuffle(deer);
				
				var rewardValue:Int = 0;
				
				for (i in 0...deer.length)
				{
					var currentDeer:Deer = deer[i];
					var climbingSkill:Int = currentDeer.dex * 2 + currentDeer.lck + randomNums.int(0, 4);
					
					if (climbingSkill >= 12)
					{
						message.push(currentDeer.getName() + " manages to scramble up the cliffside.");
						
						var smackingSkill:Int = currentDeer.str * 2 + randomNums.int(0, 4);
						
						if (smackingSkill >= 16)
						{
							message.push(currentDeer.getName() + " bashes into the goat's horns, sending them stumbling backwards.");
							rewardValue += 5;
						}
						else if (smackingSkill >= 14)
						{
							message.push(currentDeer.getName() + " bashes into the goat's horns, making them take a few steps back.");
							rewardValue += 4;
						} 
						else if (smackingSkill >= 12)
						{
							message.push(currentDeer.getName() + " bashes into the goat's horns, making them take a step back.");
							rewardValue += 3;
						} 
						else
						{
							message.push(currentDeer.getName() + " tries to bash into the goat's horns, but moreso just head-taps them.");
							rewardValue += 1;
						} 
					}
					else
					{
						message.push(currentDeer.getName() + " fails to climb the cliffside and stumbles back down.");
					}
				}
				
				if (rewardValue > 0)
				{
					message.push("The goat seems to have enjoyed playing around with you.");
					if (rewardValue == 1)
					{
						message.push("The goat quickly hops off, then comes back with a stone acorn in its mouth to offer to you as a gift.");
					}
					else
					{
						message.push("The goat quickly hops off, then comes back with a mouthful of " + rewardValue + " stone acorns to offer as a gift.");
					}
					
					GameVariables.instance.mountVireStoneAcorns += rewardValue;
					message.push(SquirrelVillage.getAcornStatus());
				}
				else
				{
					message.push("Your pack lies down at the bottom of the cliffside, unable to make it up to the goat.");
				}
				
				showResult(message);
			}
			else
			{
				setOut();
			}
		}
		else
		{
			if (deer.length > 0)
			{
				showResult(["It seems there's nothing to hunt on this area of the mountain."]);
			}
			else
			{
				setOut();
			}
		}
	}
	
	static public function getStoneAcornStatus(?addNow:Bool = true):String
	{
		var result:String;
		
		if (addNow)
		{
			result = "(You now have " + GameVariables.instance.mountVireStoneAcorns;
		}
		else
		{
			result = "(You have " + GameVariables.instance.mountVireStoneAcorns;
		}
		
		if (GameVariables.instance.mountVireStoneAcorns == 1)
		{
			result += " stone acorn.)";
		}
		else
		{
			result += " stone acorns.)";
		}
		
		return result;
	}
}