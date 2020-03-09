package locations;

import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;

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
			actionText.text = "Defending";
			defended = true;
			setActiveDeer(deerDefenders);
			defend(deerDefenders);
			return;
		}
		
		//Check for resters
		var deerResters:Array<Deer> = new Array();
		for (i in 0...gameVariables.controlledDeer.length) {
			if (!gameVariables.controlledDeer[i].actedThisRound && gameVariables.controlledDeer[i].currentAction == "Resting") {
				gameVariables.controlledDeer[i].actedThisRound = true;
				deerResters.push(gameVariables.controlledDeer[i]);
			}
        }
		
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
		
		//Out of food
		if (starved) {
			starved = false;
			outOfFood(GameVariables.instance.getPlayerDeer());
		}else{
			//Return
			returnToDen();
		}
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
			var message:String = "You wake up alone in your den in the Unfamiliar Woods.";
			showChoice(["You wake up alone in your den in the Unfamiliar Woods with a small pile of berries sitting at your side."], ["Continue on"], [wakeUp], deer);
		}else if (choice == "Continue on") {
			GameVariables.instance.currentFood = 1;
			GameVariables.instance.loseAllDeer();
			GameVariables.instance.changeLocation("Unfamiliar Woods");
			returnToDen();
		}
	}
	
	public function eat() {
		var amountToEat = GameVariables.instance.controlledDeer.length;
		if(GameVariables.instance.currentFood - amountToEat < 0){
			starved = true;
		}
		
		if (GameVariables.instance.currentFood > 0) {
			GameVariables.instance.modifyFood(amountToEat * -1);
			if(GameVariables.instance.controlledDeer.length > 1){
				showResult(["Your pack eats away at the food stores (-" + amountToEat + " food)."]);
			}else{
				showResult(["You eat away at your food supplies (-" + amountToEat + " food)."]);
			}	
		}else{
			starved = true;
			continueOn();
		}
    }
	
	public function rest(deer:Array<Deer>) {
		var result:String = "";
		for (i in 0...deer.length) {
			var currentDeer:Deer = deer[i];
			if(currentDeer.health == currentDeer.maxHealth){
				result = result + currentDeer.name + " seems healthy and continues to rest.\n";
			}else{
				currentDeer.heal(2);
				result = result + currentDeer.name + " rests and is now " + currentDeer.getStatus() + ".\n";
			}
		}
		showResult([result]);
    }
	
	public function defend(deer:Array<Deer>){
		
    }

    public function explore(deer:Deer){

    }
	
	public function forage(deer:Deer){

    }
	
	public function hunt(deer:Array<Deer>){

    }

    public function showChoice(text:Array<String>, optionNames:Array<String>, resultFunction:Array<(String, Deer)->Void>, deer:Deer){
		displayedTextList = new FlxUIListModified(40, 110, null, 400, 280);
		FlxG.state.add(displayedTextList);
		
		for(i in 0...text.length){
			var happenedText:FlxUIText = new FlxUIText(40, 110, 400, text[i], 20);
			happenedText.color = 0xFF000000;
			displayedTextList.add(happenedText);
		}

        displayedOptions = new Array();
		
		for(i in 0...optionNames.length){
			displayedOptions[i] = spawnButton(optionNames[i]);
			if(i != (optionNames.length - 1) || (optionNames.length%2 == 0)){
				displayedOptions[i].x += (-90) + ((i%2) * 180);
			}
			displayedOptions[i].y += 100 + (Math.floor(i/2) * 48);
			displayedOptions[i].onUp.callback = choiceChosen.bind(optionNames[i], resultFunction[i], deer);
			FlxG.state.add(displayedOptions[i]);
		}
    }
	
	public function choiceChosen(choice:String, resultFunction:(String, Deer)->Void, deer:Deer){
        for(i in 0...displayedOptions.length){
			FlxG.state.remove(displayedOptions[i]);
        }
		FlxG.state.remove(displayedTextList);
		resultFunction(choice, deer);
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
	}
	
	public function continueOnChoice(choice:String, deer:Deer){
		continueOn();
	}
	
	public function continueOn(){
        for(i in 0...displayedOptions.length){
			FlxG.state.remove(displayedOptions[i]);
        }
		FlxG.state.remove(displayedTextList);
		setOut();
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
		}
		
		deerDisplayBoxes = null;
	}
	
	public function createItemDescriptions():Array<FlxText>{
		var texts:Array<FlxText> = new Array<FlxText>();
		return texts;
	}
}