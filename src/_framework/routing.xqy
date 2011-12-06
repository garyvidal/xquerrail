xquery version "1.0-ml";

module namespace routing ="http://www.xquerrail-framework.com/routing";

import module namespace config = "http://www.xquerrail-framework.com/config"
at "config.xqy";

declare variable $routes := xdmp:invoke("/_config/routes.xml");
declare function get-routes()
{
   $routes
};
declare function get-route($url as xs:string)
{
  let $map := map:map()
  let $matching-route := $routes//routing:route[fn:matches($url,@pattern)]
  let $defaults := 
     for $default in $matching-route/routing:default
     return
       if($default/@key eq "controller") 
       then for $tfn:tokenize($default/text(),":")
       else ()
       
  
};