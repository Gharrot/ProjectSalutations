package;


import haxe.io.Bytes;
import lime.utils.AssetBundle;
import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;
import lime.utils.Assets;

#if sys
import sys.FileSystem;
#end

@:access(lime.utils.Assets)


@:keep @:dox(hide) class ManifestResources {


	public static var preloadLibraries:Array<AssetLibrary>;
	public static var preloadLibraryNames:Array<String>;
	public static var rootPath:String;


	public static function init (config:Dynamic):Void {

		preloadLibraries = new Array ();
		preloadLibraryNames = new Array ();

		rootPath = null;

		if (config != null && Reflect.hasField (config, "rootPath")) {

			rootPath = Reflect.field (config, "rootPath");

		}

		if (rootPath == null) {

			#if (ios || tvos || emscripten)
			rootPath = "assets/";
			#elseif android
			rootPath = "";
			#elseif console
			rootPath = lime.system.System.applicationDirectory;
			#else
			rootPath = "./";
			#end

		}

		#if (openfl && !flash && !display)
		openfl.text.Font.registerFont (__ASSET__OPENFL__flixel_fonts_nokiafc22_ttf);
		openfl.text.Font.registerFont (__ASSET__OPENFL__flixel_fonts_monsterrat_ttf);
		
		#end

		var data, manifest, library, bundle;

		#if kha

		null
		library = AssetLibrary.fromManifest (manifest);
		Assets.registerLibrary ("null", library);

		if (library != null) preloadLibraries.push (library);
		else preloadLibraryNames.push ("null");

		#else

		data = '{"name":null,"assets":"aoy4:pathy34:assets%2Fdata%2Fdata-goes-here.txty4:sizezy4:typey4:TEXTy2:idR1y7:preloadtgoR0y42:assets%2Fimages%2FBrownDownButton.asepriteR2i929R3y6:BINARYR5R7R6tgoR0y37:assets%2Fimages%2FBrownDownButton.pngR2i506R3y5:IMAGER5R9R6tgoR0y40:assets%2Fimages%2FBrownUpButton.asepriteR2i935R3R8R5R11R6tgoR0y35:assets%2Fimages%2FBrownUpButton.pngR2i472R3R10R5R12R6tgoR0y46:assets%2Fimages%2FCharacterCreationBG.asepriteR2i1775R3R8R5R13R6tgoR0y41:assets%2Fimages%2FCharacterCreationBG.pngR2i2583R3R10R5R14R6tgoR0y30:assets%2Fimages%2FCheckbox.pngR2i593R3R10R5R15R6tgoR0y37:assets%2Fimages%2FCheckedCheckbox.pngR2i428R3R10R5R16R6tgoR0y37:assets%2Fimages%2FConfirmationBox.pngR2i1818R3R10R5R17R6tgoR0y34:assets%2Fimages%2FDeerScreenBG.pngR2i2345R3R10R5R18R6tgoR0y36:assets%2Fimages%2FDeerTileSprite.pngR2i653R3R10R5R19R6tgoR0y42:assets%2Fimages%2FDeerTileSpriteBorder.pngR2i473R3R10R5R20R6tgoR0y61:assets%2Fimages%2FDeerTileSprites%2FHealthMarkerLime.asepriteR2i629R3R8R5R21R6tgoR0y56:assets%2Fimages%2FDeerTileSprites%2FHealthMarkerLime.pngR2i195R3R10R5R22R6tgoR0y63:assets%2Fimages%2FDeerTileSprites%2FHealthMarkerOrange.asepriteR2i629R3R8R5R23R6tgoR0y58:assets%2Fimages%2FDeerTileSprites%2FHealthMarkerOrange.pngR2i197R3R10R5R24R6tgoR0y60:assets%2Fimages%2FDeerTileSprites%2FHealthMarkerRed.asepriteR2i631R3R8R5R25R6tgoR0y55:assets%2Fimages%2FDeerTileSprites%2FHealthMarkerRed.pngR2i198R3R10R5R26R6tgoR0y68:assets%2Fimages%2FDeerTileSprites%2FHealthMarkerTransparent.asepriteR2i521R3R8R5R27R6tgoR0y63:assets%2Fimages%2FDeerTileSprites%2FHealthMarkerTransparent.pngR2i87R3R10R5R28R6tgoR0y63:assets%2Fimages%2FDeerTileSprites%2FHealthMarkerYellow.asepriteR2i629R3R8R5R29R6tgoR0y58:assets%2Fimages%2FDeerTileSprites%2FHealthMarkerYellow.pngR2i197R3R10R5R30R6tgoR0y63:assets%2Fimages%2FDeerTileSprites%2FHealthMarkerYellowGreen.pngR2i197R3R10R5R31R6tgoR0y31:assets%2Fimages%2FDenButton.pngR2i457R3R10R5R32R6tgoR0y37:assets%2Fimages%2FDenButtonStatic.pngR2i268R3R10R5R33R6tgoR0y35:assets%2Fimages%2FEmptyDeerTile.pngR2i1067R3R10R5R34R6tgoR0y35:assets%2Fimages%2FExploreButton.pngR2i721R3R10R5R35R6tgoR0y32:assets%2Fimages%2FFemaleDeer.pngR2i3215R3R10R5R36R6tgoR0y34:assets%2Fimages%2FFemaleSprite.pngR2i884R3R10R5R37R6tgoR0y32:assets%2Fimages%2FHerdButton.pngR2i410R3R10R5R38R6tgoR0y40:assets%2Fimages%2FHerdButtonSelected.pngR2i280R3R10R5R39R6tgoR0y36:assets%2Fimages%2Fimages-go-here.txtR2zR3R4R5R40R6tgoR0y32:assets%2Fimages%2FLeftButton.pngR2i957R3R10R5R41R6tgoR0y54:assets%2Fimages%2FLocationImages%2FAbandonedFields.aseR2i2538R3R8R5R42R6tgoR0y54:assets%2Fimages%2FLocationImages%2FAbandonedFields.pngR2i2860R3R10R5R43R6tgoR0y60:assets%2Fimages%2FLocationImages%2FCurrentLocationMarker.pngR2i216R3R10R5R44R6tgoR0y49:assets%2Fimages%2FLocationImages%2FDarkForest.pngR2i919R3R10R5R45R6tgoR0y62:assets%2Fimages%2FLocationImages%2FDarkForestEmptyDeerTile.pngR2i855R3R10R5R46R6tgoR0y56:assets%2Fimages%2FLocationImages%2FDarkForestNoFrame.pngR2i821R3R10R5R47R6tgoR0y53:assets%2Fimages%2FLocationImages%2FForgottenWoods.pngR2i910R3R10R5R48R6tgoR0y66:assets%2Fimages%2FLocationImages%2FForgottenWoodsEmptyDeerTile.pngR2i855R3R10R5R49R6tgoR0y60:assets%2Fimages%2FLocationImages%2FForgottenWoodsNoFrame.pngR2i824R3R10R5R50R6tgoR0y53:assets%2Fimages%2FLocationImages%2FLocationButton.pngR2i329R3R10R5R51R6tgoR0y48:assets%2Fimages%2FLocationImages%2FMapDesign.aseR2i5805R3R8R5R52R6tgoR0y47:assets%2Fimages%2FLocationImages%2FMapWoods.pngR2i2893R3R10R5R53R6tgoR0y32:assets%2Fimages%2FmainMenuBg.pngR2i2593R3R10R5R54R6tgoR0y30:assets%2Fimages%2FMaleDeer.pngR2i2467R3R10R5R55R6tgoR0y40:assets%2Fimages%2FMaleDeerTileSprite.pngR2i1023R3R10R5R56R6tgoR0y32:assets%2Fimages%2FMaleSprite.pngR2i717R3R10R5R57R6tgoR0y31:assets%2Fimages%2FMapButton.pngR2i414R3R10R5R58R6tgoR0y39:assets%2Fimages%2FMapButtonSelected.pngR2i284R3R10R5R59R6tgoR0y55:assets%2Fimages%2FMapImages%2FCurrentLocationMarker.pngR2i216R3R10R5R60R6tgoR0y48:assets%2Fimages%2FMapImages%2FLocationButton.pngR2i330R3R10R5R61R6tgoR0y43:assets%2Fimages%2FMapImages%2FMapDesign.aseR2i4811R3R8R5R62R6tgoR0y42:assets%2Fimages%2FMapImages%2FMapWoods.pngR2i2893R3R10R5R63R6tgoR0y53:assets%2Fimages%2FMapImages%2FUnreachableLocation.pngR2i216R3R10R5R64R6tgoR0y54:assets%2Fimages%2FMedallions%2FDarkForestMedallion.pngR2i906R3R10R5R65R6tgoR0y58:assets%2Fimages%2FMedallions%2FForgottenWoodsMedallion.pngR2i898R3R10R5R66R6tgoR0y33:assets%2Fimages%2FMinusButton.pngR2i214R3R10R5R67R6tgoR0y32:assets%2Fimages%2FOctaButton.aseR2i3357R3R8R5R68R6tgoR0y32:assets%2Fimages%2FOctaButton.pngR2i1680R3R10R5R69R6tgoR0y38:assets%2Fimages%2FOctaButtonSkinny.aseR2i3319R3R8R5R70R6tgoR0y38:assets%2Fimages%2FOctaButtonSkinny.pngR2i1786R3R10R5R71R6tgoR0y36:assets%2Fimages%2FPassTimeButton.pngR2i517R3R10R5R72R6tgoR0y42:assets%2Fimages%2FPassTimeButtonStatic.pngR2i333R3R10R5R73R6tgoR0y32:assets%2Fimages%2FPlusButton.pngR2i236R3R10R5R74R6tgoR0y33:assets%2Fimages%2FRightButton.pngR2i978R3R10R5R75R6tgoR0y38:assets%2Fimages%2FStaticLeftButton.pngR2i491R3R10R5R76R6tgoR0y39:assets%2Fimages%2FStaticRightButton.pngR2i435R3R10R5R77R6tgoR0y34:assets%2Fimages%2FStatusButton.pngR2i405R3R10R5R78R6tgoR0y42:assets%2Fimages%2FStatusButtonSelected.pngR2i276R3R10R5R79R6tgoR0y35:assets%2Fimages%2FTransparentBG.pngR2i2585R3R10R5R80R6tgoR0y29:assets%2Fimages%2FXButton.pngR2i1135R3R10R5R81R6tgoR0y36:assets%2Fmusic%2Fmusic-goes-here.txtR2zR3R4R5R82R6tgoR0y36:assets%2Fsounds%2Fsounds-go-here.txtR2zR3R4R5R83R6tgoR2i2114R3y5:MUSICR5y26:flixel%2Fsounds%2Fbeep.mp3y9:pathGroupaR85y26:flixel%2Fsounds%2Fbeep.ogghR6tgoR2i39706R3R84R5y28:flixel%2Fsounds%2Fflixel.mp3R86aR88y28:flixel%2Fsounds%2Fflixel.ogghR6tgoR2i5794R3y5:SOUNDR5R87R86aR85R87hgoR2i33629R3R90R5R89R86aR88R89hgoR2i15744R3y4:FONTy9:classNamey35:__ASSET__flixel_fonts_nokiafc22_ttfR5y30:flixel%2Ffonts%2Fnokiafc22.ttfR6tgoR2i29724R3R91R92y36:__ASSET__flixel_fonts_monsterrat_ttfR5y31:flixel%2Ffonts%2Fmonsterrat.ttfR6tgoR0y33:flixel%2Fimages%2Fui%2Fbutton.pngR2i519R3R10R5R97R6tgoR0y36:flixel%2Fimages%2Flogo%2Fdefault.pngR2i3280R3R10R5R98R6tgoR0y34:flixel%2Fflixel-ui%2Fimg%2Fbox.pngR2i912R3R10R5R99R6tgoR0y37:flixel%2Fflixel-ui%2Fimg%2Fbutton.pngR2i433R3R10R5R100R6tgoR0y48:flixel%2Fflixel-ui%2Fimg%2Fbutton_arrow_down.pngR2i446R3R10R5R101R6tgoR0y48:flixel%2Fflixel-ui%2Fimg%2Fbutton_arrow_left.pngR2i459R3R10R5R102R6tgoR0y49:flixel%2Fflixel-ui%2Fimg%2Fbutton_arrow_right.pngR2i511R3R10R5R103R6tgoR0y46:flixel%2Fflixel-ui%2Fimg%2Fbutton_arrow_up.pngR2i493R3R10R5R104R6tgoR0y42:flixel%2Fflixel-ui%2Fimg%2Fbutton_thin.pngR2i247R3R10R5R105R6tgoR0y44:flixel%2Fflixel-ui%2Fimg%2Fbutton_toggle.pngR2i534R3R10R5R106R6tgoR0y40:flixel%2Fflixel-ui%2Fimg%2Fcheck_box.pngR2i922R3R10R5R107R6tgoR0y41:flixel%2Fflixel-ui%2Fimg%2Fcheck_mark.pngR2i946R3R10R5R108R6tgoR0y37:flixel%2Fflixel-ui%2Fimg%2Fchrome.pngR2i253R3R10R5R109R6tgoR0y42:flixel%2Fflixel-ui%2Fimg%2Fchrome_flat.pngR2i212R3R10R5R110R6tgoR0y43:flixel%2Fflixel-ui%2Fimg%2Fchrome_inset.pngR2i192R3R10R5R111R6tgoR0y43:flixel%2Fflixel-ui%2Fimg%2Fchrome_light.pngR2i214R3R10R5R112R6tgoR0y44:flixel%2Fflixel-ui%2Fimg%2Fdropdown_mark.pngR2i156R3R10R5R113R6tgoR0y41:flixel%2Fflixel-ui%2Fimg%2Ffinger_big.pngR2i1724R3R10R5R114R6tgoR0y43:flixel%2Fflixel-ui%2Fimg%2Ffinger_small.pngR2i294R3R10R5R115R6tgoR0y38:flixel%2Fflixel-ui%2Fimg%2Fhilight.pngR2i129R3R10R5R116R6tgoR0y36:flixel%2Fflixel-ui%2Fimg%2Finvis.pngR2i128R3R10R5R117R6tgoR0y41:flixel%2Fflixel-ui%2Fimg%2Fminus_mark.pngR2i136R3R10R5R118R6tgoR0y40:flixel%2Fflixel-ui%2Fimg%2Fplus_mark.pngR2i147R3R10R5R119R6tgoR0y36:flixel%2Fflixel-ui%2Fimg%2Fradio.pngR2i191R3R10R5R120R6tgoR0y40:flixel%2Fflixel-ui%2Fimg%2Fradio_dot.pngR2i153R3R10R5R121R6tgoR0y37:flixel%2Fflixel-ui%2Fimg%2Fswatch.pngR2i185R3R10R5R122R6tgoR0y34:flixel%2Fflixel-ui%2Fimg%2Ftab.pngR2i201R3R10R5R123R6tgoR0y39:flixel%2Fflixel-ui%2Fimg%2Ftab_back.pngR2i210R3R10R5R124R6tgoR0y44:flixel%2Fflixel-ui%2Fimg%2Ftooltip_arrow.pngR2i18509R3R10R5R125R6tgoR0y39:flixel%2Fflixel-ui%2Fxml%2Fdefaults.xmlR2i1263R3R4R5R126R6tgoR0y53:flixel%2Fflixel-ui%2Fxml%2Fdefault_loading_screen.xmlR2i1953R3R4R5R127R6tgoR0y44:flixel%2Fflixel-ui%2Fxml%2Fdefault_popup.xmlR2i1848R3R4R5R128R6tgh","rootPath":null,"version":2,"libraryArgs":[],"libraryType":null}';
		manifest = AssetManifest.parse (data, rootPath);
		library = AssetLibrary.fromManifest (manifest);
		Assets.registerLibrary ("default", library);
		

		library = Assets.getLibrary ("default");
		if (library != null) preloadLibraries.push (library);
		else preloadLibraryNames.push ("default");
		

		#end

	}


}


