module namespace interceptor = "http://www.xquerrail-framework.com/interceptor";
(:
 : Base interceptor all interceptors must register themselves with base.
 : Interceptors must be registered in the order in which they should be executed.
 : If an interceptor is making a database update you must define your interceptor
 : with the appropriate transaction mode to ensure proper invocation.
 : Warning!!! Running interceptors in transaction-mode="update" will hurt performance of application.
 : If possible use a spawned function to write information to db where possible.
 : or pattern interceptors to not use be used on every call.
 : @param $name - Name of the interceptor you want to deregister 
:)
declare variable $interceptor-map := map:map();
declare variable $interceptor-functions := map:map();
(:~
 :  Register an interceptor with the global cache.
 :  Interceptors must be registered in the order in which the should 
 :  executed
~:)
declare function interceptor:register(
$name as xs:NCName, 
$scopes as xs:string*
) as empty-sequence()
{
   let $scopes-values := 
     for $s in $scopes
     return 
        element {$s} {""}
   let $uris := fn:concat("/_framework/interceptors/interceptors.",$name,".xqy")
   let $func := 
       xdmp:function(
          fn:QName("http://www.xquerrail-framework.com/interceptor",$name),
          $uri
       )
   return (   
      map:put($interceptor-map,$name,(<module-uri>{$uri}</module-uri>,<scopes>{$scope-values</scopes>)),
      map:put($interceptor-functions,$name,$func)
   )
};

(:~
 : Deregisters a interceptor with the global cache by its scope 
~:)
declare function interceptor:deregister($name,$scope)
{
  let $interceptor := map:get($interceptor-map,$name)
  return
    map:remove($interceptor)
};

declare function interceptor:before-interceptors()
{
  
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
