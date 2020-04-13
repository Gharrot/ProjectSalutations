package;

import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;

class ConfirmationBox extends FlxObject{
	var transparentBG:FlxSprite;
	var background:FlxSprite;

	var deerCharacterSprite:FlxSprite;
	
    var questionText:FlxText;

    var confirmButton:FlxButton;
    var cancelButton:FlxButton;
	
	public function new(){
		super();

		transparentBG = new FlxSprite(0, 0);
		transparentBG.loadGraphic("assets/images/TransparentBG.png");
		transparentBG.screenCenter();
		FlxG.state.add(transparentBG);
		
        background = new FlxSprite(0, 0);
		background.loadGraphic("assets/images/ConfirmationBox.png");
		background.screenCenter();
		FlxG.state.add(background);

        setupTexts();
        setupGraphics();
        setupButtons();
	}
	
    public function close(){
        FlxG.state.remove(background);
        FlxG.state.remove(transparentBG);
		
        FlxG.state.remove(confirmButton);
        FlxG.state.remove(cancelButton);
		
        FlxG.state.remove(deerCharacterSprite);
		
        FlxG.state.remove(questionText);

        GameObjects.instance.mainGameMenu.returnToMainScreen();
        FlxG.state.remove(this);
    }
	
	public function confirm(){
		close();
	}

    public function setupButtons(){
        confirmButton = new FlxButton(200, 460, "Confirm");
		confirmButton.screenCenter();
		confirmButton.x -= 80;
		confirmButton.y = 460;
		confirmButton.onUp.callback = confirm.bind();
        FlxG.state.add(confirmButton);
		
        cancelButton = new FlxButton(280, 460, "Cancel");
		cancelButton.screenCenter();
		cancelButton.x += 80;
		cancelButton.y = 460;
		cancelButton.onUp.callback = close.bind();
        FlxG.state.add(cancelButton);
    }

    public function setupGraphics() {
        deerCharacterSprite = new FlxSprite(55, 128);
        deerCharacterSprite.loadGraphic("assets/images/MaleDeerTileSprite.png", true, 190, 134);
		deerCharacterSprite.screenCenter();
		FlxG.state.add(deerCharacterSprite);
    }

    public function setupTexts(){
        questionText = new FlxText(0, 0, 360, "Please confirm your action", 24);
        questionText.screenCenter();
        questionText.y = questionText.y - 175;
		questionText.color = 0xFF000000;
		questionText.alignment = "center";
        FlxG.state.add(questionText);
    }
}