#if kha

null

#else

#if !display
#if flash

@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_data_goes_here_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_browndownbutton_aseprite extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_browndownbutton_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_brownupbutton_aseprite extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_brownupbutton_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_charactercreationbg_aseprite extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_charactercreationbg_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_checkbox_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_checkedcheckbox_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_confirmationbox_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_deerscreenbg_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_deertilesprite_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_deertilespriteborder_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_deertilesprites_healthmarkerlime_aseprite extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_deertilesprites_healthmarkerlime_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_deertilesprites_healthmarkerorange_aseprite extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_deertilesprites_healthmarkerorange_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_deertilesprites_healthmarkerred_aseprite extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_deertilesprites_healthmarkerred_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_deertilesprites_healthmarkertransparent_aseprite extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_deertilesprites_healthmarkertransparent_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_deertilesprites_healthmarkeryellow_aseprite extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_deertilesprites_healthmarkeryellow_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_deertilesprites_healthmarkeryellowgreen_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_denbutton_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_denbuttonstatic_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_emptydeertile_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_explorebutton_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_femaledeer_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_femalesprite_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_herdbutton_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_herdbuttonselected_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_images_go_here_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_leftbutton_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_locationimages_abandonedfields_ase extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_locationimages_abandonedfields_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_locationimages_currentlocationmarker_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_locationimages_darkforest_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_locationimages_darkforestemptydeertile_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_locationimages_darkforestnoframe_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_locationimages_forgottenwoods_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_locationimages_forgottenwoodsemptydeertile_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_locationimages_forgottenwoodsnoframe_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_locationimages_locationbutton_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_locationimages_mapdesign_ase extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_locationimages_mapwoods_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_mainmenubg_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_maledeer_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_maledeertilesprite_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_malesprite_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_mapbutton_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_mapbuttonselected_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_mapimages_currentlocationmarker_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_mapimages_locationbutton_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_mapimages_mapdesign_ase extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_mapimages_mapwoods_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_mapimages_unreachablelocation_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_medallions_darkforestmedallion_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_medallions_forgottenwoodsmedallion_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_minusbutton_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_octabutton_ase extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_octabutton_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_octabuttonskinny_ase extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_octabuttonskinny_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_passtimebutton_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_passtimebuttonstatic_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_plusbutton_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_rightbutton_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_staticleftbutton_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_staticrightbutton_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_statusbutton_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_statusbuttonselected_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_transparentbg_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_xbutton_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_music_music_goes_here_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sounds_sounds_go_here_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_sounds_beep_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_sounds_flixel_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_sounds_beep_ogg extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_sounds_flixel_ogg extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_fonts_nokiafc22_ttf extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_fonts_monsterrat_ttf extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_images_ui_button_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_images_logo_default_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_img_box_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_img_button_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_img_button_arrow_down_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_img_button_arrow_left_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_img_button_arrow_right_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_img_button_arrow_up_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_img_button_thin_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_img_button_toggle_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_img_check_box_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_img_check_mark_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_img_chrome_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_img_chrome_flat_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_img_chrome_inset_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_img_chrome_light_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_img_dropdown_mark_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_img_finger_big_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_img_finger_small_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_img_hilight_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_img_invis_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_img_minus_mark_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_img_plus_mark_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_img_radio_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_img_radio_dot_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_img_swatch_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_img_tab_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_img_tab_back_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_img_tooltip_arrow_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_xml_defaults_xml extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_xml_default_loading_screen_xml extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_xml_default_popup_xml extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__manifest_default_json extends null { }


