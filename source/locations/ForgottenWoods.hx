package locations;

import flixel.math.FlxRandom;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import statuses.DeerStatusEffect;

class ForgottenWoods extends Location
{
	public static var instance(default, null):ForgottenWoods = new ForgottenWoods();

	public var foundDeer:Deer;
	public var deerInCave:Array<Deer>;

	public var mazePosition:Int;

	public function new()
	{
		super();
		
		name = "Unfamiliar Forest";
		backgroundImageFile = "assets/images/LocationImages/ForgottenWoods.png";
		backgroundImageFileNoFrame = "assets/images/LocationImages/ForgottenWoodsNoFrame.png";
		backgroundImageFileMiniFramed = "assets/images/LocationImages/ForgottenWoodsEmptyDeerTile.png";
	}

	override public function setOut()
	{
		super.setOut();
	}

	override public function startDay()
	{
		deerInCave = new Array<Deer>();
		super.startDay();
	}

	override public function endDay()
	{
		deerInCave = null;
		super.endDay();
	}

	override public function defend(deer:Array<Deer>)
	{
		var randomNums:FlxRandom = new FlxRandom();
		randomNums.shuffle(deer);

		var thisDefenseNums = randomNums.int(1, 100);
		if (thisDefenseNums >= 70)
		{
			//rabbit attakk
			var resultMessage:String = "A few wandering rabbits find your den";
			if (deer.length == 0)
			{
				if (GameVariables.instance.currentFood > 5)
				{
					resultMessage += " and crunch away some of your food (-2 food).";
					GameVariables.instance.modifyFood(-2);
				}
				else if (GameVariables.instance.currentFood > 0)
				{
					resultMessage += " and crunch away some of your food (-1 food).";
					GameVariables.instance.modifyFood(-1);
				}
				else
				{
					resultMessage += ", but after finding no food to munch on they quickly wander off.";
				}
			}
			else
			{
				resultMessage += ", but your defending deer are able to scare them off.";
			}
			showResult([resultMessage]);
		}
		else
		{
			setOut();
		}

		//Defending mother gets big air bonus
	}

	override public function forage(deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		
		var randomNums:FlxRandom = new FlxRandom();
		var forageResult = (deer.int * 2) + (deer.lck) + randomNums.int(0, 10);

		if (forageResult <= 6)
		{
			//Found nothing
		}
		else if (forageResult <= 9)
		{
			GameVariables.instance.modifyFood(1);
			message.push("You find some nuts on the forest floor (+1 food).");
		}
		else if (forageResult <= 11)
		{
			GameVariables.instance.modifyFood(2);
			message.push("You find a bush with some blackberries on it (+2 food).");
		}
		else if (forageResult <= 18)
		{
			GameVariables.instance.modifyFood(3);
			message.push("You find a tree filled with small crabapples (+3 food).");
		}
		else
		{
			GameVariables.instance.modifyFood(4);
			message.push("You find a tree filled with full juicy apples (+4 food).");
		}

		
		var challengeEvent = randomNums.int(0, 6);
		//Risky apple
		if(challengeEvent == 0){
			message.push("You see a particularily juicy apple hanging off a small precipice.");
			showChoice(message, ["Jump for it", "Continue on"], [riskyApple, continueOnChoice], deer);
		}
		//Perseverance apple
		else if(challengeEvent == 1){
			message.push("You see a tree filled with apples ahead, but an especially dense and prickly thicket lies before you.");
			showChoice(message, ["Trudge through it", "Turn back"], [perseveranceApple, continueOnChoice], deer);
		}
		else{
			if(message.length == 0){
				message.push("You are unable to find any food today.");
			}
			showResult(message);
		}
	}

	override public function hunt(deer:Array<Deer>)
	{
		var randomNums:FlxRandom = new FlxRandom();
		randomNums.shuffle(deer);

		var thisExplorationNum = randomNums.int(0, 0);

		//Rabbit
		if (thisExplorationNum == 0)
		{
			var result:String = "Your hunting pack finds a small rabbit.\n";
			var initialCatch:Bool = false;
			for (i in 0...deer.length)
			{
				//Successful catch
				if (randomNums.int(0, 8) + (deer[i].dex*2) + (deer[i].lck - 2) >= 14)
				{
					initialCatch = true;
					result += deer[i].name + " runs the rabbit down and trips it up. ";
					break;
				}
			}

			if (initialCatch)
			{
				var damageDealth:Int = 0;
				for (i in 0...deer.length)
				{
					//Successful hit
					if (randomNums.int(0, 8) + (deer[i].dex*2) + (deer[i].lck - 2) >= 8)
					{
						var hitStrength:Int = randomNums.int(0, 8) + (deer[i].str * 2) + (deer[i].lck - 1);

						if (hitStrength >= 15)
						{
							result += deer[i].name + " lands a critical blow on the rabbit. ";
							damageDealth += 2;
						}
						else if (hitStrength >= 10)
						{
							result += deer[i].name + " deals a solid blow to the rabbit. ";
							damageDealth += 1;
						}
						else
						{
							result += deer[i].name + " lands an ineffective attack on the rabbit. ";
						}
					}
					else
					{
						result += deer[i].name + " fails to land their attack. ";
					}

					if (damageDealth >= 2)
					{
						GameVariables.instance.modifyFood(3);
						GameVariables.instance.addUnfamiliarWoodsRabbitFur();
						result += "The rabbit lies defeated. You bring it to the den to use as food and bedding (+3 food).";
						break;
					}
				}

				if (damageDealth == 1)
				{
					result += "The rabbit bounds off with a few new scratches.";
				}
				else
				{
					result += "The rabbit bounds off unharmed.";
				}
			}
			else
			{
				result += "No one is able to keep up to the rabbit and it bounds off.";
			}

			showResult([result]);
		}
		//Wolf
		else if (thisExplorationNum == 1)
		{
		}
	}

