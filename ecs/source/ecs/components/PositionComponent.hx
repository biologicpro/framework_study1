package ecs.components;

import ecs.IComponent;

/**
 * Stores position data (x, y coordinates).
 */
class PositionComponent implements IComponent
{
	public var x:Float;
	public var y:Float;

	public function new(x:Float = 0, y:Float = 0)
	{
		this.x = x;
		this.y = y;
	}
}
