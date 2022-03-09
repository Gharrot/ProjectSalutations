package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import org.flixel.*;
import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.math.FlxRandom;
import flixel.util.FlxSort;
import flixel.util.FlxAxes;
import haxe.ds.ArraySort;
import haxe.Serializer;
import haxe.Unserializer;
import sound.SoundManager;
import flixel.FlxSubState;

class PlayState extends FlxState
{
	var bgSprite:FlxSprite;
	var upperBgSprite:FlxSprite;
	
	var deerSprites:Array<RunningDeerSprite>;
	var timeUntilNextSprite:Float;
	
	var startGameButton:FlxButton;
	
	var settingsButton:FlxButton;
	
	var creditsButton:FlxButton;
	var credits:Array<String>;
	var creditsIndex:Int;
	var playingCredits:Bool;
	
	var newGameButton:FlxButton;
	
	var saves:Array<FlxSave>;
	var saveSprites:Array<DeerDisplay>;
	var saveStartButtons:Array<FlxButton>;
	var saveDeleteButtons:Array<FlxButton>;
	
	var showDeleteButton:FlxButton;
	
	var saveToStart:Int = 0;
	
	var settingsMenuState:SettingsMenu;
	
	public var paused = false;

	override public function create()
	{
		super.create();
		this.bgColor = 0xFFD8F6F3;
		
		SoundManager.instance.setBackgroundSong("MainMenu");
		
		bgSprite = new FlxSprite(0, 0, "assets/images/mainMenuBg.png");
		add(bgSprite);
		
		upperBgSprite = new FlxSprite(0, -640, "assets/images/CharacterCreationBG.png");
		add(upperBgSprite);
		
		var text = new flixel.text.FlxText(0, 70, 0, "Deer\nSurvivors", 64);
		text.alignment = "center";
		text.color = 0xFF000000;
		text.screenCenter(FlxAxes.X);
		add(text);
		
		//Load save data
		saves = new Array<FlxSave>();
		saveSprites = new Array<DeerDisplay>();
		saveStartButtons = new Array<FlxButton>();
		saveDeleteButtons = new Array<FlxButton>();
		for(i in 0...3){
			saves.push(new FlxSave());
			saves[i].bind("Save" + i);
			
			var saveDeerDisplay = new DeerDisplay();
			saveDeerDisplay.moveDisplay(3 + (159 * i), 260);
			
			saveSprites.push(saveDeerDisplay);
			add(saveDeerDisplay);
			
			var saveStartButton = new FlxButton(41 + (159 * i), 410, "New Game");
			if(saves[i].data.controlledDeer != null){
				saveStartButton.label.text = "Continue";
				saveStartButton.onUp.callback = continueGame.bind(i);
				saveDeerDisplay.updateDeer(saves[i].data.controlledDeer[0]);
				
				//get delete button ready
				var saveDeleteButton = new FlxButton(41 + (159 * i), 435, "Delete Save");
				saveDeleteButton.onUp.callback = deleteSave.bind(i, saveDeleteButton);
				saveDeleteButtons.push(saveDeleteButton);
				
				//set background for save display
				saveDeerDisplay.loadBGSprite(GameVariables.getLocationByName(saves[i].data.currentLocationName).backgroundImageFileMiniFramed);
				
			}else{
				saveStartButton.onUp.callback = startNewGame.bind(i);
				saveDeerDisplay.emptyDisplay();
			}
			
			saveDeerDisplay.hide();
			
			saveStartButtons.push(saveStartButton);
			add(saveStartButton);
			saveStartButton.visible = false;
		}
		
		showDeleteButton = new FlxButton(330, 590, "Show Delete Buttons", showDeleteSaveButtons);
		showDeleteButton.scale.set(1.5, 1.4);
        showDeleteButton.updateHitbox();
        showDeleteButton.label.offset.y -= 4;
        showDeleteButton.label.fieldWidth = showDeleteButton.width;
        showDeleteButton.label.alignment = "center";
		showDeleteButton.visible = false;

		newGameButton = new FlxButton(0, 270, "- Begin -", showSaves);
		newGameButton.loadGraphic("assets/images/DeerTileSprites/HealthMarkerTransparent.png");
		add(newGameButton);
		newGameButton.scale.set(12, 2.5);
		ButtonUtils.fixButtonText(newGameButton, 30, 0, 0);
        newGameButton.label.fieldWidth = newGameButton.width;
		newGameButton.screenCenter(FlxAxes.X);
		newGameButton.label.color = 0xFF000000;
		newGameButton.onOver.callback = buttonHoverOver.bind(newGameButton);
		newGameButton.onOut.callback = buttonHoverOut.bind(newGameButton);
		
		settingsButton = new FlxButton(0, 325, "- Settings -", showSettings);
		settingsButton.loadGraphic("assets/images/DeerTileSprites/HealthMarkerTransparent.png");
		add(settingsButton);
		settingsButton.scale.set(10, 2);
		ButtonUtils.fixButtonText(settingsButton, 20, 0, 0);
        settingsButton.label.fieldWidth = settingsButton.width;
		settingsButton.screenCenter(FlxAxes.X);
		settingsButton.label.color = 0xFF000000;
		settingsButton.onOver.callback = buttonHoverOver.bind(settingsButton);
		settingsButton.onOut.callback = buttonHoverOut.bind(settingsButton);
		
		creditsButton = new FlxButton(0, 360, "- Credits -", startCredits);
		creditsButton.loadGraphic("assets/images/DeerTileSprites/HealthMarkerTransparent.png");
		add(creditsButton);
		creditsButton.scale.set(10, 2);
		ButtonUtils.fixButtonText(creditsButton, 20, 0, 0);
        creditsButton.label.fieldWidth = creditsButton.width;
		creditsButton.screenCenter(FlxAxes.X);
		creditsButton.label.color = 0xFF000000;
		creditsButton.onOver.callback = buttonHoverOver.bind(creditsButton);
		creditsButton.onOut.callback = buttonHoverOut.bind(creditsButton);
		
		timeUntilNextSprite = 1;
		deerSprites = new Array<RunningDeerSprite>();
		
		destroySubStates = false;
		persistentUpdate = true;
		settingsMenuState = new SettingsMenu();
		settingsMenuState.makerState = this;
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		
		SoundManager.instance.initializeSoundManager();
		
		timeUntilNextSprite -= FlxG.elapsed;
		if(timeUntilNextSprite <= 0){
			var randomNums:FlxRandom = new FlxRandom();
			//4,7
			timeUntilNextSprite = randomNums.float(4, 7);
			
			var newRunningDeer:RunningDeerSprite = new RunningDeerSprite(-64, 490);
			deerSprites[deerSprites.length] = newRunningDeer;
			
			newRunningDeer.scale.set(4, 4);
			newRunningDeer.y += randomNums.int(0, 60);
			
			if(playingCredits){
				if(creditsIndex >= credits.length){
					creditsIndex = 0;
				}
				
				newRunningDeer.giveNameText(credits[creditsIndex]);
				creditsIndex++;
			}
			add(newRunningDeer);
			
			//remove offscreen deer
			var i:Int = deerSprites.length - 1;
			while(i >= 0){
				if(deerSprites[i].x >= 680){
					remove(deerSprites[i]);
					deerSprites.remove(deerSprites[i]);
				}
				
				i--;
			}
			
			//remove and re-add deer in right order
			haxe.ds.ArraySort.sort(deerSprites, function (a:FlxSprite, b:FlxSprite) return cast(a.y - b.y, Int));
			for(i in 0...deerSprites.length){
				remove(deerSprites[i]);
			}
			
			for(i in 0...deerSprites.length){
				deerSprites[i].refreshNameText();
				add(deerSprites[i]);
				remove(deerSprites[i]);
				insert(this.length, deerSprites[i]);
			}
			
			if (showDeleteButton != null && saveDeleteButtons.length > 0){
				remove(showDeleteButton);
				insert(this.length, showDeleteButton);
			}
		}
	}
	
