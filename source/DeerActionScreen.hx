package;

import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.FlxAxes;

class DeerActionScreen extends FlxObject{
    var deer:Deer;

	var transparentBG:FlxSprite;
	var background:FlxSprite;

	var deerCharacterSprite:DeerTile;
    var nameText:FlxText;
    var statTexts:Array<FlxText>;
    var statNumbers:Array<FlxText>;
    
	var healthStatusText:FlxText;
	
    var statusText:FlxText;
	
	var renamingBox:DeerRenamingBox;
    
	var actionOptions:Array<FlxButton>;
	var actionOptionLabels:Array<FlxText>;
	
    var renameButton:FlxButton;
    var dismissButton:FlxButton;
    var banishButton:FlxButton;

    var xButton:FlxButton;
	
	var hidden:Bool = false;

    public function new(deer:Deer){
        super();

        this.deer = deer;
		
		transparentBG = new FlxSprite(0, 0);
		transparentBG.loadGraphic("assets/images/TransparentBG.png");
		transparentBG.screenCenter();
		FlxG.state.add(transparentBG);

        background = new FlxSprite(25, 25);
		background.loadGraphic("assets/images/DeerScreenBG.png", false, 128, 128);
		FlxG.state.add(background);

        setupStats();
        setupGraphics();
        setupButtons();
		
		hidden = false;
    }
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		if (!hidden)
		{
			if (FlxG.keys.justPressed.E)
			{
				actionOptionClicked("Exploring", 0);
			}
			else if (FlxG.keys.justPressed.F)
			{
				actionOptionClicked("Foraging", 1);
			}
			else if (FlxG.keys.justPressed.H)
			{
				actionOptionClicked("Hunting", 2);
			}
			else if (FlxG.keys.justPressed.D)
			{
				actionOptionClicked("Defending", 3);
			}
			else if (FlxG.keys.justPressed.R)
			{
				actionOptionClicked("Resting", 4);
			}
			
			if (FlxG.mouse.justReleasedRight)
			{
				close();
			}
		}
	}

    public function close()
	{
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
        FlxG.state.remove(healthStatusText);
        FlxG.state.remove(background);
        FlxG.state.remove(transparentBG);
		deerCharacterSprite.destroyChildren();
        FlxG.state.remove(deerCharacterSprite);
        
        FlxG.state.remove(xButton);
		
        FlxG.state.remove(renameButton);
        FlxG.state.remove(dismissButton);
        FlxG.state.remove(banishButton);
		
        FlxG.state.remove(renamingBox);

        GameObjects.instance.mainGameMenu.returnToMainScreen();
        FlxG.state.remove(this);
    }
	
	public function hide()
	{
		for(i in 0...5){
			statTexts[i].visible = false;
			statNumbers[i].visible = false;
		}

        for(i in 0...5){
			actionOptions[i].visible = false;
			actionOptionLabels[i].visible = false;
        }

        nameText.visible = false;
        statusText.visible = false;
        healthStatusText.visible = false;
        background.visible = false;
        transparentBG.visible = false;
		
		deerCharacterSprite.hide();
        deerCharacterSprite.visible = false;
        
        xButton.visible = false;
		
		renameButton.visible = false;
        dismissButton.visible = false;
        banishButton.visible = false;
		
		hidden = true;
	}
	
	public function show()
	{
		for(i in 0...5){
			statTexts[i].visible = true;
			statNumbers[i].visible = true;
		}

        for(i in 0...5){
			actionOptions[i].visible = true;
			actionOptionLabels[i].visible = true;
        }

        nameText.visible = true;
        statusText.visible = true;
        healthStatusText.visible = true;
        background.visible = true;
        transparentBG.visible = true;
		
		deerCharacterSprite.show();
        deerCharacterSprite.visible = true;
        deerCharacterSprite.deerDisplayOnlyMode();
        
        xButton.visible = true;
		
		renameButton.visible = true;
        dismissButton.visible = true;
        banishButton.visible = true;
		
		hidden = false;
	}

    function setupButtons()
	{
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
			actionOptions[i] = new FlxButton(70, 355+(i*45));
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
			actionOptionLabels[i] = new FlxText(115, 358+(i*45), 0, actionNames[i], 24);
			actionOptionLabels[i].color = 0xFF000000;
			FlxG.state.add(actionOptionLabels[i]);
		}
		
		renameButton = new FlxButton(270, 400, "Rename");
		renameButton.loadGraphic("assets/images/DenButton.png", true, 160, 56);
		renameButton.onUp.callback = renameDeer.bind();
		renameButton.scale.set(0.9, 0.9);
		ButtonUtils.fixButtonText(renameButton, 22, 7, -7);
        FlxG.state.add(renameButton);
		
        dismissButton = new FlxButton(270, 460, "Dismiss");
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
	
	function renameDeer()
	{
		hide();
		
		renamingBox = new DeerRenamingBox(deer, this);
		FlxG.state.add(renamingBox);
	}
	
	function dismissDeer()
	{
		GameVariables.instance.loseControlledDeer(deer);
		close();
	}
	
	function banishDeer()
	{
		GameVariables.instance.banishControlledDeer(deer);
		close();
	}
	
	public function updateName()
	{
        FlxG.state.remove(nameText);
		
		nameText = new FlxText(9, 9, 0, deer.name, 32);
        nameText.screenCenter();
        nameText.y = nameText.y - 240;
		nameText.color = 0xFF000000;
        FlxG.state.insert(FlxG.state.length, nameText);
		nameText.visible = true;
		
        deerCharacterSprite.deerDisplayOnlyMode();
	}

    function actionOptionClicked(action:String, buttonIndex:Int)
	{
		//If the deer has no health, it must rest
		if (deer.health <= 0)
		{
			return;
		}
		
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

    function setupGraphics()
	{
        deerCharacterSprite = new DeerTile(deer);
        deerCharacterSprite.moveDisplay(55, 128);
        deerCharacterSprite.deerDisplayOnlyMode();
		FlxG.state.add(deerCharacterSprite);
    }

    function setupStats()
	{
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

        statusText = new FlxText(55, 310, 400, deer.currentAction, 22);
		statusText.color = 0xFF000000;
		statusText.alignment = "center";
		statusText.screenCenter(FlxAxes.X);
        FlxG.state.add(statusText);
		
		if (deer.health <= 0)
		{
			statusText.text = "Resting (Injured)";
		}
		
		healthStatusText = new FlxText(55, 265, 0, deer.getHealthStatus(), 22);
		healthStatusText.color = 0xFF000000;
        FlxG.state.add(healthStatusText);
    }
}