package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
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
	private var soldier_new : FlxSprite;
	private var phage : FlxSprite;
	private var overlay : FlxSprite;
	
	private var ending : Bool = false;
	
	private var vignette : Vignette;
	
	private var _score : Int = 0;
	
	private var army : FlxSpriteGroup;
	var age:Float = 0;
	
	public function new (Score : Int)
	{
		super();
		_score = Score;
	}
	
	
	override public function create() 
	{
		super.create();
		
		var backgroundSprite : FlxSprite = new FlxSprite(0, 0);
		backgroundSprite.loadGraphic(AssetPaths.background__png, false, 200, 150);
		backgroundSprite.origin.set();
		backgroundSprite.scale.set(4, 4);
		add(backgroundSprite);
		
		var platform : FlxSprite = new FlxSprite(0, 500+12);
		//platform.makeGraphic(FlxG.width, 300, FlxColor.BLACK);
		platform.loadGraphic(AssetPaths.ground__png, false, 200, 25);
		platform.origin.set(0, 0);
		platform.scale.set(4, 4);
		add(platform);
		
		
		soldier = new FlxSprite(400 - 24 * 2, -100);
		
		
		var floorypos: Float = FlxG.height - 100;
		
		soldier.loadGraphic(AssetPaths.Soldier__png, true, 24, 24);
		soldier.scale.set(4, 4);
		
		
		soldier.animation.add("fall", [ 26, 27, 28, 29, 30, 31, 32, 33], 8);
		soldier.animation.add("land", [ 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44], 8);
		soldier.animation.add("idle", [ 0, 1, 2, 3, 4], 5);
		
		
		soldier.animation.play("fall");
		add(soldier);
		
		soldier_new = new FlxSprite(400 - 24*2, floorypos - 24 * 2);
		soldier_new.scale.set(4, 4); 
		soldier_new.loadGraphic(AssetPaths.soldier_new__png, true, 24, 24);
		soldier_new.animation.add("flag", [for (i in 44... (75)) i], 8);
		soldier_new.animation.add("flagidle", [for (i in 71... (75)) i], 8);
		soldier_new.animation.add("loose", [for (i in 103... (119)) i], 8);
		soldier_new.animation.add("win", [for (i in 76... (102)) i], 8);
		soldier_new.animation.add("run", [for (i in 142... (145)) i], 8);
		soldier_new.alpha = 0;
		add(soldier_new);
		
		army = new FlxSpriteGroup();
		add(army);
		
		phage = new FlxSprite(900, floorypos - 50 * 2 - 12);
		phage.loadGraphic(AssetPaths.macrophage__png, true, 72, 50);
		phage.scale.set(4, 4);
		phage.animation.add("walk", [0, 1, 2], 6);
		phage.animation.add("shout", [3, 4, 5], 6);
		phage.animation.add("shy", [for ( i in 0 ... 18) i], 8);
		add(phage);
		
		
		overlay = new FlxSprite();
		overlay.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		overlay.alpha = 0;
		add(overlay);
		
		vignette = new Vignette(FlxG.camera, 0.35);
		add(vignette);
		
		FlxTween.tween(soldier, { y: floorypos - 24* 2 }, 2, { ease:FlxEase.cubeOut } );
		
		var t1 : FlxTimer = new FlxTimer();
		t1.start(2.0, function(t) { soldier.animation.play("land"); } );
		
		var t2 : FlxTimer = new FlxTimer();
		t2.start(2.0 + 11.0 / 8.0 , function (t) {  soldier.animation.play("idle",true); } );
	
		var t3 : FlxTimer = new FlxTimer();
		t3.start(2.0 + 11.0 / 8.0 + 12.0/5.0 , function (t) 
		{
			soldier.alpha = 0;
			soldier_new.alpha = 1;
			soldier_new.animation.play("flag");
		} );
		
		var t4 : FlxTimer = new FlxTimer();
		t4.start(2.0 + 11.0 / 8.0 + 12.0/5.0  + 31.0/8.0, function (t) 
		{
			soldier_new.animation.play("flagidle", true);
			FlxTween.tween(phage, { x : 600 }, 2);
		} );
		
		var t5 : FlxTimer = new FlxTimer();
		t5.start(2.0 + 11.0 / 8.0 + 12.0/5.0  + 31.0/8.0 + 2, function (t) 
		{
			phage.animation.play("shout", true);
		} );
	
		
		if (_score >= 3)
		{
			var t6 : FlxTimer = new FlxTimer();
			t6.start(2.0 + 11.0 / 8.0 + 12.0/5.0  + 31.0/8.0 + 3, function (t) 
			{
				soldier_new.animation.play("win", true);
			} );
			var t7 : FlxTimer = new FlxTimer();
			t7.start(2.0 + 11.0 / 8.0 + 12.0/5.0  + 31.0/8.0 + 3 + 26.0/8.0, function (t) 
			{
				
				
				for (i in 0 ... 10)
				{
					var t : FlxTimer = new FlxTimer();
					t.start(FlxG.random.float(0, 2), function (t) 
					{
						FlxG.camera.flash(FlxColor.BLACK, 0.125, function () { FlxG.camera.flash(FlxColor.WHITE, 0.2); } );
						var s : FlxSprite = new FlxSprite(soldier_new.x, soldier_new.y);
						s.loadGraphic(AssetPaths.Soldier__png, true, 24, 24);
						s.animation.add("idle", [ 0, 1, 2, 3, 4], 5);
						s.animation.play("idle");
						s.scale.set(4 , 4);
						var v : Int = FlxG.random.int(150, 255);
						s.color = FlxColor.fromRGB(v, v, v);
						s.velocity.set( FlxG.random.float( -100, 100), -100);
						s.acceleration.set(0, 250);
						army.add(s);
						
					});
					
				}
			} );
			
			var t8 : FlxTimer = new FlxTimer();
			t8.start(2.0 + 11.0 / 8.0 + 12.0/5.0  + 31.0/8.0 + 3 + 26.0/8.0 + 0.5, function (t) 
			{
				phage.animation.play("shy", true);
			} );
			
			var t9 : FlxTimer = new FlxTimer();
			t9.start(2.0 + 11.0 / 8.0 + 12.0/5.0  + 31.0/8.0 + 3 + 26.0/8.0 + 0.5 + 1.5, function (t) 
			{
				phage.velocity.x = 150;  
			} );
			
		}
		else
		{
			var t6 : FlxTimer = new FlxTimer();
			t6.start(2.0 + 11.0 / 8.0 + 12.0/5.0  + 31.0/8.0 + 3, function (t) 
			{
				soldier_new.animation.play("loose", true);
			} );
			var t7 : FlxTimer = new FlxTimer();
			t7.start(2.0 + 11.0 / 8.0 + 12.0/5.0  + 31.0/8.0 + 3 + 16.0/8.0, function (t) 
			{
				soldier_new.animation.play("run", true);
				soldier_new.velocity.set( - 150, 0);
				phage.velocity.set( -150, 0);
				//FlxTween.tween(soldier_new, { x : - 100 }, 3);
				//FlxTween.tween(phage, { x : - 100 }, 3, sta);
			} );
		}

		var tend : FlxTimer = new FlxTimer();
		tend.start(2.0 + 11.0 / 8.0 + 12.0/5.0 + 11.5 + ((_score >= 3) ? 3 : 0) , function (t) 
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
		age += elapsed;
		
		if (FlxG.keys.justPressed.ANY)
		{
			SwitchToNext();
		}
		
		for (s in army)
		{
			if (s.y > soldier_new.y) s.y = soldier_new.y;
			if ( age > 2.0 + 11.0 / 8.0 + 12.0 / 5.0  + 31.0 / 8.0 + 3 + 26.0 / 8.0 + 0.5 + 1.5)
			{
				s.velocity.x = 150;
				soldier_new.velocity.x = 150;
			}
		}
	}
	
	
	
}