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

class PlayState extends FlxState
{
	var bgSprite:FlxSprite;
	
	var deerSprites:Array<FlxSprite>;
	var timeUntilNextSprite:Float;
	
	var newGameButton:FlxButton;
	var save1:FlxSave; 
	var save2:FlxSave;
	var save3:FlxSave;

	override public function create():Void
	{
		super.create();
		this.bgColor = 0xFFD8F6F3;
		
		bgSprite = new FlxSprite(0, 0, "assets/images/mainMenuBg.png");
		add(bgSprite);
		
		var text = new flixel.text.FlxText(0, 100, 0, "Dear\nSurvivors", 64);
		text.alignment = "center";
		text.color = 0xFF000000;
		text.screenCenter(FlxAxes.X);
		add(text);
		
		//Load save data
		save1 = new FlxSave(); 
		save2 = new FlxSave();
		save3 = new FlxSave();
		
		save1.bind("Save1");
		save2.bind("Save2");
		save3.bind("Save3");

		newGameButton = new FlxButton(0, 280, "New Game", startNewGame);
		newGameButton.screenCenter(FlxAxes.X);
		add(newGameButton);
		
		timeUntilNextSprite = 1;
		deerSprites = new Array<FlxSprite>();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		timeUntilNextSprite -= FlxG.elapsed;
		if(timeUntilNextSprite <= 0){
			var randomNums:FlxRandom = new FlxRandom();
			//4,7
			timeUntilNextSprite = randomNums.float(4, 7);
			
			var newRunningDeer:RunningDeerSprite = new RunningDeerSprite(-32, 490);
			deerSprites[deerSprites.length] = newRunningDeer;
			
			newRunningDeer.scale.set(4, 4);
			newRunningDeer.y += randomNums.int(0, 60);
			
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
				add(deerSprites[i]);
			}
		}
	}

	function startNewGame() {
		clearUpMainMenu();
		
		GameVariables.instance.save = save1;
		FlxG.switchState(new CharacterCreation());
	}
	
	function clearUpMainMenu(){
		for(i in 0...deerSprites.length){
			remove(deerSprites[i]);
		}
		deerSprites = new Array<FlxSprite>();
	}
}
