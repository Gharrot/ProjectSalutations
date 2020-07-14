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

		data = '{"name":null,"assets":"aoy4:sizezy4:typey4:TEXTy9:classNamey39:__ASSET__assets_data_data_goes_here_txty2:idy34:assets%2Fdata%2Fdata-goes-here.txtgoR0i929R1y6:BINARYR3y47:__ASSET__assets_images_browndownbutton_asepriteR5y42:assets%2Fimages%2FBrownDownButton.asepritegoR0i506R1y5:IMAGER3y42:__ASSET__assets_images_browndownbutton_pngR5y37:assets%2Fimages%2FBrownDownButton.pnggoR0i935R1R7R3y45:__ASSET__assets_images_brownupbutton_asepriteR5y40:assets%2Fimages%2FBrownUpButton.asepritegoR0i472R1R10R3y40:__ASSET__assets_images_brownupbutton_pngR5y35:assets%2Fimages%2FBrownUpButton.pnggoR0i1775R1R7R3y51:__ASSET__assets_images_charactercreationbg_asepriteR5y46:assets%2Fimages%2FCharacterCreationBG.asepritegoR0i2583R1R10R3y46:__ASSET__assets_images_charactercreationbg_pngR5y41:assets%2Fimages%2FCharacterCreationBG.pnggoR0i593R1R10R3y35:__ASSET__assets_images_checkbox_pngR5y30:assets%2Fimages%2FCheckbox.pnggoR0i428R1R10R3y42:__ASSET__assets_images_checkedcheckbox_pngR5y37:assets%2Fimages%2FCheckedCheckbox.pnggoR0i1818R1R10R3y42:__ASSET__assets_images_confirmationbox_pngR5y37:assets%2Fimages%2FConfirmationBox.pnggoR0i2345R1R10R3y39:__ASSET__assets_images_deerscreenbg_pngR5y34:assets%2Fimages%2FDeerScreenBG.pnggoR0i653R1R10R3y41:__ASSET__assets_images_deertilesprite_pngR5y36:assets%2Fimages%2FDeerTileSprite.pnggoR0i473R1R10R3y47:__ASSET__assets_images_deertilespriteborder_pngR5y42:assets%2Fimages%2FDeerTileSpriteBorder.pnggoR0i629R1R7R3y64:__ASSET__assets_images_deertilesprites_healthmarkerlime_asepriteR5y61:assets%2Fimages%2FDeerTileSprites%2FHealthMarkerLime.asepritegoR0i195R1R10R3y59:__ASSET__assets_images_deertilesprites_healthmarkerlime_pngR5y56:assets%2Fimages%2FDeerTileSprites%2FHealthMarkerLime.pnggoR0i629R1R7R3y66:__ASSET__assets_images_deertilesprites_healthmarkerorange_asepriteR5y63:assets%2Fimages%2FDeerTileSprites%2FHealthMarkerOrange.asepritegoR0i197R1R10R3y61:__ASSET__assets_images_deertilesprites_healthmarkerorange_pngR5y58:assets%2Fimages%2FDeerTileSprites%2FHealthMarkerOrange.pnggoR0i631R1R7R3y63:__ASSET__assets_images_deertilesprites_healthmarkerred_asepriteR5y60:assets%2Fimages%2FDeerTileSprites%2FHealthMarkerRed.asepritegoR0i198R1R10R3y58:__ASSET__assets_images_deertilesprites_healthmarkerred_pngR5y55:assets%2Fimages%2FDeerTileSprites%2FHealthMarkerRed.pnggoR0i521R1R7R3y71:__ASSET__assets_images_deertilesprites_healthmarkertransparent_asepriteR5y68:assets%2Fimages%2FDeerTileSprites%2FHealthMarkerTransparent.asepritegoR0i87R1R10R3y66:__ASSET__assets_images_deertilesprites_healthmarkertransparent_pngR5y63:assets%2Fimages%2FDeerTileSprites%2FHealthMarkerTransparent.pnggoR0i629R1R7R3y66:__ASSET__assets_images_deertilesprites_healthmarkeryellow_asepriteR5y63:assets%2Fimages%2FDeerTileSprites%2FHealthMarkerYellow.asepritegoR0i197R1R10R3y61:__ASSET__assets_images_deertilesprites_healthmarkeryellow_pngR5y58:assets%2Fimages%2FDeerTileSprites%2FHealthMarkerYellow.pnggoR0i197R1R10R3y66:__ASSET__assets_images_deertilesprites_healthmarkeryellowgreen_pngR5y63:assets%2Fimages%2FDeerTileSprites%2FHealthMarkerYellowGreen.pnggoR0i457R1R10R3y36:__ASSET__assets_images_denbutton_pngR5y31:assets%2Fimages%2FDenButton.pnggoR0i268R1R10R3y42:__ASSET__assets_images_denbuttonstatic_pngR5y37:assets%2Fimages%2FDenButtonStatic.pnggoR0i1067R1R10R3y40:__ASSET__assets_images_emptydeertile_pngR5y35:assets%2Fimages%2FEmptyDeerTile.pnggoR0i721R1R10R3y40:__ASSET__assets_images_explorebutton_pngR5y35:assets%2Fimages%2FExploreButton.pnggoR0i3215R1R10R3y37:__ASSET__assets_images_femaledeer_pngR5y32:assets%2Fimages%2FFemaleDeer.pnggoR0i884R1R10R3y39:__ASSET__assets_images_femalesprite_pngR5y34:assets%2Fimages%2FFemaleSprite.pnggoR0i410R1R10R3y37:__ASSET__assets_images_herdbutton_pngR5y32:assets%2Fimages%2FHerdButton.pnggoR0i280R1R10R3y45:__ASSET__assets_images_herdbuttonselected_pngR5y40:assets%2Fimages%2FHerdButtonSelected.pnggoR0zR1R2R3y41:__ASSET__assets_images_images_go_here_txtR5y36:assets%2Fimages%2Fimages-go-here.txtgoR0i957R1R10R3y37:__ASSET__assets_images_leftbutton_pngR5y32:assets%2Fimages%2FLeftButton.pnggoR0i2538R1R7R3y57:__ASSET__assets_images_locationimages_abandonedfields_aseR5y54:assets%2Fimages%2FLocationImages%2FAbandonedFields.asegoR0i2860R1R10R3y57:__ASSET__assets_images_locationimages_abandonedfields_pngR5y54:assets%2Fimages%2FLocationImages%2FAbandonedFields.pnggoR0i216R1R10R3y63:__ASSET__assets_images_locationimages_currentlocationmarker_pngR5y60:assets%2Fimages%2FLocationImages%2FCurrentLocationMarker.pnggoR0i919R1R10R3y52:__ASSET__assets_images_locationimages_darkforest_pngR5y49:assets%2Fimages%2FLocationImages%2FDarkForest.pnggoR0i855R1R10R3y65:__ASSET__assets_images_locationimages_darkforestemptydeertile_pngR5y62:assets%2Fimages%2FLocationImages%2FDarkForestEmptyDeerTile.pnggoR0i821R1R10R3y59:__ASSET__assets_images_locationimages_darkforestnoframe_pngR5y56:assets%2Fimages%2FLocationImages%2FDarkForestNoFrame.pnggoR0i910R1R10R3y56:__ASSET__assets_images_locationimages_forgottenwoods_pngR5y53:assets%2Fimages%2FLocationImages%2FForgottenWoods.pnggoR0i855R1R10R3y69:__ASSET__assets_images_locationimages_forgottenwoodsemptydeertile_pngR5y66:assets%2Fimages%2FLocationImages%2FForgottenWoodsEmptyDeerTile.pnggoR0i824R1R10R3y63:__ASSET__assets_images_locationimages_forgottenwoodsnoframe_pngR5y60:assets%2Fimages%2FLocationImages%2FForgottenWoodsNoFrame.pnggoR0i329R1R10R3y56:__ASSET__assets_images_locationimages_locationbutton_pngR5y53:assets%2Fimages%2FLocationImages%2FLocationButton.pnggoR0i5805R1R7R3y51:__ASSET__assets_images_locationimages_mapdesign_aseR5y48:assets%2Fimages%2FLocationImages%2FMapDesign.asegoR0i2893R1R10R3y50:__ASSET__assets_images_locationimages_mapwoods_pngR5y47:assets%2Fimages%2FLocationImages%2FMapWoods.pnggoR0i2593R1R10R3y37:__ASSET__assets_images_mainmenubg_pngR5y32:assets%2Fimages%2FmainMenuBg.pnggoR0i2467R1R10R3y35:__ASSET__assets_images_maledeer_pngR5y30:assets%2Fimages%2FMaleDeer.pnggoR0i1023R1R10R3y45:__ASSET__assets_images_maledeertilesprite_pngR5y40:assets%2Fimages%2FMaleDeerTileSprite.pnggoR0i717R1R10R3y37:__ASSET__assets_images_malesprite_pngR5y32:assets%2Fimages%2FMaleSprite.pnggoR0i414R1R10R3y36:__ASSET__assets_images_mapbutton_pngR5y31:assets%2Fimages%2FMapButton.pnggoR0i284R1R10R3y44:__ASSET__assets_images_mapbuttonselected_pngR5y39:assets%2Fimages%2FMapButtonSelected.pnggoR0i216R1R10R3y58:__ASSET__assets_images_mapimages_currentlocationmarker_pngR5y55:assets%2Fimages%2FMapImages%2FCurrentLocationMarker.pnggoR0i330R1R10R3y51:__ASSET__assets_images_mapimages_locationbutton_pngR5y48:assets%2Fimages%2FMapImages%2FLocationButton.pnggoR0i4811R1R7R3y46:__ASSET__assets_images_mapimages_mapdesign_aseR5y43:assets%2Fimages%2FMapImages%2FMapDesign.asegoR0i2893R1R10R3y45:__ASSET__assets_images_mapimages_mapwoods_pngR5y42:assets%2Fimages%2FMapImages%2FMapWoods.pnggoR0i216R1R10R3y56:__ASSET__assets_images_mapimages_unreachablelocation_pngR5y53:assets%2Fimages%2FMapImages%2FUnreachableLocation.pnggoR0i906R1R10R3y57:__ASSET__assets_images_medallions_darkforestmedallion_pngR5y54:assets%2Fimages%2FMedallions%2FDarkForestMedallion.pnggoR0i898R1R10R3y61:__ASSET__assets_images_medallions_forgottenwoodsmedallion_pngR5y58:assets%2Fimages%2FMedallions%2FForgottenWoodsMedallion.pnggoR0i214R1R10R3y38:__ASSET__assets_images_minusbutton_pngR5y33:assets%2Fimages%2FMinusButton.pnggoR0i3357R1R7R3y37:__ASSET__assets_images_octabutton_aseR5y32:assets%2Fimages%2FOctaButton.asegoR0i1680R1R10R3y37:__ASSET__assets_images_octabutton_pngR5y32:assets%2Fimages%2FOctaButton.pnggoR0i3319R1R7R3y43:__ASSET__assets_images_octabuttonskinny_aseR5y38:assets%2Fimages%2FOctaButtonSkinny.asegoR0i1786R1R10R3y43:__ASSET__assets_images_octabuttonskinny_pngR5y38:assets%2Fimages%2FOctaButtonSkinny.pnggoR0i517R1R10R3y41:__ASSET__assets_images_passtimebutton_pngR5y36:assets%2Fimages%2FPassTimeButton.pnggoR0i333R1R10R3y47:__ASSET__assets_images_passtimebuttonstatic_pngR5y42:assets%2Fimages%2FPassTimeButtonStatic.pnggoR0i236R1R10R3y37:__ASSET__assets_images_plusbutton_pngR5y32:assets%2Fimages%2FPlusButton.pnggoR0i978R1R10R3y38:__ASSET__assets_images_rightbutton_pngR5y33:assets%2Fimages%2FRightButton.pnggoR0i491R1R10R3y43:__ASSET__assets_images_staticleftbutton_pngR5y38:assets%2Fimages%2FStaticLeftButton.pnggoR0i435R1R10R3y44:__ASSET__assets_images_staticrightbutton_pngR5y39:assets%2Fimages%2FStaticRightButton.pnggoR0i405R1R10R3y39:__ASSET__assets_images_statusbutton_pngR5y34:assets%2Fimages%2FStatusButton.pnggoR0i276R1R10R3y47:__ASSET__assets_images_statusbuttonselected_pngR5y42:assets%2Fimages%2FStatusButtonSelected.pnggoR0i2585R1R10R3y40:__ASSET__assets_images_transparentbg_pngR5y35:assets%2Fimages%2FTransparentBG.pnggoR0i1135R1R10R3y34:__ASSET__assets_images_xbutton_pngR5y29:assets%2Fimages%2FXButton.pnggoR0zR1R2R3y41:__ASSET__assets_music_music_goes_here_txtR5y36:assets%2Fmusic%2Fmusic-goes-here.txtgoR0zR1R2R3y41:__ASSET__assets_sounds_sounds_go_here_txtR5y36:assets%2Fsounds%2Fsounds-go-here.txtgoR0i2114R1y5:MUSICR3y31:__ASSET__flixel_sounds_beep_mp3R5y26:flixel%2Fsounds%2Fbeep.mp3goR0i39706R1R159R3y33:__ASSET__flixel_sounds_flixel_mp3R5y28:flixel%2Fsounds%2Fflixel.mp3goR0i15744R1y4:FONTR3y35:__ASSET__flixel_fonts_nokiafc22_ttfR5y30:flixel%2Ffonts%2Fnokiafc22.ttfgoR0i29724R1R164R3y36:__ASSET__flixel_fonts_monsterrat_ttfR5y31:flixel%2Ffonts%2Fmonsterrat.ttfgoR0i519R1R10R3y36:__ASSET__flixel_images_ui_button_pngR5y33:flixel%2Fimages%2Fui%2Fbutton.pnggoR0i3280R1R10R3y39:__ASSET__flixel_images_logo_default_pngR5y36:flixel%2Fimages%2Flogo%2Fdefault.pnggoR0i912R1R10R3y37:__ASSET__flixel_flixel_ui_img_box_pngR5y34:flixel%2Fflixel-ui%2Fimg%2Fbox.pnggoR0i433R1R10R3y40:__ASSET__flixel_flixel_ui_img_button_pngR5y37:flixel%2Fflixel-ui%2Fimg%2Fbutton.pnggoR0i446R1R10R3y51:__ASSET__flixel_flixel_ui_img_button_arrow_down_pngR5y48:flixel%2Fflixel-ui%2Fimg%2Fbutton_arrow_down.pnggoR0i459R1R10R3y51:__ASSET__flixel_flixel_ui_img_button_arrow_left_pngR5y48:flixel%2Fflixel-ui%2Fimg%2Fbutton_arrow_left.pnggoR0i511R1R10R3y52:__ASSET__flixel_flixel_ui_img_button_arrow_right_pngR5y49:flixel%2Fflixel-ui%2Fimg%2Fbutton_arrow_right.pnggoR0i493R1R10R3y49:__ASSET__flixel_flixel_ui_img_button_arrow_up_pngR5y46:flixel%2Fflixel-ui%2Fimg%2Fbutton_arrow_up.pnggoR0i247R1R10R3y45:__ASSET__flixel_flixel_ui_img_button_thin_pngR5y42:flixel%2Fflixel-ui%2Fimg%2Fbutton_thin.pnggoR0i534R1R10R3y47:__ASSET__flixel_flixel_ui_img_button_toggle_pngR5y44:flixel%2Fflixel-ui%2Fimg%2Fbutton_toggle.pnggoR0i922R1R10R3y43:__ASSET__flixel_flixel_ui_img_check_box_pngR5y40:flixel%2Fflixel-ui%2Fimg%2Fcheck_box.pnggoR0i946R1R10R3y44:__ASSET__flixel_flixel_ui_img_check_mark_pngR5y41:flixel%2Fflixel-ui%2Fimg%2Fcheck_mark.pnggoR0i253R1R10R3y40:__ASSET__flixel_flixel_ui_img_chrome_pngR5y37:flixel%2Fflixel-ui%2Fimg%2Fchrome.pnggoR0i212R1R10R3y45:__ASSET__flixel_flixel_ui_img_chrome_flat_pngR5y42:flixel%2Fflixel-ui%2Fimg%2Fchrome_flat.pnggoR0i192R1R10R3y46:__ASSET__flixel_flixel_ui_img_chrome_inset_pngR5y43:flixel%2Fflixel-ui%2Fimg%2Fchrome_inset.pnggoR0i214R1R10R3y46:__ASSET__flixel_flixel_ui_img_chrome_light_pngR5y43:flixel%2Fflixel-ui%2Fimg%2Fchrome_light.pnggoR0i156R1R10R3y47:__ASSET__flixel_flixel_ui_img_dropdown_mark_pngR5y44:flixel%2Fflixel-ui%2Fimg%2Fdropdown_mark.pnggoR0i1724R1R10R3y44:__ASSET__flixel_flixel_ui_img_finger_big_pngR5y41:flixel%2Fflixel-ui%2Fimg%2Ffinger_big.pnggoR0i294R1R10R3y46:__ASSET__flixel_flixel_ui_img_finger_small_pngR5y43:flixel%2Fflixel-ui%2Fimg%2Ffinger_small.pnggoR0i129R1R10R3y41:__ASSET__flixel_flixel_ui_img_hilight_pngR5y38:flixel%2Fflixel-ui%2Fimg%2Fhilight.pnggoR0i128R1R10R3y39:__ASSET__flixel_flixel_ui_img_invis_pngR5y36:flixel%2Fflixel-ui%2Fimg%2Finvis.pnggoR0i136R1R10R3y44:__ASSET__flixel_flixel_ui_img_minus_mark_pngR5y41:flixel%2Fflixel-ui%2Fimg%2Fminus_mark.pnggoR0i147R1R10R3y43:__ASSET__flixel_flixel_ui_img_plus_mark_pngR5y40:flixel%2Fflixel-ui%2Fimg%2Fplus_mark.pnggoR0i191R1R10R3y39:__ASSET__flixel_flixel_ui_img_radio_pngR5y36:flixel%2Fflixel-ui%2Fimg%2Fradio.pnggoR0i153R1R10R3y43:__ASSET__flixel_flixel_ui_img_radio_dot_pngR5y40:flixel%2Fflixel-ui%2Fimg%2Fradio_dot.pnggoR0i185R1R10R3y40:__ASSET__flixel_flixel_ui_img_swatch_pngR5y37:flixel%2Fflixel-ui%2Fimg%2Fswatch.pnggoR0i201R1R10R3y37:__ASSET__flixel_flixel_ui_img_tab_pngR5y34:flixel%2Fflixel-ui%2Fimg%2Ftab.pnggoR0i210R1R10R3y42:__ASSET__flixel_flixel_ui_img_tab_back_pngR5y39:flixel%2Fflixel-ui%2Fimg%2Ftab_back.pnggoR0i18509R1R10R3y47:__ASSET__flixel_flixel_ui_img_tooltip_arrow_pngR5y44:flixel%2Fflixel-ui%2Fimg%2Ftooltip_arrow.pnggoR0i1263R1R2R3y42:__ASSET__flixel_flixel_ui_xml_defaults_xmlR5y39:flixel%2Fflixel-ui%2Fxml%2Fdefaults.xmlgoR0i1953R1R2R3y56:__ASSET__flixel_flixel_ui_xml_default_loading_screen_xmlR5y53:flixel%2Fflixel-ui%2Fxml%2Fdefault_loading_screen.xmlgoR0i1848R1R2R3y47:__ASSET__flixel_flixel_ui_xml_default_popup_xmlR5y44:flixel%2Fflixel-ui%2Fxml%2Fdefault_popup.xmlgh","rootPath":null,"version":2,"libraryArgs":[],"libraryType":null}';
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

