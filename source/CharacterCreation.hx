package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.FlxSprite;
import flixel.addons.ui.FlxInputText;
import flixel.text.FlxText;
import flixel.util.FlxAxes;
import locations.Location;

class CharacterCreation extends FlxState
{
	var bgSprite:FlxSprite;
	
	var gender:String;
	var maleButton:FlxButton;
	var femaleButton:FlxButton;

	var nameBox:FlxInputText;

	var characterDisplay:DeerDisplay;

	var statPointsRemaining:Int = 6;
	var maxStatValue:Int = 5;

	var plusButtons:Array<FlxButton>;
	var statTexts:Array<FlxText>;
	var minusButtons:Array<FlxButton>;
	var pointsRemainingText:FlxText;
	
	var startButton:FlxButton;

	override public function create():Void
	{
		super.create();
		this.bgColor = 0xFFD8F6F3;
		
		bgSprite = new FlxSprite(0, 0, "assets/images/CharacterCreationBG.png");
		add(bgSprite);

		var titleText = new FlxText(0, 0, 0, "Create your Character", 30);
		titleText.color = 0xFF000000;
		titleText.screenCenter();
		titleText.y = 30;
		add(titleText);

		nameBox = new FlxInputText(26,240,154, "Name", 16);
		add(nameBox);

		characterDisplay = new DeerDisplay();
		characterDisplay.moveDisplay(25, 90);
		add(characterDisplay);

		setupGenderButtons();
		if(FlxG.random.bool(50)){
			maleClicked(false);
			nameBox.text = NameGenerator.getRandomName("Male");
		}else{
			femaleClicked(false);
			nameBox.text = NameGenerator.getRandomName("Female");
		}

		setupStats();

		startButton = new FlxButton(370, 520, "Begin", startGame);
		startButton.loadGraphic("assets/images/OctaButton.png", true, 160, 74);
		ButtonUtils.fixButtonText(startButton, 22, 18, 3);
		startButton.screenCenter(FlxAxes.X);
		add(startButton);
		
		updateDeer();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		while(nameBox.text.length >= 13){
			nameBox.text = nameBox.text.substring(0, nameBox.text.length - 1);
			nameBox.caretIndex = nameBox.text.length;
		}
		
		if(characterDisplay.nameText.text != nameBox.text){
			characterDisplay.nameText.text = nameBox.text;
		}
	}
	
	private function updateDeer(){
		var currentDeer:Deer = new Deer(nameBox.text, gender, Std.parseInt(statTexts[0].text), 
										Std.parseInt(statTexts[1].text), Std.parseInt(statTexts[2].text),
										Std.parseInt(statTexts[3].text), Std.parseInt(statTexts[4].text), 
										true);
		characterDisplay.updateDeer(currentDeer);
	}

	private function startGame(){
		GameVariables.instance.addDeer(new Deer(nameBox.text, gender, Std.parseInt(statTexts[0].text), 
										Std.parseInt(statTexts[1].text), Std.parseInt(statTexts[2].text),
										Std.parseInt(statTexts[3].text), Std.parseInt(statTexts[4].text), 
										true));
		FlxG.switchState(new MainGame());
	}

	private function setupStats(){
		plusButtons = new Array();
		for(i in 0...5){
			plusButtons[i] = new FlxButton(428, 90+(i*30));
			plusButtons[i].onDown.callback = plusClicked.bind(i);
			plusButtons[i].loadGraphic("assets/images/PlusButton.png", true, 32, 32);
			plusButtons[i].scale.set(0.7,0.7);
			plusButtons[i].updateHitbox();
			add(plusButtons[i]);
		}

		minusButtons = new Array();
		for(i in 0...5){
			minusButtons[i] = new FlxButton(368, 90+(i*30));
			minusButtons[i].onDown.callback = minusClicked.bind(i);
			minusButtons[i].loadGraphic("assets/images/MinusButton.png", true, 32, 32);
			minusButtons[i].scale.set(0.7,0.7);
			minusButtons[i].updateHitbox();
			add(minusButtons[i]);
		}

		statTexts = new Array();
		for(i in 0...5){
			statTexts[i] = new FlxText(400, 86+(i*30), 0, "2", 20);
			statTexts[i].color = 0xFF000000;
			add(statTexts[i]);
		}

		var statName = ["Strength", "Resilience", "Dexterity", "Intellect", "Fortune"];
		for(i in 0...5){
			var statNameText = new FlxText(200, 86+(i*30), 0, "...", 20);
			statNameText.color = 0xFF000000;
			statNameText.text = statName[i];
			add(statNameText);
		}

		pointsRemainingText = new FlxText(200, 236, 0, "Points remaining: " + statPointsRemaining, 20);
		pointsRemainingText.color = 0xFF000000;
		add(pointsRemainingText);
	}

	private function plusClicked(stat:Int){
		if(statPointsRemaining > 0 && Std.parseInt(statTexts[stat].text) < maxStatValue){
			statTexts[stat].text = Std.string(Std.parseInt(statTexts[stat].text)+1);
			statPointsRemaining--;
			pointsRemainingText.text = "Points remaining: " + statPointsRemaining;
		}
		updateDeer();
	}

	private function minusClicked(stat:Int){
		if(Std.parseInt(statTexts[stat].text) > 0){
			statTexts[stat].text = Std.string(Std.parseInt(statTexts[stat].text)-1);
			statPointsRemaining++;
			pointsRemainingText.text = "Points remaining: " + statPointsRemaining;
		}
		updateDeer();
	}
	
	private function setupGenderButtons(){
		var maleText = new flixel.text.FlxText(50, 280, 0, "Male", 16);
		maleText.color = 0xFF000000;
		add(maleText);
		
		var femaleText = new flixel.text.FlxText(50, 310, 0, "Female", 16);
		femaleText.color = 0xFF000000;
		add(femaleText);

        maleButton = new FlxButton(25, 280, "");
        maleButton.loadGraphic("assets/images/Checkbox.png", true, 128, 128);
        add(maleButton);
		maleButton.onUp.callback = maleClicked.bind();
		maleButton.scale.set(0.17, 0.17);
		maleButton.updateHitbox();

		femaleButton = new FlxButton(25, 310, "");
        femaleButton.loadGraphic("assets/images/Checkbox.png", true, 128, 128);
        add(femaleButton);
		femaleButton.onUp.callback = femaleClicked.bind();
		femaleButton.scale.set(0.17,0.17);
		femaleButton.updateHitbox();
	}

	private function maleClicked(?updateDeerDisplay:Bool = true){
		gender = "Male";
		maleButton.loadGraphic("assets/images/CheckedCheckbox.png", false, 128, 128);
        femaleButton.loadGraphic("assets/images/Checkbox.png", true, 128, 128);
		
		maleButton.updateHitbox();
		femaleButton.updateHitbox();
		
		if(updateDeerDisplay){
			updateDeer();
		}
	}

	private function femaleClicked(?updateDeerDisplay:Bool = true){
		gender = "Female";
		femaleButton.loadGraphic("assets/images/CheckedCheckbox.png", false, 128, 128);
        maleButton.loadGraphic("assets/images/Checkbox.png", true, 128, 128);
		
		maleButton.updateHitbox();
		femaleButton.updateHitbox();
		
		if(updateDeerDisplay){
			updateDeer();
		}
	}

}
