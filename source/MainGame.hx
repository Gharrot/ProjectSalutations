package;

import flixel.FlxG;
import org.flixel.*;
import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.util.FlxAxes;

class MainGame extends FlxState
{
    var dateText:FlxText;
    var foodText:FlxText;

    var currentScreen:String;
    
	var setOutDisabledText:FlxText;
    var continueButton:FlxButton;

	var deerTilePage:Int;
    var deerTiles:Array<DeerTile>;
    var locationSprites:Array<FlxSprite>;
	var deerLeftButton:FlxButton;
	var deerRightButton:FlxButton;
	
	var mapSprites:Array<FlxSprite>;
	var mapButtons:Array<FlxButton>;
	var travelConfirmation:TravelConfirmationBox;
	
    var babyDeerTiles:Array<BabyDeerTile>;
    var babyLocationSprites:Array<FlxSprite>;
    var itemDescriptions:Array<FlxText>;
    var interactButton:FlxButton;
    var improveButton:FlxButton;
    var breedButton:FlxButton;
	var improvementBox:ImprovementBox;
	var pairingBox:PairingBox;

    var herdButton:FlxButton;
    var mapButton:FlxButton;
    var denButton:FlxButton;

	override public function create()
	{
		super.create();
		this.bgColor = 0xFFD8F6F3;

        GameObjects.instance.mainGameMenu = this;

        setupTopBar();
        setupDeerTiles();
		setupMap();
		setupDen();
        setupOtherButtons();
		updateContinueButton();

        herdButton.loadGraphic("assets/images/HerdButtonSelected.png", false);
        currentScreen = "Setup";
		herdClicked();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}

    public function returnToMainScreen() {
		GameVariables.instance.prepareDeer();
		updateDeerTiles();
		setupMap();
		setupDen();
		
		updateTopBar();
		
        herdButton.visible = true;
        mapButton.visible = true;
        denButton.visible = true;
		
		updateContinueButton();
        continueButton.visible = true;
		
        if (currentScreen == "Herd") {
			currentScreen = "Transition";
            herdClicked();
        }else if(currentScreen == "Map"){
			currentScreen = "Transition";
			mapClicked();
		}else if(currentScreen == "Den"){
			currentScreen = "Transition";
			denClicked();
		}
    }

    public function hide(){
        hideHerd();
		removeDen();
		removeMap();

        herdButton.visible = false;
        mapButton.visible = false;
        denButton.visible = false;
        continueButton.visible = false;
		
		if(setOutDisabledText != null){
			setOutDisabledText.visible = false;
		}
    }
	
	public function updateContinueButton(){
		if(continueButton == null){
			continueButton = new FlxButton(118, 568, "Set Out");
			ButtonUtils.fixButtonText(continueButton, 30, 18, -2);
			add(continueButton);
		}
		
		var ableToContinue:Bool = true;
		
		if(GameVariables.instance.controlledDeer.length > GameVariables.instance.maxPackSize){
			ableToContinue = false;
		}
		
		if(ableToContinue){
			continueButton.loadGraphic("assets/images/PassTimeButton.png", true, 244, 72);
			continueButton.alpha = 1;
			ButtonUtils.setAlphas(continueButton);
			
			if(setOutDisabledText != null){
				setOutDisabledText.visible = false;
			}
			
			continueButton.onUp.callback = continueClicked;
		}
		else
		{
			if(setOutDisabledText == null){
				setOutDisabledText = new FlxText(0, 525, 360, "You can only control " + GameVariables.instance.maxPackSize + " deer at a time. \nDismiss or banish some to continue.", 13);
				setOutDisabledText.screenCenter();
				setOutDisabledText.y = 530;
				setOutDisabledText.color = 0xFF000000;
				setOutDisabledText.alignment = "center";
				FlxG.state.add(setOutDisabledText);
			}
			else
			{
				setOutDisabledText.visible = true;
			}
			
			continueButton.loadGraphic("assets/images/PassTimeButtonStatic.png", false);
			continueButton.alpha = 0.6;
			ButtonUtils.setAlphas(continueButton, 0.6);
			
			continueButton.onUp.callback = null;
		}
	}

