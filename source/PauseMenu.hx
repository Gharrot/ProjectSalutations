package;

import flixel.FlxState;
import flixel.FlxSubState;
import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxAxes;
import locations.Location;

class PauseMenu extends FlxSubState
{
	var textBG:FlxSprite;
	
	var title:FlxText;
	
	var tutorialButton:FlxButton;
	var saveAndQuitButton:FlxButton;
	var unpauseButton:FlxButton;

	override public function create():Void
	{
		super.create();
		this.bgColor = 0xFFD8F6F3;
		
		textBG = new FlxSprite(0, 0, "assets/images/tutorialBG.png");
		add(textBG);
		textBG.screenCenter();
		
		title = new flixel.text.FlxText(50, 0, 0, "Paused", 32);
		title.color = 0xFF000000;
		title.alignment = FlxTextAlign.CENTER;
		
		add(title);
		title.screenCenter();
		title.y = 70;
		
		tutorialButton = new FlxButton(370, 425, "Tutorial", returnToGame);
		tutorialButton.loadGraphic("assets/images/DenButton.png", true, 160, 56);
		ButtonUtils.fixButtonText(tutorialButton, 24, 9, 1);
		tutorialButton.screenCenter(FlxAxes.X);
		tutorialButton.x += 90;
		add(tutorialButton);
		
		saveAndQuitButton = new FlxButton(370, 425, "Save & Quit", saveAndQuit);
		saveAndQuitButton.loadGraphic("assets/images/DenButton.png", true, 160, 56);
		ButtonUtils.fixButtonText(saveAndQuitButton, 20, 12, 1);
		saveAndQuitButton.screenCenter(FlxAxes.X);
		saveAndQuitButton.x -= 90;
		add(saveAndQuitButton);
		
		unpauseButton = new FlxButton(370, 500, "Unpause", returnToGame);
		unpauseButton.loadGraphic("assets/images/DenButton.png", true, 160, 56);
		ButtonUtils.fixButtonText(unpauseButton, 24, 9, 2);
		unpauseButton.screenCenter(FlxAxes.X);
		add(unpauseButton);
	}
	
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (FlxG.keys.justPressed.ESCAPE || FlxG.mouse.justReleasedRight)
		{
			returnToGame();
		}
	}
	
	private function saveAndQuit()
	{
		close();
		
		GameVariables.instance.saveGameData();
		
		FlxG.switchState(new PlayState());
	}
	
	private function returnToGame()
	{
		close();
	}
}