	override public function explore(deer:Deer)
	{
		continueCount = 0;

		var exploreOptionNames:Array<String> = new Array<String>();
		var exploreOptionFunctions:Array<(String, Deer)->Void> = new Array<(String, Deer)->Void>();

		if (GameVariables.instance.unfamiliarWoodsCaveFound)
		{
			exploreOptionNames.push("The Cave");
			exploreOptionFunctions.push(cave);
		}

		if (GameVariables.instance.unfamiliarWoodsDeepWoodsFound)
		{
			exploreOptionNames.push("The Deep Woods");
			exploreOptionFunctions.push(deepWoods);
		}
		
		if (GameVariables.instance.unfamiliarWoodsIntellectSpringFound)
		{
			exploreOptionNames.push("The Spring");
			exploreOptionFunctions.push(intellectSpring);
		}
		
		if (GameVariables.instance.unfamiliarWoodsInspiringViewFound)
		{
			exploreOptionNames.push("The Hill");
			exploreOptionFunctions.push(inspiringView);
		}
		
		if (GameVariables.instance.unfamiliarWoodsSquirrelsOfGoodFortuneFound)
		{
			exploreOptionNames.push("The Squirrels");
			exploreOptionFunctions.push(squirrelVisiting);
		}

		exploreOptionNames.push("Wander Elsewhere");
		exploreOptionFunctions.push(wander);

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

		if (!GameVariables.instance.unfamiliarWoodsCaveFound)
		{
			possibilities.push("The Cave");
		}
		if (!GameVariables.instance.unfamiliarWoodsDeepWoodsFound)
		{
			possibilities.push("The Deep Woods");
		}
		if (!GameVariables.instance.unfamiliarWoodsIntellectSpringFound)
		{
			possibilities.push("The Spring");
		}
		if (!GameVariables.instance.unfamiliarWoodsInspiringViewFound)
		{
			possibilities.push("The Hill");
		}
		if (!GameVariables.instance.unfamiliarWoodsSquirrelsOfGoodFortuneFound)
		{
			possibilities.push("The Squirrels");
		}
		possibilities.push("Deer Friend");

		var resultingEvent:String = possibilities[randomNums.int(0, possibilities.length - 1)];
		if (resultingEvent == "The Cave")
		{
			cave("Cave enter", deer);
		}
		else if (resultingEvent == "The Deep Woods")
		{
			deepWoods("Deep woods entrance", deer);
		}
		else if (resultingEvent == "The Spring")
		{
			intellectSpring("spring", deer);
		}
		else if (resultingEvent == "The Hill")
		{
			inspiringView("hill", deer);
		}
		else if (resultingEvent == "The Squirrels")
		{
			squirrelVisiting("squrrels", deer);
		}
		else if (resultingEvent == "Deer Friend")
		{
			findDeer("Find deer", deer);
		}
	}
	
	public function intellectSpring(choice:String, deer:Deer){
		GameVariables.instance.unfamiliarWoodsIntellectSpringFound = true;
		
		var message:Array<String> = new Array<String>();
		message.push("Walking through the woods, you come a small pond.");
		message.push("The pond seems to be fed by a natural spring flowing from some rocks nearby.");
		message.push("You sit by the spring for a while, and feel a sense of calm flow over you.");
		message.push("(+1 Intellect for 2 days).");
		
		deer.addStatusEffect(new DeerStatusEffect("Calmed", 3, 0, 0, 0, 1, 0));
		
		showResult(message);
	}
	
	public function inspiringView(choice:String, deer:Deer){
		GameVariables.instance.unfamiliarWoodsInspiringViewFound = true;
		
		var message:Array<String> = new Array<String>();
		message.push("Walking through the woods, you come upon a dirt trail heading up a large hill. You decide you have to climb it.");
		message.push("The trail is longer than you expected, with many sections overgrown.");
		message.push("Still, you push on and reach the top.");
		message.push("You sit on the top of the hill admiring the view of the forest, happy that your efforts have paid off.");
		message.push("(+1 Resilience for 2 days).");
		
		deer.addStatusEffect(new DeerStatusEffect("Inspired", 3, 0, 1, 0, 0, 0));
		
		showResult(message);
	}
	
