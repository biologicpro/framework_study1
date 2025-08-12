package ecs.systems;

import ecs.components.InputComponent;
import ecs.components.VelocityComponent;
import flixel.FlxG;
import flixel.input.keyboard.FlxKey;

/**
 * Processes user input and updates the velocity of the controllable entity.
 */
class InputSystem extends System
{
	public function new(world:ecs.World)
	{
		super(world);
	}

	override public function update(elapsed:Float)
	{
		for (entity in world.getEntities())
		{
			// This system only cares about the single entity with an InputComponent
			if (world.hasComponent(entity, InputComponent) && world.hasComponent(entity, VelocityComponent))
			{
				var vel = world.getComponent(entity, VelocityComponent);
				
				// Reset velocity
				vel.vx = 0;
				vel.vy = 0;

				// Check keys and set velocity
				if (FlxG.keys.anyPressed([LEFT, A]))
				{
					vel.vx = -150;
				}
				if (FlxG.keys.anyPressed([RIGHT, D]))
				{
					vel.vx = 150;
				}
				if (FlxG.keys.anyPressed([UP, W]))
				{
					vel.vy = -150;
				}
				if (FlxG.keys.anyPressed([DOWN, S]))
				{
					vel.vy = 150;
				}

				// Break because we assume only one player-controlled entity
				break;
			}
		}
	}
}
