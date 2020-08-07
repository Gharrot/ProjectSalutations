package locations;

import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.FlxAxes;

class SquirrelVillage extends Location 
{
	var foundDeer:Deer;
	var acornsEarned:Int = 0;
	
	var mountaineeringChallengeStartingTomorrow:Bool = false;
	var mountaineeringChallengeActive:Bool = false;
	var buyingPhase = false;

	public function new(){
		super();
		
		name = "Squirrel Village";
		backgroundImageFile = "assets/images/LocationImages/StoneStrongholdEntrance.png";
		backgroundImageFileNoFrame = "assets/images/LocationImages/StoneStrongholdEntranceNoFrame.png";
		backgroundImageFileMiniFramed = "assets/images/LocationImages/StoneStrongholdEntranceEmptyDeerTile.png";
	}
	
	override public function explore(deer:Deer)
	{
		exploreWithString("You have no chance to survive make your time", deer);
	}
	
	public function exploreWithString(choice:String, deer:Deer)
	{
		var exploreOptionNames:Array<String> = new Array<String>();
		var exploreOptionFunctions:Array<(String, Deer)->Void> = new Array<(String, Deer)->Void>();

		//Cafe 
		exploreOptionNames.push("Cafe");
		exploreOptionFunctions.push(cafe);
		
		//Inn
		if (!buyingPhase)
		{
			exploreOptionNames.push("Inn");
			exploreOptionFunctions.push(inn); 
		}
		
		//Visitor Center
		exploreOptionNames.push("Visitor Center");
		exploreOptionFunctions.push(visitorCenter); 
		
		//Museum
		exploreOptionNames.push("Museum");
		exploreOptionFunctions.push(museum); 
		
		//Supplies Shop
		exploreOptionNames.push("Supplies Shop");
		exploreOptionFunctions.push(suppliesShop);

		showChoice(["Where will you head to?"], exploreOptionNames, exploreOptionFunctions, deer);
	}
	
	//Cafe Location
	public function cafe(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		message.push("You walk over to the cafe and head inside.");
		message.push("A few squirrels are sitting around drinking coffee and another is standing on a counter, ready to serve you.");
		
		var exploreOptionNames:Array<String> = new Array<String>();
		var exploreOptionFunctions:Array<(String, Deer)->Void> = new Array<(String, Deer)->Void>();

		//Gossip 
		exploreOptionNames.push("Gossip");
		exploreOptionFunctions.push(gossip);
		
		//Coffees
		exploreOptionNames.push("Specialty Brews");
		exploreOptionFunctions.push(coffee);
		
		//Work
		exploreOptionNames.push("Work the counter");
		exploreOptionFunctions.push(workingTheCafe);
		
		//Back
		exploreOptionNames.push("Head outside");
		exploreOptionFunctions.push(exploreWithString); 

		showChoice(message, exploreOptionNames, exploreOptionFunctions, deer);
	}
	
	public function gossip(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		message.push("You head over to the cafe counter and take a seat next to some squirrels.");
		
		var exploreOptionNames:Array<String> = new Array<String>();
		var exploreOptionFunctions:Array<(String, Deer)->Void> = new Array<(String, Deer)->Void>();

		//Gossip 
		exploreOptionNames.push("Discuss Squirrels");
		exploreOptionFunctions.push(gossipSquirrels);
		
		//Coffees
		exploreOptionNames.push("Discuss Deer");
		exploreOptionFunctions.push(gossipDeer);

		showChoice(message, exploreOptionNames, exploreOptionFunctions, deer);
	}
	
	public function gossipSquirrels(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		//Add randomized tips here later
		message.push("The squirrel says 'Hey, I've gotta good tip for ya'.");
		message.push("'Or at least I would if the dev didn't forget to remove this placeholder'.");
		message.push("'Please go remind that guy to give me some tips to say'.");
		message.push("'I feel so worthless'.");
		showResult(message);
	}
	
	public function gossipDeer(choice:String, deer:Deer)
	{
		var randomNums:FlxRandom = new FlxRandom();
		
		var newDeerFriend:Deer = Deer.buildADeer(randomNums.int(14, 15));
		foundDeer = newDeerFriend;
		
		var message:String = "You ask the squirrels if they've met any other deer around here. They say that a ";
		message += newDeerFriend.gender;
		message += " deer named " + " came by often, and that they were very ";
		message += newDeerFriend.getGlimmer(["strong", "resilient", "quick", "wise", "good at cards"]);
		message += ".";
		showChoice([message], ["Ask to meet them", "Head back"], [recruitGossipDeer, continueOnChoice], deer);
	}
	
	public function recruitGossipDeer(choice:String, deer:Deer)
	{
		GameVariables.instance.addFoundDeer(foundDeer);
		
		var message:Array<String> = new Array<String>();
		message.push("The squirrel says they'll let the deer know where you're staying.");
		message.push("They should join your herd in the morning.");
		showResult(message);
	}
	