	public function squirrelVisiting(choice:String, deer:Deer){
		GameVariables.instance.unfamiliarWoodsSquirrelsOfGoodFortuneFound = true;
		
		var message:Array<String> = new Array<String>();
		message.push("Walking through the woods, you start to get the sense that something is watching you.");
		message.push("Looking up you see that many things are watching you.");
		message.push("A pack of squirrels sit in the trees above you, staring intently.");
		
		showChoice(message, ["Offer some food (1)", "Continue On"], [feedingTheSquirrels, squirrelDenial], deer);
	}
	
	public function feedingTheSquirrels(choice:String, deer:Deer){
		var message:Array<String> = new Array<String>();
		
		if(GameVariables.instance.currentFood >= 1){
			GameVariables.instance.modifyFood(-1);
			message.push("You place some of the food you brought for the day on the ground in front of you.");
			message.push("A few squirrels run down the tree to collect the food.");
			message.push("They look up at you and chitter happily before scampering back up the tree to divide your gift.");
			message.push("(+2 Luck for 2 days).");
			
			deer.addStatusEffect(new DeerStatusEffect("Luck of the Squirrels", 3, 0, 0, 0, 0, 2));
		}
		else
		{
			message.push("You move to give the squirrels some of your food, but realize that you don't have any.");
			message.push("You keep walking.");
		}
		
		showResult(message);
	}
	
	public function squirrelDenial(choice:String, deer:Deer){
		var message:Array<String> = new Array<String>();
		message.push("You ignore the squirrels and keep walking.");
		
		deer.addStatusEffect(new DeerStatusEffect("Fury of the Squirrels", 3, 0, 0, 0, 0, -1));
		
		showResult(message);
	}

	public function deepWoods(choice:String, deer:Deer)
	{
		var gameVariables:GameVariables = GameVariables.instance;
		gameVariables.unfamiliarWoodsDeepWoodsFound = true;
		var message:Array<String> = new Array<String>();

		mazePosition = 0;

		if (choice == "Deep woods entrance" || choice == "The Deep Woods")
		{
			message.push("As you walk the woods grow darker around you. You soon come to a dense thicket.");
			if (gameVariables.unfamiliarWoodsDeepWoodsThicketCleared)
			{
				message.push("You can see a clear path has been made through the thicket");
				showChoice(message, ["Follow clear path", "Head back"], [deepWoods, deepWoods], deer);
			}
			else if (gameVariables.unfamiliarWoodsDeepWoodsThicketNavigated)
			{
				message.push("You can see someone has marked areas where the thicket is traversable.");
				showChoice(message, ["Follow markings", "Head back"], [deepWoods, deepWoods], deer);
			}
			else
			{
				showChoice(message, ["Push through the thicket", "Navigate past the thicket", "Head back"], [deepWoods, deepWoods, deepWoods], deer);
			}
		}
		else if (choice == "Push through the thicket")
		{
			if (deer.str >= 5 || deer.res >= 5)
			{
				deepWoodsMaze(choice, deer);
			}
			else
			{
				message.push("The branches of the thicket are too thick for you to push through, and you give up after getting a few cuts.");
				message.push("You stand in front of the dense thicket.");
				showChoice(message, ["Push through the thicket", "Navigate past the thicket", "Head back"], [deepWoods, deepWoods, deepWoods], deer);
				deer.takeDamage(1);
			}
		}
		else if (choice == "Navigate past the thicket")
		{
			if (deer.int >= 5 || deer.lck >= 5)
			{
				deepWoodsMaze(choice, deer);
			}
			else
			{
				message.push("Wandering around the outside of the thicket, you are unable to find an easier path.");
				message.push("You stand in front of the dense thicket.");
				showChoice(message, ["Push through the thicket", "Navigate past the thicket", "Head back"], [deepWoods, deepWoods, deepWoods], deer);
			}
		}
		else if (choice == "Follow clear path" || choice == "Follow markings")
		{
			deepWoodsMaze(choice, deer);
		}
		else if (choice == "Head back"){
			continueOn();
		}
	}

