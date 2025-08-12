package ecs.components;

import ecs.IComponent;
import flixel.FlxSprite;

/**
 * A key component for HaxeFlixel integration.
 * It holds a reference to the FlxSprite that represents the entity visually.
 */
class SpriteComponent implements IComponent
{
	public var sprite:FlxSprite;

	public function new(sprite:FlxSprite)
	{
		this.sprite = sprite;
	}
}
