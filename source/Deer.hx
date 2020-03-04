package;
import haxe.display.Position.Location;
import locations.Location;
import flixel.math.FlxRandom;

class Deer{
    public var name:String;
    public var gender:String;

    public var str:Int;
	public var res:Int;
	public var dex:Int;
	public var int:Int;
	public var lck:Int;

    public var player:Bool;

    public var currentAction:String;
	public var actedThisRound:Bool;
	
	public var health:Int;
	public var maxHealth:Int;
	
	public var pregnant:Bool;
	public var baby:Bool;
	
	public var knowsTheDarkenedWoods:Bool;

    public function new(name:String, gender:String, str:Int, res:Int, dex:Int, int:Int, lck:Int, player:Bool = false) {
        this.name = name;
        this.gender = gender;
        this.str = str;
        this.res = res;
        this.dex = dex;
        this.int = int;
        this.lck = lck;
        this.player = player;
		
		this.maxHealth = res * 2;
		this.health = maxHealth;

        currentAction = "Exploring";
		
		pregnant = false;
		baby = false;
		
		knowsTheDarkenedWoods = false;
    }
	
	static public function getNewBlankDeer():Deer{
		var newDeer:Deer = new Deer("Pley Soulder", "Undetermined", 0, 0, 0, 0, 0);
        newDeer.currentAction = "Waiting";
		
		return newDeer;
    }
	
	public function getStatus():String{
		var status:String = "";
		
		if(health == maxHealth){
			status = "in perfect health";
		}else if (health == 1){
			status = "barely conscious";
		}else if (health == 2){
			status = "barely standing";
		}else if (health == 3){
			status = "a bit worse for wear";
		}else{
			status = "in decent condition";
		}
		
		return status;
	}
	
	public function isAvailable():Bool{
		if(health <= 0){
			return false;
		}else if(pregnant){
			return false;
		}
		
		return true;
	}
	
	public function heal(amount:Int){
		health += amount;
		if(health > maxHealth){
			health = maxHealth;
		}
	}
	
	public function takeDamage(amount:Int){
		health -= amount;
		if(health <= 0){
			health = 0;
		}
	}
	
	//Returns a hint about the deer's stats
	public function getGlimmer():String{
		var result:String = "(insert glimmer here)";
		var statNames = ["Strength", "Resilience", "Dexterity", "Intellect", "Fortune"];
		
		var randomizer:FlxRandom = new FlxRandom();
		randomizer.shuffle(statNames);
		
		var maxSkillName:String = "Nothing";
		var maxSkillValue = 0;
		
		for(i in 0...statNames.length){
			if(getStatByName(statNames[i]) > maxSkillValue){
				maxSkillValue = getStatByName(statNames[i]);
				maxSkillName = statNames[i];
			}
		} 
		
		result = maxSkillName;
		
		return result;
	}
	
	public function increaseStatByName(statName:String, amount:Int = 1){
		if(statName == "Strength"){
			this.str += amount;
		}else if(statName == "Resilience"){
			this.res += amount;
		}else if(statName == "Dexterity"){
			this.dex += amount;
		}else if(statName == "Intellect"){
			this.int += amount;
		}else if(statName == "Fortune"){
			this.lck += amount;
		}
	}
	
	public function getStatByName(statName:String):Int{
		if(statName == "Strength"){
			return this.str;
		}else if(statName == "Resilience"){
			return this.res;
		}else if(statName == "Dexterity"){
			return this.dex;
		}else if(statName == "Intellect"){
			return this.int;
		}else if(statName == "Fortune"){
			return this.lck;
		}
		
		return -1;
	}
	
	static public function buildADeer(totalStatPoints:Int, ?distributions:Array<Array<Int>>):Deer{
		var randomizer:FlxRandom = new FlxRandom();
		var statNames = ["Strength", "Resilience", "Dexterity", "Intellect", "Fortune"];
		randomizer.shuffle(statNames);
		
		if(distributions == null){
			distributions = [[30, 53, 73, 88, 100]];
		}
		
		var chosenDistribution:Array<Int> = distributions[randomizer.int(0, distributions.length - 1)];
		
		var newDeer:Deer = getNewBlankDeer();
		
		for (i in 0...totalStatPoints) {
			var statRoll:Int = randomizer.int(0, 100);
			
			for (i in 0...chosenDistribution.length) {
				if (statRoll <= chosenDistribution[i]) {
					newDeer.increaseStatByName(statNames[i]);
					break;
				}
			}
		}
		
		if(newDeer.res == 0){
			newDeer.res = 1;
		}
		
		newDeer.maxHealth = newDeer.res * 2;
		newDeer.health = newDeer.maxHealth;
			
		if(randomizer.bool()){
			newDeer.gender = "Female";
		}else{
			newDeer.gender = "Male";
		}
		
		newDeer.name = NameGenerator.getRandomName(newDeer.gender);
		
		return newDeer;
	}
}