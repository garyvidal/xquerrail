xquery version "1.0-ml";

module namespace config = "http://www.xquerrail-framework.com/config";

import module namespace response = "http://www.xquerrail-framework.com/response"
   at "/_framework/response.xqy";
   
import module namespace request  = "http://www.xquerrail-framework.com/request"
   at "/_framework/request.xqy";
   
declare namespace routing = "http://www.xquerrail-framework.com/routing";   
   

declare variable $CONFIG := xdmp:invoke("/_config/config.xml");
declare variable $ENGINE-PATH := "/_framework/engines";
declare variable $DEFAULT-ANONYMOUS-USER := "anonymous-user";


(:Standard Error Messages:)
declare variable $ERROR-RESOURCE-CONFIGURATION := xs:QName("ERROR-RESOURCE-CONFIGURATION");

(:~
 : Returns the default controller for entire application usually default
:)
declare function config:default-controller()
{
  fn:string($CONFIG/config:default-controller/@resource)
};

(:~
 : Returns the resource directory for framework defined in /_config/config.xml
~:)
declare function config:resource-directory() as xs:string
{
   if(fn:not($CONFIG/config:resource-directory))
   then "/resources/"
   else fn:data($CONFIG/config:resource-directory/@resource)
}; 

(:~
 : Returns the default action 
:)
declare function config:default-action()
{
  fn:string($CONFIG/config:default-action/@value)
};

(:~
 : Returns the default format
 :)
declare function config:default-format()
{
  fn:string($CONFIG/config:default-format/@value)
};

(:~
 : returns the default dispatcher for entire framework.
 :)
declare function config:get-dispatcher()
{
  fn:string($CONFIG/config:dispatcher/@resource)
};

(:~
 : returns the application configuration for a given application by name
 : @param $application-name - Application name
 :)
declare function config:get-application($application-name as xs:string)
{
   $CONFIG/config:application[@name eq $application-name]
};

(:~
 : Get the current application directory
 :)
declare function config:application-directory($name)
{
   fn:concat(config:get-application($name)/@uri)
};

(:~
 : Gets the default anonymous user
 :)
declare function config:anonymous-user($application-name)
{
   fn:data($CONFIG/config:anonymous-user/@value)
};

(:~
 :  Get the domain for a given asset
 :)
declare function config:get-domain($application-name)
{
  let $app-path := config:application-directory($application-name)
  return 
     xdmp:invoke(fn:concat($app-path,"/domains/application-domain.xml"))
};

(:~
 : Returns the routes configuration file 
 :)
declare function config:get-routes()
{
  xdmp:invoke($CONFIG/config:routes/@resource) 
};

(:~
 : Returns the engine for processing requests satisfying the request
 :)
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
     else fn:string($CONFIG/config:default-engine/@value)
};

(:~
 : Returns the engine for processing requests satisfying the request
 :)
declare function config:get-model-xqy-path($model-name as xs:string) {

    let $modelSuffix := fn:data($CONFIG/config:model-suffix/@value)
    let $path := fn:concat("/model/", $model-name, $modelSuffix, ".xqy")
    
    return
     if(xdmp:uri-is-file($path))
     then $path
     else fn:concat("/_framework/base/base", $modelSuffix, ".xqy")
};