    function deerTileClicked(deer:Deer){
        add(new DeerActionScreen(deer));
        hide();
    }

    function removeHerd(){
		for(i in 0...deerTiles.length){
			deerTiles[i].destroyChildren();
			remove(deerTiles[i]);
		}
		deerTiles = new Array();

		for(i in 0...locationSprites.length){
			remove(locationSprites[i]);
		}
		locationSprites = new Array();
		
		remove(deerLeftButton);
		remove(deerRightButton);
    }
	
	function removeDen(){
		for(i in 0...babyDeerTiles.length){
			babyDeerTiles[i].destroyChildren();
			remove(babyDeerTiles[i]);
		}
		babyDeerTiles = new Array();

		for(i in 0...babyLocationSprites.length){
			remove(babyLocationSprites[i]);
		}
		babyLocationSprites = new Array();
		
		remove(interactButton);
		remove(improveButton);
		remove(breedButton);
		
		for(i in 0...itemDescriptions.length){
			remove(itemDescriptions[i]);
		}
		itemDescriptions = new Array();
    }

    function hideHerd(){
		for(i in 0...deerTiles.length){
			deerTiles[i].visible = false;
			deerTiles[i].hide();
		}

		for(i in 0...locationSprites.length){
			locationSprites[i].visible = false;
		}
		
		deerLeftButton.visible = false;
		deerRightButton.visible = false;
    }

    function showHerd(){
        if (currentScreen == "Herd") {
			updateDeerTiles();
        }
    }

    function herdClicked(){
        if(currentScreen != "Herd"){
			hideMap();
			hideDen();
            currentScreen = "Herd";

            herdButton.loadGraphic("assets/images/HerdButtonSelected.png", false);
            denButton.loadGraphic("assets/images/StatusButton.png", true, 160, 69);
            mapButton.loadGraphic("assets/images/MapButton.png", true, 160, 69);

            showHerd();
        }
    }

    function mapClicked(){
        if(currentScreen != "Map"){
            hideHerd();
			hideDen();
            currentScreen = "Map";

            mapButton.loadGraphic("assets/images/MapButtonSelected.png", false);
            herdButton.loadGraphic("assets/images/HerdButton.png", true, 160, 69);
            denButton.loadGraphic("assets/images/StatusButton.png", true, 160, 69);
			
			showMap();
        }
    }

    function denClicked(){
        if(currentScreen != "Den"){
            hideHerd();
			hideMap();
            currentScreen = "Den";

            denButton.loadGraphic("assets/images/StatusButtonSelected.png", false);
            herdButton.loadGraphic("assets/images/HerdButton.png", true, 160, 69);
            mapButton.loadGraphic("assets/images/MapButton.png", true, 160, 69);
			
			showDen();
        }
    }
	
	function setupDen(){
		setupBabyDeerTiles();
		
		//den items
		itemDescriptions = GameVariables.instance.currentLocation.createItemDescriptions();
		for(i in 0...itemDescriptions.length){
			add(itemDescriptions[i]);
			itemDescriptions[i].y = 140 + (30 * i);
		}
		
		//den buttons
		interactButton = new FlxButton(290, 140, "Interact");
        interactButton.loadGraphic("assets/images/DenButton.png", true, 160, 56);
        interactButton.updateHitbox();
        interactButton.label.size = 22;
        interactButton.label.color = 0xFF000000;
        interactButton.label.alignment = "center";
        for(offsets in interactButton.labelOffsets){
            offsets.y += 10;
        }
        interactButton.label.alpha = 1.0;
        interactButton.labelAlphas[0] = 1.0;
        interactButton.labelAlphas[2] = 1.0;
        //add(interactButton);
		
		improveButton = new FlxButton(290, 140, "Improve");
        improveButton.loadGraphic("assets/images/DenButton.png", true, 160, 56);
        improveButton.updateHitbox();
        improveButton.label.size = 22;
        improveButton.label.color = 0xFF000000;
        improveButton.label.alignment = "center";
        for(offsets in improveButton.labelOffsets){
            offsets.y += 10;
        }
        improveButton.label.alpha = 1.0;
        improveButton.labelAlphas[0] = 1.0;
        improveButton.labelAlphas[2] = 1.0;
		improveButton.onUp.callback = improvementMenu.bind();
        add(improveButton);
		
		breedButton = new FlxButton(290, 216, "Breeding");
        breedButton.loadGraphic("assets/images/DenButton.png", true, 160, 56);
        breedButton.updateHitbox();
        breedButton.label.size = 22;
        breedButton.label.color = 0xFF000000;
        breedButton.label.alignment = "center";
        for(offsets in breedButton.labelOffsets){
            offsets.y += 10;
        }
        breedButton.label.alpha = 1.0;
        breedButton.labelAlphas[0] = 1.0;
        breedButton.labelAlphas[2] = 1.0;
		breedButton.onUp.callback = pairingMenu.bind();
        add(breedButton);
	}
	
