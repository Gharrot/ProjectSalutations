package locations;

import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import statuses.DeerStatusEffect;
import flixel.math.FlxRandom;

import flixel.addons.ui.FlxUIList;
import flixel.addons.ui.FlxUIText;

import flixel.FlxG;

class Location{
    public var name:String;
	
    public var backgroundImageFile:String;
    public var backgroundImageFileNoFrame:String;
    public var backgroundImageFileMiniFramed:String;
	
    private var actionText:FlxText;
	
	private var displayedTextList:FlxUIListModified;
    private var displayedOptions:Array<FlxButton>;
	
	private var optionIndex:Int;
	private var scrollOptionsLeftButton:FlxButton;
	private var scrollOptionsRightButton:FlxButton;
	
	public var activeDeer:Array<Deer>;
	private var deerDisplayBoxes:Array<DeerDisplay>;
	private var activeDeerScrollIndex:Int = 0;
	
	private var defended:Bool = false;
	private var eaten:Bool = false;
	
	private var starved:Bool = false;
	
	public var continueCount:Int = 0;
	
	public var dayStarted:Bool = false;

    public function new() {
		activeDeer = new Array<Deer>();
    }
	
	public function playMusic()
	{
		
	}

    public function setOut() {
		if(!dayStarted){
			dayStarted = true;
			startDay();
		}
		
		var mainState:MainGame = cast(FlxG.state, MainGame);
		mainState.updateTopBar();
		
		if(actionText == null){
			actionText = new FlxText(0, 60, 260, "Exploring", 20);
			actionText.color = FlxColor.BLACK;
			actionText.screenCenter(FlxAxes.X);
			actionText.alignment = "center";
		}
		mainState.add(actionText);
		
		var gameVariables:GameVariables = GameVariables.instance;
		
		//Check for remaining explorers
        for (i in 0...gameVariables.controlledDeer.length) {
			if (!gameVariables.controlledDeer[i].actedThisRound && gameVariables.controlledDeer[i].currentAction == "Exploring"){
				gameVariables.controlledDeer[i].actedThisRound = true;
				setActiveDeer([gameVariables.controlledDeer[i]]);
				explore(gameVariables.controlledDeer[i]);
				actionText.text = "Exploring";
				return;
			}
        }
		
		//Check for foragers
        for (i in 0...gameVariables.controlledDeer.length) {
			if (!gameVariables.controlledDeer[i].actedThisRound && gameVariables.controlledDeer[i].currentAction == "Foraging"){
				gameVariables.controlledDeer[i].actedThisRound = true;
				setActiveDeer([gameVariables.controlledDeer[i]]);
				forage(gameVariables.controlledDeer[i]);
				actionText.text = "Foraging";
				return;
			}
        }
		
		//Check for hunters
		var deerHunters:Array<Deer> = new Array();
        for (i in 0...gameVariables.controlledDeer.length) {
			if (!gameVariables.controlledDeer[i].actedThisRound && gameVariables.controlledDeer[i].currentAction == "Hunting"){
				gameVariables.controlledDeer[i].actedThisRound = true;
				deerHunters.push(gameVariables.controlledDeer[i]);
			}
        }
		
		if(deerHunters.length > 0){
			actionText.text = "Hunting";
			setActiveDeer(deerHunters);
			hunt(deerHunters);
			return;
		}
		
		//Check for defenders
		var deerDefenders:Array<Deer> = new Array();
		for (i in 0...gameVariables.controlledDeer.length) {
			if (!gameVariables.controlledDeer[i].actedThisRound && gameVariables.controlledDeer[i].currentAction == "Defending") {
				gameVariables.controlledDeer[i].actedThisRound = true;
				deerDefenders.push(gameVariables.controlledDeer[i]);
			}
        }
		
		if(!defended){
			var randomNums:FlxRandom = new FlxRandom();
			randomNums.shuffle(deerDefenders);
			
			actionText.text = "Defending";
			defended = true;
			setActiveDeer(deerDefenders);
			defend(deerDefenders);
			return;
		}
		
		//Check for resters
		var deerResters:Array<Deer> = gameVariables.getRestingDeer();
		
		if(deerResters.length > 0){
			actionText.text = "Resting";
			setActiveDeer(deerResters);
			rest(deerResters);
			return;
		}
		
		//Eat
		if(!eaten){
			actionText.text = "Eating";
			eaten = true;
			eat();
			return;
		}
		
		endDay();
    }
	
	public function startDay(){
		
	}
	
	public function endDay(){
		resetDailyVariables();
		
		//Out of food
		if (starved) {
			starved = false;
			outOfFood(GameVariables.instance.getPlayerDeer());
		}else{
			//Return
			returnAfterDayEnd();
		}
	}
	
