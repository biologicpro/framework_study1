package context9.ecs;

/**
 * Basic System contract.
 * Systems declare required/optional components and dependencies for scheduling.
 */
interface ISystem {
  // Component access intent
  public function name():String;

  /** Components that must exist on an entity for the system to consider it. */
  public function required():Array<Class<Dynamic>>;
  /** Optional components the system may read if present. */
  public function optional():Array<Class<Dynamic>>;

  /** Declare components this system reads/writes for conflict-aware scheduling. */
  public function reads():Array<Class<Dynamic>>;
  public function writes():Array<Class<Dynamic>>;

  // Resource access intent (singletons)
  public function resourceReads():Array<Class<Dynamic>>;
  public function resourceWrites():Array<Class<Dynamic>>;

  // Event access intent (double-buffered buses)
  public function eventReads():Array<Class<Dynamic>>;
  public function eventWrites():Array<Class<Dynamic>>;

  /** Explicit ordering/dependency hints for the scheduler. */
  public function before():Array<String>;
  public function after():Array<String>;
  /** Optional phase bucketing (e.g., "init", "logic", "render"). */
  public function phase():String;

  /** Called each frame. */
  public function update(world:World, dt:Float):Void;
}

class BaseSystem implements ISystem {
  final _name:String;
  final _required:Array<Class<Dynamic>>;
  final _optional:Array<Class<Dynamic>>;
  final _reads:Array<Class<Dynamic>>;
  final _writes:Array<Class<Dynamic>>;
  final _before:Array<String>;
  final _after:Array<String>;
  final _phase:String;
  final _resReads:Array<Class<Dynamic>>;
  final _resWrites:Array<Class<Dynamic>>;
  final _evtReads:Array<Class<Dynamic>>;
  final _evtWrites:Array<Class<Dynamic>>;

  public function new(cfg:{
    ?name:String,
    ?required:Array<Class<Dynamic>>,
    ?optional:Array<Class<Dynamic>>,
    ?reads:Array<Class<Dynamic>>,
    ?writes:Array<Class<Dynamic>>,
    ?resourceReads:Array<Class<Dynamic>>,
    ?resourceWrites:Array<Class<Dynamic>>,
    ?eventReads:Array<Class<Dynamic>>,
    ?eventWrites:Array<Class<Dynamic>>,
    ?before:Array<String>,
    ?after:Array<String>,
    ?phase:String
  }) {
    _name = cfg.name != null ? cfg.name : Type.getClassName(Type.getClass(this));
    _required = cfg.required != null ? cfg.required : [];
    _optional = cfg.optional != null ? cfg.optional : [];
    _reads = cfg.reads != null ? cfg.reads : [];
    _writes = cfg.writes != null ? cfg.writes : [];
    _before = cfg.before != null ? cfg.before : [];
    _after = cfg.after != null ? cfg.after : [];
    _phase = cfg.phase != null ? cfg.phase : "logic";
    _resReads = cfg.resourceReads != null ? cfg.resourceReads : [];
    _resWrites = cfg.resourceWrites != null ? cfg.resourceWrites : [];
    _evtReads = cfg.eventReads != null ? cfg.eventReads : [];
    _evtWrites = cfg.eventWrites != null ? cfg.eventWrites : [];
  }

  public function name():String return _name;
  public function required():Array<Class<Dynamic>> return _required;
  public function optional():Array<Class<Dynamic>> return _optional;
  public function reads():Array<Class<Dynamic>> return _reads;
  public function writes():Array<Class<Dynamic>> return _writes;
  public function resourceReads():Array<Class<Dynamic>> return _resReads;
  public function resourceWrites():Array<Class<Dynamic>> return _resWrites;
  public function eventReads():Array<Class<Dynamic>> return _evtReads;
  public function eventWrites():Array<Class<Dynamic>> return _evtWrites;
  public function before():Array<String> return _before;
  public function after():Array<String> return _after;
  public function phase():String return _phase;
  public function update(world:World, dt:Float):Void {}
}
