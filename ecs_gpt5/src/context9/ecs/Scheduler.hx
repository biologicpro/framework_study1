package context9.ecs;

interface IScheduler {
  public function run(world:World, systems:Array<ISystem>, dt:Float):Void;
}
