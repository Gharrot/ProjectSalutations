package;

import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;

class PairingBox extends FlxObject
{
	var transparentBG:FlxSprite;
	var background:FlxSprite;

	var maleDeerCharacterDisplay:DeerDisplay;
	var femaleDeerCharacterDisplay:DeerDisplay;
	
	var maleDeerEmptySprite:FlxSprite;
	var femaleDeerEmptySprite:FlxSprite;
	var maleDeerEmptyText:FlxText;
	var femaleDeerEmptyText:FlxText;
	
    var questionText:FlxText;

    var confirmButton:FlxButton;
    var xButton:FlxButton;
	
	var maleLeftButton:FlxButton;
	var maleRightButton:FlxButton;
	var femaleLeftButton:FlxButton;
	var femaleRightButton:FlxButton;
	
	var noMales:Bool;
	var noFemales:Bool;
	
	var malePage:Int;
	var femalePage:Int;
	
	var maleDeer:Array<Deer>;
	var femaleDeer:Array<Deer>; 
	
	public function new(){
		super();
		
		maleDeer = GameVariables.instance.getMaleDeer();
		femaleDeer = GameVariables.instance.getFemaleDeer();
		
		malePage = 0;
		femalePage = 0;

		transparentBG = new FlxSprite(0, 0);
		transparentBG.loadGraphic("assets/images/TransparentBG.png");
		transparentBG.screenCenter();
		FlxG.state.add(transparentBG);
		
        background = new FlxSprite(0, 0);
		background.loadGraphic("assets/images/ConfirmationBox.png");
		background.screenCenter();
		FlxG.state.add(background);

        setupTexts();
        setupButtons();
		setupDeerDisplays();
		
		updateArrowButtons();
	}
	
    public function close(){
        FlxG.state.remove(background);
        FlxG.state.remove(transparentBG);
		
        FlxG.state.remove(confirmButton);
        FlxG.state.remove(xButton);
		
        FlxG.state.remove(maleLeftButton);
        FlxG.state.remove(maleRightButton);
        FlxG.state.remove(femaleLeftButton);
        FlxG.state.remove(femaleRightButton);
		
		if(noMales){
			FlxG.state.remove(maleDeerEmptySprite);
			FlxG.state.remove(maleDeerEmptyText);
		}else {
			FlxG.state.remove(maleDeerCharacterDisplay);
			maleDeerCharacterDisplay.destroyChildren();
		}
		
		if(noFemales){
			FlxG.state.remove(femaleDeerEmptySprite);
			FlxG.state.remove(femaleDeerEmptyText);
		}else{
			FlxG.state.remove(femaleDeerCharacterDisplay);
			femaleDeerCharacterDisplay.destroyChildren();
		}
		
        FlxG.state.remove(questionText);

        GameVariables.instance.mainGameMenu.returnToMainScreen();
        FlxG.state.remove(this);
    }
	
	public function confirm(){
		close();
	}
	
	function setupDeerDisplays(){
		if(maleDeer.length == 0){
			noMales = true;
			
			maleDeerEmptySprite = new FlxSprite(67, 240);
			maleDeerEmptySprite.loadGraphic("assets/images/EmptyDeerTile.png");
			FlxG.state.add(maleDeerEmptySprite);
			
			maleDeerEmptyText = new FlxText(0, 0, 360, "No available males", 13);
			maleDeerEmptyText.screenCenter();
			maleDeerEmptyText.x -= 95;
			maleDeerEmptyText.y -= 95;
			maleDeerEmptyText.color = 0xFF000000;
			maleDeerEmptyText.alignment = "center";
			FlxG.state.add(maleDeerEmptyText);
		}else{
			noMales = false;
			
			maleDeerCharacterDisplay = new DeerDisplay(maleDeer[0]);
			maleDeerCharacterDisplay.moveDisplay(67, 240);
			FlxG.state.add(maleDeerCharacterDisplay);
		}
		
		if(femaleDeer.length == 0){
			noFemales = true;
			
			femaleDeerEmptySprite = new FlxSprite(253, 240);
			femaleDeerEmptySprite.loadGraphic("assets/images/EmptyDeerTile.png");
			FlxG.state.add(femaleDeerEmptySprite);
			
			femaleDeerEmptyText = new FlxText(0, 0, 360, "No available females", 13);
			femaleDeerEmptyText.screenCenter();
			femaleDeerEmptyText.x += 90;
			femaleDeerEmptyText.y -= 95;
			femaleDeerEmptyText.color = 0xFF000000;
			femaleDeerEmptyText.alignment = "center";
			FlxG.state.add(femaleDeerEmptyText);
		}else{
			noFemales = false;
			
			femaleDeerCharacterDisplay = new DeerDisplay(femaleDeer[0]);
			femaleDeerCharacterDisplay.moveDisplay(253, 240);
			FlxG.state.add(femaleDeerCharacterDisplay);
		}
	}