#elseif (desktop || cpp)

@:keep @:file("assets/data/data-goes-here.txt") @:noCompletion #if display private #end class __ASSET__assets_data_data_goes_here_txt extends haxe.io.Bytes {}
@:keep @:file("assets/images/BrownDownButton.aseprite") @:noCompletion #if display private #end class __ASSET__assets_images_browndownbutton_aseprite extends haxe.io.Bytes {}
@:keep @:image("assets/images/BrownDownButton.png") @:noCompletion #if display private #end class __ASSET__assets_images_browndownbutton_png extends lime.graphics.Image {}
@:keep @:file("assets/images/BrownUpButton.aseprite") @:noCompletion #if display private #end class __ASSET__assets_images_brownupbutton_aseprite extends haxe.io.Bytes {}
@:keep @:image("assets/images/BrownUpButton.png") @:noCompletion #if display private #end class __ASSET__assets_images_brownupbutton_png extends lime.graphics.Image {}
@:keep @:file("assets/images/CharacterCreationBG.aseprite") @:noCompletion #if display private #end class __ASSET__assets_images_charactercreationbg_aseprite extends haxe.io.Bytes {}
@:keep @:image("assets/images/CharacterCreationBG.png") @:noCompletion #if display private #end class __ASSET__assets_images_charactercreationbg_png extends lime.graphics.Image {}
@:keep @:image("assets/images/Checkbox.png") @:noCompletion #if display private #end class __ASSET__assets_images_checkbox_png extends lime.graphics.Image {}
@:keep @:image("assets/images/CheckedCheckbox.png") @:noCompletion #if display private #end class __ASSET__assets_images_checkedcheckbox_png extends lime.graphics.Image {}
@:keep @:image("assets/images/ConfirmationBox.png") @:noCompletion #if display private #end class __ASSET__assets_images_confirmationbox_png extends lime.graphics.Image {}
@:keep @:image("assets/images/DeerScreenBG.png") @:noCompletion #if display private #end class __ASSET__assets_images_deerscreenbg_png extends lime.graphics.Image {}
@:keep @:image("assets/images/DeerTileSprite.png") @:noCompletion #if display private #end class __ASSET__assets_images_deertilesprite_png extends lime.graphics.Image {}
@:keep @:image("assets/images/DeerTileSpriteBorder.png") @:noCompletion #if display private #end class __ASSET__assets_images_deertilespriteborder_png extends lime.graphics.Image {}
@:keep @:file("assets/images/DeerTileSprites/HealthMarkerLime.aseprite") @:noCompletion #if display private #end class __ASSET__assets_images_deertilesprites_healthmarkerlime_aseprite extends haxe.io.Bytes {}
@:keep @:image("assets/images/DeerTileSprites/HealthMarkerLime.png") @:noCompletion #if display private #end class __ASSET__assets_images_deertilesprites_healthmarkerlime_png extends lime.graphics.Image {}
@:keep @:file("assets/images/DeerTileSprites/HealthMarkerOrange.aseprite") @:noCompletion #if display private #end class __ASSET__assets_images_deertilesprites_healthmarkerorange_aseprite extends haxe.io.Bytes {}
@:keep @:image("assets/images/DeerTileSprites/HealthMarkerOrange.png") @:noCompletion #if display private #end class __ASSET__assets_images_deertilesprites_healthmarkerorange_png extends lime.graphics.Image {}
@:keep @:file("assets/images/DeerTileSprites/HealthMarkerRed.aseprite") @:noCompletion #if display private #end class __ASSET__assets_images_deertilesprites_healthmarkerred_aseprite extends haxe.io.Bytes {}
@:keep @:image("assets/images/DeerTileSprites/HealthMarkerRed.png") @:noCompletion #if display private #end class __ASSET__assets_images_deertilesprites_healthmarkerred_png extends lime.graphics.Image {}
@:keep @:file("assets/images/DeerTileSprites/HealthMarkerTransparent.aseprite") @:noCompletion #if display private #end class __ASSET__assets_images_deertilesprites_healthmarkertransparent_aseprite extends haxe.io.Bytes {}
@:keep @:image("assets/images/DeerTileSprites/HealthMarkerTransparent.png") @:noCompletion #if display private #end class __ASSET__assets_images_deertilesprites_healthmarkertransparent_png extends lime.graphics.Image {}
@:keep @:file("assets/images/DeerTileSprites/HealthMarkerYellow.aseprite") @:noCompletion #if display private #end class __ASSET__assets_images_deertilesprites_healthmarkeryellow_aseprite extends haxe.io.Bytes {}
@:keep @:image("assets/images/DeerTileSprites/HealthMarkerYellow.png") @:noCompletion #if display private #end class __ASSET__assets_images_deertilesprites_healthmarkeryellow_png extends lime.graphics.Image {}
@:keep @:image("assets/images/DeerTileSprites/HealthMarkerYellowGreen.png") @:noCompletion #if display private #end class __ASSET__assets_images_deertilesprites_healthmarkeryellowgreen_png extends lime.graphics.Image {}
@:keep @:image("assets/images/DenButton.png") @:noCompletion #if display private #end class __ASSET__assets_images_denbutton_png extends lime.graphics.Image {}
@:keep @:image("assets/images/DenButtonStatic.png") @:noCompletion #if display private #end class __ASSET__assets_images_denbuttonstatic_png extends lime.graphics.Image {}
@:keep @:image("assets/images/EmptyDeerTile.png") @:noCompletion #if display private #end class __ASSET__assets_images_emptydeertile_png extends lime.graphics.Image {}
@:keep @:image("assets/images/ExploreButton.png") @:noCompletion #if display private #end class __ASSET__assets_images_explorebutton_png extends lime.graphics.Image {}
@:keep @:image("assets/images/FemaleDeer.png") @:noCompletion #if display private #end class __ASSET__assets_images_femaledeer_png extends lime.graphics.Image {}
@:keep @:image("assets/images/FemaleSprite.png") @:noCompletion #if display private #end class __ASSET__assets_images_femalesprite_png extends lime.graphics.Image {}
@:keep @:image("assets/images/HerdButton.png") @:noCompletion #if display private #end class __ASSET__assets_images_herdbutton_png extends lime.graphics.Image {}
@:keep @:image("assets/images/HerdButtonSelected.png") @:noCompletion #if display private #end class __ASSET__assets_images_herdbuttonselected_png extends lime.graphics.Image {}
@:keep @:file("assets/images/images-go-here.txt") @:noCompletion #if display private #end class __ASSET__assets_images_images_go_here_txt extends haxe.io.Bytes {}
@:keep @:image("assets/images/LeftButton.png") @:noCompletion #if display private #end class __ASSET__assets_images_leftbutton_png extends lime.graphics.Image {}
@:keep @:file("assets/images/LocationImages/AbandonedFields.ase") @:noCompletion #if display private #end class __ASSET__assets_images_locationimages_abandonedfields_ase extends haxe.io.Bytes {}
@:keep @:image("assets/images/LocationImages/AbandonedFields.png") @:noCompletion #if display private #end class __ASSET__assets_images_locationimages_abandonedfields_png extends lime.graphics.Image {}
@:keep @:image("assets/images/LocationImages/CurrentLocationMarker.png") @:noCompletion #if display private #end class __ASSET__assets_images_locationimages_currentlocationmarker_png extends lime.graphics.Image {}
@:keep @:image("assets/images/LocationImages/DarkForest.png") @:noCompletion #if display private #end class __ASSET__assets_images_locationimages_darkforest_png extends lime.graphics.Image {}
@:keep @:image("assets/images/LocationImages/DarkForestEmptyDeerTile.png") @:noCompletion #if display private #end class __ASSET__assets_images_locationimages_darkforestemptydeertile_png extends lime.graphics.Image {}
@:keep @:image("assets/images/LocationImages/DarkForestNoFrame.png") @:noCompletion #if display private #end class __ASSET__assets_images_locationimages_darkforestnoframe_png extends lime.graphics.Image {}
@:keep @:image("assets/images/LocationImages/ForgottenWoods.png") @:noCompletion #if display private #end class __ASSET__assets_images_locationimages_forgottenwoods_png extends lime.graphics.Image {}
@:keep @:image("assets/images/LocationImages/ForgottenWoodsEmptyDeerTile.png") @:noCompletion #if display private #end class __ASSET__assets_images_locationimages_forgottenwoodsemptydeertile_png extends lime.graphics.Image {}
@:keep @:image("assets/images/LocationImages/ForgottenWoodsNoFrame.png") @:noCompletion #if display private #end class __ASSET__assets_images_locationimages_forgottenwoodsnoframe_png extends lime.graphics.Image {}
@:keep @:image("assets/images/LocationImages/LocationButton.png") @:noCompletion #if display private #end class __ASSET__assets_images_locationimages_locationbutton_png extends lime.graphics.Image {}
@:keep @:file("assets/images/LocationImages/MapDesign.ase") @:noCompletion #if display private #end class __ASSET__assets_images_locationimages_mapdesign_ase extends haxe.io.Bytes {}
@:keep @:image("assets/images/LocationImages/MapWoods.png") @:noCompletion #if display private #end class __ASSET__assets_images_locationimages_mapwoods_png extends lime.graphics.Image {}
@:keep @:image("assets/images/mainMenuBg.png") @:noCompletion #if display private #end class __ASSET__assets_images_mainmenubg_png extends lime.graphics.Image {}
@:keep @:image("assets/images/MaleDeer.png") @:noCompletion #if display private #end class __ASSET__assets_images_maledeer_png extends lime.graphics.Image {}
@:keep @:image("assets/images/MaleDeerTileSprite.png") @:noCompletion #if display private #end class __ASSET__assets_images_maledeertilesprite_png extends lime.graphics.Image {}
@:keep @:image("assets/images/MaleSprite.png") @:noCompletion #if display private #end class __ASSET__assets_images_malesprite_png extends lime.graphics.Image {}
@:keep @:image("assets/images/MapButton.png") @:noCompletion #if display private #end class __ASSET__assets_images_mapbutton_png extends lime.graphics.Image {}
@:keep @:image("assets/images/MapButtonSelected.png") @:noCompletion #if display private #end class __ASSET__assets_images_mapbuttonselected_png extends lime.graphics.Image {}
@:keep @:image("assets/images/MapImages/CurrentLocationMarker.png") @:noCompletion #if display private #end class __ASSET__assets_images_mapimages_currentlocationmarker_png extends lime.graphics.Image {}
@:keep @:image("assets/images/MapImages/LocationButton.png") @:noCompletion #if display private #end class __ASSET__assets_images_mapimages_locationbutton_png extends lime.graphics.Image {}
@:keep @:file("assets/images/MapImages/MapDesign.ase") @:noCompletion #if display private #end class __ASSET__assets_images_mapimages_mapdesign_ase extends haxe.io.Bytes {}
@:keep @:image("assets/images/MapImages/MapWoods.png") @:noCompletion #if display private #end class __ASSET__assets_images_mapimages_mapwoods_png extends lime.graphics.Image {}
@:keep @:image("assets/images/MapImages/UnreachableLocation.png") @:noCompletion #if display private #end class __ASSET__assets_images_mapimages_unreachablelocation_png extends lime.graphics.Image {}
@:keep @:image("assets/images/Medallions/DarkForestMedallion.png") @:noCompletion #if display private #end class __ASSET__assets_images_medallions_darkforestmedallion_png extends lime.graphics.Image {}
@:keep @:image("assets/images/Medallions/ForgottenWoodsMedallion.png") @:noCompletion #if display private #end class __ASSET__assets_images_medallions_forgottenwoodsmedallion_png extends lime.graphics.Image {}
@:keep @:image("assets/images/MinusButton.png") @:noCompletion #if display private #end class __ASSET__assets_images_minusbutton_png extends lime.graphics.Image {}
@:keep @:file("assets/images/OctaButton.ase") @:noCompletion #if display private #end class __ASSET__assets_images_octabutton_ase extends haxe.io.Bytes {}
@:keep @:image("assets/images/OctaButton.png") @:noCompletion #if display private #end class __ASSET__assets_images_octabutton_png extends lime.graphics.Image {}
@:keep @:file("assets/images/OctaButtonSkinny.ase") @:noCompletion #if display private #end class __ASSET__assets_images_octabuttonskinny_ase extends haxe.io.Bytes {}
@:keep @:image("assets/images/OctaButtonSkinny.png") @:noCompletion #if display private #end class __ASSET__assets_images_octabuttonskinny_png extends lime.graphics.Image {}
@:keep @:image("assets/images/PassTimeButton.png") @:noCompletion #if display private #end class __ASSET__assets_images_passtimebutton_png extends lime.graphics.Image {}
@:keep @:image("assets/images/PassTimeButtonStatic.png") @:noCompletion #if display private #end class __ASSET__assets_images_passtimebuttonstatic_png extends lime.graphics.Image {}
@:keep @:image("assets/images/PlusButton.png") @:noCompletion #if display private #end class __ASSET__assets_images_plusbutton_png extends lime.graphics.Image {}
@:keep @:image("assets/images/RightButton.png") @:noCompletion #if display private #end class __ASSET__assets_images_rightbutton_png extends lime.graphics.Image {}
@:keep @:image("assets/images/StaticLeftButton.png") @:noCompletion #if display private #end class __ASSET__assets_images_staticleftbutton_png extends lime.graphics.Image {}
@:keep @:image("assets/images/StaticRightButton.png") @:noCompletion #if display private #end class __ASSET__assets_images_staticrightbutton_png extends lime.graphics.Image {}
@:keep @:image("assets/images/StatusButton.png") @:noCompletion #if display private #end class __ASSET__assets_images_statusbutton_png extends lime.graphics.Image {}
@:keep @:image("assets/images/StatusButtonSelected.png") @:noCompletion #if display private #end class __ASSET__assets_images_statusbuttonselected_png extends lime.graphics.Image {}
@:keep @:image("assets/images/TransparentBG.png") @:noCompletion #if display private #end class __ASSET__assets_images_transparentbg_png extends lime.graphics.Image {}
@:keep @:image("assets/images/XButton.png") @:noCompletion #if display private #end class __ASSET__assets_images_xbutton_png extends lime.graphics.Image {}
@:keep @:file("assets/music/music-goes-here.txt") @:noCompletion #if display private #end class __ASSET__assets_music_music_goes_here_txt extends haxe.io.Bytes {}
@:keep @:file("assets/sounds/sounds-go-here.txt") @:noCompletion #if display private #end class __ASSET__assets_sounds_sounds_go_here_txt extends haxe.io.Bytes {}
@:keep @:file("C:/HaxeToolkit/haxe/lib/flixel/4,6,3/assets/sounds/beep.mp3") @:noCompletion #if display private #end class __ASSET__flixel_sounds_beep_mp3 extends haxe.io.Bytes {}
@:keep @:file("C:/HaxeToolkit/haxe/lib/flixel/4,6,3/assets/sounds/flixel.mp3") @:noCompletion #if display private #end class __ASSET__flixel_sounds_flixel_mp3 extends haxe.io.Bytes {}
@:keep @:file("C:/HaxeToolkit/haxe/lib/flixel/4,6,3/assets/sounds/beep.ogg") @:noCompletion #if display private #end class __ASSET__flixel_sounds_beep_ogg extends haxe.io.Bytes {}
@:keep @:file("C:/HaxeToolkit/haxe/lib/flixel/4,6,3/assets/sounds/flixel.ogg") @:noCompletion #if display private #end class __ASSET__flixel_sounds_flixel_ogg extends haxe.io.Bytes {}
@:keep @:font("export/html5/obj/webfont/nokiafc22.ttf") @:noCompletion #if display private #end class __ASSET__flixel_fonts_nokiafc22_ttf extends lime.text.Font {}
@:keep @:font("export/html5/obj/webfont/monsterrat.ttf") @:noCompletion #if display private #end class __ASSET__flixel_fonts_monsterrat_ttf extends lime.text.Font {}
@:keep @:image("C:/HaxeToolkit/haxe/lib/flixel/4,6,3/assets/images/ui/button.png") @:noCompletion #if display private #end class __ASSET__flixel_images_ui_button_png extends lime.graphics.Image {}
@:keep @:image("C:/HaxeToolkit/haxe/lib/flixel/4,6,3/assets/images/logo/default.png") @:noCompletion #if display private #end class __ASSET__flixel_images_logo_default_png extends lime.graphics.Image {}
@:keep @:image("C:/HaxeToolkit/haxe/lib/flixel-ui/2,3,2/assets/images/box.png") @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_img_box_png extends lime.graphics.Image {}
@:keep @:image("C:/HaxeToolkit/haxe/lib/flixel-ui/2,3,2/assets/images/button.png") @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_img_button_png extends lime.graphics.Image {}
@:keep @:image("C:/HaxeToolkit/haxe/lib/flixel-ui/2,3,2/assets/images/button_arrow_down.png") @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_img_button_arrow_down_png extends lime.graphics.Image {}
@:keep @:image("C:/HaxeToolkit/haxe/lib/flixel-ui/2,3,2/assets/images/button_arrow_left.png") @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_img_button_arrow_left_png extends lime.graphics.Image {}
@:keep @:image("C:/HaxeToolkit/haxe/lib/flixel-ui/2,3,2/assets/images/button_arrow_right.png") @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_img_button_arrow_right_png extends lime.graphics.Image {}
@:keep @:image("C:/HaxeToolkit/haxe/lib/flixel-ui/2,3,2/assets/images/button_arrow_up.png") @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_img_button_arrow_up_png extends lime.graphics.Image {}
@:keep @:image("C:/HaxeToolkit/haxe/lib/flixel-ui/2,3,2/assets/images/button_thin.png") @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_img_button_thin_png extends lime.graphics.Image {}
@:keep @:image("C:/HaxeToolkit/haxe/lib/flixel-ui/2,3,2/assets/images/button_toggle.png") @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_img_button_toggle_png extends lime.graphics.Image {}
@:keep @:image("C:/HaxeToolkit/haxe/lib/flixel-ui/2,3,2/assets/images/check_box.png") @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_img_check_box_png extends lime.graphics.Image {}
@:keep @:image("C:/HaxeToolkit/haxe/lib/flixel-ui/2,3,2/assets/images/check_mark.png") @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_img_check_mark_png extends lime.graphics.Image {}
@:keep @:image("C:/HaxeToolkit/haxe/lib/flixel-ui/2,3,2/assets/images/chrome.png") @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_img_chrome_png extends lime.graphics.Image {}
@:keep @:image("C:/HaxeToolkit/haxe/lib/flixel-ui/2,3,2/assets/images/chrome_flat.png") @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_img_chrome_flat_png extends lime.graphics.Image {}
@:keep @:image("C:/HaxeToolkit/haxe/lib/flixel-ui/2,3,2/assets/images/chrome_inset.png") @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_img_chrome_inset_png extends lime.graphics.Image {}
@:keep @:image("C:/HaxeToolkit/haxe/lib/flixel-ui/2,3,2/assets/images/chrome_light.png") @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_img_chrome_light_png extends lime.graphics.Image {}
@:keep @:image("C:/HaxeToolkit/haxe/lib/flixel-ui/2,3,2/assets/images/dropdown_mark.png") @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_img_dropdown_mark_png extends lime.graphics.Image {}
@:keep @:image("C:/HaxeToolkit/haxe/lib/flixel-ui/2,3,2/assets/images/finger_big.png") @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_img_finger_big_png extends lime.graphics.Image {}
@:keep @:image("C:/HaxeToolkit/haxe/lib/flixel-ui/2,3,2/assets/images/finger_small.png") @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_img_finger_small_png extends lime.graphics.Image {}
@:keep @:image("C:/HaxeToolkit/haxe/lib/flixel-ui/2,3,2/assets/images/hilight.png") @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_img_hilight_png extends lime.graphics.Image {}
@:keep @:image("C:/HaxeToolkit/haxe/lib/flixel-ui/2,3,2/assets/images/invis.png") @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_img_invis_png extends lime.graphics.Image {}
@:keep @:image("C:/HaxeToolkit/haxe/lib/flixel-ui/2,3,2/assets/images/minus_mark.png") @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_img_minus_mark_png extends lime.graphics.Image {}
@:keep @:image("C:/HaxeToolkit/haxe/lib/flixel-ui/2,3,2/assets/images/plus_mark.png") @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_img_plus_mark_png extends lime.graphics.Image {}
@:keep @:image("C:/HaxeToolkit/haxe/lib/flixel-ui/2,3,2/assets/images/radio.png") @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_img_radio_png extends lime.graphics.Image {}
@:keep @:image("C:/HaxeToolkit/haxe/lib/flixel-ui/2,3,2/assets/images/radio_dot.png") @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_img_radio_dot_png extends lime.graphics.Image {}
@:keep @:image("C:/HaxeToolkit/haxe/lib/flixel-ui/2,3,2/assets/images/swatch.png") @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_img_swatch_png extends lime.graphics.Image {}
@:keep @:image("C:/HaxeToolkit/haxe/lib/flixel-ui/2,3,2/assets/images/tab.png") @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_img_tab_png extends lime.graphics.Image {}
@:keep @:image("C:/HaxeToolkit/haxe/lib/flixel-ui/2,3,2/assets/images/tab_back.png") @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_img_tab_back_png extends lime.graphics.Image {}
@:keep @:image("C:/HaxeToolkit/haxe/lib/flixel-ui/2,3,2/assets/images/tooltip_arrow.png") @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_img_tooltip_arrow_png extends lime.graphics.Image {}
@:keep @:file("C:/HaxeToolkit/haxe/lib/flixel-ui/2,3,2/assets/xml/defaults.xml") @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_xml_defaults_xml extends haxe.io.Bytes {}
@:keep @:file("C:/HaxeToolkit/haxe/lib/flixel-ui/2,3,2/assets/xml/default_loading_screen.xml") @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_xml_default_loading_screen_xml extends haxe.io.Bytes {}
@:keep @:file("C:/HaxeToolkit/haxe/lib/flixel-ui/2,3,2/assets/xml/default_popup.xml") @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_xml_default_popup_xml extends haxe.io.Bytes {}
@:keep @:file("") @:noCompletion #if display private #end class __ASSET__manifest_default_json extends haxe.io.Bytes {}



