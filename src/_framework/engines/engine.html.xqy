xquery version "1.0-ml";

module namespace base = "http://www.xquerrail-framework.com/engine";
    
import module namespace engine  = "http://www.xquerrail-framework.com/engine"     at "/_framework/engines/engine.base.xqy";
import module namespace config = "http://www.xquerrail-framework.com/config"      at "/_framework/config.xqy";
import module namespace routing = "http://www.xquerrail-framework.com/routing"    at "/_framework/routing.xqy";
import module namespace domain = "http://www.xquerrail-framework.com/domain"      at "/_framework/domain.xqy";
import module namespace request = "http://www.xquerrail-framework.com/request"    at "/_framework/request.xqy";
import module namespace response = "http://www.xquerrail-framework.com/response"  at "/_framework/response.xqy";
   
declare namespace tag = "http://www.xquerrail-framework.com/tag";  

declare default element namespace "http://www.w3.org/1999/xhtml";
declare default function namespace "http://www.w3.org/2005/xpath-functions";

declare option xdmp:output "indent=yes";
declare option xdmp:output "method=xml";
declare option xdmp:ouput "omit-xml-declaration=yes";

(:Internal Holders for request, response and context:)
declare variable $request := map:map() ;
declare variable $response := map:map();
declare variable $context := map:map();

(:~
 : Custom Tags the HTML Engine renders and handles during transform
~:)
declare variable $engine-tags := 
(
     xs:QName("engine:title"),
     xs:QName("engine:include-metas"),
     xs:QName("engine:include-http-metas"),
     xs:QName("engine:controller-script"),
     xs:QName("engine:controller-stylesheet"),
     xs:QName("engine:controller-list")
);

(:~
 : Initialize the engine passing the request and response for the given object.
~:)
declare function engine:initialize($resp,$req){ 
    (
      let $init := 
      (
           response:initialize($resp),
           xdmp:set($response,$resp),
           engine:set-engine-transformer(xdmp:function(xs:QName("engine:custom-transform"),"/_framework/engines/engine.html.xqy")),
           engine:register-tags($engine-tags)
      )
      return
       engine:render()
    )
};
(:~
 : Some Common settings for html 
~:)
declare variable $html-strict :=        '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">';
declare variable $html-transitional :=  '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">';
declare variable $html-frameset :=      '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">';
declare variable $xhtml-strict :=       '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">';
declare variable $xhtml-transitional := '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">';
declare variable $xhtml-frameset :=     '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">';
declare variable $xhtml-1.1 :=          '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">';

(:~
 : Returns a <meta/> element for use in http header
~:)
declare function engine:transform-include_metas($node as node())
{
  response:metas()
};

(:~
 :  Renders out HTTP meta elements to header
~:)
declare function engine:transform-http_metas($node as node())
{
  response:httpmetas()
};

(:~
 : Custom Tag for rendering Label or Title of Controller.  This is set using the
 : response:set-title("MY Title") function during controller invocation
~:)
declare function engine:transform-title($node as node())
{
   response:title()
};

declare function engine:module-file-exists($path as xs:string) as xs:boolean
{
   let $fs-path := if(xdmp:platform() eq "winnt") then "\\" else "/"
   return
   if(xdmp:modules-database() eq 0) 
   then xdmp:filesystem-file-exists(
           fn:concat(xdmp:modules-root(),$fs-path,fn:replace($path,"\\|/",$fs-path))
        )
   else 
      xdmp:eval('fn:doc-available($uri)',
      (xs:QName("uri"),$path),
         <options xmlns="xdmp:eval">
            <database>{xdmp:modules-database()}</database>
         </options>   
      )
};
(:~
 : Generates a script element for the given controller.  If a controller 
 : script is defined in the template the system will check to see if the
 : file exists on the system before rendering any output
~:)
declare function engine:transform-controller-script($node)
{
  let $resource-uri := fn:concat(config:resource-directory(),"scripts/",response:controller(),".js")
  return 
  if(response:controller() ne "" and engine:module-file-exists($resource-uri)) 
  then element script {
          attribute type{"text/javascript"},
          attribute src {$resource-uri},
          text{"//"}
          }
  else ()
};
(:~
 : Generates a script element for the given controller.  If a controller 
 : script is defined in the template the system will check to see if the
 : file exists on the system before rendering any output
~:)
declare function engine:transform-controller-stylesheet($node)
{
  let $resource-uri := fn:concat(config:resource-directory(),"stylesheets/",response:controller(),".css")
  return 
  if(response:controller() ne "" and engine:module-file-exists($resource-uri))  
  then element link {
          attribute type{"text/css"},
          attribute href {$resource-uri},
          attribute rel {"stylesheet"},
          text{""}
          }
  else ()
};

(:~
 :  Returns a list of controllers as a unordered list.
 :  This can be used during app generation to quickly test
 :  New controllers. 
 :)
declare function engine:transform-controller-list($node)
{
   for $controller in domain:get-controllers("application")
   return
     <li><a href="/{$controller/@name}/index.html">{(fn:data($controller/@label),fn:data($controller/@name))[1]}</a></li>
};
(:~
 : Custom Transformer handles HTML specific templates and
 : Tags.
~:)
declare function engine:custom-transform($node as node())
{  
   if(engine:visited($node))
   then  ()    
   else(
       typeswitch($node)
         case processing-instruction("title") return engine:transform-title($node)
         case processing-instruction("include-http-metas") return engine:transform-http_metas($node)
         case processing-instruction("include-metas") return engine:transform-include_metas($node)
         case processing-instruction("controller-script") return engine:transform-controller-script($node)
         case processing-instruction("controller-stylesheet") return engine:transform-controller-stylesheet($node)
         case processing-instruction("controller-list") return engine:transform-controller-list($node)
         case processing-instruction() return engine:transform($node)   
         default return engine:transform($node)
     )    
};
(:~
 : Handles redirection.
 : The redirector will try to ensure a valid route is defined to handle the request
 : If the redirect does not map to an existing route then 
 : will throw invalid redirect error.
~:)
declare function engine:redirect($path)
{
     let $controller := response:controller()
     let $action     := $path
     let $format     := response:format()
     let $route-uri  := 
        if(fn:contains($path,"/")) 
        then $path 
        else fn:concat('/',$controller,'/',($action,config:default-action())[1],'.',($format,config:default-format())[1])
     let $route      := routing:get-route($route-uri)
     return
        if($route) 
        then xdmp:redirect-response($route-uri)
        else fn:error(xs:QName("INVALID-REDIRECT"),"No valid Routes")
};
(:~
 : Renders the HTML response.
~:)
declare function engine:render()
{
   if(response:redirect()) 
   then engine:redirect(response:redirect())
   else 
   (
     (:Set the response content type:)
     if(response:content-type())
     then xdmp:set-response-content-type(response:content-type())
     else xdmp:set-response-content-type("text/html"),
     for $key in map:keys(response:response-headers())
     return 
        xdmp:add-response-header($key,response:response-header($key)),
        if(response:partial()) 
        then ()
        else  '<!doctype html>',
     if(response:partial()) 
     then engine:render-view()
     else if(response:template()) 
     then engine:render-template($response)
     else if(response:view())
     then engine:render-view()
     else if(response:body()) 
          then response:body()
     else ()   
   )
};