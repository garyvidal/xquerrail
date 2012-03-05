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
 : with the appropriate transaction mode to ensure proper invocation.
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

declare function interceptor:before-request($request as map:map)
{
  ()
};
declare function interceptor:after-request($response as map:map)
{
  ()
};
declare function interceptor:before-response($response as map:map)
{
  ()
};
declare function interceptor:after-response($response as map:map)
{ 
  ()
}; 
