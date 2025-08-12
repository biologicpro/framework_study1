package ecs.systems;

import ecs.World;

/**
 * The base class for all systems.
 * A system contains the logic that operates on entities with specific components.
 */
class System
{
	/**
	 * A reference to the world, to access entities and components.
	 */
	public var world:World;

	public function new(world:World)
	{
		this.world = world;
	}

	/**
	 * This method is called by the world on every frame.
	 * Subclasses should implement their logic here.
	 * @param elapsed The time in seconds since the last frame.
	 */
	public function update(elapsed:Float)
	{
		// To be implemented by subclasses
	}
}