	function showDen(){
		for(i in 0...babyDeerTiles.length){
			babyDeerTiles[i].visible = true;
			babyDeerTiles[i].show();
		}

		for(i in 0...babyLocationSprites.length){
			babyLocationSprites[i].visible = true;
		}
		
		interactButton.visible = true;
		improveButton.visible = true;
		breedButton.visible = true;
		
		for(i in 0...itemDescriptions.length){
			itemDescriptions[i].visible = true;
		}
	}
	
	function hideDen(){
		for(i in 0...babyDeerTiles.length){
			babyDeerTiles[i].visible = false;
			babyDeerTiles[i].hide();
		}

		for(i in 0...babyLocationSprites.length){
			babyLocationSprites[i].visible = false;
		}
		
		interactButton.visible = false;
		improveButton.visible = false;
		breedButton.visible = false;
		
		for(i in 0...itemDescriptions.length){
			itemDescriptions[i].visible = false;
		}
    }
	
	function setupBabyDeerTiles(){
		babyDeerTiles = new Array<BabyDeerTile>();
		babyLocationSprites = new Array<FlxSprite>();
		for (i in 0...2) {
			if(GameVariables.instance.babyDeer.length > i){
				var babyDeerTile:BabyDeerTile = new BabyDeerTile(GameVariables.instance.babyDeer[i]);
				add(babyDeerTile);
				babyDeerTile.loadGraphic("assets/images/MaleDeerTileSprite.png", true, 190, 134);
				babyDeerTile.moveDisplay(30 + ((i%2)*225), 390);
				babyDeerTiles.push(babyDeerTile);
			}else{
				var locationSprite:FlxSprite = new FlxSprite(30 + ((i%2)*225), 390);
				add(locationSprite);
				locationSprite.loadGraphic(GameVariables.instance.currentLocation.backgroundImageFile, true, 190, 134);
				babyLocationSprites.push(locationSprite);
			}
		}
	}

    function continueClicked(){
        hide();

        GameVariables.instance.currentLocation.setOut();
    }

    function setupOtherButtons(){
        herdButton = new FlxButton(0, 25, "Herd", herdClicked);
        herdButton.loadGraphic("assets/images/HerdButton.png", true, 160, 69);
        herdButton.updateHitbox();
        herdButton.label.size = 30;
        herdButton.label.color = 0xFF000000;
        for(offsets in herdButton.labelOffsets){
            offsets.y += 12;
        }
        herdButton.label.alpha = 1.0;
        herdButton.labelAlphas[0] = 1.0;
        herdButton.labelAlphas[2] = 1.0;
        add(herdButton);

        mapButton = new FlxButton(160, 25, "Map", mapClicked);
        mapButton.loadGraphic("assets/images/MapButton.png", true, 160, 69);
        mapButton.updateHitbox();
        mapButton.label.size = 30;
        mapButton.label.color = 0xFF000000;
        add(mapButton);
        for(offsets in mapButton.labelOffsets){
            offsets.y += 12;
        }
        mapButton.label.alpha = 1.0;
        mapButton.labelAlphas[0] = 1.0;
        mapButton.labelAlphas[2] = 1.0;

        denButton = new FlxButton(320, 25, "Den", denClicked);
        denButton.loadGraphic("assets/images/StatusButton.png", true, 160, 69);
        denButton.updateHitbox();
        denButton.label.size = 30;
        denButton.label.color = 0xFF000000;
        for(offsets in denButton.labelOffsets){
            offsets.y += 12;
        }
        denButton.label.alpha = 1.0;
        denButton.labelAlphas[0] = 1.0;
        denButton.labelAlphas[2] = 1.0;
        add(denButton);
    }

