package;

class Inventory 
{
	public var items:Array<String>;
	
	public function new() 
	{
		items = new Array<String>();
	}
	
	public function addItem(itemName:String, ?duplicatesAllowed = true)
	{
		if (duplicatesAllowed || !checkForItemByName(itemName))
		{
			items.push(itemName);
		}
	}
	
	public function checkForItemByName(itemName:String):Bool
	{
		for (i in 0...items.length)
		{
			if (items[i] == itemName)
			{
				return true;
			}
		}
		
		return false;
	}
}