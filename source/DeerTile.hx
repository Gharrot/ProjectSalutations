package;

import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.FlxG;

class DeerTile extends FlxButton{
    public var deer:Deer;

    public var statusText:FlxText;
    public var nameText:FlxText;
    public var statTexts:Array<FlxText>;
    public var statNumbers:Array<FlxText>;

    public var selected:Bool;

    public function new(deer:Deer){
        super();
        this.deer = deer;
        selected = false;

        this.onOver.callback = onHoverOver;
        this.onOut.callback = onHoverOut;
    }

    public function destroyChildren(){
        for(i in 0...5){
            FlxG.state.remove(statTexts[i]);
            FlxG.state.remove(statNumbers[i]);
        }
        FlxG.state.remove(nameText);
        FlxG.state.remove(statusText);
    }

    public function hide(){
        for(i in 0...5){
            statTexts[i].visible = false;
            statNumbers[i].visible = false;
        }
        nameText.visible = false;
        statusText.visible = false;
		this.visible = false;
    }

    public function show(){
        for(i in 0...5){
            statNumbers[i].visible = true;
        }
        nameText.visible = true;
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
		statusText.text = deer.currentAction;
	}

    public function setupTexts() {
		if(deer == null){
			deer = Deer.getNewBlankDeer();
		}
		
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