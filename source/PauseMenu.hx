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
	
	var musicVolText:FlxText;
	var musicVolAmount:FlxText;
	var musicVolIncreaseButton:FlxButton;
	var musicVolDecreaseButton:FlxButton;
	
	var sfxVolText:FlxText;
	var sfxVolAmount:FlxText;
	var sfxVolIncreaseButton:FlxButton;
	var sfxVolDecreaseButton:FlxButton;
	
	var tutorialButton:FlxButton;
	var saveAndQuitButton:FlxButton;
	var unpauseButton:FlxButton;
	
	var infiniteFoodText:FlxText;
	var infiniteFoodToggle:FlxButton;

	override public function create():Void
	{
		super.create();
		
		textBG = new FlxSprite(0, 0, "assets/images/tutorialBG.png");
		add(textBG);
		textBG.screenCenter();
		
		title = new flixel.text.FlxText(50, 0, 0, "Paused", 32);
		title.color = 0xFF000000;
		title.alignment = FlxTextAlign.CENTER;
		add(title);
		title.screenCenter();
		title.y = 70;
		
		setupVolumeControls();
		setupButtons();
	}
	
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (FlxG.keys.justPressed.ESCAPE || FlxG.mouse.justReleasedRight)
		{
			returnToGame();
		}
	}
	
	public function setupVolumeControls()
	{
		musicVolText = new flixel.text.FlxText(26, 0, 0, "Music Volume", 26);
		musicVolText.color = 0xFF000000;
		musicVolText.alignment = FlxTextAlign.CENTER;
		add(musicVolText);
		musicVolText.screenCenter();
		musicVolText.y = 154;
		
		musicVolAmount = new flixel.text.FlxText(26, 0, 0, "100", 22);
		musicVolAmount.color = 0xFF000000;
		musicVolAmount.alignment = FlxTextAlign.CENTER;
		add(musicVolAmount);
		musicVolAmount.screenCenter();
		musicVolAmount.y = 200;
		
		musicVolIncreaseButton = new FlxButton(272, 199);
		musicVolIncreaseButton.onDown.callback = modifyMusicVolumeLevel.bind(5);
		musicVolIncreaseButton.loadGraphic("assets/images/PlusButton.png", true, 32, 32);
		musicVolIncreaseButton.screenCenter(FlxAxes.X);
		musicVolIncreaseButton.x += 50;
		musicVolIncreaseButton.updateHitbox();
		add(musicVolIncreaseButton);
		
		musicVolDecreaseButton = new FlxButton(272, 199);
		musicVolDecreaseButton.onDown.callback = modifyMusicVolumeLevel.bind(-5);
		musicVolDecreaseButton.loadGraphic("assets/images/MinusButton.png", true, 32, 32);
		musicVolDecreaseButton.screenCenter(FlxAxes.X);
		musicVolDecreaseButton.x -= 50;
		musicVolDecreaseButton.updateHitbox();
		add(musicVolDecreaseButton);
		
		var sfxOffset:Int = 100;
		
		sfxVolText = new flixel.text.FlxText(26, 0, 0, "SFX Volume", 26);
		sfxVolText.color = 0xFF000000;
		sfxVolText.alignment = FlxTextAlign.CENTER;
		add(sfxVolText);
		sfxVolText.screenCenter();
		sfxVolText.y = 154 + sfxOffset;
		
		sfxVolAmount = new flixel.text.FlxText(26, 0, 0, "100", 22);
		sfxVolAmount.color = 0xFF000000;
		sfxVolAmount.alignment = FlxTextAlign.CENTER;
		add(sfxVolAmount);
		sfxVolAmount.screenCenter();
		sfxVolAmount.y = 200 + sfxOffset;
		
		sfxVolIncreaseButton = new FlxButton(272, 199 + sfxOffset);
		sfxVolIncreaseButton.onDown.callback = modifySFXVolumeLevel.bind(5);
		sfxVolIncreaseButton.loadGraphic("assets/images/PlusButton.png", true, 32, 32);
		sfxVolIncreaseButton.screenCenter(FlxAxes.X);
		sfxVolIncreaseButton.x += 50;
		sfxVolIncreaseButton.updateHitbox();
		add(sfxVolIncreaseButton);
		
		sfxVolDecreaseButton = new FlxButton(272, 199 + sfxOffset);
		sfxVolDecreaseButton.onDown.callback = modifySFXVolumeLevel.bind(-5);
		sfxVolDecreaseButton.loadGraphic("assets/images/MinusButton.png", true, 32, 32);
		sfxVolDecreaseButton.screenCenter(FlxAxes.X);
		sfxVolDecreaseButton.x -= 50;
		sfxVolDecreaseButton.updateHitbox();
		add(sfxVolDecreaseButton);
	}
	
	public function modifyMusicVolumeLevel(amount:Int)
	{
		
	}
	
	public function modifySFXVolumeLevel(amount:Int)
	{
		
	}
	
	public function setupButtons()
	{
		tutorialButton = new FlxButton(370, 415, "Tutorial", viewTutorial);
		tutorialButton.loadGraphic("assets/images/DenButton.png", true, 160, 56);
		ButtonUtils.fixButtonText(tutorialButton, 24, 9, 1);
		tutorialButton.screenCenter(FlxAxes.X);
		tutorialButton.x += 90;
		add(tutorialButton);
		
		saveAndQuitButton = new FlxButton(370, 415, "Save/Quit", saveAndQuit);
		saveAndQuitButton.loadGraphic("assets/images/DenButton.png", true, 160, 56);
		ButtonUtils.fixButtonText(saveAndQuitButton, 24, 10, 1);
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
			infiniteFoodToggle.loadGraphic("assets/images/CheckedCheckboxAnimated.png", true, 128, 128);
			infiniteFoodToggle.updateHitbox();
		}
		else
		{
			infiniteFoodToggle.loadGraphic("assets/images/Checkbox.png", true, 128, 128);
			infiniteFoodToggle.updateHitbox();
		}
	}
	
	private function viewTutorial()
	{
		var tutorial = new TutorialSubState();
		var color = FlxG.state.bgColor;
		
		openSubState(tutorial);
		tutorial.bgColor = color;
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
