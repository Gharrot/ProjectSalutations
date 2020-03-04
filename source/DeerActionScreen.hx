package;

import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;

class DeerActionScreen extends FlxObject{
    var deer:Deer;

	var background:FlxSprite;

	var deerCharacterSprite:FlxSprite;
    var nameText:FlxText;
    var statTexts:Array<FlxText>;
    var statNumbers:Array<FlxText>;
    
    var statusText:FlxText;
    
	var actionOptions:Array<FlxButton>;
	var actionOptionLabels:Array<FlxText>;
	
    var dismissButton:FlxButton;
    var banishButton:FlxButton;

    var xButton:FlxButton;

    public function new(deer:Deer){
        super();

        this.deer = deer;

        background = new FlxSprite(25, 25);
		background.loadGraphic("assets/images/DeerScreenBG.png", false, 128, 128);
		FlxG.state.add(background);

        setupStats();
        setupGraphics();
        setupButtons();
    }

    function close(){
		for(i in 0...5){
			FlxG.state.remove(statTexts[i]);
			FlxG.state.remove(statNumbers[i]);
		}

        for(i in 0...5){
			FlxG.state.remove(actionOptions[i]);
			FlxG.state.remove(actionOptionLabels[i]);
        }

        FlxG.state.remove(nameText);
        FlxG.state.remove(statusText);
        FlxG.state.remove(background);
        FlxG.state.remove(deerCharacterSprite);
        
        FlxG.state.remove(xButton);
		
        FlxG.state.remove(dismissButton);
        FlxG.state.remove(banishButton);

        GameVariables.instance.mainGameMenu.returnToMainScreen();
        FlxG.state.remove(this);
    }

    function setupButtons(){
        xButton = new FlxButton(400, 50);
		xButton.loadGraphic("assets/images/XButton.png", true, 64, 64);
        xButton.scale.set(0.5,0.5);
        xButton.updateHitbox();
        xButton.onUp.callback = close.bind();
        FlxG.state.add(xButton);

        var actionNames = ["Explore", "Forage", "Hunt", "Defend", "Rest"];
        var actionNameVerbs = ["Exploring", "Foraging", "Hunting", "Defending", "Resting"];
		actionOptions = new Array();
		for(i in 0...5){
			actionOptions[i] = new FlxButton(70, 350+(i*45));
			actionOptions[i].onDown.callback = actionOptionClicked.bind(actionNameVerbs[i], i);
            if(deer.currentAction == actionNameVerbs[i]){
			    actionOptions[i].loadGraphic("assets/images/CheckedCheckbox.png", false, 128, 128);
            }else{
			    actionOptions[i].loadGraphic("assets/images/Checkbox.png", true, 128, 128);
            }
			actionOptions[i].scale.set(0.3,0.3);
			actionOptions[i].updateHitbox();
			FlxG.state.add(actionOptions[i]);
		}

		actionOptionLabels = new Array();
		for(i in 0...5){
			actionOptionLabels[i] = new FlxText(115, 353+(i*45), 0, actionNames[i], 24);
			actionOptionLabels[i].color = 0xFF000000;
			FlxG.state.add(actionOptionLabels[i]);
		}
		
        dismissButton = new FlxButton(270, 455, "Dismiss");
		if(deer.player){
			dismissButton.loadGraphic("assets/images/DenButtonStatic.png", false);
			dismissButton.labelAlphas[1] = 0.6;
		}else{
			dismissButton.loadGraphic("assets/images/DenButton.png", true, 160, 56);
			dismissButton.onUp.callback = dismissDeer.bind();
		}
		dismissButton.scale.set(0.9, 0.9);
		if(deer.player){
			ButtonUtils.fixButtonText(dismissButton, 22, 7, -7, 0.6);
			dismissButton.alpha = 0.6;
		}else{
			ButtonUtils.fixButtonText(dismissButton, 22, 7, -7);
		}
        FlxG.state.add(dismissButton);
		
        banishButton = new FlxButton(270, 520, "Banish");
		if(deer.player){
			banishButton.loadGraphic("assets/images/DenButtonStatic.png", false);
			banishButton.labelAlphas[1] = 0.6;
		}else{
			banishButton.loadGraphic("assets/images/DenButton.png", true, 160, 56);
			banishButton.onUp.callback = banishDeer.bind();
		}
		banishButton.scale.set(0.9, 0.9);
		if(deer.player){
			ButtonUtils.fixButtonText(banishButton, 22, 7, -6, 0.6);
			banishButton.alpha = 0.6;
		}else{
			ButtonUtils.fixButtonText(banishButton, 22, 7, -6);
		}
        FlxG.state.add(banishButton);
    }
	
	function dismissDeer(){
		GameVariables.instance.loseControlledDeer(deer);
		close();
	}
	
	function banishDeer(){
		GameVariables.instance.banishControlledDeer(deer);
		close();
	}

    function actionOptionClicked(action:String, buttonIndex:Int){
		for(i in 0...5){
            if(i == buttonIndex){
			    actionOptions[i].loadGraphic("assets/images/CheckedCheckbox.png", false, 128, 128);
			    actionOptions[i].updateHitbox();
                deer.currentAction = action;
                statusText.text = action;
            }else{
			    actionOptions[i].loadGraphic("assets/images/Checkbox.png", true, 128, 128);
			    actionOptions[i].updateHitbox();
            }
		}
    }

    function setupGraphics(){
        deerCharacterSprite = new FlxSprite(55, 128);
        deerCharacterSprite.loadGraphic("assets/images/MaleDeerTileSprite.png", true, 190, 134);
		FlxG.state.add(deerCharacterSprite);
    }

    function setupStats(){
        var statName = ["Strength", "Resilience", "Dexterity", "Intellect", "Fortune"];
        var statValues = [deer.str, deer.res, deer.dex, deer.int, deer.lck];
        
        statTexts = new Array();
		for(i in 0...5){
			var statNameText = new FlxText(255, 120 + (i*30), 0, "...", 20);
			statNameText.color = 0xFF000000;
			statNameText.text = statName[i] + ": ";
            statTexts[i] = statNameText;
			FlxG.state.add(statNameText);
		}

        statNumbers = new Array();
		for(i in 0...5){
			var statNumber = new FlxText(410, 120 + (i*30), 0, "...", 20);
			statNumber.color = 0xFF000000;
			statNumber.text = Std.string(statValues[i]);
            statNumbers[i] = statNumber;
			FlxG.state.add(statNumber);
		}

        nameText = new FlxText(9, 9, 0, deer.name, 32);
        nameText.screenCenter();
        nameText.y = nameText.y - 240;
		nameText.color = 0xFF000000;
        FlxG.state.add(nameText);

        statusText = new FlxText(55, 260, 0, deer.currentAction, 22);
		statusText.color = 0xFF000000;
        FlxG.state.add(statusText);
    }
}