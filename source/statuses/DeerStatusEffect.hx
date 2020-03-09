package statuses;

class DeerStatusEffect 
{
	public var statusName:String;
	
	public var strChange:Int;
	public var resChange:Int;
	public var dexChange:Int;
	public var intChange:Int;
	public var lckChange:Int;
	
	public var duration:Int;
	
	public function new(?name = "Buff", ?duration:Int = 1, ?strChange = 0, ?resChange = 0, ?dexChange = 0, ?intChange = 0, ?lckChange = 0) 
	{
		this.strChange  = strChange;
		this.resChange  = resChange;
		this.dexChange  = dexChange;
		this.intChange  = intChange;
		this.lckChange  = lckChange;
		
		this.duration = duration;
	}
	
	public function progressStatusEffect(){
		duration--;
	}
	
}