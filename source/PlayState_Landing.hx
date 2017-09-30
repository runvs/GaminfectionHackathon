package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

/**
 * ...
 * @author 
 */
class PlayState_Landing extends FlxState
{

	private var soldier : FlxSprite;
	private var overlay : FlxSprite;
	
	private var ending : Bool = false;
	
	private var vignette : Vignette;
	
	override public function create() 
	{
		super.create();
		
		var backgroundSprite : FlxSprite = new FlxSprite(0, 0);
		backgroundSprite.loadGraphic(AssetPaths.background__png, false, 200, 150);
		backgroundSprite.origin.set();
		backgroundSprite.scale.set(4, 4);
		add(backgroundSprite);
		
		var platform : FlxSprite = new FlxSprite(0, 500);
		platform.makeGraphic(FlxG.width, 300, FlxColor.BLACK);
		add(platform);
		
		
		soldier = new FlxSprite(400 - 24 * 2, -100);
		
		soldier.loadGraphic(AssetPaths.Soldier__png, true, 24, 24);
		soldier.scale.set(4, 4);
		
		
		soldier.animation.add("fall", [ 26, 27, 28, 29, 30, 31, 32, 33], 8);
		soldier.animation.add("land", [ 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44], 8);
		soldier.animation.add("idle", [ 0,1,2,3,4], 5);
		soldier.animation.play("fall");
		add(soldier);
		
		
		
		overlay = new FlxSprite();
		overlay.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		overlay.alpha = 0;
		add(overlay);
		
		vignette = new Vignette(FlxG.camera, 0.35);
		add(vignette);
		
		FlxTween.tween(soldier, { y: FlxG.height - 100 - 24 * 2 }, 2, { ease:FlxEase.cubeOut } );
		
		var t1 : FlxTimer = new FlxTimer();
		t1.start(2.0, function(t) { soldier.animation.play("land"); } );
		
		var t2 : FlxTimer = new FlxTimer();
		t2.start(2.0 + 11.0 / 8.0 , function (t) {  soldier.animation.play("idle",true); } );
	
		var tend : FlxTimer = new FlxTimer();
		tend.start(2.0 + 11.0 / 8.0 + 12.0/5.0, function (t) 
		{
			SwitchToNext();
		} );
		
	}
	
	function SwitchToNext() 
	{
		if (!ending)
		{
			ending = true;
			FlxTween.tween(overlay, { alpha : 1 }, 0.5);
				
			var te2 : FlxTimer = new FlxTimer();
			te2.start(0.75, function (txx) { FlxG.switchState(new MenuState()); } );
		}
	}
	
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if (FlxG.keys.justPressed.ANY)
		{
			SwitchToNext();
		}
	}
	
	
	
}