	public function resetDailyVariables()
	{
		//Reset deer
        for (i in 0...GameVariables.instance.controlledDeer.length) {
			GameVariables.instance.controlledDeer[i].actedThisRound = false;
        }
		
		setActiveDeer([]);
		
		//Reset variables
		defended = false;
		eaten = false;
		dayStarted = false;
		GameVariables.instance.checkVariables();
		
		GameVariables.instance.advanceDay();
	}
	
	public function returnAfterDayEnd(){
		returnToDen();
	}
	
	public function outOfFood(deer:Deer){
		if(GameVariables.instance.controlledDeer.length > 1){
			showChoice(["Unable to feed the whole pack and unwilling to eat while others starve, you black out."], ["Wake up"], [wakeUp], deer);
		}else{
			showChoice(["Without enough food to last the day, you black out."], ["Wake up"], [wakeUp], deer);
		}
	}
	
	public function wakeUp(choice:String, deer:Deer) {
		if (choice == "Wake up") {
			showChoice(["You wake up in your den in the Unfamiliar Woods with a small pile of berries sitting at your side."], ["Continue on"], [wakeUp], deer);
		}else if (choice == "Continue on") {
			GameVariables.instance.currentFood = 1;
			GameVariables.instance.changeLocation("Unfamiliar Woods");
			GameVariables.instance.healAllDeer();
			returnToDen();
		}
	}
	
	public function eat() {
		var message:Array<String> = new Array<String>();
		
		var amountToEat = GameVariables.instance.controlledDeer.length + GameVariables.instance.babyDeer.length;
		if(GameVariables.instance.currentFood - amountToEat < 0){
			starved = true;
		}
		
		GameVariables.instance.modifyFood(amountToEat * -1);
		if (GameVariables.instance.controlledDeer.length > 1){
			message.push("Your pack eats away at the food stores (-" + amountToEat + " food).");
		}else{
			message.push("You eat away at your food supplies (-" + amountToEat + " food).");
		}
		
		if (starved)
		{
			message.push("But there's not enough...");
		}
		
		showResult(message);
    }
	
	public function rest(deer:Array<Deer>) {
		var result:Array<String> = new Array<String>();
		for (i in 0...deer.length) {
			var currentDeer:Deer = deer[i];
			var statusDetermined:Bool = false;
			
			if(currentDeer.health == currentDeer.maxHealth){
				result.push(currentDeer.name + " seems healthy and continues to rest.");
				statusDetermined = true;
			}
			
			currentDeer.heal(2);
			
			if(GameVariables.instance.rabbitFurBeddingMade){
				currentDeer.heal(1);
				currentDeer.addStatusEffect(new DeerStatusEffect("Lucky Bedding", 2, 0, 0, 0, 0, 1));
			}
			
			if (currentDeer.checkForStatusByName("Sleepy as a Spruce Tree"))
			{
				currentDeer.heal(2);
			}
			
			if(!statusDetermined){
				result.push(currentDeer.name + " rests and is now " + currentDeer.getStatus() + ".");
			}
		}
		
		if(GameVariables.instance.rabbitFurBeddingMade){
			result.push("(+1 health restored and +1 luck tomorrow for rested deer from rabbit fur bedding)");
		}
		
		showResult(result);
    }
	
	public function defend(deer:Array<Deer>){
		
    }

    public function explore(deer:Deer){

    }
	
	public function forage(deer:Deer){

    }
	
	public function hunt(deer:Array<Deer>){

    }

    public function showChoice(text:Array<String>, optionNames:Array<String>, resultFunction:Array < (String, Deer)->Void > , deer:Deer){
		spawnOptionButtons(text, optionNames);
		for (i in 0...displayedOptions.length){
			if (i < resultFunction.length)
			{
				displayedOptions[i].onUp.callback = choiceChosen.bind(optionNames[i], resultFunction[i], deer);
			}
			else
			{
				displayedOptions[i].onUp.callback = choiceChosen.bind(optionNames[i], resultFunction[resultFunction.length-1], deer);
			}
		}
    }
	
    public function showChoiceMultipleDeer(text:Array<String>, optionNames:Array<String>, resultFunction:Array < (String, Array<Deer>)->Void > , deer:Array<Deer>){
		spawnOptionButtons(text, optionNames);
		for (i in 0...displayedOptions.length){
			displayedOptions[i].onUp.callback = choiceChosenMultipleDeer.bind(optionNames[i], resultFunction[i], deer);
		}
    }
	