#else

@:keep @:expose('__ASSET__flixel_fonts_nokiafc22_ttf') @:noCompletion #if display private #end class __ASSET__flixel_fonts_nokiafc22_ttf extends lime.text.Font { public function new () { #if !html5 __fontPath = "flixel/fonts/nokiafc22"; #else ascender = 2048; descender = -512; height = 2816; numGlyphs = 172; underlinePosition = -640; underlineThickness = 256; unitsPerEM = 2048; #end name = "Nokia Cellphone FC Small"; super (); }}
@:keep @:expose('__ASSET__flixel_fonts_monsterrat_ttf') @:noCompletion #if display private #end class __ASSET__flixel_fonts_monsterrat_ttf extends lime.text.Font { public function new () { #if !html5 __fontPath = "flixel/fonts/monsterrat"; #else ascender = 968; descender = -251; height = 1219; numGlyphs = 263; underlinePosition = -150; underlineThickness = 50; unitsPerEM = 1000; #end name = "Monsterrat"; super (); }}


#end

#if (openfl && !flash)

#if html5
@:keep @:expose('__ASSET__OPENFL__flixel_fonts_nokiafc22_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__flixel_fonts_nokiafc22_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__flixel_fonts_nokiafc22_ttf ()); super (); }}
@:keep @:expose('__ASSET__OPENFL__flixel_fonts_monsterrat_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__flixel_fonts_monsterrat_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__flixel_fonts_monsterrat_ttf ()); super (); }}

#else
@:keep @:expose('__ASSET__OPENFL__flixel_fonts_nokiafc22_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__flixel_fonts_nokiafc22_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__flixel_fonts_nokiafc22_ttf ()); super (); }}
@:keep @:expose('__ASSET__OPENFL__flixel_fonts_monsterrat_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__flixel_fonts_monsterrat_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__flixel_fonts_monsterrat_ttf ()); super (); }}

#end

#end
#end

#end
