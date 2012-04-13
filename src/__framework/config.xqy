xquery version "1.0-ml";

module namespace config = "http://www.xquerrail-framework.com/config";

import module namespace response = "http://www.xquerrail-framework.com/response"
   at "/_framework/response.xqy";
   
import module namespace request  = "http://www.xquerrail-framework.com/request"
   at "/_framework/request.xqy";
   
declare namespace routing = "http://www.xquerrail-framework.com/routing";   

declare option xdmp:mapping "false";
(:Make sure this points to a valid location in your modules path:)   
declare variable $CONFIG                   := xdmp:invoke("/_config/config.xml");

(:Default Path Values:)
declare variable $FRAMEWORK-PATH           := "/_framework";
declare variable $DEFAULT-ENGINE-PATH      := "/_framework/engines";
declare variable $DEFAULT-INTERCEPTOR-PATH := "/_framework/interceptors";
declare variable $DEFAULT-DISPATCHER-PATH  := "/_framework/dispatchers";
declare variable $DEFAULT-BASE-PATH        := "/_framework/base";
declare variable $DEFAULT-VIEWS-PATH       := fn:concat($DEFAULT-BASE-PATH,"/views");
declare variable $DEFAULT-TEMPLATE-PATH    := fn:concat($DEFAULT-BASE-PATH,"/templates");


declare variable $DEFAULT-CONTROLLER-RESOURCE  := fn:concat($DEFAULT-BASE-PATH,"/base-controller.xqy");
declare variable $DEFAULT-MODEL-RESOURCE       := fn:concat($DEFAULT-BASE-PATH,"/base-model.xqy");


declare variable $DEFAULT-ANONYMOUS-USER   := "anonymous-user";
declare variable $DEFAULT-ROUTING-MODULE   := "/_framework/routing.xqy";

(:Error Codes:)
declare variable $ERROR-RESOURCE-CONFIGURATION := xs:QName("ERROR-RESOURCE-CONFIGURATION");
declare variable $ERROR-ROUTING-CONFIGURATION  := xs:QName("ERROR-ROUTING-CONFIGURATION");
declare variable $ERROR-DOMAIN-CONFIGURATION   := xs:QName("ERROR-DOMAIN-CONFIGURATION");

(:~
 : Returns the default application defined in the config

 :)
 declare function config:default-application()
 {
    ($CONFIG/config:default-application/@value/fn:string(),"application")[1]
 }; 
(:~
 : Returns the default controller for entire application usually default
:)
declare function config:default-controller()
{
  fn:string($CONFIG/config:default-controller/@value)
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

declare function config:base-view-directory() {
   let $dir :=  fn:data($CONFIG/config:base-view-location/@value)
   return 
    if ($dir) then $dir else "/_framework/base/views"
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
  xdmp:invoke($CONFIG/config:routes-config/@resource) 
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
declare function config:error-handler()
{ 
  (
    $CONFIG/config:error-handler/@resource,
    $CONFIG/config:error-handler/@dbresource,
    "/_framework/error.xqy"
  )[1]
};
declare function config:get-interceptors()
{
  config:get-interceptors(())
};
declare function config:get-interceptors(
  $value as xs:string?
){
  if($value) 
  then $CONFIG/config:interceptors
     /config:interceptor[
      if($value eq "before-request") then ./@before-request eq "true" 
      else if($value eq "after-request") then ./@after-request eq "true"
      else if($value eq "before-response") then ./@before-response eq "true"
      else if($value eq "after-response") then  ./@after-response eq "true"
      else if($value eq "all") then fn:true()
      else fn:false()
     ]
  else ()
};
declare function config:interceptor-config()
{
   (
     $CONFIG/config:interceptor-config/@value/fn:data(.),
     "/_config/interceptor.xml"
   )[1]
   
};