@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_data_goes_here_txt extends flash.utils.ByteArray { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_browndownbutton_aseprite extends flash.utils.ByteArray { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_browndownbutton_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_brownupbutton_aseprite extends flash.utils.ByteArray { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_brownupbutton_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_charactercreationbg_aseprite extends flash.utils.ByteArray { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_charactercreationbg_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_checkbox_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_checkedcheckbox_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_confirmationbox_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_deerscreenbg_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_deertilesprite_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_deertilespriteborder_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_deertilesprites_healthmarkerlime_aseprite extends flash.utils.ByteArray { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_deertilesprites_healthmarkerlime_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_deertilesprites_healthmarkerorange_aseprite extends flash.utils.ByteArray { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_deertilesprites_healthmarkerorange_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_deertilesprites_healthmarkerred_aseprite extends flash.utils.ByteArray { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_deertilesprites_healthmarkerred_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_deertilesprites_healthmarkertransparent_aseprite extends flash.utils.ByteArray { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_deertilesprites_healthmarkertransparent_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_deertilesprites_healthmarkeryellow_aseprite extends flash.utils.ByteArray { }
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
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_images_go_here_txt extends flash.utils.ByteArray { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_leftbutton_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_locationimages_abandonedfields_ase extends flash.utils.ByteArray { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_locationimages_abandonedfields_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_locationimages_currentlocationmarker_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_locationimages_darkforest_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_locationimages_darkforestemptydeertile_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_locationimages_darkforestnoframe_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_locationimages_forgottenwoods_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_locationimages_forgottenwoodsemptydeertile_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_locationimages_forgottenwoodsnoframe_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_locationimages_locationbutton_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_locationimages_mapdesign_ase extends flash.utils.ByteArray { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_locationimages_mapwoods_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_mainmenubg_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_maledeer_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_maledeertilesprite_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_malesprite_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_mapbutton_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_mapbuttonselected_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_mapimages_currentlocationmarker_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_mapimages_locationbutton_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_mapimages_mapdesign_ase extends flash.utils.ByteArray { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_mapimages_mapwoods_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_mapimages_unreachablelocation_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_medallions_darkforestmedallion_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_medallions_forgottenwoodsmedallion_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_minusbutton_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_octabutton_ase extends flash.utils.ByteArray { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_octabutton_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_octabuttonskinny_ase extends flash.utils.ByteArray { }
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
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_music_music_goes_here_txt extends flash.utils.ByteArray { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sounds_sounds_go_here_txt extends flash.utils.ByteArray { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_sounds_beep_mp3 extends flash.media.Sound { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_sounds_flixel_mp3 extends flash.media.Sound { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_fonts_nokiafc22_ttf extends flash.text.Font { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_fonts_monsterrat_ttf extends flash.text.Font { }
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
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_xml_defaults_xml extends flash.utils.ByteArray { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_xml_default_loading_screen_xml extends flash.utils.ByteArray { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_flixel_ui_xml_default_popup_xml extends flash.utils.ByteArray { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__manifest_default_json extends flash.utils.ByteArray { }


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
@:keep @:font("C:/HaxeToolkit/haxe/lib/flixel/4,6,3/assets/fonts/nokiafc22.ttf") @:noCompletion #if display private #end class __ASSET__flixel_fonts_nokiafc22_ttf extends lime.text.Font {}
@:keep @:font("C:/HaxeToolkit/haxe/lib/flixel/4,6,3/assets/fonts/monsterrat.ttf") @:noCompletion #if display private #end class __ASSET__flixel_fonts_monsterrat_ttf extends lime.text.Font {}
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

@:keep @:expose('__ASSET__flixel_fonts_nokiafc22_ttf') @:noCompletion #if display private #end class __ASSET__flixel_fonts_nokiafc22_ttf extends lime.text.Font { public function new () { #if !html5 __fontPath = "flixel/fonts/nokiafc22.ttf"; #else ascender = null; descender = null; height = null; numGlyphs = null; underlinePosition = null; underlineThickness = null; unitsPerEM = null; #end name = "Nokia Cellphone FC Small"; super (); }}
@:keep @:expose('__ASSET__flixel_fonts_monsterrat_ttf') @:noCompletion #if display private #end class __ASSET__flixel_fonts_monsterrat_ttf extends lime.text.Font { public function new () { #if !html5 __fontPath = "flixel/fonts/monsterrat.ttf"; #else ascender = null; descender = null; height = null; numGlyphs = null; underlinePosition = null; underlineThickness = null; unitsPerEM = null; #end name = "Monsterrat"; super (); }}


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
