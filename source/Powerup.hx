package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class Powerup extends FlxSprite
{
	private var underlay : GlowOverlay;

	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		loadGraphic(AssetPaths.speed__png, true, 12, 12);
		scale.set(4, 4);
		animation.add("idle",  [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], 8);
		animation.play("idle");
		updateHitbox();
		
		underlay = new GlowOverlay(x, y, FlxG.camera, 128, 1, 0.9);
		underlay.color = FlxColor.fromRGB(254, 174, 52);
		underlay.alpha = 0.4;
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		underlay.setPosition(x+ 24, y+24);
		
	}
	
	override public function draw():Void 
	{
		underlay.draw();
		super.draw();
	}
	
}