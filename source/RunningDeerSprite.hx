package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.math.FlxRandom;
import flixel.FlxG;
import flixel.text.FlxText;

class RunningDeerSprite extends FlxSprite
{
	private var actionTime:Float;
	
	private var running:Bool = false;
	private var runningSpeed:Float = 50;
	
	private var looking:Bool = false;
	private var monching:Bool = false;
	
	public var nameText:FlxText;
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		var randomNums:FlxRandom = new FlxRandom();
		actionTime = randomNums.float(2, 5);
		running = true;
		
		runningSpeed = randomNums.float(60, 80);
		
		if (randomNums.bool())
		{
			loadGraphic("assets/images/FemaleDeer.png", true, 32, 32);
		}
		else
		{
			loadGraphic("assets/images/MaleDeer.png", true, 32, 32);
		}
		animation.add("running", [10, 11, 12, 13, 14], 8, true);
		animation.add("looking", [0, 1, 1, 1, 1, 2, 2, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 0, 0, 0, 0], 5, true);
		animation.add("monching", [5, 6, 7, 7, 7, 8, 9, 0, 0, 0, 0, 0, 0,], 4, true);
		
		animation.play("running");
	}
	
	override public function update(elapsed:Float) {
		super.update(elapsed);
		
		actionTime -= elapsed;
		
		if(actionTime <= 0){
			chooseNewAction();
		}
		
		if(running){
			x += runningSpeed * elapsed;
		}
		
		if(nameText != null){
			nameText.x = x - 65;
			nameText.y = y - 80;
		}
	}
	
	public function chooseNewAction(){
		var randomNums:FlxRandom = new FlxRandom();
		var actionNum = randomNums.int(0, 3);
		
		running = false;
		looking = false;
		monching = false;
		
		if(actionNum == 0 || actionNum == 3){
			//Running
			actionTime = randomNums.float(3, 6);
			running = true;
			animation.play("running");
			runningSpeed += randomNums.float(-5, 5);
		}else if(actionNum == 1){
			//Looking
			actionTime = randomNums.float(3, 4);
			looking = true;
			animation.play("looking");
		}else if(actionNum == 2){
			//Monching
			actionTime = randomNums.float(2, 3);
			monching = true;
			animation.play("monching");
		}
	}
	
	public function giveNameText(nameString:String){
		nameText = new FlxText(0, 0, 160, nameString, 14);
		nameText.alignment = "center";
		nameText.color = 0xFF000000;
		FlxG.state.add(nameText);
		
		nameText.x = x - 65;
		nameText.y = y - 65;
	}
	
	public function refreshNameText(){
		FlxG.state.remove(nameText);
		FlxG.state.add(nameText);
	}
}