    function setupDeerTiles(){
        deerTiles = new Array();
		
        for(i in 0...4){
            var playerDeerTile:DeerTile;
			if(i < GameVariables.instance.controlledDeer.length){
				playerDeerTile = new DeerTile(GameVariables.instance.controlledDeer[i]);
			}else{
				playerDeerTile = new DeerTile(null);
			}
            add(playerDeerTile);
            playerDeerTile.loadGraphic("assets/images/DeerTileSprite.png", true, 190, 134);
            playerDeerTile.moveDisplay(35 + ((i%2)*220), 150 + (Std.int(i/2)*164));
			playerDeerTile.onUp.callback = deerTileClicked.bind(GameVariables.instance.controlledDeer[i]);
            deerTiles.push(playerDeerTile);
        }

        locationSprites = new Array();
        for (i in 0...4){
            var locationSprite:FlxSprite = new FlxSprite(35 + ((i%2)*220), 150 + (Std.int(i/2)*164));
            add(locationSprite);
            locationSprite.loadGraphic(GameVariables.instance.currentLocation.backgroundImageFile, true, 190, 134);
            locationSprites.push(locationSprite);
			
			if(i < GameVariables.instance.controlledDeer.length){
				locationSprite.visible = false;
			}
        }
		
		updateDeerScrollButtons();
		updateDeerTiles();
        //7th son of a 7th son
    }
	
	function updateDeerTiles(){
		if(deerTilePage == null){
			deerTilePage = 0;
		}
		var offSet:Int = deerTilePage * 4;
		
        for (i in 0...4){
			var playerDeerTile:DeerTile = deerTiles[i];
			if(i + offSet < GameVariables.instance.controlledDeer.length){
				playerDeerTile.updateDeer(GameVariables.instance.controlledDeer[i + offSet]);
				playerDeerTile.onUp.callback = deerTileClicked.bind(GameVariables.instance.controlledDeer[i + offSet]);
				playerDeerTile.show();
			}else{
				playerDeerTile.hide();
			}
        }

        for (i in 0...4){
            var locationSprite:FlxSprite = locationSprites[i];
			if(i + offSet >= GameVariables.instance.controlledDeer.length){
				locationSprite.visible = true;
			}else{
				locationSprite.visible = false;
			}
            locationSprite.loadGraphic(GameVariables.instance.currentLocation.backgroundImageFile, true, 190, 134);
        }
		
		updateDeerScrollButtons();
	}
	
	function updateDeerScrollButtons(){
		if(deerLeftButton == null){
			deerLeftButton = new FlxButton(420, 180);
			deerLeftButton.loadGraphic("assets/images/LeftButton.png", true, 96, 60);
			deerLeftButton.screenCenter();
			deerLeftButton.x -= 140;
			deerLeftButton.y += 175;
			deerLeftButton.updateHitbox();
			add(deerLeftButton);
			deerLeftButton.onUp.callback = changeDeerTilePage.bind(-1);
		}
		
		if(deerRightButton == null){
			deerRightButton = new FlxButton(420, 470);
			deerRightButton.loadGraphic("assets/images/RightButton.png", true, 96, 60);
			deerRightButton.screenCenter();
			deerRightButton.x += 140;
			deerRightButton.y += 175;
			deerRightButton.updateHitbox();
			add(deerRightButton);
			deerRightButton.onUp.callback = changeDeerTilePage.bind(1);
		}
		
		if(deerTilePage == null){
			deerTilePage = 0;
		}
		
		if(deerTilePage > 0){
			deerLeftButton.visible = true;
		}else{
			deerLeftButton.visible = false;
		}
		
		var offSet:Int = deerTilePage * 4;
		if(offSet + 4 < GameVariables.instance.controlledDeer.length){
			deerRightButton.visible = true;
		}else{
			deerRightButton.visible = false;
		}
	}
	
