package ecs.systems;

import ecs.components.PositionComponent;
import ecs.components.BoundsCheckComponent;
import flixel.FlxG;

/**
 * Wraps entities around the screen bounds.
 */
class BoundsSystem extends System
{
	public function new(world:ecs.World)
	{
		super(world);
	}

	override public function update(elapsed:Float)
	{
		for (entity in world.getEntities())
		{
			if (world.hasComponent(entity, PositionComponent) && world.hasComponent(entity, BoundsCheckComponent))
			{
				var pos = world.getComponent(entity, PositionComponent);

				if (pos.x > FlxG.width)  pos.x = 0;
				if (pos.x < 0)         pos.x = FlxG.width;
				if (pos.y > FlxG.height) pos.y = 0;
				if (pos.y < 0)         pos.y = FlxG.height;
			}
		}
	}
}