    function setupButtons(){
        xButton = new FlxButton(404, 116);
		xButton.loadGraphic("assets/images/XButton.png", true, 64, 64);
        xButton.scale.set(0.4,0.4);
        xButton.updateHitbox();
        xButton.onUp.callback = close.bind();
        FlxG.state.add(xButton);
		
		confirmButton = new FlxButton(0, 460, "Breed");
		if(maleDeer.length == 0 || femaleDeer.length == 0){
			confirmButton.loadGraphic("assets/images/DenButtonStatic.png", false);
			confirmButton.labelAlphas[1] = 0.6;
		}else{
			confirmButton.loadGraphic("assets/images/DenButton.png", true, 160, 56);
			confirmButton.onUp.callback = confirm.bind();
		}
		confirmButton.scale.set(0.9, 0.9);
		if(maleDeer.length == 0 || femaleDeer.length == 0){
			ButtonUtils.fixButtonText(confirmButton, 22, 7, -7, 0.6);
			confirmButton.alpha = 0.6;
		}else{
			ButtonUtils.fixButtonText(confirmButton, 22, 7, -7);
		}
		confirmButton.screenCenter();
		confirmButton.x += 5;
		confirmButton.y = 460;
        FlxG.state.add(confirmButton); 
		
		//Selection buttons
        maleLeftButton = new FlxButton(80, 390);
		maleLeftButton.loadGraphic("assets/images/LeftButton.png", true, 96, 60);
		maleLeftButton.scale.set(0.5, 0.5);
        maleLeftButton.updateHitbox();
        FlxG.state.add(maleLeftButton);
		
		
        maleRightButton = new FlxButton(162, 390);
		maleRightButton.loadGraphic("assets/images/RightButton.png", true, 96, 60);
		maleRightButton.scale.set(0.5, 0.5);
        maleRightButton.updateHitbox();
        FlxG.state.add(maleRightButton);
		
		
        femaleLeftButton = new FlxButton(265, 390);
		femaleLeftButton.loadGraphic("assets/images/LeftButton.png", true, 96, 60);
		femaleLeftButton.scale.set(0.5, 0.5);
        femaleLeftButton.updateHitbox();
        FlxG.state.add(femaleLeftButton);
		
		
        femaleRightButton = new FlxButton(347, 390);
		femaleRightButton.loadGraphic("assets/images/RightButton.png", true, 96, 60);
		femaleRightButton.scale.set(0.5, 0.5);
        femaleRightButton.updateHitbox();
        FlxG.state.add(femaleRightButton);
		
    }

    function setupTexts(){
        questionText = new FlxText(0, 0, 360, "Choose a pairing", 30);
        questionText.screenCenter();
        questionText.y = questionText.y - 150;
		questionText.color = 0xFF000000;
		questionText.alignment = "center";
        FlxG.state.add(questionText);
    }
	
	function updateArrowButtons(){
		if(malePage == 0){
			maleLeftButton.loadGraphic("assets/images/StaticLeftButton.png");
			maleLeftButton.alpha = 0.4;
			maleLeftButton.onUp.callback = null;
		}else{
			maleLeftButton.loadGraphic("assets/images/LeftButton.png", true, 96, 60);
			maleLeftButton.alpha = 1;
			maleLeftButton.onUp.callback = scrollMaleDeer.bind(-1);
		}
		
		if(malePage >= maleDeer.length - 1){
			maleRightButton.loadGraphic("assets/images/StaticRightButton.png");
			maleRightButton.alpha = 0.4;
			maleRightButton.onUp.callback = null;
		}else{
			maleRightButton.loadGraphic("assets/images/RightButton.png", true, 96, 60);
			maleRightButton.alpha = 1;
			maleRightButton.onUp.callback = scrollMaleDeer.bind(1);
		}
		
		if(femalePage == 0){
			femaleLeftButton.loadGraphic("assets/images/StaticLeftButton.png");
			femaleLeftButton.alpha = 0.4;
			femaleLeftButton.onUp.callback = null;
		}else{
			femaleLeftButton.loadGraphic("assets/images/LeftButton.png", true, 96, 60);
			femaleLeftButton.alpha = 1;
			femaleLeftButton.onUp.callback = scrollFemaleDeer.bind(-1);
		}
		
		if(femalePage >= femaleDeer.length - 1){
			femaleRightButton.loadGraphic("assets/images/StaticRightButton.png");
			femaleRightButton.alpha = 0.4;
			femaleRightButton.onUp.callback = null;
		}else{
			femaleRightButton.loadGraphic("assets/images/RightButton.png", true, 96, 60);
			femaleRightButton.alpha = 1;
			femaleRightButton.onUp.callback = scrollFemaleDeer.bind(1);
		}
		
		
        maleLeftButton.updateHitbox();
        maleRightButton.updateHitbox();
        femaleLeftButton.updateHitbox();
        femaleRightButton.updateHitbox();
	}
	
	function scrollMaleDeer(amount:Int){
		malePage += amount;
		
		if(malePage < 0){
			malePage = 0;
		}else if (malePage >= maleDeer.length){
			malePage = maleDeer.length - 1;
		}
		
		if(maleDeer.length > 0){
			maleDeerCharacterDisplay.updateDeer(maleDeer[malePage]);
		}
		
		updateArrowButtons();
	}
	
	function scrollFemaleDeer(amount:Int){
		femalePage += amount;
		
		if(femalePage < 0){
			femalePage = 0;
		}else if (femalePage >= femaleDeer.length){
			femalePage = femaleDeer.length - 1;
		}
		
		if(femaleDeer.length > 0){
			femaleDeerCharacterDisplay.updateDeer(femaleDeer[femalePage]);
		}
		
		updateArrowButtons();
	}
}