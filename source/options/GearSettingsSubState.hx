package options;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;

using StringTools;

class GearSettingsSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Gear';
		rpcTitle = 'Gear Settings Menu'; //for Discord Rich Presence

		var option:Option = new Option('Perfect Mode',
			'When checked, missing a note means instant death.',
			'perfectGear',
			'bool',
			false);
		option.showPerfect = true;
		addOption(option);

		var option:Option = new Option('Health Drain',
			'When checked, your health will deplete slowly during gameplay.',
			'drainGear',
			'bool',
			false);
		option.showDrain = true;
		addOption(option);

		var option:Option = new Option('Enemy Attacks',
			'When checked, when an enemy hits a note, you will lose health.',
			'enemyGear',
			'bool',
			false);
		option.showEnemy = true;
		addOption(option);

		var option:Option = new Option('Transparent Notes',
			'When checked, notes in gameplay will be transparent.',
			'transparentGear',
			'bool',
			false);
		option.showTransparent = true;
		addOption(option);
		super();
	}
}