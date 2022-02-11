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
	
	var infiniteFoodText:FlxText;
	var infiniteFoodToggle:FlxButton;

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
		
		tutorialButton = new FlxButton(370, 415, "Tutorial", returnToGame);
		tutorialButton.loadGraphic("assets/images/DenButton.png", true, 160, 56);
		ButtonUtils.fixButtonText(tutorialButton, 24, 9, 1);
		tutorialButton.screenCenter(FlxAxes.X);
		tutorialButton.x += 90;
		add(tutorialButton);
		
		saveAndQuitButton = new FlxButton(370, 415, "Save & Quit", saveAndQuit);
		saveAndQuitButton.loadGraphic("assets/images/DenButton.png", true, 160, 56);
		ButtonUtils.fixButtonText(saveAndQuitButton, 20, 12, 1);
		saveAndQuitButton.screenCenter(FlxAxes.X);
		saveAndQuitButton.x -= 90;
		add(saveAndQuitButton);
		
		unpauseButton = new FlxButton(370, 485, "Unpause", returnToGame);
		unpauseButton.loadGraphic("assets/images/DenButton.png", true, 160, 56);
		ButtonUtils.fixButtonText(unpauseButton, 24, 9, 2);
		unpauseButton.screenCenter(FlxAxes.X);
		add(unpauseButton);
		
		infiniteFoodText = new flixel.text.FlxText(50, 0, 0, "Infinite Food", 20);
		infiniteFoodText.color = 0xFF000000;
		infiniteFoodText.alignment = FlxTextAlign.CENTER;
		add(infiniteFoodText);
		infiniteFoodText.screenCenter();
		infiniteFoodText.y = 555;
		infiniteFoodText.x += 13;

        infiniteFoodToggle = new FlxButton(25, 557, "");
        infiniteFoodToggle.loadGraphic("assets/images/Checkbox.png", true, 128, 128);
		infiniteFoodToggle.onUp.callback = toggleInfiniteFood.bind();
		infiniteFoodToggle.scale.set(0.18, 0.18);
		infiniteFoodToggle.screenCenter(FlxAxes.X);
		infiniteFoodToggle.x -= 37;
		infiniteFoodToggle.updateHitbox();
        add(infiniteFoodToggle);
		
		updateInfiniteFoodToggle();
	}
	
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (FlxG.keys.justPressed.ESCAPE || FlxG.mouse.justReleasedRight)
		{
			returnToGame();
		}
	}
	
	private function toggleInfiniteFood()
	{
		if (GameVariables.instance.infiniteFood)
		{
			GameVariables.instance.infiniteFood = false;
			updateInfiniteFoodToggle();
		}
		else
		{
			GameVariables.instance.infiniteFood = true;
			updateInfiniteFoodToggle();
		}
	}
	
	private function updateInfiniteFoodToggle()
	{
		if (GameVariables.instance.infiniteFood)
		{
			infiniteFoodToggle.loadGraphic("assets/images/Checkbox.png", true, 128, 128);
			infiniteFoodToggle.updateHitbox();
		}
		else
		{
			infiniteFoodToggle.loadGraphic("assets/images/CheckedCheckboxAnimated.png", true, 128, 128);
			infiniteFoodToggle.updateHitbox();
		}
	}
	
	private function viewTutorial()
	{
		
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
