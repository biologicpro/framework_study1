package ecs.components;

import ecs.IComponent;

/**
 * Stores velocity data (vx, vy vectors).
 */
class VelocityComponent implements IComponent
{
	public var vx:Float;
	public var vy:Float;

	public function new(vx:Float = 0, vy:Float = 0)
	{
		this.vx = vx;
		this.vy = vy;
	}
}