	private function spawnOptionButtons(text:Array<String>, optionNames:Array<String>){
		displayedTextList = new FlxUIListModified(40, 110, null, 400, 280);
		FlxG.state.add(displayedTextList);
		
		optionIndex = 0;
		
		for(i in 0...text.length){
			var happenedText:FlxUIText = new FlxUIText(40, 110, 400, text[i], 20);
			happenedText.color = 0xFF000000;
			displayedTextList.add(happenedText);
		}

        displayedOptions = new Array();
		for (i in 0...optionNames.length){
			displayedOptions.push(spawnButton(optionNames[i]));
			if(i != (optionNames.length - 1) || (optionNames.length%2 == 0)){
				displayedOptions[i].x += (-90) + ((i%2) * 180);
			}
			
			if(i%4 <= 1){
				displayedOptions[i].y += 100;
			}else{
				displayedOptions[i].y += 148;
			}
			
			FlxG.state.add(displayedOptions[i]);
			
			if(i >= 4){
				displayedOptions[i].visible = false;
			}
		}
		
		if(scrollOptionsLeftButton == null){
			scrollOptionsLeftButton = new FlxButton(420, 180);
			scrollOptionsLeftButton.loadGraphic("assets/images/LeftButton.png", true, 96, 60);
			scrollOptionsLeftButton.scale.set(0.6, 0.6);
			
			scrollOptionsLeftButton.screenCenter();
			scrollOptionsLeftButton.x -= 187;
			scrollOptionsLeftButton.y += 136;
			scrollOptionsLeftButton.updateHitbox();
			
			scrollOptionsLeftButton.onUp.callback = changeButtonPage.bind(-4);
			FlxG.state.add(scrollOptionsLeftButton);
		}
		
		if(scrollOptionsRightButton == null){
			scrollOptionsRightButton = new FlxButton(420, 470);
			scrollOptionsRightButton.loadGraphic("assets/images/RightButton.png", true, 96, 60);
			scrollOptionsRightButton.scale.set(0.6, 0.6);
			
			scrollOptionsRightButton.screenCenter();
			scrollOptionsRightButton.x += 223;
			scrollOptionsRightButton.y += 136;
			scrollOptionsRightButton.updateHitbox();
			
			scrollOptionsRightButton.onUp.callback = changeButtonPage.bind(4);
			FlxG.state.add(scrollOptionsRightButton);
		}
		
		updateOptionScrollButtons();
	}
	
	public function changeButtonPage(amount:Int){
		for (i in optionIndex...cast(Math.min(optionIndex + 4, displayedOptions.length), Int)){
			displayedOptions[i].visible = false;
		}
		
		optionIndex += amount;
		
		for (i in optionIndex...cast(Math.min(optionIndex + 4, displayedOptions.length), Int)){
			displayedOptions[i].visible = true;
		}
		
		updateOptionScrollButtons();
	}
	
	private function updateOptionScrollButtons(){
		if(optionIndex > 0){
			scrollOptionsLeftButton.visible = true;
		}else{
			scrollOptionsLeftButton.visible = false;
		}
		
		if(optionIndex + 4 < displayedOptions.length){
			scrollOptionsRightButton.visible = true;
		}else{
			scrollOptionsRightButton.visible = false;
		}
	}
	
	public function choiceChosen(choice:String, resultFunction:(String, Deer)->Void, deer:Deer){
		clearOptionButtons();
		resultFunction(choice, deer);
	}
	
	public function choiceChosenMultipleDeer(choice:String, resultFunction:(String, Array<Deer>)->Void, deer:Array<Deer>){
		clearOptionButtons();
		resultFunction(choice, deer);
	}
	
	private function clearOptionButtons(){
        for(i in 0...displayedOptions.length){
			FlxG.state.remove(displayedOptions[i]);
        }
		FlxG.state.remove(displayedTextList);
	}
	
	public function showResult(text:Array<String>, buttonText:String = "Continue"){
		displayedTextList = new FlxUIListModified(40, 110, null, 400, 280);
		FlxG.state.add(displayedTextList);
		
		for(i in 0...text.length){
			var happenedText:FlxUIText = new FlxUIText(40, 110, 400, text[i], 20);
			happenedText.color = 0xFF000000;
			displayedTextList.add(happenedText);
		}
		
        displayedOptions = new Array();
		displayedOptions[0] = spawnButton(buttonText);
		displayedOptions[0].y += 100;
		displayedOptions[0].onUp.callback = continueOn.bind();
		FlxG.state.add(displayedOptions[0]);
		
		optionIndex = 0;
		
		if(scrollOptionsLeftButton != null){
			updateOptionScrollButtons();
		}
	}
	
	public function continueOnChoice(choice:String, deer:Deer)
	{
		continueOn();
	}
	
	public function continueOn(?setOutAgain:Bool = true){
		clearChoicesAndEventDisplay();
		
		if (setOutAgain)
		{
			setOut();
		}
	}
	
	public function clearChoicesAndEventDisplay()
	{
		if (displayedOptions != null)
		{
			for(i in 0...displayedOptions.length){
				FlxG.state.remove(displayedOptions[i]);
			}
		}
		
		FlxG.state.remove(displayedTextList);
	}
	
