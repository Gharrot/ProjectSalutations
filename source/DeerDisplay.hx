package;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.util.FlxColor;

class DeerDisplay extends FlxObject
{
	private static var buffedStatColor:FlxColor = 0xFF009700;
	private static var nerfedStatColor:FlxColor = 0xFFBF0020;
	
    public var deer:Deer;
	
	public var bgSprite:FlxSprite;
	public var deerSprite:FlxSprite;

    public var nameText:FlxText;
    public var statNumbers:Array<FlxText>;
	
	public var healthStatusSprite:FlxSprite;
	public var otherStatusSprites:Array<FlxSprite>;
	
	public var emptied:Bool = false;

    public function new(?deer:Deer){
        super();
        this.deer = deer;
    }
	
	public function emptyDisplay(){
        for(i in 0...5){
            statNumbers[i].visible = false;
        }
        nameText.visible = false;
        deerSprite.visible = false;
        healthStatusSprite.visible = false;
		
        for(i in 0...otherStatusSprites.length){
            otherStatusSprites[i].visible = false;
        }
		
		emptied = true;
	}
	
	public function unemptyDisplay(){
        for(i in 0...5){
            statNumbers[i].visible = true;
        }
        nameText.visible = true;
        deerSprite.visible = true;
        healthStatusSprite.visible = true;
		
        for(i in 0...otherStatusSprites.length){
            otherStatusSprites[i].visible = true;
        }
		
		emptied = false;
	}

    public function destroyChildren(){
        for(i in 0...5){
            FlxG.state.remove(statNumbers[i]);
        }
        FlxG.state.remove(nameText);
        FlxG.state.remove(deerSprite);
        FlxG.state.remove(bgSprite);
        FlxG.state.remove(healthStatusSprite);
		
		for(i in 0...otherStatusSprites.length){
            FlxG.state.remove(otherStatusSprites[i]);
        }
    }

    public function hide(){
        for(i in 0...5){
            statNumbers[i].visible = false;
        }
        nameText.visible = false;
		deerSprite.visible = false;
		bgSprite.visible = false;
		healthStatusSprite.visible = false;
		this.visible = false;
		
        for(i in 0...otherStatusSprites.length){
            otherStatusSprites[i].visible = false;
        }
    }

    public function show(){
		if(!emptied){
			for(i in 0...5){
				statNumbers[i].visible = true;
			}
			
			nameText.visible = true;
			deerSprite.visible = true;
			healthStatusSprite.visible = true;
			
			for(i in 0...otherStatusSprites.length){
				otherStatusSprites[i].visible = true;
			}
		}
			
		bgSprite.visible = true;
		this.visible = true;
    }

    public function moveDisplay(x:Int, y:Int):Void{
		if(deer == null){
			deer = Deer.getNewBlankDeer();
		}
		
		if(deerSprite == null){
			setupDeerSprite();
		}
		
        if(statNumbers == null){
            setupTexts();
        }

        this.x = x; 
        this.y = y;
		
		bgSprite.x = x;
		bgSprite.y = y;
		
		healthStatusSprite.x = x + 15;
		healthStatusSprite.y = y + 35;
		
		for(i in 0...otherStatusSprites.length){
			otherStatusSprites[i].x = x + 33 + (i*18);
			otherStatusSprites[i].y = y + 35;
		}
		
        deerSprite.x = x + 62; 
        deerSprite.y = y + 69;
		
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
			unemptyDisplay();
		}
		
        var statValues = [deer.str, deer.res, deer.dex, deer.int, deer.lck];
        var baseStatValues = [deer.baseStr, deer.baseRes, deer.baseDex, deer.baseInt, deer.baseLck];
		for(i in 0...statNumbers.length){
			statNumbers[i].text = Std.string(statValues[i]);
			
			if (statValues[i] > baseStatValues[i])
			{
				statNumbers[i].color = buffedStatColor;
			}
			else if (statValues[i] < baseStatValues[i])
			{
				statNumbers[i].color = nerfedStatColor;
			}
			else
			{
				statNumbers[i].color = 0xFF000000;
			}
		}
		
		if(deer.gender == "Male"){
			deerSprite.loadGraphic("assets/images/MaleDeer.png", true, 32, 32);
		}else{
			deerSprite.loadGraphic("assets/images/FemaleDeer.png", true, 32, 32);
		}
		
		deerSprite.animation.add("looking", [0, 1, 1, 1, 1, 2, 2, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 0, 0, 0, 0], 5, false);
		deerSprite.animation.add("monching", [5, 6, 7, 7, 7, 8, 9, 0, 0, 0, 0, 0, 0], 4, false);

		nameText.text = deer.name;
		
		healthStatusSprite.loadGraphic(deer.getHealthSpriteString());
		updateDeerStatusIcons();
	}

    public function setupTexts(){
		
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
		bgSprite = new FlxSprite(0, 0);
		bgSprite.loadGraphic(GameVariables.instance.currentLocation.backgroundImageFileMiniFramed);
		FlxG.state.add(bgSprite);
		
		healthStatusSprite = new FlxSprite(0, 0);
		healthStatusSprite.loadGraphic(deer.getHealthSpriteString());
		FlxG.state.add(healthStatusSprite);
		
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
		
		updateDeerStatusIcons();
	}
	
	public function loadBGSprite(path:String)
	{
		bgSprite.loadGraphic(path);
	}
	
	function updateDeerStatusIcons()
	{
		if (otherStatusSprites != null)
		{
			for(i in 0...otherStatusSprites.length){
				FlxG.state.remove(otherStatusSprites[i]);
			}
		}
		
		otherStatusSprites = deer.getStatusIcons();
		
        for(i in 0...otherStatusSprites.length){
            FlxG.state.add(otherStatusSprites[i]);
		}
		
		for(i in 0...otherStatusSprites.length){
			otherStatusSprites[i].x = x + 33 + (i*18);
			otherStatusSprites[i].y = y + 35;
		}
	}
}