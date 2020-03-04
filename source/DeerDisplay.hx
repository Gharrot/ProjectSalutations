package;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.input.mouse.FlxMouseEventManager;

class DeerDisplay extends FlxObject
{
    public var deer:Deer;
	
	public var deerSprite:FlxSprite;

    public var nameText:FlxText;
    public var statNumbers:Array<FlxText>;

    public function new(deer:Deer){
        super();
        this.deer = deer;
    }

    public function destroyChildren(){
        for(i in 0...5){
            FlxG.state.remove(statNumbers[i]);
        }
        FlxG.state.remove(nameText);
        FlxG.state.remove(deerSprite);
    }

    public function hide(){
        for(i in 0...5){
            statNumbers[i].visible = false;
        }
        nameText.visible = false;
		deerSprite.visible = false;
		this.visible = false;
    }

    public function show(){
        for(i in 0...5){
            statNumbers[i].visible = true;
        }
        nameText.visible = true;
		deerSprite.visible = true;
		this.visible = true;
    }

    public function moveDisplay(x:Int, y:Int):Void{
		if(deerSprite == null){
			setupDeerSprite();
		}
		
        if(statNumbers == null){
            setupTexts();
        }

        this.x = x; 
        this.y = y;
		
        deerSprite.x = x; 
        deerSprite.y = y;
		
		for(i in 0...5){
            statNumbers[i].x = x + 28 + (i*21);
            statNumbers[i].y = y + 108;
		}

        nameText.x = x + 12;
        nameText.y = y + 13;
		nameText.alignment = "center";
    }
	
	public function updateDeer(?newDeer:Deer) {
		if(newDeer != null){
			deer = newDeer;
		}
		
        var statValues = [deer.str, deer.res, deer.dex, deer.int, deer.lck];
		for(i in 0...statNumbers.length){
			statNumbers[i].text = Std.string(statValues[i]);
		}

		nameText.text = deer.name;
	}

    public function setupTexts() {
		if(deer == null){
			deer = Deer.getNewBlankDeer();
		}
		
        var statValues = [deer.str, deer.res, deer.dex, deer.int, deer.lck];
		
        statNumbers = new Array();
		for(i in 0...5){
			var statNumber = new FlxText(0, 0, 0, "...", 14);
			statNumber.color = 0xFF000000;
			statNumber.text = Std.string(statValues[i]);
            statNumbers[i] = statNumber;
			FlxG.state.add(statNumber);
		}

        nameText = new FlxText(0, 0, 132, deer.name, 14);
		nameText.color = 0xFF000000;
		nameText.alignment = "center";
        FlxG.state.add(nameText);
    }
	
	function setupDeerSprite(){
		deerSprite = new FlxSprite(0, 0);
		deerSprite.loadGraphic("assets/images/MaleSprite.png");
		FlxG.state.add(deerSprite);
	}
}