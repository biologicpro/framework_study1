package ecs.systems;

import ecs.components.PositionComponent;
import ecs.components.VelocityComponent;

/**
 * Updates the position of entities based on their velocity.
 */
class MovementSystem extends System
{
	public function new(world:ecs.World)
	{
		super(world);
	}

	override public function update(elapsed:Float)
	{
		for (entity in world.getEntities())
		{
			if (world.hasComponent(entity, PositionComponent) && world.hasComponent(entity, VelocityComponent))
			{
				var pos = world.getComponent(entity, PositionComponent);
				var vel = world.getComponent(entity, VelocityComponent);
				pos.x += vel.vx * elapsed;
				pos.y += vel.vy * elapsed;
			}
		}
	}
}
