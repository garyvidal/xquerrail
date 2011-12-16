module namespace interceptor = "http://www.xquerrail-framework.com/interceptor";

(:~
 :  Register an interceptor with the global cache.
 :  Interceptors must be registered in the order in which the should 
 :  executed
~:)
declare function interceptor:register($name, $uri,$scope)
{
  ()
};

(:~
 : Deregisters a interceptor with the global cache. 
 : Interceptors must be registered in the order in which they should be executed.
 : If an interceptor is making a database update you must define your interceptor
 : with the appropriate transcation mode to ensure proper invocation.
 : @param $name - Name of the interceptor you want to deregister
~:)
declare function interceptor:deregister($name,$scope)
{
  ()
};

declare function interceptor:before-interceptors()
{
  ()
};

declare function interceptor:after-interceptors()
{
  ()
};

(:~
 : The front-controller will invoke your before interceptors
~:)
declare function interceptor:invoke-before($request,$context)
{
  ()
};

(:~
 : The system will invoke your after interceptors
~:)
declare function interceptor:invoke-after($request as map:map(),$response as map:map())
{
  ()
};