	public function deepWoodsMaze(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		if (mazePosition == 0)
		{
			if (choice == "Push through the thicket")
			{
				if (deer.str >= 5)
				{
					message.push("The branches of the thicket easily give away as you push through them.");
				}
				else if (deer.res >= 5)
				{
					message.push("The branches of the thicket don't give way easily, but you persevere and push through.");
				}
				message.push("Other deer should be able to follow your cleared path.");
				GameVariables.instance.unfamiliarWoodsDeepWoodsThicketCleared = true;
			}
			else if (choice == "Navigate past the thicket")
			{
				if (deer.int >= 5)
				{
					message.push("Navigating around the outside of the thicket, you manage to find a less dense path through it.");
				}
				else if (deer.lck >= 5)
				{
					message.push("Wandering around the outside of the thicket, you stumble upon a less dense path through it.");
				}
				message.push("You mark the path you followed, for any future deer that pass through.");
				GameVariables.instance.unfamiliarWoodsDeepWoodsThicketNavigated = true;
			}
			else if (choice == "Follow clear path")
			{
				message.push("You follow the cleared path through the thicket.");
			}
			else if (choice == "Follow markings")
			{
				message.push("You follow the marked path through the thicket.");
			}

			message.push("You stand in a small clearing, three paths lead into a darker section of the woods.");
			showChoice(message, ["Follow left path", "Move forward", "Follow right path", "Head home"], [deepWoodsMaze, deepWoodsMaze, deepWoodsMaze, continueOnChoice], deer);
			mazePosition = 1;
		}
		else if (mazePosition == 1)
		{
			if (choice == "Follow left path")
			{
				message.push("You follow the path to your left.");
				message.push("The path continues on further, curving through the trees.");
				showChoice(message, ["Follow the path further", "Head back"], [deepWoodsMaze, deepWoodsMaze], deer);
				mazePosition = 2;
			}
			else if (choice == "Move forward")
			{
				message.push("You follow the path straight ahead.");
				message.push("The path continues on further, going up a small hill.");
				showChoice(message, ["Follow the path further", "Head back"], [deepWoodsMaze, deepWoodsMaze], deer);
				mazePosition = 5;
			}
			else if (choice == "Follow right path")
			{
				message.push("You follow the path to your right.");
				message.push("The path continues on further, deep into the woods.");
				message.push("The path looks especially treacherous; the woods overtaking it are old, dense, and threateningly thistled.");
				showChoice(message, ["Follow the path further", "Head back"], [deepWoodsMaze, deepWoodsMaze], deer);
				mazePosition = 8;
			}
		}
		else if (mazePosition == 2)
		{
			if (choice == "Head back")
			{
				mazePosition = 1;
				message.push("You follow the path back to the clearing.");
				message.push("Three paths lead into a darker section of the woods.");
				showChoice(message, ["Follow left path", "Move forward", "Follow right path", "Head home"], [deepWoodsMaze, deepWoodsMaze, deepWoodsMaze, continueOnChoice], deer);
			}
			else if (choice == "Follow the path further")
			{
				if (deer.int >= 4)
				{
					mazePosition = 3;
					message.push("You follow the path as it winds between the trees.");
					message.push("You get disorientated a bit, but you still manage to progress deeper into the woods.");
					message.push("The path ahead of you leads through some particularly thorny brush.");
					message.push("You see another path over to your right you could cut through to.");
					showChoice(message, ["Move forward", "Head to the other path", "Head back"], [deepWoodsMaze, deepWoodsMaze, deepWoodsMaze], deer);
				}
				else
				{
					message.push("You follow the path as it winds between the trees.");
					message.push("As the path winds more and more, you begin to get disorientated.");
					message.push("You stand in front of a path that continues deeper into the woods, curving through the trees.");
					showChoice(message, ["Follow the path further", "Head back"], [deepWoodsMaze, deepWoodsMaze], deer);
					mazePosition = 2;
				}
			}
		}
		else if (mazePosition == 3)
		{
			if(choice == "Head back"){
				message.push("You walk back towards the den for a bit.");
				message.push("You stand in front of a path that continues deeper into the woods, curving through the trees.");
				showChoice(message, ["Follow the path further", "Head back"], [deepWoodsMaze, deepWoodsMaze], deer);
				mazePosition = 2;
			}
			else if (choice == "Head to the other path")
			{
				//middle 1 deep
				mazePosition = 6;
				message.push("You push through a low brush and reach the other path.");
				message.push("You stand in front of a path that leads through some dense bushes.");
				message.push("You see another path over to your left you could cut through to.");
				showChoice(message, ["Move forward", "Head to the other path", "Head back"], [deepWoodsMaze, deepWoodsMaze, deepWoodsMaze], deer);
			}
			else if (choice == "Move forward")
			{
				if (deer.res >= 3)
				{
					message.push("You follow the path through the thorns.");
					if (deer.res == 3)
					{
						message.push("The thorns cut deep, but you're able to push through the pain.");
						deer.takeDamage(1);
					}
					else
					{
						message.push("The thorns barely bother you, and you're able to easily push forward.");
					}
					mazePosition = 4;
					message.push("The path ahead of you leads to a sharp incline before continuing on.");
					showChoice(message, ["Climb up", "Head back"], [deepWoodsMaze, deepWoodsMaze], deer);
				}
				else
				{
					message.push("You follow the path through the thorns.");
					message.push("The thorns cut deep, and you are soon forced to turn back.");
					message.push("You stand in front of a path that continues through a patch of thorned branches.");
					message.push("You see another path over to your right you could cut through to.");
					deer.takeDamage(2);
					showChoice(message, ["Move forward", "Head to the other path", "Head back"], [deepWoodsMaze, deepWoodsMaze, deepWoodsMaze], deer);
					mazePosition = 3;
				}
			}
		}
		else if (mazePosition == 4)
		{
			if (choice == "Head back")
			{
				message.push("You push back through the thorns, which seem to hurt much less going this direction.");
				message.push("You stand in front of a path that continues through a patch of thorned branches.");
				message.push("You see another path over to your right you could cut through to.");
				showChoice(message, ["Move forward", "Head to the other path", "Head back"], [deepWoodsMaze, deepWoodsMaze, deepWoodsMaze], deer);
				mazePosition = 3;
			}
			else if (choice == "Climb up")
			{
				if (deer.str >= 4)
				{
					message.push("You pull yourself up the steep slope and continue on.");
					message.push("As you move forward the woods grow even darker around you, soon no light at all reaches the forest ground.");
					message.push("A flickering light shines in the distance.");
					showChoice(message, ["Walk forward"], [enterTheDarkenedWoods], deer);
				}
				else
				{
					message.push("You try to pull yourself up the steep slope, but you just don't have the strength.");
					message.push("The path ahead of you leads to a sharp incline before continuing on.");
					showChoice(message, ["Climb up", "Head back"], [deepWoodsMaze, deepWoodsMaze, deepWoodsMaze], deer);
					mazePosition = 4;
				}
			}
		}
		else if (mazePosition == 5)
		{
			if (choice == "Head back")
			{
				mazePosition = 1;
				message.push("You follow the path back to the clearing.");
				message.push("Three paths lead into a darker section of the woods.");
				showChoice(message, ["Follow left path", "Move forward", "Follow right path", "Head home"], [deepWoodsMaze, deepWoodsMaze, deepWoodsMaze, continueOnChoice], deer);
			}
			else if (choice == "Follow the path further")
			{
				if (deer.dex >= 4)
				{
					mazePosition = 6;
					message.push("You follow the path up the small hill.");
					message.push("The path grows softer as you walk, crumbling away where you step.");
					message.push("With some quick footwork you make it to the top safely.");
					message.push("The path ahead of you leads through a patch of dense bushes.");
					message.push("You see another path over to your left you could cut through to.");
					showChoice(message, ["Move forward", "Head to the other path", "Head back"], [deepWoodsMaze, deepWoodsMaze, deepWoodsMaze], deer);
				}
				else
				{
					message.push("You follow the path up the small hill.");
					message.push("The path grows softer as you walk, crumbling away where you step.");
					message.push("You trip over yourself and fall back down to the foot of the hill.");
					message.push("You stand in front of a path that continues deeper into the woods, going up a small hill.");
					showChoice(message, ["Follow the path further", "Head back"], [deepWoodsMaze, deepWoodsMaze], deer);
					mazePosition = 5;
				}
			}
		}
		else if (mazePosition == 6)
		{
			if (choice == "Head back")
			{
				message.push("You carefully walk down a small hill, following the path back towards the den.");
				message.push("You stand in front of a path that continues deeper into the woods, going up a small hill.");
				showChoice(message, ["Follow the path further", "Head back"], [deepWoodsMaze, deepWoodsMaze], deer);
				mazePosition = 5;
			}
			else if (choice == "Head to the other path")
			{
				//left 1 deep
				message.push("You push through a low brush and reach the other path.");
				message.push("You stand in front of a path that continues through a patch of thorned branches.");
				message.push("You see another path over to your right you could cut through to.");
				showChoice(message, ["Move forward", "Head to the other path", "Head back"], [deepWoodsMaze, deepWoodsMaze, deepWoodsMaze], deer);
				mazePosition = 3;
			}
			else if (choice == "Move forward")
			{
				if (deer.str >= 3)
				{
					mazePosition = 7;
					message.push("You follow the path through the dense bushes.");
					message.push("It takes some work, but you manage to push your way through.");
					message.push("The path ahead of you leads deeper into the woods, growing darker and darker.");
					showChoice(message, ["Walk forward", "Head back"], [deepWoodsMaze, deepWoodsMaze], deer);
				}
				else
				{
					mazePosition = 6;
					message.push("You follow the path through the dense bushes.");
					message.push("Pushing forward as hard as you can, you are unable to make any real progress and turn back.");
					message.push("You stand in front of a path that leads through some dense bushes.");
					message.push("You see another path over to your left you could cut through to.");
					showChoice(message, ["Move forward", "Head to the other path", "Head back"], [deepWoodsMaze, deepWoodsMaze, deepWoodsMaze], deer);
				}
			}
		}
		else if (mazePosition == 7)
		{
			if (choice == "Head back")
			{
				mazePosition = 6;
				message.push("You head towards the den, pushing through some dense bushes. They bend away easily in this direction.");
				message.push("You stand in front of a path that leads through some dense bushes.");
				message.push("You see another path over to your left you could cut through to.");
				showChoice(message, ["Move forward", "Head to the other path", "Head back"], [deepWoodsMaze, deepWoodsMaze, deepWoodsMaze], deer);
			}
			else if (choice == "Move forward")
			{
				if (deer.lck >= 3)
				{
					message.push("As you follow the path you soon end up walking through pitch darkness.");
					message.push("Somehow you manage to keep walking unimpeded. After short while you stop and peer further ahead.");
					message.push("A flickering light shines in the distance.");
					showChoice(message, ["Walk forward"], [enterTheDarkenedWoods], deer);
				}
				else
				{
					mazePosition = 7;
					message.push("As you follow the path you soon end up walking through pitch darkness.");
					message.push("After bumping into trees and tripping over roots, you end up turned around and back where you started.");
					message.push("The path ahead of you leads deeper into the woods, growing darker and darker.");
					showChoice(message, ["Walk forward", "Head back"], [deepWoodsMaze, deepWoodsMaze], deer);
				}
			}
		}
		else if (mazePosition == 8)
		{
			if (choice == "Head back")
			{
				//Initial 3 path choice
				mazePosition = 1;
				message.push("You follow the path back to the clearing.");
				message.push("Three paths lead into a darker section of the woods.");
				showChoice(message, ["Follow left path", "Move forward", "Follow right path", "Head home"], [deepWoodsMaze, deepWoodsMaze, deepWoodsMaze, continueOnChoice], deer);
			}
			else if (choice == "Follow the path further")
			{
				if (deer.res >= 6)
				{
					message.push("As you walk you often trip on the uneven terrain, and cut yourself on the thorns surrounding you.");
					message.push("Still, you manage to push forward.");
					message.push("Hours pass and the woods around you grow darker and darker.");
					message.push("Soon no light at all reaches the forest floor.");
					message.push("A flickering light shines in the distance.");
					showChoice(message, ["Walk forward"], [enterTheDarkenedWoods], deer);
				}
				else
				{
					if(deer.res >= 5){
						message.push("As you walk you often trip on the uneven terrain, and cut yourself on the thorns surrounding you.");
						message.push("You make it fairly far, but eventually exhaustion starts to set in and you have to turn back.");
					}else if(deer.res >= 4){
						message.push("As you walk you often trip on the uneven terrain, and cut yourself on the thorns surrounding you.");
						message.push("You're able to continue for a bit, but eventually exhaustion starts to set in and you have to turn back.");
					}else{
						message.push("After a short ways you trip and land in a patch of thorns.");
						message.push("With some effort you stand up, but your determination to push forward is all but gone.");
						message.push("You turn around and head back.");
					}
					mazePosition = 8;
					message.push("You stand in front of a path travelling deep into the woods.");
					message.push("The path looks especially treacherous; the woods overtaking it are old, dense, and threateningly thistled.");
					showChoice(message, ["Follow the path further", "Head back"], [deepWoodsMaze, deepWoodsMaze], deer);
				}
			}
		}
	}

