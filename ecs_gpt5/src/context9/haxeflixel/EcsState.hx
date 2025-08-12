package context9.haxeflixel;

import flixel.FlxState;
import context9.ecs.World;
import context9.ecs.IScheduler;
import context9.ecs.schedulers.SequenceScheduler;

/**
 * EcsState wires a World into a FlxState lifecycle.
 * Provide your own scheduler or use the default SequenceScheduler.
 */
class EcsState extends FlxState {
  public var world:World;

  public function new(?scheduler:IScheduler) {
    super();
    world = new World(scheduler != null ? scheduler : new SequenceScheduler());
  }

  override public function update(elapsed:Float):Void {
    world.update(elapsed);
    super.update(elapsed);
  }
}
