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
	
	public function modifyStatByName(statName:String, amount:Int = 1){
		if(statName == "Strength"){
			str += amount;
		}else if(statName == "Resilience"){
			res += amount;
		}else if(statName == "Dexterity"){
			dex += amount;
		}else if(statName == "Intellect"){
			int += amount;
		}else if(statName == "Fortune"){
			lck += amount;
		}
	}
	
	public function getStatByName(statName:String):Int{
		if(statName == "Strength"){
			return str;
		}else if(statName == "Resilience"){
			return res;
		}else if(statName == "Dexterity"){
			return dex;
		}else if(statName == "Intellect"){
			return int;
		}else if(statName == "Fortune"){
			return lck;
		}
		
		return -1;
	}
	
	public function getStatTotal():Int{
		return this.str + this.res + this.dex + this.int + this.lck;
	}
	
	public function getStatsOverZero(?shuffle:Bool = true):Array<String>{
		var statNames = new Array<String>();
		
		if(str > 0){
			statNames.push("Strength");
		}
		if(res > 0){
			statNames.push("Resilience");
		}
		if(dex > 0){
			statNames.push("Dexterity");
		}
		if(int > 0){
			statNames.push("Intellect");
		}
		if(lck > 0){
			statNames.push("Fortune");
		}
		
		if(shuffle){
			var randomizer:FlxRandom = new FlxRandom();
			randomizer.shuffle(statNames);
		}
		
		return statNames;
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
					newDeer.modifyStatByName(statNames[i]);
					break;
				}
			}
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
	
	static public function generateBabyDeer(motherDeer:Deer, fatherDeer:Deer):Deer{
		var randomizer:FlxRandom = new FlxRandom();
		var statNames = ["Strength", "Resilience", "Dexterity", "Intellect", "Fortune"];
		randomizer.shuffle(statNames);
		
		var newDeer:Deer = getNewBlankDeer();
		
		var mothersInfluence:Int = randomizer.int(2, 3);
		
		//Inheriting mother's stats
		for (i in 0...mothersInfluence) {
			newDeer.modifyStatByName(statNames[i], motherDeer.getStatByName(statNames[i]));
		}
		
		//Inheriting father's stats
		for (i in mothersInfluence...5) {
			newDeer.modifyStatByName(statNames[i], fatherDeer.getStatByName(statNames[i]));
		}
		
		//shuffling a bit
		var shuffles:Int = randomizer.int(1, 4);
		
		for (i in 0...shuffles) {
			var statToDecrease:String = statNames[randomizer.int(0, statNames.length)];
			if(newDeer.getStatByName(statToDecrease) > 0){
				newDeer.modifyStatByName(statToDecrease, -1);
				newDeer.modifyStatByName(statNames[randomizer.int(0, statNames.length)], 1);
			}
		}
		
		//Balance out the stats if they have more or less than their parents
		var parentsTotalStats = motherDeer.getStatTotal() + fatherDeer.getStatTotal();
		var statDifference:Int = newDeer.getStatTotal() - Math.floor(parentsTotalStats/2);
		
		var statChanges:Int = cast(Math.abs(statDifference), Int);
		
		if(statDifference > 0){
			var statsOverZero:Array<String> = newDeer.getStatsOverZero();
			while(statChanges > 0 && statsOverZero.length > 0){
				newDeer.modifyStatByName(statsOverZero[randomizer.int(0, statsOverZero.length)], -1);
				
				statsOverZero = newDeer.getStatsOverZero();
				statChanges--;
			}
		}
		else if (statDifference < 0)
		{
			for(i in 0...statChanges){
				newDeer.modifyStatByName(statNames[randomizer.int(0, statNames.length)], 1);
			}
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