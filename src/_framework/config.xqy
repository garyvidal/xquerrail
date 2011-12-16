xquery version "1.0-ml";

module namespace config = "http://www.xquerrail-framework.com/config";

import module namespace response = "http://www.xquerrail-framework.com/response"
   at "/_framework/response.xqy";
import module namespace request  = "http://www.xquerrail-framework.com/request"
   at "/_framework/request.xqy";

declare variable $CONFIG := xdmp:invoke("/_config/config.xml");
declare variable $DEFAULT-ENGINE := "engine.html";
declare variable $ENGINE-PATH := "/_framework/engines";

declare function config:get-controller()
{
   fn:string($CONFIG/config:controller/@resource)
};
declare function config:get-engine($response as map:map)
{
   let $_ := response:set-response($response)
   return
     if(response:format() eq "html") 
     then "engine.html"
     else if(response:format() eq "xml")
     then "engine.xml"
     else if(response:format() eq "json")
     then "engine.json"
     else $DEFAULT-ENGINE
     
};