	public function enterTheDarkenedWoods(choice:String, deer:Deer)
	{
		deer.knowsTheDarkenedWoods = true;

		var message:Array<String> = new Array<String>();
		message.push("As you approach the light it grows in intensity and you find yourself in front of a towering flame.");
		message.push("The flame rises from a shallow silver pit, with no firewood in sight. A steep staircase made of the same material descends into the ground behind it.");
		message.push("You hear wolves howl in the distance. The fire should keep them at bay, but you would rather get back to the den before they arrive.");
		message.push("(You can now travel to The Darkened Woods using the map)");
		showResult(message);
	}

	public function findDeer(choice:String, deer:Deer)
	{
		var randomNums:FlxRandom = new FlxRandom();

		//66% chance to find a deer you've previously lost
		if (GameVariables.instance.unfamiliarWoodsLostDeer.length > 0 && randomNums.int(0, 2) <= 1)
		{
			foundDeer = GameVariables.instance.unfamiliarWoodsLostDeer[randomNums.int(0, GameVariables.instance.unfamiliarWoodsLostDeer.length - 1)];

			var message:Array<String> = new Array<String>();
			message.push("You come across " + foundDeer.name + ", a lost deer from your pack.");
			message.push("You see they are ");
			message[1] += foundDeer.gender;
			message[1] += " and have a glimmer of ";
			message[1] += foundDeer.getGlimmer();
			message[1] += " in their eye.";
			showChoice(message, ["Welcome back", "Scare off", "Continue on"], [returningDeer, scareOffDeer, declineDeerFriend], deer);
		}
		else
		{
			var newDeerFriend:Deer = Deer.buildADeer(randomNums.int(11, 13));
			foundDeer = newDeerFriend;

			if (foundDeer.str <= 2 && (randomNums.int(0,1) == 0))
			{
				var message:Array<String> = new Array<String>();
				message.push("You come across another deer lying on the ground under a large branch. They seem to be stuck.");
				message.push("You see they are ");
				message[1] += newDeerFriend.gender;
				message[1] += " and have a glimmer of ";
				message[1] += newDeerFriend.getGlimmer();
				message[1] += " in their eye.";
				showChoice(message, ["Try to help", "Continue on"], [helpStuckDeer, declineDeerFriend], deer);
			}
			else if (foundDeer.int <= 2 && (randomNums.int(0,1) == 0))
			{
				var message:Array<String> = new Array<String>();
				message.push("You come across another deer. They look like they haven't eaten much recently.");
				message.push("You see they are ");
				message[1] += newDeerFriend.gender;
				message[1] += " and have a glimmer of ";
				message[1] += newDeerFriend.getGlimmer();
				message[1] += " in their eye.";
				showChoice(message, ["Offer food (1)", "Continue on"], [offerFood, declineDeerFriend], deer);
			}
			else
			{
				var message:String = "You come across another deer. You see they are ";
				message += newDeerFriend.gender;
				message += " and have a glimmer of ";
				message += newDeerFriend.getGlimmer();
				message += " in their eye.";
				showChoice([message], ["Recruit", "Continue on"], [recruitDeer, declineDeerFriend], deer);
			}
		}
	}

