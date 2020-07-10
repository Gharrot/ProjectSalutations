package;

import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;

class ImprovementBox extends FlxObject
{
	var transparentBG:FlxSprite;
	var background:FlxSprite;
	
	var xButton:FlxButton;
	
    var questionText:FlxText;
	
	var optionDescriptions:FlxUIListModified;
	var optionButtons:FlxUIListModified;
	
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
        setupButtons();
		
		generatePossibilities();
	}
	
    public function close(){
        FlxG.state.remove(background);
        FlxG.state.remove(transparentBG);
        FlxG.state.remove(xButton);
		
        FlxG.state.remove(questionText);
		
		if(optionDescriptions != null){
			FlxG.state.remove(optionDescriptions);
		}
		
		if(optionButtons != null){
			FlxG.state.remove(optionButtons);
		}

        GameObjects.instance.mainGameMenu.returnToMainScreen();
        FlxG.state.remove(this);
    }
	
	public function confirm(){
		close();
	}

    function setupButtons(){
        xButton = new FlxButton(404, 116);
		xButton.loadGraphic("assets/images/XButton.png", true, 64, 64);
        xButton.scale.set(0.4,0.4);
        xButton.updateHitbox();
        xButton.onUp.callback = close.bind();
        FlxG.state.add(xButton);
    }

    function setupTexts(){
        questionText = new FlxText(0, 0, 360, "Improvements", 30);
        questionText.screenCenter();
        questionText.y = questionText.y - 150;
		questionText.color = 0xFF000000;
		questionText.alignment = "center";
        FlxG.state.add(questionText);
    }
	
	function generatePossibilities(){
		var gameVariables:GameVariables = GameVariables.instance;
		
		optionDescriptions = new FlxUIListModified(70, 220, null, 400, 280);
		optionButtons = new FlxUIListModified(265, 205, null, 400, 280);
		
		if(!gameVariables.rabbitFurBeddingMade){
			var furText:FlxText = new FlxText(0, 0, 200, "Rabbit fur bedding\nRabbit fur: " + gameVariables.rabbitFur + "/2", 15);
			furText.alignment = "left";
			furText.color = 0xFF000000;
			optionDescriptions.add(furText);
			
			var furButton:FlxButton = new FlxButton(0, 0, "Make");
			furButton.loadGraphic("assets/images/OctaButtonSkinny.png", true, 160, 74);
			if (gameVariables.rabbitFur >= 2)
			{
				furButton.onUp.callback = buildFurBeds.bind();
				ButtonUtils.fixButtonText(furButton, 14, 23, 0);
			}
			else
			{
				furButton.label.text = "(Missing materials)";
				ButtonUtils.fixButtonText(furButton, 8, 26, 0);
			}
			optionButtons.add(furButton);
		}
		
		FlxG.state.add(optionDescriptions);
		FlxG.state.add(optionButtons);
	}
	
	public function buildFurBeds(){
		var gameVariables:GameVariables = GameVariables.instance;
		gameVariables.rabbitFur -= 2;
		gameVariables.rabbitFurBeddingMade = true;
		
		close();
	}
}