(:
 : Copyright 2011 - Gary Vidal
 :
 : Licensed     under the Apache License, Version 2.0 (the "License");
 : you may not use this file except in compliance with the License.
 : You may obtain a copy of the License at
 :
 :    http://www.apache.org/licenses/LICENSE-2.0
 :
 : Unless required by applicable law or agreed to in writing, software
 : distributed under the License is distributed on an "AS IS" BASIS,
 : WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 : See the License for the specific language governing permissions and
 : limitations under the License.
 :)



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

(:~
 : You initialize your variables
~:)
declare variable $request := map:map() ;
declare variable $response := map:map();
declare variable $context := map:map();

(:~
   Initialize  Any custom tags your engine handles so the system can call 
   your custom transform functions
~:)
declare variable $custom-engine-tags as xs:QName*:= 
(
  fn:QName("engine","x-json")
);
(:Set your engines custom transformer:)
declare variable $custom-transform-function := 
   xdmp:function(
     xs:QName("engine:custom-transform"),
     "/_framework/engines/engine.json.xqy"
);
(:~
 : The Main Controller will call your initialize method
 : and register your engine with the engine.base.xqy
~:)
declare function engine:initialize($_response,$_request){ 
(
  let $init := 
  (
       response:initialize($_response),
       xdmp:set($response,$_response),
       engine:set-custom-transformer($custom-transform-function),
       engine:register-tags($engine-tags)
  )
  return
   engine:render()
)
};

(:~
 : The Kernel controller will call your render method.
 : From this point it is up to your engine to handle 
 : to initialize any specific response settings and
 : and start the rendering process 
~:)
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
(:~
  Handle your custom tags in this method or the method you have assigned  
  initialized with the base.engine
  It is important that you only handle your custom tags and
  any content that is required to be consumed by your tags
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
         case processing-instruction() return engine:transform($node)   
         default return engine:transform($node)
     )    
};