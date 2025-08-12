package ecs.components;

import ecs.IComponent;

/**
 * A marker component that flags an entity to be checked by the BoundsSystem.
 */
class BoundsCheckComponent implements IComponent
{
	public function new() {}
}