	public function returningDeer(choice:String, deer:Deer)
	{
		GameVariables.instance.unfamiliarWoodsLostDeer.remove(foundDeer);
		GameVariables.instance.addFoundDeer(foundDeer);

		showResult(["After bowing to each other, you continue walking as " + foundDeer.name + " follows."]);
	}

	public function scareOffDeer(choice:String, deer:Deer)
	{
		GameVariables.instance.unfamiliarWoodsLostDeer.remove(foundDeer);

		showResult(["You stomp your hooves menancing at " + foundDeer.name + ".", "They take off quickly, and you doubt you'll see them again."]);
	}

	public function helpStuckDeer(choice:String, deer:Deer)
	{
		var randomNums:FlxRandom = new FlxRandom();
		if (randomNums.int(0,5) + deer.str >= 6)
		{
			GameVariables.instance.addFoundDeer(foundDeer);
			showResult(["You lift the fallen branch easily, allowing them to stand up.", "You continue on as they follow behind."]);
		}
		else
		{
			if (randomNums.int(0,5) + deer.res >= 7)
			{
				showResult(["The branch is too cumbersome for you to lift.", "Surely someone else will be by soon."]);
			}
			else
			{
				deer.takeDamage(1);
				showResult(["The branch is too cumbersome for you to lift, and you injure yourself slightly in your attempt.", "Surely someone else will be by soon."]);
			}
		}
	}