	public function showSettings()
	{
		openSubState(settingsMenuState);
		paused = true;
	}

	function showSaves(){
		if (paused)
		{
			return;
		}
		
		clearFirstButtons();
		for(i in 0...3){
			saveStartButtons[i].visible = true;
			
			saveSprites[i].show();
		}
		
		playingCredits = false;
		
		if(saveDeleteButtons.length != 0){
			add(showDeleteButton);
			showDeleteButton.visible = true;
		}
	}
	
	function startNewGame(saveNum:Int){
		for(i in 0...3){
			saves[i].close();
		}
		clearSavesButtons();
		saveToStart = saveNum;
		
		showDeleteButton.visible = false;
		
		FlxG.camera.fade(0xFFD8F6F3, 0.5, false, switchToCharacterCreation);
	}
	
	function continueGame(saveNum:Int){
		for(i in 0...3){
			saves[i].close();
		}
		GameVariables.instance.saveNum = saveNum;
		GameVariables.instance.loadFromSave();
		FlxG.switchState(new MainGame());
	}
	
	function clearDeer(){
		for(i in 0...deerSprites.length){
			remove(deerSprites[i]);
		}
		deerSprites = new Array<RunningDeerSprite>();
	}
	
	function clearFirstButtons(){
		remove(newGameButton);
		remove(creditsButton);
		remove(settingsButton);
	}
	