	public function coffee(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		message.push("There's a bunch of choices.");
		
		var drinkNames:Array<String> = new Array<String>();

		//Gossip 
		drinkNames.push("Acorn Brew");
		drinkNames.push("Sleepy Spruce Tea");

		showChoice(message, drinkNames, [coffeeDrinking], deer);
	}
	
	public function coffeeDrinking(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		
		if (choice == "Acorn Brew")
		{
			//+2 luck
		}
		else if (choice == "Sleepy Spruce Tea")
		{
			//+3 health while resting for 2 days
		}
	}
	
	public function workingTheCafe(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		if (mountaineeringChallengeActive)
		{
			message.push("Serving.");
		}
		else
		{
			
		}
	}
	
	//Inn Location
	public function inn(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		message.push("You walk over to the hotel and head inside.");
		message.push("It's a hotel.");
		
		var exploreOptionNames:Array<String> = new Array<String>();
		var exploreOptionFunctions:Array<(String, Deer)->Void> = new Array<(String, Deer)->Void>();
		
		//Coffees
		exploreOptionNames.push("Book a room");
		exploreOptionFunctions.push(coffee);
		
		//Clean rooms
		exploreOptionNames.push("Clean rooms");
		exploreOptionFunctions.push(workingTheCafe);
		
		//Back
		exploreOptionNames.push("Head outside");
		exploreOptionFunctions.push(exploreWithString); 

		showChoice(message, exploreOptionNames, exploreOptionFunctions, deer);
	}
	
	public function roomBooking(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		
		if (!mountaineeringChallengeActive)
		{
			message.push("Ya gotta go to the info center");
			showChoice(message, ["Clean rooms", "Head outside"], [roomCleaning, exploreWithString], deer);
		}
		else
		{
			//Room booking
		}
	}
	
	public function roomCleaning(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		
		if (!mountaineeringChallengeActive)
		{
			message.push("Ya gotta go to the info center");
			showChoice(message, ["Book a room", "Head outside"], [roomBooking, exploreWithString], deer);
		}
		else
		{
			//Room cleaning
		}
	}
	
	//Visitor Center Location
	public function visitorCenter(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		message.push("You walk over to the vistor center and head inside.");
		message.push("It's a visitor center.");
		
		var exploreOptionNames:Array<String> = new Array<String>();
		var exploreOptionFunctions:Array<(String, Deer)->Void> = new Array<(String, Deer)->Void>();
		
		//Booth
		exploreOptionNames.push("Visit the booth");
		exploreOptionFunctions.push(booth);
		
		//Study the maps
		exploreOptionNames.push("Study the maps");
		exploreOptionFunctions.push(exploreWithString); 
		
		//Back
		exploreOptionNames.push("Head outside");
		exploreOptionFunctions.push(exploreWithString); 

		showChoice(message, exploreOptionNames, exploreOptionFunctions, deer);
	}
	
	public function booth(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		message.push("You walk over to the booth.");
		
		if (mountaineeringChallengeActive || mountaineeringChallengeStartingTomorrow)
		{
			showChoice(message, ["Ask for info", "Study the maps", "Head outside"], [mountaineeringChallengeInfo, mapStudying, exploreWithString], deer);
		}
		else
		{
			showChoice(message, ["Ask for info", "Start the challenge", "Study the maps", "Head outside"], [mountaineeringChallengeInfo, mountaineeringChallengeStart, mapStudying, exploreWithString], deer);
		}
	}
	
	public function mountaineeringChallengeInfo(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		
		if (mountaineeringChallengeStartingTomorrow)
		{
			message.push("It starts tomorah.");
			showChoice(message, ["Study the maps", "Head outside"], [mountaineeringChallengeStart, mapStudying, exploreWithString], deer);
		}
		else if (mountaineeringChallengeActive)
		{
			message.push("Info while started.");
			showChoice(message, ["Study the maps", "Head outside"], [mountaineeringChallengeStart, mapStudying, exploreWithString], deer);
		}
		else
		{
			message.push("Normal info.");
			showChoice(message, ["Start the challenge", "Study the maps", "Head outside"], [mountaineeringChallengeStart, mapStudying, exploreWithString], deer);
		}
	}
	
	public function mountaineeringChallengeStart(choice:String, deer:Deer)
	{
		mountaineeringChallengeStartingTomorrow = true;
		
		var message:Array<String> = new Array<String>();
		message.push("Everything will start tomorrow.");
		showResult(message);
	}
	
	public function mapStudying(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		
		if (mountaineeringChallengeStartingTomorrow)
		{
			message.push("Hey don't bother, the route we follow changes daily.");
			showChoice(message, ["Visit the booth", "Head outside"], [booth, exploreWithString], deer);
		}
		else if (!mountaineeringChallengeActive)
		{
			message.push("Hey don't bother, the route we follow changes daily.");
			showChoice(message, ["Visit the booth", "Head outside"], [booth, exploreWithString], deer);
		}
		else
		{
			message.push("Study the maps.");
			showResult(message);
		}
	}
	