	function changeDeerTilePage(amount:Int){
		deerTilePage += amount;
		if(deerTilePage < 0){
			deerTilePage = 0;
		}
		
		updateDeerTiles();
	}

	function setupTopBar(){
        dateText = new FlxText(5, 0, 0, "Fall Wk 1", 18);
		dateText.color = 0xFF000000;
		dateText.alignment = "left";
		add(dateText);

        foodText = new FlxText(315, 0, 160, "Food: " + Std.string(GameVariables.instance.currentFood) + "/" + Std.string(GameVariables.instance.maxFood), 18);
		foodText.color = 0xFF000000;
		foodText.alignment = "right";
		add(foodText);
    }
	
	public function updateTopBar(){
        dateText.text = "Fall Wk 1";
		
        foodText.text = "Food: ";
		if(GameVariables.instance.currentFood > GameVariables.instance.maxFood){
			foodText.text += "(" + Std.string(GameVariables.instance.currentFood) + ")";
		}else{
			foodText.text += Std.string(GameVariables.instance.currentFood);
		}
		foodText.text += "/" + Std.string(GameVariables.instance.maxFood);
	}
	
	function deerReplacement(){
		
	}
	
	function setupMap(){
		mapSprites = new Array<FlxSprite>();
		mapButtons = new Array<FlxButton>();
		
		//var mapSprite:FlxSprite = new FlxSprite(0, 0);
		if(GameVariables.instance.currentLocationName == "Unfamiliar Woods"){
			//mapSprite.loadGraphic("assets/images/MapImages/MapWoods.png");
			//Dark Forest
			var newButton:FlxButton;
			newButton = new FlxButton(0, 0);
			newButton.loadGraphic("assets/images/MapImages/LocationButton.png", true, 23, 23);
			newButton.scale.set(3, 3);
			newButton.updateHitbox();
			newButton.screenCenter();
			newButton.x -= 150;
			mapButtons[mapButtons.length] = newButton;
			newButton.onUp.callback = locationMovement.bind("Dark Forest", 7);
			add(newButton);
			
			//Unfamiliar Woods (current location)
			var currentLocationSprite:FlxSprite = new FlxSprite(0, 0);
			currentLocationSprite.loadGraphic("assets/images/MapImages/CurrentLocationMarker.png", true);
			currentLocationSprite.scale.set(3, 3);
			currentLocationSprite.screenCenter();
			mapSprites[mapSprites.length] = currentLocationSprite;
			add(currentLocationSprite);
			
			//River
			newButton = new FlxButton(0, 0);
			newButton.loadGraphic("assets/images/MapImages/LocationButton.png", true, 23, 23);
			newButton.scale.set(3, 3);
			newButton.updateHitbox();
			newButton.screenCenter();
			newButton.x += 110;
			mapButtons[mapButtons.length] = newButton;
			add(newButton);
			
			//Fields
			newButton = new FlxButton(0, 0);
			newButton.loadGraphic("assets/images/MapImages/LocationButton.png", true, 23, 23);
			newButton.scale.set(3, 3);
			newButton.updateHitbox();
			newButton.screenCenter();
			newButton.y += 110;
			mapButtons[mapButtons.length] = newButton;
			newButton.onUp.callback = locationMovement.bind("Abandoned Fields", 5);
			add(newButton);
		}
		else if (GameVariables.instance.currentLocationName == "Dark Forest")
		{
			//mapSprite.loadGraphic("assets/images/MapImages/MapWoods.png");
			//Power Plant
			var newButton:FlxButton;
			newButton = new FlxButton(0, 0);
			newButton.loadGraphic("assets/images/MapImages/LocationButton.png", true, 23, 23);
			newButton.scale.set(3, 3);
			newButton.updateHitbox();
			newButton.screenCenter();
			newButton.y += 110;
			mapButtons[mapButtons.length] = newButton;
			add(newButton);
			
			//Dark Forest (current location)
			var currentLocationSprite:FlxSprite = new FlxSprite(0, 0);
			currentLocationSprite.loadGraphic("assets/images/MapImages/CurrentLocationMarker.png", true);
			currentLocationSprite.scale.set(3, 3);
			currentLocationSprite.screenCenter();
			mapSprites[mapSprites.length] = currentLocationSprite;
			add(currentLocationSprite);
			
			//Unfamiliar Woods
			newButton = new FlxButton(0, 0);
			newButton.loadGraphic("assets/images/MapImages/LocationButton.png", true, 23, 23);
			newButton.scale.set(3, 3);
			newButton.updateHitbox();
			newButton.screenCenter();
			newButton.x += 110;
			mapButtons[mapButtons.length] = newButton;
			newButton.onUp.callback = locationMovement.bind("Unfamiliar Woods", 5);
			add(newButton);
		}
		else
		{
			//mapSprite.loadGraphic("assets/images/MapImages/MapWoods.png");
			//Power Plant
			var newButton:FlxButton;
			newButton = new FlxButton(0, 0);
			newButton.loadGraphic("assets/images/MapImages/LocationButton.png", true, 23, 23);
			newButton.scale.set(3, 3);
			newButton.updateHitbox();
			newButton.screenCenter();
			newButton.x -= 150;
			newButton.y += 110;
			mapButtons[mapButtons.length] = newButton;
			add(newButton);
			
			//Abandoned Fields (current location)
			var currentLocationSprite:FlxSprite = new FlxSprite(0, 0);
			currentLocationSprite.loadGraphic("assets/images/MapImages/CurrentLocationMarker.png", true);
			currentLocationSprite.scale.set(3, 3);
			currentLocationSprite.screenCenter();
			currentLocationSprite.y += 110;
			mapSprites[mapSprites.length] = currentLocationSprite;
			add(currentLocationSprite);
			
			//River
			newButton = new FlxButton(0, 0);
			newButton.loadGraphic("assets/images/MapImages/LocationButton.png", true, 23, 23);
			newButton.scale.set(3, 3);
			newButton.updateHitbox();
			newButton.screenCenter();
			newButton.x += 110;
			mapButtons[mapButtons.length] = newButton;
			add(newButton);
			
			//Unfamiliar Woods
			newButton = new FlxButton(0, 0);
			newButton.loadGraphic("assets/images/MapImages/LocationButton.png", true, 23, 23);
			newButton.scale.set(3, 3);
			newButton.updateHitbox();
			newButton.screenCenter();
			mapButtons[mapButtons.length] = newButton;
			newButton.onUp.callback = locationMovement.bind("The Darkened Woods", 5);
			add(newButton);
		}
		
		//mapSprite.screenCenter();
		//add(mapSprite);
		//mapSprites[mapSprites.length] = mapSprite;
	}
	
	function hideMap(){
		for (i in 0...mapSprites.length) {
			mapSprites[i].visible = false;
        }
		for (i in 0...mapButtons.length) {
			mapButtons[i].visible = false;
        }
	}
	
	function showMap(){
		for (i in 0...mapSprites.length) {
			mapSprites[i].visible = true;
        }
		for (i in 0...mapButtons.length) {
			mapButtons[i].visible = true;
        }
	}
	
	function removeMap(){
		for (i in 0...mapSprites.length) {
			remove(mapSprites[i]);
        }
		for (i in 0...mapButtons.length) {
			remove(mapButtons[i]);
        }
		
		mapSprites = new Array<FlxSprite>();
		mapButtons = new Array<FlxButton>();
	}
	
	function locationMovement(locationName:String, cost:Int){
		travelConfirmation = new TravelConfirmationBox(locationName, cost);
		hide();
	}
	
	public function confirmMovement(locationName:String, cost:Int){
		GameVariables.instance.currentFood -= cost;
		GameVariables.instance.changeLocation(locationName);
		removeMap();
	}
	
	function pairingMenu(){
		pairingBox = new PairingBox();
		hide();
	}
	
	function improvementMenu(){
		improvementBox = new ImprovementBox();
		hide();
	}
}
