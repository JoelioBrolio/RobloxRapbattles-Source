package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.5.1'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	
	var optionShit:Array<String> = [
		'story_mode',
		'freeplay',
		//#if MODS_ALLOWED 'mods', #end
		//#if ACHIEVEMENTS_ALLOWED 'awards', #end
		//'credits',
		//#if !switch 'donate', #end
		'options',
		'awards',
		'credits'
	];

	var magenta:FlxSprite;
	var crossroadsAd1:FlxSprite;
	var crossroadsAd2:FlxSprite;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var debugKeys:Array<FlxKey>;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement);
		FlxCamera.defaultCameras = [camGame];

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('bloxbg-desat'));
		bg.scrollFactor.set(0, 0);
		bg.setGraphicSize(Std.int(bg.width * 0.8));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('bloxbg-desat'));
		magenta.scrollFactor.set(0, 0);
		magenta.setGraphicSize(Std.int(magenta.width * 0.8));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = ClientPrefs.globalAntialiasing;
		magenta.color = 0xFFfd719b;
		add(magenta);
		// magenta.scrollFactor.set();

		var headerBlox:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('menuheader', 'shared'));
		headerBlox.setGraphicSize(Std.int(headerBlox.width * 0.6));
		headerBlox.scrollFactor.set(0, 0);
		headerBlox.antialiasing = ClientPrefs.globalAntialiasing;
		headerBlox.updateHitbox();
		add(headerBlox);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var scale:Float = 0.35;
		var headerScale:Float = 0.6;
		/*if(optionShit.length > 6) {
			scale = 6 / optionShit.length;
		}*/

		//for (i in 0...optionShit.length)
		//{
			//var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
			//var menuItem:FlxSprite = new FlxSprite(0, (i * 140)  + offset);
			//menuItem.scale.x = scale;
			//menuItem.scale.y = scale;
			//menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
			//menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			//menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			//menuItem.animation.play('idle');
			//menuItem.ID = i;
			//menuItem.screenCenter(X);
			//menuItems.add(menuItem);
			//var scr:Float = (optionShit.length - 4) * 0.135;
			//if(optionShit.length < 6) scr = 0;
			//menuItem.scrollFactor.set(0, scr);
			//menuItem.antialiasing = ClientPrefs.globalAntialiasing;
			//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
			//menuItem.updateHitbox();
		//}

		var storyMenuItem:FlxSprite = new FlxSprite(0, 255);
		storyMenuItem.scale.x = scale;
		storyMenuItem.scale.y = scale;
		storyMenuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_story_mode_blox');
		storyMenuItem.animation.addByPrefix('idle', "story_mode_blox" + " basic", 24);
		storyMenuItem.animation.addByPrefix('selected', "story_mode_blox" + " white", 24);
		storyMenuItem.animation.play('idle');
		storyMenuItem.screenCenter(X);
		storyMenuItem.ID = 0;
		menuItems.add(storyMenuItem);
		storyMenuItem.scrollFactor.set(0, 0);
		storyMenuItem.antialiasing = ClientPrefs.globalAntialiasing;
		storyMenuItem.updateHitbox();

		var freeplayMenuItem:FlxSprite = new FlxSprite(0, 400);
		freeplayMenuItem.scale.x = scale;
		freeplayMenuItem.scale.y = scale;
		freeplayMenuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_freeplay_blox');
		freeplayMenuItem.animation.addByPrefix('idle', "freeplay_blox" + " basic", 24);
		freeplayMenuItem.animation.addByPrefix('selected', "freeplay_blox" + " white", 24);
		freeplayMenuItem.animation.play('idle');
		freeplayMenuItem.screenCenter(X);
		freeplayMenuItem.ID = 1;
		menuItems.add(freeplayMenuItem);
		freeplayMenuItem.scrollFactor.set(0, 0);
		freeplayMenuItem.antialiasing = ClientPrefs.globalAntialiasing;
		freeplayMenuItem.updateHitbox();

		var optionsMenuItem:FlxSprite = new FlxSprite(0, 545);
		optionsMenuItem.scale.x = scale;
		optionsMenuItem.scale.y = scale;
		optionsMenuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_options_blox');
		optionsMenuItem.animation.addByPrefix('idle', "options_blox" + " basic", 24);
		optionsMenuItem.animation.addByPrefix('selected', "options_blox" + " white", 24);
		optionsMenuItem.animation.play('idle');
		optionsMenuItem.screenCenter(X);
		optionsMenuItem.ID = 2;
		menuItems.add(optionsMenuItem);
		optionsMenuItem.scrollFactor.set(0, 0);
		optionsMenuItem.antialiasing = ClientPrefs.globalAntialiasing;
		optionsMenuItem.updateHitbox();

		var achievementsMenuItem:FlxSprite = new FlxSprite(50, 0);
		achievementsMenuItem.scale.x = headerScale;
		achievementsMenuItem.scale.y = headerScale;
		achievementsMenuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_achievements_blox');
		achievementsMenuItem.animation.addByPrefix('idle', "achievements_blox" + " basic", 24);
		achievementsMenuItem.animation.addByPrefix('selected', "achievements_blox" + " white", 24);
		achievementsMenuItem.animation.play('idle');
		achievementsMenuItem.x -= 50;
		achievementsMenuItem.ID = 3;
		menuItems.add(achievementsMenuItem);
		achievementsMenuItem.scrollFactor.set(0, 0);
		achievementsMenuItem.antialiasing = ClientPrefs.globalAntialiasing;
		achievementsMenuItem.updateHitbox();

		var creditsMenuItem:FlxSprite = new FlxSprite(50, 0);
		creditsMenuItem.scale.x = headerScale;
		creditsMenuItem.scale.y = headerScale;
		creditsMenuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_credits_blox');
		creditsMenuItem.animation.addByPrefix('idle', "credits_blox" + " basic", 24);
		creditsMenuItem.animation.addByPrefix('selected', "credits_blox" + " white", 24);
		creditsMenuItem.animation.play('idle');
		creditsMenuItem.x -= 50;
		creditsMenuItem.ID = 4;
		menuItems.add(creditsMenuItem);
		creditsMenuItem.scrollFactor.set(0, 0);
		creditsMenuItem.antialiasing = ClientPrefs.globalAntialiasing;
		creditsMenuItem.updateHitbox();

		crossroadsAd1 = new FlxSprite(20, 110).loadGraphic(Paths.image('crossroadsad', 'shared'));
		crossroadsAd1.setGraphicSize(Std.int(crossroadsAd1.width * 0.45));
		crossroadsAd1.scrollFactor.set(0, 0);
		crossroadsAd1.antialiasing = ClientPrefs.globalAntialiasing;
		crossroadsAd1.updateHitbox();
		add(crossroadsAd1);
		
		crossroadsAd2 = new FlxSprite(960, 110).loadGraphic(Paths.image('crossroadsad', 'shared'));
		crossroadsAd2.setGraphicSize(Std.int(crossroadsAd2.width * 0.45));
		crossroadsAd2.scrollFactor.set(0, 0);
		crossroadsAd2.antialiasing = ClientPrefs.globalAntialiasing;
		crossroadsAd2.updateHitbox();
		add(crossroadsAd2);

		var bfProfile:FlxSprite = new FlxSprite(380, 30).loadGraphic(Paths.image('bfprofile', 'shared'));
		bfProfile.setGraphicSize(Std.int(bfProfile.width * 0.4));
		bfProfile.scrollFactor.set(0, 0);
		bfProfile.antialiasing = ClientPrefs.globalAntialiasing;
		bfProfile.updateHitbox();
		add(bfProfile);

		FlxG.camera.follow(camFollowPos, null, 1);

		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "Psych Engine v" + psychEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
		var leDate = Date.now();
		var achieveID:Int = Achievements.getAchievementIndex('welcome_roblox');
		if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])) { //It's a friday night. WEEEEEEEEEEEEEEEEEE
			Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
			giveAchievement();
			ClientPrefs.saveSettings();
		}
		#end

		super.create();
	}

	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	function giveAchievement() {
		add(new AchievementObject('welcome_roblox', camAchievement));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('Giving achievement "welcome_roblox"');
	}
	#end

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if (!selectedSomethin)
		{
			if (curSelected <= 2)
			{
				if (controls.UI_UP_P)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeItem(-1);
				}
			}
			else
			{
				if (curSelected == 4)
				{
					if (controls.UI_LEFT_P)
					{
						FlxG.sound.play(Paths.sound('scrollMenu'));
						changeItem(-1);
					}
				}
			}

			if (curSelected != 2 && curSelected < 2)
			{
				if (controls.UI_DOWN_P)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeItem(1);
				}
			}
			else if (curSelected > 2)
			{
				if (curSelected != 4)
				{
					if (controls.UI_RIGHT_P)
					{
						FlxG.sound.play(Paths.sound('scrollMenu'));
						changeItem(1);
					}
				}
				
				if (curSelected == 3)
				{
					if (controls.UI_DOWN_P)
					{
						FlxG.sound.play(Paths.sound('scrollMenu'));
						changeItem(-3);
					}
				}
				if (curSelected == 4)
				{
					if (controls.UI_DOWN_P)
					{
						FlxG.sound.play(Paths.sound('scrollMenu'));
						changeItem(-4);
					}
				}
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					if(ClientPrefs.flashing) FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							if (spr.ID != 3 && spr.ID != 4)
							{
								FlxTween.tween(spr, {alpha: 0}, 0.4, {
									ease: FlxEase.quadOut,
									onComplete: function(twn:FlxTween)
									{
										spr.kill();
									}
								});
							}
						}
						else
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'story_mode':
										MusicBeatState.switchState(new StoryMenuState());
									case 'freeplay':
										MusicBeatState.switchState(new FreeplayState());
									#if MODS_ALLOWED
									case 'mods':
										MusicBeatState.switchState(new ModsMenuState());
									#end
									case 'awards':
										MusicBeatState.switchState(new AchievementsMenuState());
									case 'credits':
										MusicBeatState.switchState(new CreditsState());
									case 'options':
										MusicBeatState.switchState(new options.OptionsState());
								}
							});
						}
					});
				}
			}
			#if desktop
			else if (FlxG.keys.anyJustPressed(debugKeys))
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			if (spr.ID != 3 && spr.ID != 4)
			{
				spr.screenCenter(X);
			}
			if (spr.ID != curSelected)
			{
				if (spr.ID < 3)
				{
					FlxTween.cancelTweensOf(spr);

					spr.scale.set(0.35, 0.35);
					spr.centerOffsets();
					spr.updateHitbox();
				}
				else
				{
					FlxTween.cancelTweensOf(spr);

					spr.x = 0;
					spr.y = 0;
					spr.scale.set(0.6, 0.6);
					spr.centerOffsets();
					spr.updateHitbox();
				}
			}
		});

		//var mult:Float = FlxMath.lerp(1, crossroadsAd1.scale.x, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
		//crossroadsAd1.scale.set(mult, mult);
		//crossroadsAd1.updateHitbox();

		//var mult:Float = FlxMath.lerp(1, crossroadsAd2.scale.x, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
		//crossroadsAd2.scale.set(mult, mult);
		//crossroadsAd2.updateHitbox();
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = 3;

		menuItems.forEach(function(spr:FlxSprite)
		{
			FlxTween.cancelTweensOf(spr);

			spr.animation.play('idle');
			spr.scale.set(0.35, 0.35);
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				if (spr.ID < 3)
				{
					FlxTween.tween(spr, {"scale.x": 0.4, "scale.y": 0.4}, 0.2, {ease: FlxEase.elasticInOut});
				}
				else
				{
					FlxTween.tween(spr, {x: 170, y: 105, "scale.x": 0.65, "scale.y": 0.65}, 0.2, {ease: FlxEase.elasticInOut});
				}
				var add:Float = 0;
				if(menuItems.length > 4) {
					add = menuItems.length * 8;
				}
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y - add);
				spr.centerOffsets();
				spr.updateHitbox();
			}
			else if (spr.ID < 3)
			{
				FlxTween.cancelTweensOf(spr);

				spr.scale.set(0.35, 0.35);
				spr.centerOffsets();
				spr.updateHitbox();
			}
			else
			{
				FlxTween.cancelTweensOf(spr);

				spr.x = 0;
				spr.y = 0;
				spr.scale.set(0.6, 0.6);
				spr.centerOffsets();
				spr.updateHitbox();
			}
		});
	}
}
