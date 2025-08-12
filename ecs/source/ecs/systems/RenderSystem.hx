package ecs.systems;

import ecs.components.PositionComponent;
import ecs.components.SpriteComponent;
import flixel.FlxState;

/**
 * Updates the visual representation (FlxSprite) of entities based on their position.
 * Also adds new sprites to the Flixel state.
 */
class RenderSystem extends System
{
	private var state:FlxState;
	private var addedEntities:haxe.ds.IntMap<Bool> = new haxe.ds.IntMap<Bool>();

	public function new(world:ecs.World, state:FlxState)
	{
		super(world);
		this.state = state;
	}

	override public function update(elapsed:Float)
	{
		for (entity in world.getEntities())
		{
			if (world.hasComponent(entity, PositionComponent) && world.hasComponent(entity, SpriteComponent))
			{
				var pos = world.getComponent(entity, PositionComponent);
				var spriteComp = world.getComponent(entity, SpriteComponent);

				// Update the sprite's position
				spriteComp.sprite.x = pos.x;
				spriteComp.sprite.y = pos.y;

				// Add the sprite to the state if it's not already there
				if (!addedEntities.exists(entity))
				{
					state.add(spriteComp.sprite);
					addedEntities.set(entity, true);
				}
			}
		}
	}
}