	function clearSavesButtons(){
		for(i in 0...3){
			remove(saveStartButtons[i]);
		}
		
		for(i in 0...saveDeleteButtons.length){
			remove(saveDeleteButtons[i]);
		}
	}
	
	function switchToCharacterCreation(){
		GameVariables.instance.initialize();
		GameVariables.instance.saveNum = saveToStart;
		FlxG.switchState(new Tutorial());
	}
	
	function startCredits()
	{
		if (paused)
		{
			return;
		}
		
		credits = new Array<String>();
		credits.push("Coding & Art\nPajamaBee");
		credits.push("Deer Sprites & Animations\nCalciumtrice");
		
		remove(creditsButton);
		creditsIndex = 0;
		playingCredits = true;
		
		if(timeUntilNextSprite > 2){
			timeUntilNextSprite = 2;
		}
	}
	
	function showDeleteSaveButtons(){
		for(i in 0...saveDeleteButtons.length){
			add(saveDeleteButtons[i]);
		}
		
		showDeleteButton.onUp.callback = hideDeleteSaveButtons.bind();
		showDeleteButton.label.text = "Hide Delete Buttons";
	}
	
	function hideDeleteSaveButtons(){
		for(i in 0...saveDeleteButtons.length){
			remove(saveDeleteButtons[i]);
		}
		
		showDeleteButton.onUp.callback = showDeleteSaveButtons.bind();
		showDeleteButton.label.text = "Show Delete Buttons";
	}
	
	function deleteSave(saveNum:Int, deleteSaveButton:FlxButton){
		saves[saveNum].erase();
		saves[saveNum].bind("Save" + saveNum);
		
		saveSprites[saveNum].emptyDisplay();
		saveStartButtons[saveNum].label.text = "New Game";
		saveStartButtons[saveNum].onUp.callback = startNewGame.bind(saveNum);
		
		remove(deleteSaveButton);
		saveDeleteButtons.remove(deleteSaveButton);
		
		if(saveDeleteButtons.length == 0){
			remove(showDeleteButton);
		}
	}
	
	function buttonHoverOver(button:FlxButton)
	{
		button.label.alpha = 0.8;
	}
	
	function buttonHoverOut(button:FlxButton)
	{
		button.label.alpha = 1;
	}
}
