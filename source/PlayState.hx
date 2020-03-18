package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import org.flixel.*;
import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.math.FlxRandom;

class PlayState extends FlxState
{
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
		
		var text = new flixel.text.FlxText(0, 0, 0, "Salutations", 64);
		text.color = 0xFF000000;
		text.screenCenter();
		add(text);
		
		//Load save data
		save1 = new FlxSave(); 
		save2 = new FlxSave();
		save3 = new FlxSave();
		
		save1.bind("Save1");
		save2.bind("Save2");
		save3.bind("Save3");

		newGameButton = new FlxButton(0, 0, "New Game", startNewGame);
		newGameButton.screenCenter();
		newGameButton.y += 80;
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
			timeUntilNextSprite = randomNums.float(4, 7);
			
			var newRunningDeer:RunningDeerSprite = new RunningDeerSprite(-32, 600);
			deerSprites[deerSprites.length] = newRunningDeer;
			
			newRunningDeer.scale.set(4, 4);
			newRunningDeer.y += randomNums.int(0, 10);
			
			add(newRunningDeer);
			
			var i:Int = deerSprites.length - 1;
			while(i >= 0){
				if(deerSprites[i].x >= 680){
					remove(deerSprites[i]);
					deerSprites.remove(deerSprites[i]);
				}
				
				i--;
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
