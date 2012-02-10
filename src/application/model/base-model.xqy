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



module namespace base = "http://www.xquerrail-framework.com/model/base";

import module namespace search =  "http://marklogic.com/appservices/search"
    at "/MarkLogic/appservices/search/search.xqy";

declare namespace domain = "http://www.xquerrail-framework.com/domain";

declare variable $BASE-SEARCH-OPTIONS :=
<options xmlns="http://marklogic.com/appservices/search">

</options>;

declare function base:CREATE(
    $domain as element(domain:domain),
    $values as map:map
)
{
   base:recurse-create($domain,$values)
};

declare private function base:register-module(
$import as element(domain:import-module)
){
     map:put($MODEL-REGISTRY,$import/@name,
     (
       fn:concat("http://www.xquerrail-framework.com/model/",$import/@name),
       fn:concat('/application/model/',$import/@name,"-model.xy");
     ))    
};

declare private function base:recurse-create($node as element(),$values)
{
   typeswitch($node)
    case element(domain:import-module) 
    return base:register-module($node)
    
    case element(domain:domain) return 
        let $name := $node/@name
        let $ns := ($node/@ns,"")[1]
        return element {fn:QName($ns,$name)}
        {
           attribute create-user {xdmp:current-user()},
           attribute create-date {fn:current-dateTime()},
           for $n in $node/node()
           return
             base:recurse-create($node,$n)
        }
    case element(domain:element) return base:create-element($node,$values)
    case element(domain:attribute) return base:create-attribute($node,$values) 
    case element(domain:optionlist) return ()
    default return ()
};

(:
 : Common Conventions for parsing element
:)
declare private base:create-element($node as element(),$values as map:map)
{
   let $name := $node/@name
   let $type := $node/@type
   let $ref  := $node/@ref
   let $required := $node/@required eq "true"
   let $default := $node/@default
   let $value := 
    if($type) then 
       let $type-tokens := fn:tokenize($type,":")
       let $type-scheme := $type-tokens[1]
       let $type-value  := $type-tokens[2]
       return
          if($scheme = "xs") then
             let $map-value := map:get($values,$node/@name)
             return
               ($map-value,$default)[1]
          else if($scheme = "element") then
              for $e in $node/domain:element
              return domain:recurse-create($e,$values)            
          else 
              fn:error(xs:QName("DOMAIN-UNKNOWN-TYPE-SCHEME"),"Unknown domain scheme")
   else if($ref) then    
        let $ref-scheme := fn:tokenize($ref,':')[1]
        let $ref-value := fn:tokenize($ref,":")[2]        
        return
           if($ref-scheme eq "options") then
              return ($map:get($values,$node/@name),$default)[1]
           else if($ref-scheme eq "model") then
               let $model-name := fn:tokenize($ref-value,"#")[1]
               let $model-func := fn:tokenize($ref-value,"#")[2]
               return
                 xdmp:apply(
                    xdmp:function(
                        xs:QName(map:get($MODEL-REGISTRY,$model-name)[1]),
                        map:get($MODEL-REGISTRY,$mode-name)[2]
                    )
                )
           else 
              fn:error(xs:QName("DOMAIN-UNKNOWN-REF-SCHEME"),"Unknown Reference Scheme",$ref-scheme)
   return
    element {fn:QName("",$name)}
    {
      for $a in $node/domain:attribute
      return domain:recurse-create($a,$values),
      $value
    }  
};