	//Museum Location
	public function museum(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		message.push("You walk over to the vistor center and head inside.");
		message.push("It's a visitor center.");
		
		var exploreOptionNames:Array<String> = new Array<String>();
		var exploreOptionFunctions:Array<(String, Deer)->Void> = new Array<(String, Deer)->Void>();
		
		//Booth
		exploreOptionNames.push("Visit the booth");
		exploreOptionFunctions.push(booth);
		
		//Study the maps
		exploreOptionNames.push("Study the maps");
		exploreOptionFunctions.push(exploreWithString); 
		
		//Back
		exploreOptionNames.push("Head outside");
		exploreOptionFunctions.push(exploreWithString); 

		showChoice(message, exploreOptionNames, exploreOptionFunctions, deer);
	}
	
	public function museumEnter(choice:String, deer:Deer)
	{
		
	}
	
	public function giftShop(choice:String, deer:Deer)
	{
		
	}
	
	//Supplies Shop Location
	public function suppliesShop(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		message.push("You walk over to the supplies and head inside.");
		
		var exploreOptionNames:Array<String> = new Array<String>();
		var exploreOptionFunctions:Array<(String, Deer)->Void> = new Array<(String, Deer)->Void>();
		
		if (!buyingPhase)
		{
			message.push("The squirrel motions for you to step up to the counter.");
			
			//Counter
			exploreOptionNames.push("Step up to the Counter");
			exploreOptionFunctions.push(suppliesExplanation);
		}
		else
		{
			message.push("The squirrel standing behind the shop counter welcomes you and gestures towards a few sections of the store.");
			
			//Food Packs
			exploreOptionNames.push("Food aisle");
			exploreOptionFunctions.push(exploreWithString); 
			
			//Explosives
			exploreOptionNames.push("Explosives section");
			exploreOptionFunctions.push(exploreWithString); 
			
			//Firewood
			exploreOptionNames.push("Firewood stacks");
			exploreOptionFunctions.push(exploreWithString); 
		}
		
		//Chop wood
		exploreOptionNames.push("Chop wood");
		exploreOptionFunctions.push(exploreWithString); 
		
		//Back
		exploreOptionNames.push("Head outside");
		exploreOptionFunctions.push(exploreWithString); 

		showChoice(message, exploreOptionNames, exploreOptionFunctions, deer);
	}
	
	public function suppliesExplanation(choice:String, deer:Deer)
	{
		
	}
	
	public function foodAisle(choice:String, deer:Deer)
	{
		
	}
	
	public function explosives(choice:String, deer:Deer)
	{
		
	}
	
	public function firewood(choice:String, deer:Deer)
	{
		
	}
	
	public function woodChopping(choice:String, deer:Deer)
	{
		
	}
	
	override public function forage(deer:Deer) 
	{
		var randomNums:FlxRandom = new FlxRandom();
		
		GameVariables.instance.modifyFood(3);
		showResult(["Some nearby squirrels see you searching for food and offer you some acorns to eat (+3 food)."]);
	}
	
	override public function defend(deer:Array<Deer>)
	{
		var message:Array<String> = new Array<String>();
		if (mountaineeringChallengeStartingTomorrow)
		{
			message.push("It seems there's nothing that will attack your den here. It's likely thanks to the squirrel guards patrolling the area.");
			message.push("You run into some patrolling squirrels and they warn you that you'll have to defend your own stuff during the mountaineering challenge tomorrow.");
			showResult(message);
		}
		else if (!mountaineeringChallengeActive)
		{
			if (deer.length > 0)
			{
				message.push("It seems there's nothing that will attack your den here. It's likely thanks to the squirrel guards patrolling the area.");
				message.push("You run into some patrolling squirrels and they warn you that you'll have to defend your own stuff during the mountaineering challenge.");
				message.push("They motion for you to head to the visitors center to learn more about it.");
				showResult(message);
			}
			else
			{
				setOut();
			}
		}
		else
		{
			setOut();
		}
	}
	
	override public function hunt(deer:Array<Deer>) {
		var message:Array<String> = new Array<String>();
		
		if (mountaineeringChallengeStartingTomorrow)
		{
			message.push("Your hunting pack wanders around the area, but it seems like the squirrels have scared off anything nearby.");
			message.push("You run into some squirrels heading back to the village after a hunt, they tell you to come back and help them tomorrow once your mountaineering challenge has started.");
			showResult(message);
		}
		else if (!mountaineeringChallengeActive)
		{
			message.push("Your hunting pack wanders around the area, but it seems like the squirrels have scared off anything nearby.");
			message.push("You run into some squirrels heading back to the village after a hunt, they let you know you could help them while you're doing the mountaineering challenge.");
			message.push("They motion for you to head to the visitors center to learn more about it.");
			showResult(message);
		}
		else
		{
			
		}
	}
}