	public function offerFood(choice:String, deer:Deer)
	{
		if (GameVariables.instance.currentFood >= 1)
		{
			GameVariables.instance.modifyFood(-1);
			GameVariables.instance.addFoundDeer(foundDeer);
			showResult(["You lead the deer to the den, where they quickly scarf down some food.", "You expext that they'll stick around."]);
		}
		else
		{
			showResult(["Without any food to offer them, you wish them luck and continue on."], "...");
		}
	}

	public function recruitDeer(choice:String, deer:Deer)
	{
		GameVariables.instance.addFoundDeer(foundDeer);
		showResult(["After bowing to each other, the deer follows behind you as you continue walking."]);
	}

	public function declineDeerFriend(choice:String, deer:Deer)
	{
		showResult(["You turn your head and keep walking."], "...");
	}

	public function cave(choice:String, deer:Deer)
	{
		GameVariables.instance.unfamiliarWoodsCaveFound = true;

		var messages:Array<String> = new Array<String>();
		messages.push("You come across a large cave.");
		messages.push("It seems to go quite far into the hillside. A dim light shines further inside.");

		showChoice(messages, ["Walk inside", "Head back"], [insideCave, continueOnChoice], deer);
	}

	//Change to be 1 stone for each stat, need a deer with 4+ to make it glow
	public function insideCave(choice:String, deer:Deer)
	{
		var messages:Array<String> = new Array<String>();
		messages.push("Heading inside you follow the cave as it curves rightwards, soon coming to a dead-end.");
		messages.push("You stand in front of a smooth stone wall, featureless except for an arc of 5 clear stones embedded within it.");
		
		deerInCave.push(deer);
		
		var statNames = ["Strength", "Resilience", "Dexterity", "Intellect", "Fortune"];
		var stonesGlowing:Int = 0;
		for (i in 0...deerInCave.length){
			var originalStatNameLength = statNames.length;
			for(j in 1...statNames.length+1){
				if (deerInCave[i].getStatByName(statNames[originalStatNameLength - j]) >= 4){
					statNames.remove(statNames[originalStatNameLength - j]);
					stonesGlowing++;
				}
			}
		}
		
		if (stonesGlowing == 1)
		{
			messages.push("One of the stones is glowing.");
		}
		else if (stonesGlowing == 2)
		{
			messages.push("Two of the stones are glowing.");
		}
		else if (stonesGlowing == 3)
		{
			messages.push("Three of the stones are glowing.");
		}
		else if (stonesGlowing == 4)
		{
			messages.push("Four of the stones are glowing.");
		}
		else if (stonesGlowing == 5)
		{
			if(deerInCave.length > 1){
				messages.push("As you walk forward and stand next to the other deer waiting around, all five of the glowing stones begin to pulse slowly.");
			}else{
				messages.push("As you walk closer to to the wall, all five of the glowing stones begin to pulse slowly.");
			}
			messages.push("You hear a grinding sound as the stone wall lowers into the ground.");
		}

		if (stonesGlowing == 5)
		{
			showChoice(messages, ["Step Forward"], [enterDeepCave], deer);
		}
		else
		{
			showChoice(messages, ["Wait around"], [continueOnChoice], deer);
		}
	}

