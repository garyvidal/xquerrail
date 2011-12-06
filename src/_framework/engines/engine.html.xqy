xquery version "1.0-ml";

module namespace base = "http://www.xquerrail-framework.com/engine";
    
import module namespace engine  = "http://www.xquerrail-framework.com/engine"
  at "/_framework/engines/engine.base.xqy";
import module namespace request = "http://www.xquerrail-framework.com/request"
   at "/_framework/request.xqy";
import module namespace response = "http://www.xquerrail-framework.com/response"
   at "/_framework/response.xqy";

declare namespace tag = "http://www.xquerrail-framework.com/tag";  

declare default element namespace "http://www.w3.org/1999/xhtml";
declare default function namespace "http://www.w3.org/2005/xpath-functions";

declare option xdmp:output "method=html";

declare variable $request := map:map() ;
declare variable $response := map:map();
declare variable $context := map:map();
declare variable $engine-tags := 
(
     xs:QName("engine:title"),
     xs:QName("engine:include-metas"),
     xs:QName("engine:include-http-metas"),
     xs:QName("engine:controller-script")
);

declare function engine:initialize($resp,$req){ 
(
  let $init := 
  (
       response:initialize($resp),
       xdmp:set($resp,$response),
       engine:set-engine-transformer(xdmp:function(xs:QName("engine:custom-transform"),"/_framework/engines/engine.html.xqy")),
       engine:register-tags($engine-tags)
  )
  return
   engine:render()
)
};
declare variable $html-4.01-strict :=       '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">';
declare variable $html-4.01-transitional := '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">';
declare variable $html-4.01-frameset :=     '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">';
declare variable $xhtml-1.0-strict :=       '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">';
declare variable $xhtml-1.0-transitional := '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">';
declare variable $xhtml-1.0-frameset :=     '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">';
declare variable $xhtml-1.1 :=              '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">';

declare function engine:transform-include_metas($node as node())
{
  response:metas()
};
declare function engine:transform-http_metas($node as node())
{
  response:httpmetas()
};

declare function engine:transform-title($node as node())
{
   response:title()
};

declare function engine:transform-controller-script($node)
{
  if(response:controller()) 
  then element script {
          attribute type{"text/javascript"},
          attribute src {fn:concat("/resources/js/",response:controller(),".js")},
          text{"//"}
          }
  else ()
};

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
         case processing-instruction() return engine:transform($node)   
         default return engine:transform($node)
     )    
};

declare function engine:render()
{
   if(response:redirect()) 
   then xdmp:redirect-response(response:redirect())
   else 
   (
     (:Set the response content type:)
     if(response:content-type())
     then xdmp:set-response-content-type(response:content-type())
     else xdmp:set-response-content-type("text/html"),
     for $key in map:keys(response:response-headers())
     return 
        xdmp:add-response-header($key,response:response-header($key)),
        '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">',
     if(response:template()) 
     then engine:render-template($response)
     else if(response:view())
     then engine:render-view($response)
     else if(response:body()) 
          then response:body()
     else ()
   )
};

