package context9.ecs.schedulers;

import context9.ecs.IScheduler;
import context9.ecs.ISystem;
import context9.ecs.World;

/**
 * Runs systems strictly in the order they were registered.
 */
class SequenceScheduler implements IScheduler {
  public function new() {}
  public function run(world:World, systems:Array<ISystem>, dt:Float):Void {
    for (s in systems) s.update(world, dt);
  }
}
