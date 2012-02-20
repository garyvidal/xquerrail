xquery version "1.0-ml";
declare default element namespace "http://www.w3.org/1999/xhtml";
declare namespace domain = "http://www.xquerrail-framework.com/domain";

import module namespace form = "http://www.xquerrail-framework.com/formbuilder" at "/_framework/helpers/formbuilder.xqy";
import module namespace response = "http://www.xquerrail-framework.com/response" at "/_framework/response.xqy";

declare option xdmp:output "indent-untyped=yes";
declare variable $response as map:map external;

let $init := response:initialize($response)
let $domain-model := response:model()
return
    <ul class="editPanel">
         <li style="display:none">
             {
                 (: If there is a UUID this will be an update form :)
                 (: If not included it will default to a new form :)
                 if(response:body()/*:uuid) then      
                     <input type="hidden" name="uuid" value="{response:body()/*:uuid}"/>
                 else () 
             }
         </li>
        {
          for $element in $domain-model/domain:element
          let $name := fn:data($element/@name)
          let $type := fn:data($element/@type)
          let $value := response:body()//*[fn:local-name(.) eq $name]
          let $ui := $element/domain:ui
          let $class  := "class=large"
          let $opts :=  
               fn:string-join( 
                   for $attr in $element/(domain:navigation/@* | ./@*)
                   return fn:concat( fn:local-name($attr), "=", fn:data($attr)) 
               ,";")
          return
              <li>
                  { form:render-control($name,$type,$value,$opts,$ui) }
              </li>
        }
    </ul>
