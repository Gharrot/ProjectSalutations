package;

import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.FlxG;

class DeerTile extends FlxButton{
    public var deer:Deer;

    public var statusText:FlxText;
    public var nameText:FlxText;
    public var statTexts:Array<FlxText>;
    public var statNumbers:Array<FlxText>;
	
	public var healthStatusSprite:FlxSprite;

	public var bgSprite:FlxSprite;
	public var deerSprite:FlxSprite;
	
	public var actionTime:Float;
	
    public var selected:Bool;

    public function new(deer:Deer){
        super();
        this.deer = deer;
        selected = false;

        this.onOver.callback = onHoverOver;
        this.onOut.callback = onHoverOut;
		
		var randomNums:FlxRandom = new FlxRandom();
		actionTime = randomNums.float(1, 7);
    }
	
	override public function update(elapsed:Float){
		super.update(elapsed);
		if(deerSprite != null){
			actionTime -= elapsed;
			if (actionTime <= 0){
				playNewDeerAction();
			}
		}
	}
	
	private function playNewDeerAction(){
		var randomNums:FlxRandom = new FlxRandom();
		var actionNum = randomNums.int(0, 1);
		
		if(actionNum == 0){
			//Looking
			actionTime = randomNums.float(5, 8);
			deerSprite.animation.play("looking");
		}else if(actionNum == 1){
			//Monching
			actionTime = randomNums.float(2, 8);
			deerSprite.animation.play("monching");
		}
	}

    public function destroyChildren(){
        for(i in 0...5){
            FlxG.state.remove(statTexts[i]);
            FlxG.state.remove(statNumbers[i]);
        }
        FlxG.state.remove(nameText);
        FlxG.state.remove(statusText);
        FlxG.state.remove(bgSprite);
        FlxG.state.remove(healthStatusSprite);
        FlxG.state.remove(deerSprite);
    }

    public function hide(){
        for(i in 0...5){
            statTexts[i].visible = false;
            statNumbers[i].visible = false;
        }
        nameText.visible = false;
        statusText.visible = false;
		deerSprite.visible = false;
		bgSprite.visible = false;
		healthStatusSprite.visible = false;
		this.visible = false;
    }

    public function show(){
        for(i in 0...5){
            statNumbers[i].visible = true;
        }
        nameText.visible = true;
		deerSprite.visible = true;
		bgSprite.visible = true;
		healthStatusSprite.visible = true;
		this.visible = true;
    }

    private function onHoverOver(){
        for(i in 0...5){
            statTexts[i].visible = true;
		}
        statusText.visible = true;
    }

    private function onHoverOut(){
        for(i in 0...5){
            statTexts[i].visible = false;
		}
        statusText.visible = false;
    }

    public function moveDisplay(x:Int, y:Int):Void{
		if(deer == null){
			deer = Deer.getNewBlankDeer();
		}
		
		if(bgSprite == null){
			setupBgSprite();
		}
		
		if(healthStatusSprite == null){
			setupHealthSprite();
		}
		
		if(deerSprite == null){
			setupDeerSprite();
		}
		
        if(statTexts == null){
            setupTexts();
        }
		
        this.x = x; 
        this.y = y;
        for(i in 0...5){
            statTexts[i].x = x + 112;
            statTexts[i].y = y + 16 + (i*20);
		}
        for(i in 0...5){
            statNumbers[i].x = x + 158;
            statNumbers[i].y = y + 16 + (i*20);
		}

        nameText.x = x + 10;
        nameText.y = y + 10;

        statusText.x = x + 10;
        statusText.y = y + 104;
		
		bgSprite.x = x + 10;
		bgSprite.y = y + 10;
		
		healthStatusSprite.x = x + 15;
		healthStatusSprite.y = y + 33;
		
		deerSprite.x = x + 79;
		deerSprite.y = y + 74;
    }
	
	public function updateDeer(?newDeer:Deer) {
		if(newDeer != null){
			deer = newDeer;
		}
		
        var statValues = [deer.str, deer.res, deer.dex, deer.int, deer.lck];
		for(i in 0...statNumbers.length){
			statNumbers[i].text = Std.string(statValues[i]);
		}
		
		if(deer.gender == "Male"){
			deerSprite.loadGraphic("assets/images/MaleDeer.png", true, 32, 32);
		}else{
			deerSprite.loadGraphic("assets/images/FemaleDeer.png", true, 32, 32);
		}
		
		deerSprite.animation.add("looking", [0, 1, 1, 1, 1, 2, 2, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 0, 0, 0, 0], 5, false);
		deerSprite.animation.add("monching", [5, 6, 7, 7, 7, 8, 9, 0, 0, 0, 0, 0, 0], 4, false);

		nameText.text = deer.name;
		statusText.text = deer.currentAction;
		
		bgSprite.loadGraphic(GameVariables.instance.currentLocation.backgroundImageFileNoFrame);
		healthStatusSprite.loadGraphic(deer.getHealthSpriteString());
	}
	
	public function setupBgSprite(){
		bgSprite = new FlxSprite(0, 0);
		bgSprite.loadGraphic(GameVariables.instance.currentLocation.backgroundImageFileNoFrame);
		FlxG.state.add(bgSprite);
	}
	
	public function setupHealthSprite(){
		healthStatusSprite = new FlxSprite(0, 0);
		healthStatusSprite.loadGraphic(deer.getHealthSpriteString());
		FlxG.state.add(healthStatusSprite);
	}
	
	public function setupDeerSprite(){
		deerSprite = new FlxSprite(0, 0);
		
		if(deer.gender == "Male"){
			deerSprite.loadGraphic("assets/images/MaleDeer.png", true, 32, 32);
		}else{
			deerSprite.loadGraphic("assets/images/FemaleDeer.png", true, 32, 32);
		}
		
		deerSprite.animation.add("looking", [0, 1, 1, 1, 1, 2, 2, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 0, 0, 0, 0], 5, false);
		deerSprite.animation.add("monching", [5, 6, 7, 7, 7, 8, 9, 0, 0, 0, 0, 0, 0], 4, false);
		
		deerSprite.scale.set(2, 2);
		FlxG.state.add(deerSprite);
	}

    public function setupTexts() {
        var statName = ["Str", "Res", "Dex", "Int", "For"];
        var statValues = [deer.str, deer.res, deer.dex, deer.int, deer.lck];
        
        statTexts = new Array();
		for(i in 0...5){
			var statNameText = new FlxText(0, 0, 0, "...", 14);
			statNameText.color = 0xFF000000;
			statNameText.text = statName[i] + ": ";
            statTexts[i] = statNameText;
			FlxG.state.add(statNameText);
            statTexts[i].visible = false;
		}

        statNumbers = new Array();
		for(i in 0...5){
			var statNumber = new FlxText(0, 0, 0, "...", 14);
			statNumber.color = 0xFF000000;
			statNumber.text = Std.string(statValues[i]);
            statNumbers[i] = statNumber;
			FlxG.state.add(statNumber);
		}

        nameText = new FlxText(9, 9, 0, deer.name, 14);
		nameText.color = 0xFF000000;
        FlxG.state.add(nameText);

        statusText = new FlxText(9, 9, 0, deer.currentAction, 14);
		statusText.color = 0xFF000000;
        statusText.visible = false;
        FlxG.state.add(statusText);
    }
}