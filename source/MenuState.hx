package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.FlxState;
import flixel.text.FlxText;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	public static var HighScore : Int = 0;
	public static var LastScore : Int = 0;
	
	public var overlay : FlxSprite;
	public var vignette : Vignette;
	
	private var ending : Bool = false;
	
	public static function setNewScore (s: Int)
	{
		LastScore = s;
		if (s > HighScore)
		{
			HighScore = s;
		}
		
	}

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		var backgroundSprite : FlxSprite = new FlxSprite();
		backgroundSprite.makeGraphic(FlxG.width, FlxG.height, FlxColor.fromRGB(99,100,102));
		add(backgroundSprite);
		
		var logo : FlxSprite = new FlxSprite( -500, -500);
		
		logo.y = FlxG.height * 2.0 / 3.0;
		
		logo.loadGraphic(AssetPaths.startbildschirm__png, true, 94, 26);
		logo.animation.add("idle",  [for (i in 0... (33)) i], 14 );
		logo.animation.play("idle");
		logo.scale.set(8, 8);
		logo.screenCenter(FlxAxes.XY);
		logo.y -= 100;
		add(logo);
		
		var title : FlxText = new FlxText(100, 45, 0, "...", 20);
		title.screenCenter();
		title.y = 45;
		title.alignment = "CENTER";
		title.color = Palette.primary1();
		var t1 : FlxText = new FlxText (100, 350, 600, "Press any button to start", 14);
		t1.color = Palette.primary1();
		var t2 : FlxText = new FlxText (20, 0, 600, "created by @Sturmvogl, @xXBloodyOrange and @Laguna_999 for Gaminfection Hackaton\n2017-09-30\nvisit us at https://runvs.io", 10);
		t2.y = FlxG.height - t2.height - 20;
		t2.color = Palette.primary0();
		t1.color = Palette.primary0(); 
		//add(title);
		add(t1);
		add(t2);
		
		
		overlay = new FlxSprite();
		overlay.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(overlay);
		
		FlxTween.tween(overlay, { alpha : 0 }, 0.25);
		
		vignette = new Vignette(FlxG.camera, 0.35);
		add(vignette);

	}
	
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update(elapsed : Float):Void
	{	
		MyInput.update();
		super.update(elapsed);
		if (FlxG.keys.pressed.SPACE ||MyInput.AnyButtonPrressed)
		{
			if (!ending)
			{
				ending = true;
				FlxTween.tween(overlay, { alpha : 1 }, 0.75, {onComplete: function(t) {MyInput.reset();
				FlxG.switchState(new PlayStateJump());} });
			}
			
			
		}
	}	
}