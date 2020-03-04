package;

class NameGenerator  
{
	public static function getRandomName(gender:String):String
	{
		if(gender == "Male"){
			return "Tom Ato";
		}else if(gender == "Female"){
			return "Ann Chovy";
		}

		return "Jeff";
	}
}
