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

class PlayState extends FlxState
{
	var bgSprite:FlxSprite;
	var upperBgSprite:FlxSprite;
	
	var deerSprites:Array<RunningDeerSprite>;
	var timeUntilNextSprite:Float;
	
	var startGameButton:FlxButton;
	
	var creditsButton:FlxButton;
	var credits:Array<String>;
	var creditsIndex:Int;
	var playingCredits:Bool;
	
	var newGameButton:FlxButton;
	
	var saves:Array<FlxSave>;
	var saveSprites:Array<DeerDisplay>;
	var saveStartButtons:Array<FlxButton>;
	
	var rising:Bool;
	var cameraScrollSpeed:Float = 10;
	var cameraScrollMaxSpeed:Float = 300;
	var cameraScrollAcceleration:Float = 180;
	var cameraMaxY:Float = 140;
	
	var saveToStart:Int = 0;

	override public function create()
	{
		super.create();
		this.bgColor = 0xFFD8F6F3;
		
		bgSprite = new FlxSprite(0, 0, "assets/images/mainMenuBg.png");
		add(bgSprite);
		
		upperBgSprite = new FlxSprite(0, -640, "assets/images/CharacterCreationBG.png");
		add(upperBgSprite);
		
		var text = new flixel.text.FlxText(0, 70, 0, "Dear\nSurvivors", 64);
		text.alignment = "center";
		text.color = 0xFF000000;
		text.screenCenter(FlxAxes.X);
		add(text);
		
		//Load save data
		saves = new Array<FlxSave>();
		saveSprites = new Array<DeerDisplay>();
		saveStartButtons = new Array<FlxButton>();
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
			}else{
				saveStartButton.onUp.callback = startNewGame.bind(i);
				saveDeerDisplay.emptyDisplay();
			}
			
			saveDeerDisplay.hide();
			
			saveStartButtons.push(saveStartButton);
			add(saveStartButton);
			saveStartButton.visible = false;
		}

		newGameButton = new FlxButton(0, 290, "Continue", showSaves);
		newGameButton.screenCenter(FlxAxes.X);
		add(newGameButton);
		
		creditsButton = new FlxButton(0, 340, "Credits", startCredits);
		creditsButton.screenCenter(FlxAxes.X);
		add(creditsButton);
		
		timeUntilNextSprite = 1;
		deerSprites = new Array<RunningDeerSprite>();
		
		rising = false;
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (rising)
		{
			if(cameraScrollSpeed < cameraScrollMaxSpeed){
				cameraScrollSpeed += cameraScrollAcceleration*elapsed;
				if(cameraScrollSpeed > cameraScrollMaxSpeed){
					cameraScrollSpeed = cameraScrollMaxSpeed;
				}
			}
			
			camera.scroll.y -= cameraScrollSpeed * elapsed;
			
			if(camera.scroll.y <= -640){
				camera.scroll.y = -640;
				rising = false;
				switchToCharacterCreation();
			}
		}
		else
		{
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
				}
			}
		}
	}

	function showSaves(){
		clearFirstButtons();
		for(i in 0...3){
			saveStartButtons[i].visible = true;
			
			saveSprites[i].show();
		}
	}
	
	function startNewGame(saveNum:Int){
		clearSavesButtons();
		saveToStart = saveNum;
		
		rising = true;
	}
	
	function continueGame(saveNum:Int){
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
	}
	
	function clearSavesButtons(){
		for(i in 0...3){
			remove(saveStartButtons[i]);
		}
	}
	
	function switchToCharacterCreation(){
		GameVariables.instance.saveNum = saveToStart;
		FlxG.switchState(new CharacterCreation());
	}
	
	function startCredits(){
		credits = new Array<String>();
		credits.push("Coding & Art\nLuc Bouchard (Gharry/Gharrot)");
		credits.push("Deer Sprites & Animations\nCalciumtrice");
		
		remove(creditsButton);
		creditsIndex = 0;
		playingCredits = true;
		
		if(timeUntilNextSprite > 2){
			timeUntilNextSprite = 2;
		}
	}
}
