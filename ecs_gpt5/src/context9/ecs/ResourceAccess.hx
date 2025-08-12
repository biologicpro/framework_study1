package context9.ecs;

/**
 * Describes resource access intent for a system (read/write sets).
 */
typedef ResourceAccess = {
  ?reads:Array<Class<Dynamic>>,
  ?writes:Array<Class<Dynamic>>
}
