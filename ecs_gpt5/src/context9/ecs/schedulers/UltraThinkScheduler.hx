package context9.ecs.schedulers;

import context9.ecs.IScheduler;
import context9.ecs.ISystem;
import context9.ecs.World;
import haxe.ds.StringMap;

/**
 UltraThinkScheduler
 - Groups systems by phase (init < logic < render)
 - Performs a topological sort using before()/after() edges
 - Splits into layers to avoid read/write conflicts where possible

 Note: Runs sequentially but creates conflict-free layers to hint at parallelizability.
 */
class UltraThinkScheduler implements IScheduler {
  static inline var PHASE_ORDER = ["init", "logic", "render"];

  public function new() {}

  public function run(world:World, systems:Array<ISystem>, dt:Float):Void {
    final phases = phaseBuckets(systems);
    for (phase in PHASE_ORDER) {
      final bucket = phases.get(phase);
      if (bucket == null) continue;
      final ordered = topoSort(bucket);
      final layers = conflictAwareLayers(ordered);
      for (layer in layers) {
        // Placeholder for parallel execution per layer; we run sequentially here
        for (s in layer) s.update(world, dt);
      }
    }
  }

  function phaseBuckets(systems:Array<ISystem>):StringMap<Array<ISystem>> {
    final buckets = new StringMap<Array<ISystem>>();
    for (s in systems) {
      final p = s.phase();
      final key = PHASE_ORDER.indexOf(p) >= 0 ? p : "logic";
      var arr = buckets.get(key);
      if (arr == null) { arr = []; buckets.set(key, arr); }
      arr.push(s);
    }
    return buckets;
  }

  function topoSort(systems:Array<ISystem>):Array<ISystem> {
    final nameToSys = new StringMap<ISystem>();
    for (s in systems) nameToSys.set(s.name(), s);

    final adj = new StringMap<Array<String>>();
    final indeg = new StringMap<Int>();

    for (s in systems) {
      final sName = s.name();
      if (!adj.exists(sName)) adj.set(sName, []);
      if (!indeg.exists(sName)) indeg.set(sName, 0);
      for (b in s.before()) {
        // s -> b (s must run before b)
        ensureNode(adj, indeg, b);
        adj.get(sName).push(b);
        indeg.set(b, indeg.get(b) + 1);
      }
      for (a in s.after()) {
        // a -> s (a must run before s)
        ensureNode(adj, indeg, a);
        if (!adj.exists(a)) adj.set(a, []);
        adj.get(a).push(sName);
        indeg.set(sName, indeg.get(sName) + 1);
      }
    }

    final q:Array<String> = [];
    for (k in indeg.keys()) if (indeg.get(k) == 0) q.push(k);

    final ordered = [];
    while (q.length > 0) {
      final n = q.shift();
      final sys = nameToSys.get(n);
      if (sys != null) ordered.push(sys);
      for (m in adj.get(n)) {
        final d = indeg.get(m) - 1; indeg.set(m, d);
        if (d == 0) q.push(m);
      }
    }

    // Append any disconnected systems not in graph
    for (s in systems) if (ordered.indexOf(s) < 0) ordered.push(s);

    return ordered;
  }

  inline function ensureNode(adj:StringMap<Array<String>>, indeg:StringMap<Int>, k:String):Void {
    if (!adj.exists(k)) adj.set(k, []);
    if (!indeg.exists(k)) indeg.set(k, 0);
  }

  function conflictAwareLayers(ordered:Array<ISystem>):Array<Array<ISystem>> {
    final layers:Array<Array<ISystem>> = [];
    var current:Array<ISystem> = [];

    for (s in ordered) {
      if (current.length == 0) { current.push(s); continue; }
      if (conflictsWithAny(s, current)) {
        layers.push(current);
        current = [s];
      } else {
        current.push(s);
      }
    }
    if (current.length > 0) layers.push(current);
    return layers;
  }

  function conflictsWithAny(s:ISystem, list:Array<ISystem>):Bool {
    for (o in list) if (conflict(s, o)) return true; return false;
  }

  function conflict(a:ISystem, b:ISystem):Bool {
    // Components: Write/Write or Write/Read overlap conflicts
    final aCW = keySet(a.writes());
    final aCR = keySet(a.reads());
    final bCW = keySet(b.writes());
    final bCR = keySet(b.reads());

    for (k in aCW.keys()) if (bCW.exists(k) || bCR.exists(k)) return true;
    for (k in aCR.keys()) if (bCW.exists(k)) return true;

    // Resources: same rules as components
    final aRW = keySet(a.resourceWrites());
    final aRR = keySet(a.resourceReads());
    final bRW = keySet(b.resourceWrites());
    final bRR = keySet(b.resourceReads());

    for (k in aRW.keys()) if (bRW.exists(k) || bRR.exists(k)) return true;
    for (k in aRR.keys()) if (bRW.exists(k)) return true;

    // Events: double-buffered; producers write to outbox, consumers read from inbox => no conflicts in-frame
    return false;
  }

  function keySet(arr:Array<Class<Dynamic>>):StringMap<Bool> {
    final m = new StringMap<Bool>();
    for (c in arr) m.set(World.typeKeyStatic(c), true);
    return m;
  }
}
