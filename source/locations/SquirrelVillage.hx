package locations;

import statuses.DeerStatusEffect;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.FlxAxes;
import flixel.math.FlxRandom;

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
	
	private function getAcornStatus():String
	{
		var result:String = "(You now have " + acornsEarned;
		
		if (acornsEarned == 1)
		{
			result += " acorn.)";
		}
		else
		{
			result += " acorns.)";
		}
		
		return result;
	}
	
	override public function explore(deer:Deer)
	{
		exploreWithString("You have no chance to survive make your time", deer);
	}
	
	public function exploreWithString(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		message.push("You step outside and walk to the center of town.");
		message.push("Where will you head to?");
		
		var exploreOptionNames:Array<String> = new Array<String>();
		var exploreOptionFunctions:Array<(String, Deer)->Void> = new Array<(String, Deer)->Void>();
		
		if (!buyingPhase)
		{
			//Cafe 
			exploreOptionNames.push("Cafe");
			exploreOptionFunctions.push(cafe);
		
			//Inn
			exploreOptionNames.push("Inn");
			exploreOptionFunctions.push(inn); 
			
			//Visitor Center
			exploreOptionNames.push("Visitor Center");
			exploreOptionFunctions.push(visitorCenter); 
		}
		
		//Museum
		exploreOptionNames.push("Museum");
		exploreOptionFunctions.push(museum); 
		
		//Supplies Shop
		exploreOptionNames.push("Supplies Shop");
		exploreOptionFunctions.push(suppliesShop);

		showChoice(message, exploreOptionNames, exploreOptionFunctions, deer);
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

		//Gossip Squirrels
		exploreOptionNames.push("Discuss Squirrels");
		exploreOptionFunctions.push(gossipSquirrels);
		
		//Gossip Deer
		exploreOptionNames.push("Discuss Deer");
		exploreOptionFunctions.push(gossipDeer);

		showChoice(message, exploreOptionNames, exploreOptionFunctions, deer);
	}
	
	public function gossipSquirrels(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		message.push("The squirrel next to you starts chittering frantically as you turn towards them.");
		message.push("Nothing they say would interest anyone but a squirrel, and after a while you politely excuse yourself.");
		showResult(message);
	}
	
	public function gossipDeer(choice:String, deer:Deer)
	{
		var randomNums:FlxRandom = new FlxRandom();
		
		var newDeerFriend:Deer = Deer.buildADeer(randomNums.int(14, 15), -1, 0, [[33, 55, 70, 82, 100], [22, 55, 70, 82, 100], [29, 58, 70, 80, 100]], false);
		foundDeer = newDeerFriend;
		
		var message:String = "You ask the squirrels if they've met any other deer around here. They say that a ";
		message += newDeerFriend.gender;
		message += " deer named " + newDeerFriend.getName() + " came by often, and that they were very ";
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
		message.push("You head over to the cafe counter and take a seat.");
		message.push("The squirrel behind the counter lays out some choices for you.");
		
		var drinkNames:Array<String> = new Array<String>();

		//Gossip 
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
			message.push("The squirrel runs and grabs you a fresh cup of coffee.");
			message.push("The flavour tastes just like munching on acorns.");
			message.push("(+2 luck for 4 days).");
			deer.addStatusEffect(new DeerStatusEffect("Lucky as an Acorn", 4, 0, 0, 0, 0, 3));
		}
		else if (choice == "Sleepy Spruce Tea")
		{
			//+2 health while resting for 4 days
			message.push("The squirrel runs and grabs you a fresh cup of tea.");
			message.push("The flavour tastes just like munching on spruce needles.");
			message.push("(+2 health while resting for 4 days).");
			deer.addStatusEffect(new DeerStatusEffect("Sleepy as a Spruce Tree", 4, 0, 0, 0, 0, 0));
		}
		else if (choice == "Chucklebean Blend")
		{
			//+2 dexterity for 4 days
			message.push("The squirrel runs and grabs you a fresh cup of coffee.");
			message.push("The flavour tastes just like munching on beans.");
			message.push("(+2 dexterity for 4 days).");
			deer.addStatusEffect(new DeerStatusEffect("Chuckled as a Bean", 4, 0, 0, 2, 0, 0));
		}
		
		showResult(message);
	}
	
	public function workingTheCafe(choice:String, deer:Deer)
	{
		var randomNums:FlxRandom = new FlxRandom();
		var message:Array<String> = new Array<String>();
		if (mountaineeringChallengeActive)
		{
			message.push("The barista squirrel ushers you behind the counter, gives you an apron, and puts you to work taking orders.");
			var cafeSkill:Int = deer.dex + deer.int + randomNums.int(0, 5);
			
			if (cafeSkill >= 17)
			{
				message.push(deer.getName() + " speedily takes the orders of every squirrel and remembers them all without a mistake.");
				message.push("The barista squirrel gives you 5 acorns for your outstanding work.");
				acornsEarned += 5;
			}
			else if (cafeSkill >= 15)
			{
				message.push(deer.getName() + " quickly takes the orders of every squirrel and remembers almost all of them without mistake.");
				message.push("The barista squirrel gives you 4 acorns for your excellent work.");
				acornsEarned += 4;
			}
			else if (cafeSkill >= 13)
			{
				message.push(deer.getName() + " manages to get all the squirrels orders before they get mad, but makes a couple mistakes.");
				message.push("The barista squirrel gives you 3 acorns for your decent performance.");
				acornsEarned += 3;
			}
			else if (cafeSkill >= 11)
			{
				message.push(deer.getName() + " scrambles to take every squirrel's order, recieving a couple complaints of the poor service.");
				message.push("The barista squirrel gives you 2 acorns for finishing your work.");
				acornsEarned += 2;
			}
			else if (cafeSkill >= 8)
			{
				message.push(deer.getName() + " scrambles to take every squirrel's order, and some leave because of the poor service.");
				message.push("The barista squirrel gives you a single acorn; you suspect they're just taking pity on you.");
				acornsEarned += 1;
			}
			else
			{
				message.push(deer.getName() + " struggles to take the squirrels orders quick enough, especially since they have to memorize them too.");
				message.push("The barista squirrel awards you no acorns for your embarrassing performance.");
			}
			
			var bonusAcorns = randomNums.int(0, deer.lck);
			
			if (bonusAcorns == 1)
			{
				message.push("You check your tip jar afterwards and find 1 acorn inside.");
			}
			else
			{
				message.push("You check your tip jar afterwards and find " + bonusAcorns + " acorns inside.");
			}
			
			acornsEarned += bonusAcorns;
			
			message.push(getAcornStatus());
			showResult(message);
		}
		else
		{
			message.push("The barista squirrel chitters rapidly as you approach the counter.");
			if (mountaineeringChallengeStartingTomorrow)
			{
				message.push("It seems you need to wait until tomorrow for your mountaineering challenge to officially start before working here.");
			}
			else
			{
				message.push("It seems you have to sign up for some mountaineering challenge to work here.");
			}
			showChoice(message, ["Gossip", "Specialty Brews", "Head outside"], [gossip, coffee, exploreWithString], deer);
		}
	}
	
	//Inn Location
	public function inn(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		message.push("You walk over to the hotel and head inside.");
		message.push("The hotel lobby is a small cramped room, with most areas of the floor covered in leaves.");
		message.push("On a reception desk in front of you a squirrel is hurriedly scurrying back and forth, scribbling on small scraps of paper as they go.");
		
		var exploreOptionNames:Array<String> = new Array<String>();
		var exploreOptionFunctions:Array<(String, Deer)->Void> = new Array<(String, Deer)->Void>();
		
		//Book a room
		exploreOptionNames.push("Book a room");
		exploreOptionFunctions.push(roomBooking);
		
		//Clean rooms
		exploreOptionNames.push("Clean rooms");
		exploreOptionFunctions.push(roomCleaning);
		
		//Back
		exploreOptionNames.push("Head outside");
		exploreOptionFunctions.push(exploreWithString); 

		showChoice(message, exploreOptionNames, exploreOptionFunctions, deer);
	}
	
	public function roomBooking(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		message.push("The squirrel sees you approaching and quickly scribbles something down on a notepad.");
		message.push("It seems your room is now booked, but you'll need to choose what type of bedding you want the room to have.");
		message.push("The squirrel lays out a few options for you to choose from.");
		
		var beddingNames:Array<String> = new Array<String>();

		//Twig Bedding (+1 Resilience) 
		beddingNames.push("Twig Bedding");
		
		//Leafy Bedding (+1 Dexterity) 
		beddingNames.push("Leafy Bedding");
		
		//Cotton Bedding (+1 Intellect) 
		beddingNames.push("Cotton Bedding");
		
		showChoice(message, beddingNames, [roomConfirmation], deer);
	}
	
	public function roomConfirmation(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		
		GameVariables.instance.beddingChoice = choice;
		message.push("The squirrel scribbles your choice down on another scrap of paper, then shoos you outside.");
		message.push("Your herd will come back to sleep there tonight.");
		showResult(message);
	}
	
	public function roomCleaning(choice:String, deer:Deer)
	{
		var randomNums:FlxRandom = new FlxRandom();
		var message:Array<String> = new Array<String>();
		
		if (mountaineeringChallengeActive)
		{
			message.push("The squirrel ushers you behind the counter, hands you a broom, and puts you to work cleaning rooms.");
			var cleaningSkill:Int = deer.res + deer.lck + randomNums.int(0, 4);
			
			if (cleaningSkill >= 16)
			{
				message.push(deer.getName() + " manages to clean every room in the inn, leaving them completely spotless.");
				message.push("The squirrel manager gives you 8 acorns for your outstanding work.");
				acornsEarned += 8;
			}
			else if (cleaningSkill >= 14)
			{
				message.push(deer.getName() + " falls over after cleaning every room in the inn, only missing a couple spots.");
				message.push("The squirrel manager gives you 6 acorns for your excellent work.");
				acornsEarned += 6;
			}
			else if (cleaningSkill >= 12)
			{
				message.push(deer.getName() + " falls over after cleaning every almost every room in the inn, leaving them very clean.");
				message.push("The squirrel manager gives you 4 acorns for your decent performance.");
				acornsEarned += 4;
			}
			else if (cleaningSkill >= 10)
			{
				message.push(deer.getName() + " gets tired after cleaning a few rooms, but leaves them very clean.");
				message.push("The squirrel manager gives you 2 acorns for your work.");
				acornsEarned += 2;
			}
			else if (cleaningSkill >= 7)
			{
				message.push(deer.getName() + " gets tired after cleaning a few rooms and slumps down in a corner.");
				message.push("The squirrel manager gives you a single acorn; you suspect they're just taking pity on you.");
				acornsEarned += 1;
			}
			else
			{
				message.push(deer.getName() + " gets tired before finishing a single room and passes out on the floor.");
				message.push("The squirrel manager awards you no acorns for your embarrassing performance.");
			}
			message.push(getAcornStatus());
			showResult(message);
		}
		else
		{
			message.push("The squirrel shakes their pencil at you and chitters as you approach the desk.");
			if (mountaineeringChallengeStartingTomorrow)
			{
				message.push("It seems you need to wait until tomorrow for your mountaineering challenge to officially start before working here.");
			}
			else
			{
				message.push("It seems you have to sign up for some mountaineering challenge to work here.");
			}
			showChoice(message, ["Book a room", "Head outside"], [roomBooking, exploreWithString], deer);
		}
	}
	
	//Visitor Center Location
	public function visitorCenter(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		message.push("You walk over to the vistor center and head inside. The center is a large 1-roomed wooden building with walls lined with maps.");
		message.push("A squirrel at the other end of the room beckons you over from the small counter they're standing on.");
		
		var exploreOptionNames:Array<String> = new Array<String>();
		var exploreOptionFunctions:Array<(String, Deer)->Void> = new Array<(String, Deer)->Void>();
		
		//Booth
		exploreOptionNames.push("Visit the squirrel");
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
		message.push("You walk over to the desk.");
		
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
			message.push("You walk over and the squirrel starts frantically chirping at you.");
			message.push("Your challenge starts tomorrow. You should help out around town to earn acorns today, then spend them on supplies tomorrow morning.");
			message.push("After that you'll head out to climb the mountain.");
			showChoice(message, ["Study the maps", "Head outside"], [mountaineeringChallengeStart, mapStudying, exploreWithString], deer);
		}
		else if (mountaineeringChallengeActive)
		{
			message.push("You walk over and the squirrel starts motioning for you to head outside, then also points at the maps.");
			message.push("Your challenge is currently underway. You should help out around town to earn acorns today, then spend them on supplies tomorrow morning.");
			message.push("After that you'll head out to climb the mountain.");
			message.push("You can also spend time today studying the route you'll be following.");
			showChoice(message, ["Study the maps", "Head outside"], [mountaineeringChallengeStart, mapStudying, exploreWithString], deer);
		}
		else
		{
			message.push("You walk over and the squirrel starts frantically chirping at you.");
			message.push("It seems the village runs a program for anyone wanting to climb the nearby mountain.");
			message.push("If you sign the clipboard next to them then you'll start the mountaineering challenge tomorrow.");
			message.push("During the challenge tomorrow you should help out squirrels to earn acorns.");
			message.push("Then the next morning you can those acorns on supplies, then head out on an expedition to climb the nearby mountain.");
			showChoice(message, ["Start the challenge", "Study the maps", "Head outside"], [mountaineeringChallengeStart, mapStudying, exploreWithString], deer);
		}
	}
	
	public function mountaineeringChallengeStart(choice:String, deer:Deer)
	{
		mountaineeringChallengeStartingTomorrow = true;
		
		var message:Array<String> = new Array<String>();
		message.push("You step over to the clipboard hanging on the wall and sign your name.");
		message.push("Your mountaineering challenge begins tomorrow.");
		showResult(message);
	}
	
	public function mapStudying(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		
		if (mountaineeringChallengeStartingTomorrow)
		{
			message.push("The squirrel sees you studying the maps and rushes over to stop you.");
			message.push("It seems the safest route to the top changes often, and you shouldn't be studying the mountain until you're about to climb it.");
			message.push("You should come by tomorrow when your challenge has started.");
			showChoice(message, ["Visit the squirrel", "Head outside"], [booth, exploreWithString], deer);
		}
		else if (!mountaineeringChallengeActive)
		{
			message.push("The squirrel sees you studying the maps and rushes over to stop you.");
			message.push("It seems the safest route to the top changes often, and you shouldn't be studying the mountain until you're about to climb it.");
			showChoice(message, ["Visit the squirrel", "Head outside"], [booth, exploreWithString], deer);
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
		message.push("You walk over to the museum and head inside.");
		message.push("The museum is a small room packed with climbing supplies and framed drawings of squirrels. Over on your right is a counter for a giftshop.");
		
		var exploreOptionNames:Array<String> = new Array<String>();
		var exploreOptionFunctions:Array<(String, Deer)->Void> = new Array<(String, Deer)->Void>();
		
		//Museum exhibits
		exploreOptionNames.push("Look at the exhibits");
		exploreOptionFunctions.push(museumExhibits);
		
		//Gift Shop
		exploreOptionNames.push("Visit the gift shop");
		exploreOptionFunctions.push(giftShop); 
		
		//Back
		exploreOptionNames.push("Head outside");
		exploreOptionFunctions.push(exploreWithString); 

		showChoice(message, exploreOptionNames, exploreOptionFunctions, deer);
	}
	
	public function museumExhibits(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		
		if (!GameVariables.instance.leaderShipSkillsEarned)
		{
			GameVariables.instance.leaderShipSkillsEarned = true;
			message.push("Looking through the exhibits, what stands out to you most is a series of drawings depicting the first expedition to climb the mountain.");
			message.push("A single squirrel seems to lead a few others up the mountain, delegating each one a task for the day.");
			message.push("You leave the museum with some ideas on how to more quickly organize your herd.");
			message.push("(This setting can be turned off in the options)");
			showResult(message);
		}
		else
		{
			message.push("Looking through the exhibits, what stands out to you most is a series of drawings depicting the first expedition to climb the mountain.");
			message.push("A single squirrel seems to lead a few others up the mountain, delegating each one a task for the day.");
			showChoice(message, ["Visit the gift shop", "Head outside"], [giftShop, exploreWithString], deer);
		}
	}
	
	public function giftShop(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		message.push("Add some stuff to buy here later.");
		showChoice(message, ["Look at the exhibits", "Head outside"], [museumExhibits, exploreWithString], deer);
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
			exploreOptionNames.push("Walk up to the counter");
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
		var message:Array<String> = new Array<String>();
		
		if (mountaineeringChallengeActive)
		{
			message.push("You walk over to the store counter.");
			message.push("You should work to earn acorns today, then come by the next morning to buy supplies.");
			showChoice(message, ["Chop wood", "Head outside"], [woodChopping, exploreWithString], deer);
		}
		else if(mountaineeringChallengeStartingTomorrow)
		{
			message.push("You walk over to the store counter.");
			message.push("You should work to earn acorns tomorrow, then come by the next morning to buy supplies.");
			showChoice(message, ["Chop wood", "Head outside"], [woodChopping, exploreWithString], deer);
		}
		else
		{
			message.push("You walk over to the store counter.");
			message.push("You could start a mountaineering challenge, then come here the morning you leave to buy some supplies.");
			showChoice(message, ["Chop wood", "Head outside"], [woodChopping, exploreWithString], deer);
		}
	}
	
	public function foodAisle(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		message.push("The food packs have 3 food each and you'll open them automatically if you run out on the mountain.");
		message.push("A sign next to them lists them as costing 2 acorns per pack.");
		showChoice(message, ["Chop wood", "Head outside"], [woodChopping, exploreWithString], deer);
	}
	
	public function explosives(choice:String, deer:Deer)
	{
		
	}
	
	public function firewood(choice:String, deer:Deer)
	{
		
	}
	
	public function woodChopping(choice:String, deer:Deer)
	{
		var randomNums:FlxRandom = new FlxRandom();
		var message:Array<String> = new Array<String>();
		
		if (mountaineeringChallengeActive)
		{
			message.push("The squirrel leads you out behind the shop, hands you an axe, and puts you to work chopping wood.");
			var choppingSkill:Int = deer.res + deer.lck + randomNums.int(0, 4);
			
			var currentAcornsEarned:Int = Math.floor(choppingSkill / 2);
			message.push(deer.getName() + " manages to chop " + choppingSkill + " sets of logs.");
			
			if (currentAcornsEarned >= 8)
			{
				message.push("The squirrel gives you " + currentAcornsEarned + " acorns for your outstanding work.");
				acornsEarned += currentAcornsEarned;
			}
			else if (currentAcornsEarned >= 6)
			{
				message.push("The squirrel gives you " + currentAcornsEarned + " acorns for your excellent work.");
				acornsEarned += currentAcornsEarned;
			}
			else if (currentAcornsEarned >= 4)
			{
				message.push("The squirrel gives you " + currentAcornsEarned + " acorns for your good work.");
				acornsEarned += currentAcornsEarned;
			}
			else if (currentAcornsEarned >= 2)
			{
				message.push("The squirrel gives you " + currentAcornsEarned + " acorns for your work.");
				acornsEarned += currentAcornsEarned;
			}
			else
			{
				message.push("The squirrel gives you a single acorn for your work; you suspect they're just taking pity on you.");
				acornsEarned += 1;
			}
			message.push(getAcornStatus());
			showResult(message);
		}
		else
		{
			message.push("You motion toward the axe leaning against the back door, but the squirrel silently shakes their head and points to a sign above them.");
			if (mountaineeringChallengeStartingTomorrow)
			{
				message.push("It seems you need to wait until tomorrow for your mountaineering challenge to officially start before working here.");
			}
			else
			{
				message.push("It seems you have to sign up for some mountaineering challenge to work here.");
			}
			showChoice(message, ["Walk up to the counter", "Head outside"], [suppliesExplanation, exploreWithString], deer);
		}
	}
	
	override public function forage(deer:Deer) 
	{
		var randomNums:FlxRandom = new FlxRandom();
		var message:Array<String> = new Array<String>();
		var forageResult = (deer.int * 2) + (deer.lck) + randomNums.int(0, 10);

		if (forageResult <= 6)
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
		
		if (!mountaineeringChallengeActive)
		{
			GameVariables.instance.modifyFood(2);
			message.push("Some nearby squirrels see you searching for food and offer you some chestnuts (+2 food).");
		}
		else
		{
			message.push("Some nearby squirrels see you searching for food.");
			message.push("They feel bad that they've taken most of it and offer you a couple acorns.");
			acornsEarned += 2;
			message.push(getAcornStatus());
		}
		
		showResult(message);
	}
	
	override public function defend(deer:Array<Deer>)
	{
		var randomNums:FlxRandom = new FlxRandom();
		var message:Array<String> = new Array<String>();
		if (mountaineeringChallengeStartingTomorrow)
		{
			message.push("It seems there's nothing that will attack your den here for now. It's likely thanks to the squirrel guards patrolling the area.");
			message.push("You run into some patrolling squirrels and they warn you that you'll have to defend your own stuff during the mountaineering challenge tomorrow.");
			showResult(message);
		}
		else if (!mountaineeringChallengeActive)
		{
			if (deer.length > 0)
			{
				message.push("It seems there's nothing that will attack your den here for now. It's likely thanks to the squirrel guards patrolling the area.");
				message.push("You run into some patrolling squirrels and they warn you that you'll have to defend your own stuff during the mountaineering challenge.");
				message.push("They motion for you to head to the visitors center to learn about it.");
				showResult(message);
			}
			else
			{
				setOut();
			}
		}
		else
		{
			message.push("Night draws and a group of ninja squirrels approaches your food stash.");
			
			for (i in 0...deer.length)
			{
				var squirrelAttackReduction:Int = 0;
				var squirrelScaringSkill:Int = deer[i].dex * 2 + deer[i].lck + randomNums.int(0, 5);
				var currentDeer:Deer = deer[i];
				
				if (squirrelScaringSkill >= 19)
				{
					message.push(currentDeer.getName() + " hones in on the squirrels' movements, deflecting all of their attempts to approach.");
					squirrelAttackReduction += 5;
				}
				else if (squirrelScaringSkill >= 17)
				{
					message.push(currentDeer.getName() + " hones in on the squirrels' movements, deflecting almost all of their attempts to approach.");
					squirrelAttackReduction += 4;
				}
				else if (squirrelScaringSkill >= 15)
				{
					message.push(currentDeer.getName() + " desperately blocks the squirrels' approaches, deflecting most of their attempts to approach.");
					squirrelAttackReduction += 3;
				}
				else if (squirrelScaringSkill >= 13)
				{
					message.push(currentDeer.getName() + " desperately blocks the squirrels' approaches, deflecting some of their attempts to approach.");
					squirrelAttackReduction += 2;
				}
				else if (squirrelScaringSkill >= 10)
				{
					message.push(currentDeer.getName() + " is too slow to keep up with the squirrels' movements, deflecting almost none of their attempts to approach.");
					squirrelAttackReduction += 1;
				}
				else
				{
					message.push(currentDeer.getName() + " is too slow to keep up with the squirrels' movements, deflecting none of their attempts to approach.");
				}
			}
			
			if (squirrelAttackReduction >= 5)
			{
				message.push("When all is said and done you lose none of your food to the ninja squirrels.");
				message.push("The squirrels leave you a pile of 5 acorns, impressed by your skills.");
				acornsEarned += 5;
				message.push(getAcornStatus());
			}
			else if (squirrelAttackReduction >= 3)
			{
				message.push("You stopped most of the ninja squirrels' attempts at stealing your food, but still lose some scraps.");
				message.push("(-2 food)");
				GameVariables.instance.modifyFood(-2);
				message.push("The squirrels leave you a pile of 3 acorns, impressed by your skills.");
				acornsEarned += 3;
				message.push(getAcornStatus());
			}
			else if (squirrelAttackReduction >= 1)
			{
				message.push("You stopped some of the ninja squirrels' attempts at stealing your food, but not all of them.");
				message.push("(-3 food)");
				GameVariables.instance.modifyFood(-3);
				message.push("The squirrels leave you a couple acorns for your admirable attempt at a defense.");
				acornsEarned += 2;
				message.push(getAcornStatus());
			}
			else
			{
				if (deer.length == 0)
				{
					message.push("With your den undefended, the squirrels take some food and leave unhindered.");
					message.push("(-4 food)");
				}
				else
				{
					message.push("Your deer were completely ineffective at preventing the ninja squirrels' attempts to steal your food.");
					message.push("(-4 food)");
					message.push("The squirrels leave you a couple acorns for your admirable attempt to defend your stash.");
					acornsEarned += 2;
					message.push(getAcornStatus());
				}
				GameVariables.instance.modifyFood(-4);
			}
		
			showResult(message);
		}
	}
	
	override public function hunt(deer:Array<Deer>) 
	{
		var randomNums:FlxRandom = new FlxRandom();
		var message:Array<String> = new Array<String>();
		
		if (mountaineeringChallengeStartingTomorrow)
		{
			message.push("Your hunting pack wanders around the area, but it seems like the squirrels have scared off anything nearby.");
			message.push("You run into some squirrels heading back to the village after a hunt, they tell you to come back and try hunting tomorrow once your mountaineering challenge has started.");
			showResult(message);
		}
		else if (!mountaineeringChallengeActive)
		{
			message.push("Your hunting pack wanders around the area, but it seems like the squirrels have scared off anything nearby.");
			message.push("You run into some squirrels heading back to the village after a hunt, they let you know you should try to go hunting when you take the mountaineering challenge.");
			message.push("They motion for you to head to the visitors center to learn about it.");
			showResult(message);
		}
		else
		{
			message.push("Your hunting pack comes across a single mountain goat, taunting you from halfway up a cliffside.");
			randomNums.shuffle(deer);
			
			var acornReward:Int = 0;
			
			for (i in 0...deer.length)
			{
				var currentDeer:Deer = deer[i];
				var climbingSkill:Int = currentDeer.dex * 2 + currentDeer.lck + randomNums.int(0, 4);
				
				if (climbingSkill >= 10)
				{
					message.push(currentDeer.getName() + " manages to scramble up the cliffside to where the goat is.");
					
					var smackingSkill:Int = currentDeer.str * 2 + randomNums.int(0, 4);
					
					if (smackingSkill >= 14)
					{
						message.push(currentDeer.getName() + " bashes into the goat's horns, sending them stumbling backwards.");
						acornReward += 10;
					}
					else if (smackingSkill >= 12)
					{
						message.push(currentDeer.getName() + " bashes into the goat's horns, making them take a step back.");
						acornReward += 8;
					} 
					else if (smackingSkill >= 10)
					{
						message.push(currentDeer.getName() + " bashes into the goat's horns, making them take a step back.");
						acornReward += 6;
					} 
					else
					{
						message.push(currentDeer.getName() + " tries to bash into the goat's horns, but moreso just head-taps them.");
						acornReward += 3;
					} 
				}
				else
				{
					message.push(currentDeer.getName() + " is too slow to keep up with the squirrels' movements, deflecting none of their attempts to approach.");
				}
			}
			
			if (acornReward > 0)
			{
				message.push("The goat follows your deer as you stumble back down the cliffside. They seem to have enjoyed your attempts at fighting a mountain goat on a mountain.");
				message.push("The goat quickly hops back up the cliff, then comes back down with a mouthful of " + acornReward + " acorns to offer as a gift.");
				
				acornsEarned += acornReward;
				message.push(getAcornStatus());
			}
			else
			{
				message.push("The goat laughingly bleats at you as your hunting pack fails to get up the cliffside.");
			}
			
			showResult(result);
		}
	}
}