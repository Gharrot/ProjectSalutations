package;

import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;

class ConfirmationBox extends FlxObject{
	var transparentBG:FlxSprite;
	var background:FlxSprite;
	
    public var questionText:FlxText;

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
		confirmButton.y = 440;
		confirmButton.onUp.callback = confirm.bind();
        FlxG.state.add(confirmButton);
		
        cancelButton = new FlxButton(280, 460, "Cancel");
		cancelButton.screenCenter();
		cancelButton.x += 80;
		cancelButton.y = 440;
		cancelButton.onUp.callback = close.bind();
        FlxG.state.add(cancelButton);
    }

    public function setupGraphics() {
		
    }

    public function setupTexts(){
        questionText = new FlxText(0, 0, 360, "Please confirm your action", 24);
        questionText.screenCenter();
        questionText.y = questionText.y - 160;
		questionText.color = 0xFF000000;
		questionText.alignment = "center";
        FlxG.state.add(questionText);
    }
}