	public function spawnButton(buttonText:String):FlxButton{
		var newButton:FlxButton = new FlxButton(240, 370, buttonText);
		
        newButton.scale.set(2, 2);
        newButton.updateHitbox();
        newButton.label.fieldWidth = newButton.width;
        newButton.label.alignment = "center";
        newButton.label.offset.y -= 10;
        newButton.screenCenter();
		
		return newButton;
	}
	
	public function returnToDen(){
		removeChildren();
		
		var mainState:MainGame = cast(FlxG.state, MainGame);
		mainState.updateTopBar();
		mainState.returnToMainScreen();
		mainState.remove(actionText);
		
		GameVariables.instance.saveGameData();
	}
	
	public function returnToDenChoice(choice:String, deer:Deer){
		returnToDen();
	}
	
	public function setActiveDeer(deer:Array<Deer>){
		activeDeer = deer;
		activeDeerScrollIndex = 0;
		displayActiveDeer();
	}
	
	public function addActiveDeer(deer:Array<Deer>){
		for(i in 0...deer.length){
			activeDeer.push(deer[i]);
		}
		displayActiveDeer();
	}
	
	public function displayActiveDeer(){
		if (deerDisplayBoxes == null){
			setupActiveDeerDisplay();
		}
		
		for (i in activeDeerScrollIndex ... (activeDeerScrollIndex + 3)){
			var displayBoxIndex:Int = i - activeDeerScrollIndex;
			if (i < activeDeer.length){
				deerDisplayBoxes[displayBoxIndex].updateDeer(activeDeer[i]);
				deerDisplayBoxes[displayBoxIndex].unemptyDisplay();
			}else{
				deerDisplayBoxes[displayBoxIndex].emptyDisplay();
			}
		}
		
		if(activeDeerScrollIndex > 0){
			//ShowLeftScrollButton
		}
		
		if(activeDeerScrollIndex + 3 > activeDeer.length){
			//showRightScrollButton
		}
	}
	
	public function scrollDeer(amount:Int){
		activeDeerScrollIndex += amount;
		displayActiveDeer();
	}
	
	private function setupActiveDeerDisplay(){
		deerDisplayBoxes = new Array<DeerDisplay>();
		for(i in 0...3){
			var newDisplayBox = new DeerDisplay();
			newDisplayBox.moveDisplay(3 + (159*i), 500);
			
			deerDisplayBoxes.push(newDisplayBox);
			
			FlxG.state.add(newDisplayBox);
		}
	}
	
	public function removeChildren(){
		if(deerDisplayBoxes != null){
			for (i in 0...deerDisplayBoxes.length){
				deerDisplayBoxes[i].destroyChildren();
				FlxG.state.remove(deerDisplayBoxes[i]);
			}
			deerDisplayBoxes = null;
		}
		
		if(displayedOptions != null){
			for (i in 0...displayedOptions.length){
				FlxG.state.remove(displayedOptions[i]);
			}
			displayedOptions = null;
		}
		
		if(scrollOptionsLeftButton != null){
			FlxG.state.remove(scrollOptionsLeftButton);
			scrollOptionsLeftButton = null;
		}
		
		if(scrollOptionsRightButton != null){
			FlxG.state.remove(scrollOptionsRightButton);
			scrollOptionsRightButton = null;
		}
		
		deerDisplayBoxes = null;
	}
	
	public function createItemDescriptions():Array<FlxText>{
		var gameVariables:GameVariables = GameVariables.instance;
		var texts:Array<FlxText> = new Array<FlxText>();
		
		var deerInDenText:FlxText = new FlxText(25, 140, 0, "Deer: " + gameVariables.controlledDeer.length + "/" + gameVariables.maxPackSize, 18);
		deerInDenText.color = FlxColor.BLACK;
		texts.push(deerInDenText);
		
		var kidsInDenText:FlxText = new FlxText(25, 140, 0, "Young Deer: " + gameVariables.babyDeer.length + "/" + gameVariables.maxBabyPackSize, 18);
		kidsInDenText.color = FlxColor.BLACK;
		texts.push(kidsInDenText);
		
		var bunnyFurAmount:Int = gameVariables.rabbitFur;
		if(bunnyFurAmount > 0){
			var bunnyFurText:FlxText = new FlxText(25, 140, 0, "Rabbit fur: " + Std.string(bunnyFurAmount), 18);
			bunnyFurText.color = FlxColor.BLACK;
			texts.push(bunnyFurText);
		}
		
		if(gameVariables.rabbitFurBeddingMade){
			var bunnyFurText:FlxText = new FlxText(25, 140, 0, "Bedding: Rabbit fur", 18);
			bunnyFurText.color = FlxColor.BLACK;
			texts.push(bunnyFurText);
		}
		
		return texts;
	}
}