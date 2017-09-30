package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.math.FlxRandom;
import flixel.util.FlxTimer;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState_Falling extends FlxState
{
	
	public var background : FlxSpriteGroup;

	public var overlay : FlxSprite;
	private var ending : Bool;
	
	
	private var RemainingHeight : Float;
	private var timerText : FlxText;
	
	private var bacteria : Bacteria;
	
	private var flakesBG : Flakes;
	
	private var hairs : FlxTypedGroup<Hair>;
	
	private var velocityY : Float = -30;
	
	private var spawnTimer :Float = 0;
	
	private var powerUps : FlxSpriteGroup;
	private var powerupTimer : Float = 2;
	
	private var Score :Int  = 0;
	
	private var vignette : Vignette;
	
	

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		background = new FlxSpriteGroup();
		
		var bg1 = new FlxSprite(0,0);
		bg1.loadGraphic(AssetPaths.background__png, false, 200, 150);
		bg1.origin.set();
		bg1.scale.set(4, 4);
		bg1.setPosition(0, 0 );
		background.add(bg1);
		
		var bg2 = new FlxSprite(0,0);
		bg2.loadGraphic(AssetPaths.background__png, false, 200, 150);
		bg2.origin.set();
		bg2.scale.set( -4, 4);
		bg2.setPosition(800, 600);
		background.add(bg2);

		// add stuff here
		
		flakesBG = new Flakes(FlxG.camera, 50, 30);
		add(flakesBG);
		
		bacteria = new Bacteria(300, 0);
		//add(bacteria);
		
		
		hairs = new FlxTypedGroup<Hair>();
		//hairs.add(new Hair(true));
		//add(hairs);
		
		powerUps = new FlxSpriteGroup();
		
		
		ending = false;
		overlay = new FlxSprite();
		overlay.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		overlay.alpha = 1;
		FlxTween.tween (overlay, { alpha : 0 }, 0.5);
		
		add(overlay);
		
		vignette = new Vignette(FlxG.camera, 0.35);
		
		
		RemainingHeight = 250;
		
		timerText = new FlxText(10, 10, 0, "0", 16);
		timerText.color = Palette.primary0();
		add(timerText);
	}
	
	
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	
	override public function draw() : Void
	{
		//super.draw();
		background.draw();
		flakesBG.draw();
		hairs.draw();
		
		bacteria.draw();
		powerUps.draw();
		overlay.draw();
		vignette.draw();
		timerText.draw();
		
	}
	
	/**
	 * Function that is called once every frame.
	 */
	override public function update(elapsed : Float):Void
	{
		super.update(elapsed);
		MyInput.update();
	
		cleanUp();
		hairs.update(elapsed);
		powerUps.update(elapsed);
		spawnTimer -= elapsed;
		powerupTimer -= elapsed;
		spawn();
		
		
		
		
		
		
		
	
		if (velocityY < 50)
		{
			velocityY += elapsed * (-20);
		}
		else if (velocityY < 70)
		{
			velocityY += elapsed * (-15);
		}
		else if (velocityY < GP.WorldMovementMax)
		{
			velocityY += elapsed * (-10);
		}
		else 
		{
			velocityY = GP.WorldMovementMax;
		}
		
		flakesBG._globalVelocityY = velocityY * 0.8;
		for (h in hairs)
		{
			h.velocity.y = velocityY;
		}
		for (p in powerUps)
		{
			p.velocity.y = velocityY;
		}
		
		for (b in background)
		{
			b.update(elapsed);
			b.velocity.set(0, velocityY);
			if (b.y < -600)
			b.y += 1200;
		}
		
		var dec: Int = Std.int((RemainingHeight * 10) % 10);
		if (dec < 0) dec *= -1;
		timerText.text = "Remaining Height: " + Std.string(Std.int(RemainingHeight) + "." + Std.string(dec));
		timerText.text += "\nPowerUps: " + Score ;
		bacteria.update(elapsed);
		if (!ending)
		{
			
			for (h in hairs)
			{
				if (h.touched) continue;
				
				if (FlxG.overlap(bacteria, h))
				{
					{
						EndGame();
					}
				}
			}
			
			for (p in powerUps)
			{
				if (p.alpha == 1)
				{
					if ( FlxG.overlap(bacteria, p))
					{
						FlxG.camera.flash(FlxColor.fromRGB(254, 174, 52, 150), 0.5);
						FlxTween.tween(p, { alpha : 0 }, 0.74);
						FlxTween.tween(p.scale, { x: 8, y: 8 }, 0.75, { onComplete:function(t) { p.alive = false; }} );
						Score++;
					}
				}
			}
			
			var speed : Float = 108; 
			RemainingHeight += (elapsed * velocityY) * 0.025;
			
			if (RemainingHeight <= 0)
			{
				RemainingHeight = 0;
				EndGame(true);
			}
			
		}
	}	
	
	
	
	function spawn() 
	{
		if (spawnTimer <= 0)
		{
			spawnTimer = FlxG.random.float(2.5, 5);
			var l : Bool = FlxG.random.bool();
			hairs.add(new Hair(l));
			//if (l) trace ("left");
			//else  trace ("right");
		}
		if (powerupTimer <= 0)
		{
			powerupTimer = FlxG.random.float(4.5, 6);
			spawnPowerUp();
		}
	}
	
	function cleanUp() 
	{
		{
			var l : FlxTypedGroup<Hair> = new FlxTypedGroup<Hair>();
			for ( s in hairs)
			{
				if (s.y < - 200) s.alive = false;
				if (s.alive) l.add(s);
			}
			hairs = l;
		}
		{
			var l : FlxSpriteGroup = new FlxSpriteGroup();
			for ( s in powerUps)
			{
				if (s.y < - 200) s.alive = false;
				if (s.alive) l.add(s);
			}
			powerUps = l;
		}
	}
	
	function spawnPowerUp()
	{
		var s : Powerup = new Powerup(FlxG.random.float(300,500), 900);
		powerUps.add(s);
	}
	

	
	function EndGame(win : Bool = false ) 
	{
		bacteria.velocity.set();
		bacteria.acceleration.set();
		bacteria.reactToInput = false;
		if (!ending)
		{
			ending = true;
			if (win)
			{
				FlxTween.tween(overlay, { alpha : 1.0 }, 0.45);
				var t: FlxTimer = new FlxTimer();
				t.start(0.5,function(t:FlxTimer): Void { FlxG.switchState(new PlayState_Landing()); } );
			}
			else
			{
				FlxTween.tween(overlay, { alpha : 1.0 }, 0.95);
				bacteria.maxVelocity.set(0, -3 * GP.BacteriaMoveMaxSpeed); 
				bacteria.velocity.set(0, -1.5 * GP.BacteriaMoveMaxSpeed);
				bacteria.color = FlxColor.GRAY;
				var t: FlxTimer = new FlxTimer();
				t.start(1.0,function(t:FlxTimer): Void { FlxG.switchState(new MenuState()); } );
			}
			
		}
	}
}