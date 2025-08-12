package context9.ecs;

/**
 * Describes event access intent for a system (read/write sets).
 */
typedef EventAccess = {
  ?reads:Array<Class<Dynamic>>,
  ?writes:Array<Class<Dynamic>>
}