	public function enterDeepCave(choice:String, deer:Deer)
	{
		var messages:Array<String> = new Array<String>();
		
		messages.push("You walk through the new opening and look around.");
		messages.push("You are in a small room, lit dimly by a few glowing rods embedded in the room's ceiling.");

		if (!GameVariables.instance.unfamiliarWoodsMedallionTaken)
		{
			messages.push("The room is empty, bar a stone pedestal near the back. A bronze medallion sits on top.");
			showChoice(messages, ["Take Medallion"], [takeMedallion], deer);
		}
		else
		{
			messages.push("The room is empty, bar a stone pedestal near the back.");
			messages.push("Seeing nothing of interest, you and the others head back.");
			deerInCave = new Array<Deer>();
			showResult(messages);
		}
	}

	public function leaveCave(choice:String, deer:Deer)
	{
		deerInCave.remove(deer);
		showResult(["You walk outside the cave and head back home."]);
	}

	public function takeMedallion(choice:String, deer:Deer)
	{
		GameVariables.instance.unfamiliarWoodsMedallionTaken = true;
		deerInCave = new Array<Deer>();

		var messages:Array<String> = new Array<String>();
		messages.push("You walk forward and pick up the medallion.");
		messages.push("Seeing nothing else of interest, you and the others head back.");
		showResult(messages);
	}

	public function perseveranceApple(choice:String, deer:Deer)
	{
		if (choice == "Trudge through it")
		{
			var message:String = "You head into the thicket and ";
			var randomNums:FlxRandom = new FlxRandom();

			//Check for success
			var successfulPushthrough:Bool;
			var pushthroughPower = (deer.str * 2) + deer.res + randomNums.int(0, 6);

			if (pushthroughPower >= 13)
			{
				successfulPushthrough = true;
				GameVariables.instance.modifyFood(2);
			}
			else
			{
				successfulPushthrough = false;
			}

			//Check for damage
			var resistancePower = (deer.res * 2) + deer.lck + randomNums.int(0, 6);

			if (resistancePower <= 10)
			{
				if (successfulPushthrough)
				{
					message += "after a lot of stuggling and cuts, you push through it. You walk away with your hard-earned apples covered in painful scratches (+2 food).";
				}
				else
				{
					message += "after a lot of stuggling and cuts, you give up. You walk away covered in painful scratches.";
				}
				deer.takeDamage(3);
			}
			else if (resistancePower <= 13)
			{
				if (successfulPushthrough)
				{
					message += "after toughing out some minor difficulties, you push through it. You walk away with your hard-earned apples and a few small scratches (+2 food).";
				}
				else
				{
					message += "after toughing out some minor difficulties, you realize you just aren't getting through. You walk away with a few small scratches.";
				}
				deer.takeDamage(1);
			}
			else
			{
				if (successfulPushthrough)
				{
					message += "with no trouble at all, you push through it. You walk away with your hard-earned apples completely unscathed (+2 food).";
				}
				else
				{
					message += "despite being able to withstand the prickled branches, you're just not able to push through. You head home empty-mouthed, but unharmed.";
				}
			}

			showResult([message]);
		}
		else if (choice == "Turn back")
		{
			showResult(["Not willing to risk injury, you head back."]);
		}
	}

	public function riskyApple(choice:String, deer:Deer)
	{
		if (choice == "Jump for it") {
			var message:String = "You leap for the apple and ";
			var randomNums:FlxRandom = new FlxRandom();
			
			//Apple catch check
			var appleResult:String = "";
			if(deer.dex + randomNums.int(0, 8) > 8){
				message += "catch it in your mouth. ";
				appleResult = "Caught";
			}else{
				if(deer.lck + randomNums.int(0, 10) > 11){
					message += "barely graze it, knocking it loose. ";
					appleResult = "Grazed";
				}else{
					message += "miss it completely. ";
					appleResult = "Missed";
				}
			}
			
			//Landing check
			if(deer.dex + randomNums.int(0, 8) > 8){
				message += "You land on the ground safely ";
			}else{
				if(deer.lck + randomNums.int(0, 10) > 11){
					message += "You stumble a bit as you land unharmed, ";
				}else{
					message += "You trip as you land, smashing into the ground. You stand up, ";
					deer.takeDamage(3);
				}
			}
			
			//Apple awarding
			if(appleResult == "Caught"){
				message += "with the apple safely in your mouth (+2 food).";
				GameVariables.instance.modifyFood(2);
			}else if(appleResult == "Grazed"){
				message += "and pick up the apple on the ground next to you (+2 food).";
				GameVariables.instance.modifyFood(2);
			}else if(appleResult == "Missed"){
				message += "looking back up at the apple you missed.";
			}
			
			showResult([message]);
		}
		else if(choice == "Continue on"){
			showResult(["Not willing to risk injury, you move on."]);
		}
	}
}