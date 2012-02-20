xquery version "1.0-ml";
(:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
   Copyright 2011 - Gary Vidal

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::)
(:~
: Model : Base
: @author 
: @version   
~:)

module namespace model = "http://www.xquerrail-framework.com/model/base";

import module namespace search = "http://marklogic.com/appservices/search" at 
"/MarkLogic/appservices/search/search.xqy";

import module namespace util = "http://www.condenast.com/dam/2.0/lib/util" at
"/lib/utils.xqy";

import module namespace domain = "http://www.xquerrail-framework.com/domain" at
"/_framework/domain.xqy";

import module namespace config = "http://www.xquerrail-framework.com/config" at
"/_framework/config.xqy";

declare default collation "http://marklogic.com/collation/codepoint";

(:Options Definition:)
declare option xdmp:mapping "false";
declare variable $collation := "http://marklogic.com/collation/codepoint";

(:~
: Generate a random id 
: @return a random string 
:)
declare function model:create-id() 
as xs:string
{
     fn:string(xdmp:random())
};

(:~
 : returns the root element of a given node
~:)
declare function model:get-root-node($doc as node()) 
as node() {
     xdmp:unpath(xdmp:path(($doc/node())))[1]
};

(:~
 : Gets the idfield from a given param or UUID as default
~:)
declare function model:get-id-from-params($domain-model as element(domain:model), $params as map:map)  
as xs:string?
{
    let $idfield := fn:data($domain-model/domain:element[@identity eq 'true']/@name)
    let $id := map:get($params,$idfield)
    let $uuid := map:get($params,"uuid")
    
    return ($uuid,$id)[1]
};

(:~
 : Create packageType
: @param $domain-model the model of the document
: @param $id the id of the doucment being created so collisions can be avoided
: @param $params the values to fill into the element
 :) 
declare function model:create($domain-model as element(domain:model), $params as map:map) 
as element()?
{
  let $id := model:get-id-from-params($domain-model,$params)
  let $current := model:get($domain-model,$params)
  let $validation := model:validate($domain-model,$params)

  return
      (: Check if the document exists  first before trying to create it:)
      if ($current) then 
        fn:error(xs:QName("DOCUMENT-EXISTS"),fn:concat("The document already exists. Duplicate ID: ", $id))
      else if(fn:count($validation) > 0) then
           fn:error(xs:QName("VALIDATION-ERROR"), fn:concat("The document trying to be created contains validation errors"), $validation)    
      else 
        let $uuid := util:generate-guid-element()
        let $systemMeta := model:create-system-node($domain-model,$params)
      
        let $name := $domain-model/@name
        let $persistence := $domain-model/@persistence
        let $update := 
            element { $name } {
               $uuid,
               $systemMeta, 
               for $element in $domain-model/domain:element
               return
                  element { $element/@name } {
                      if($element/@reference) then 
                        model:get-references($element,$params)
                      else 
                        map:get($params,$element/@name)
                  }
            }
        return
        
        (
            (: Return the update node :)
            $update,
            (: Creation for doucment persitine :)
            if ($persistence = 'document') then
                let $path := $domain-model/domain:document/text() 
                let $doc := fn:doc($path)
                let $rootNode := fn:data($domain-model/domain:document/@root)
                return 
                    if ($doc) then
                         (: create the instance of the model in the document :)      
                         xdmp:node-insert-child(model:get-root-node($doc),$update)
                    else
                        xdmp:document-insert(
                          $path,
                          element { $rootNode } { $update },
                          xdmp:default-permissions(),
                          xdmp:default-collections()
                       )
            (: Creation for directory persitine :)
            else if ($persistence = 'directory') then
                 let $path := fn:concat($domain-model/domain:directory/text() , $uuid/text(), ".xml")
                 return
                     xdmp:document-insert(
                          $path,
                          $update,
                          xdmp:default-permissions(),
                          xdmp:default-collections()
                       )
            else fn:error(xs:QName("ERROR"),"No document persistence defined for creation.")
        )
};
  
(:~
: Retrieves a model document by id
: @param $domain-model the model of the document
: @param $params the values to pull the id from
: @return the document
~:) 
declare function model:get($domain-model as element(domain:model), $params as map:map) as element()? {
    let $id := model:get-id-from-params($domain-model,$params)
    let $idfield := fn:data($domain-model/domain:element[@identity eq 'true']/@name)
    let $name := fn:data($domain-model/@name)
    let $stmt := fn:string(<stmt>
            cts:search(
                {
                    if ($domain-model/@persistence = 'document') then
                        let $rootNode := fn:data($domain-model/domain:document/@root)
                        return
                        fn:concat('fn:doc("', $domain-model/domain:document/text() , '")/', $rootNode, "/",$name)
                    else fn:concat("/",$name) 
                },
                cts:or-query(
                       (cts:element-range-query(xs:QName("uuid"),"=",$id),
                        cts:element-value-query(xs:QName("{$idfield}"),$id))
                ), ("filtered"))
        </stmt>)
    return 
        xdmp:value($stmt)
};

(:~
: Update Operation packageType
: @param $domain-model the model of the document
: @param $id the id of the doucment being retreived (Can be UUID or Model Identity)
: @param $params the values to fill into the element
:) 
declare function model:update($domain-model as element(domain:model), $params as map:map) 
as element()?
{
    let $validation := model:validate($domain-model,$params)
    return
        if(fn:count($validation) > 0) then
               fn:error(xs:QName("VALIDATION-ERROR"), fn:concat("The document trying to be updated contains validation errors"), $validation)    
        else
            let $name := $domain-model/@name
            let $current := model:get($domain-model,$params)
            let $uuid := $current/uuid
            let $update := 
                element { $name } {
                   $uuid,
                   model:create-system-node($domain-model,$params), 
                   for $element in $domain-model/domain:element
                   return
                      element { $element/@name } {
                          if($element/@reference) then 
                            model:get-references($element,$params)
                          else 
                            map:get($params,$element/@name)
                      }
                }
            return
                (: Execute the insert function :)
                ($update,
                    if ($current) then
                        xdmp:node-replace($current,$update)
                    else 
                        fn:error(xs:QName("ERROR"), "Trying to update a document that does not exist.")
                )
};

(:~
: Deletes the model document
: @param $domain-model the model of the document
: @param $params the values to fill into the element
: @return xs:boolean denoted whether delete occurred
:)  
declare function model:delete($domain-model as element(domain:model),$params as map:map)
as xs:boolean
{
  let $current := model:get($domain-model,$params)
  return
    try {
       ( xdmp:node-delete($current),fn:true() )
    } catch($ex) {
       fn:false()  
    }
};

(:~
 : Returns a key value pair of lookup values for use in populating comboboxes from a model
 : You must define your key/keyLabel attributes on the model for this to work.
~:)
declare function model:lookup($domain-model as element(domain:model), $params as map:map) 
{
    let $key := fn:data($domain-model/@key)
    let $label := fn:data($domain-model/@keyLabel)
    let $name := fn:data($domain-model/@name)
            
    let $values := 
        if($domain-model/@persistence = 'document') then
            let $loc :=  $domain-model/domain:document
            let $stmt :=  fn:string(<stmt>{fn:concat('fn:doc("', $loc/text() , '")/', fn:data($loc/@root), "/",$name)}</stmt>)
            let $nodes := xdmp:value($stmt)
            return
              for $node in $nodes
              return 
                  <lookup>
                      <key>{$node/*[fn:local-name(.) = $key]/text()}</key>
                      <label>{$node/*[fn:local-name(.) = $label]/text()}</label>
                  </lookup>
        else 
              let $query := cts:element-query(xs:QName($name), cts:and-query(()))
              return 
                for $item in cts:element-value-co-occurrences(xs:QName($key),xs:QName($label),(),$query)
                return 
                  <lookup>
                      <key>{fn:data($item/cts:value[1])}</key>
                      <label>{fn:data($item/cts:value[2])}</label>
                  </lookup>
    return
        <lookups>{$values}</lookups>
};

(:~
: Returns a list of model instances
: @return  element({model})*   
:)    
declare function model:list($domain-model as element(domain:model), $params as map:map) 
as element(list)? 
{
    let $persistence := $domain-model/@persistence
    let $name := $domain-model/@name
    let $list  := 
        if ($persistence = 'document') then
            let $path := $domain-model/domain:document/text() 
            return
            fn:doc($path)/*/*
        else 
            let $dir := cts:directory-query($domain-model/domain:directory/text())
            return cts:search(fn:collection(),$dir)          
    
    let $total :=
        if($persistence = 'document') then
            fn:count($list/node())
        else 
            let $dir := cts:directory-query($domain-model/domain:directory/text())
            return xdmp:estimate(cts:search(fn:collection(),$dir))
        
    let $page := 
        if(map:get($params,'page') castable as xs:integer) then
            xs:integer(map:get($params, 'page'))
        else 1
        
    let $pageSize := 
        if(map:get($params,'rows') castable as xs:integer) then
            xs:integer(map:get($params, 'rows'))
        else 100
        
    let $start := ($page - 1) * $pageSize + 1
    let $last :=  $start + $pageSize - 1
    let $end := if ($total > $last) then $last else $total
    
    return 
     <list>
         <currentpage xsi:type="xs:integer">{$page}</currentpage>
         <pagesize  xsi:type="xs:integer">{$pageSize}</pagesize>
         <totalpages  xsi:type="xs:integer">{fn:ceiling($total div $pageSize)}</totalpages>
         <totalrecords xsi:type="xs:integer">{$total}</totalrecords>
         { $list[$start to $end] }
     </list>
}; 

(:~
: Build search options for a given domain model
: @param $domain-model the model of the content type
: @return search options for the given model
:)
declare function model:build-search-options($domain-model as element(domain:model))
as element(search:options)
{

let $properties := $domain-model//(domain:element|domain:attribute)[domain:navigation/@searchable = ('value','range')]
let $nav := $domain-model/domain:navigation
let $constraints := 
        for $prop in $properties
        let $type := ($prop/@searchable,"value")[1]
        return
            <search:constraint name="{$prop/@name}">{
              element { fn:QName("http://marklogic.com/appservices/search",$type) } {
                    if ($type eq 'range') then
                      attribute type { "xs:string" }
                    else ()
                    ,
                    <search:element name="{$prop/@name}" ns="" >{
                        (
                            if ($nav/@facetable = 'true') then
                                 attribute facet { fn:true() }
                            else ()
                        ,
                            if ($prop instance of attribute()) then
                              <search:attribute name="{$prop/@name}" ns=""/> 
                            else ()
                        )
                    }</search:element>
              }
            }</search:constraint>
        
  let $sortOptions := 
     for $prop in $properties
     return
        ( <search:state name="{$prop/@name}">
             <search:sort-order direction="ascending" type="{$prop/@type}" collation="{$collation}">
              <search:element ns="" name="{$prop/@name}"/>
             </search:sort-order>
             <search:sort-order>
              <search:score/>
             </search:sort-order>
        </search:state>,
        <search:state name="{$prop/@name}-descending">
             <search:sort-order direction="descending" type="{$prop/@type}" collation="{$collation}">
              <search:element ns="" name="{$prop/@name}"/>
             </search:sort-order>
             <search:sort-order>
              <search:score/>
             </search:sort-order>
      </search:state>,
      <search:state name="{$prop/@name}-ascending">
             <search:sort-order direction="ascending" type="{$prop/@type}" collation="{$collation}">
              <search:element ns="" name="{$prop/@name}"/>
             </search:sort-order>
             <search:sort-order>
              <search:score/>
             </search:sort-order>
      </search:state>)
        
    let $options :=     
        <search:options>
         {$constraints}
         <search:operator name="sort">
             {$sortOptions}
         </search:operator>
     </search:options>
    
    return $options
};

(:~
: Provide search interface for the model
: @param $domain-model the model of the content type
: @param $params the values to fill into the search
: @return search response element
~:)
declare function model:search($domain-model as element(domain:model), $params as map:map)  
as element(search:response)
{

   let $query as xs:string := map:get($params, "query")
   let $sort as xs:string  := map:get($params, "sort")
   let $sort-order as xs:string := map:get($params, "sort-order")
   let $start as xs:integer  := map:get($params, "start") cast as xs:integer
   let $end as xs:integer  := map:get($params, "end") cast as xs:integer
   let $final := fn:concat($query," ",$sort)

   let $options := model:build-search-options($domain-model)
   return
     search:search($final,$options,$start,$end)
};
 
(:~ 
: This function will create a sequence of nodes that represent each
: model for inlining in other references. 
: @param $ids a sequence of ids for models to be extracted
: @return a sequence of packageType
:)
declare function model:reference($domain-model as element(domain:model), $params as map:map) 
as element()?
{
    let $name := $domain-model/@name
    let $keyLabel := fn:data($domain-model/@keyLabel)
    let $key := fn:data($domain-model/@key)
    let $modelReference := model:get($domain-model,$params)
    let $_ := xdmp:log(("....Reference....",$modelReference))
    return
        element { $name } {
            attribute ref-uuid { $modelReference/uuid/text() },
            attribute ref-id { $modelReference/node()[fn:local-name(.) = $key]/text() },
            attribute ref { $name },
            $modelReference/node()[fn:local-name(.) = $keyLabel]/text()
        }
};

(:~
: This function will call the appropriate reference type model to build 
: a relationship between two models types.
: @param $reference is the reference element that is used to contain the references
: @param $params the params items to build the relationship
:)
 declare function model:get-references($reference as element(domain:element), $params as map:map)
 as element()* 
 {
    
    let $name := fn:data($reference/@name)
    let $tokens := fn:tokenize($reference/@reference, ":")
    let $type := $tokens[2]
    let $path := config:get-model-xqy-path($type)
    let $ns := "http://www.xquerrail-framework.com/model/base"
    let $funct := xdmp:function(fn:QName($ns,$tokens[3]),$path)
    return
        if(fn:function-available($tokens[3])) then
            let $domain-model := domain:get-domain-model($type)
            return
                for $id in map:get($params,$name)        
                let $identity := $domain-model/domain:element[@identity eq 'true']/@name
                let $newParams := map:map()
                let $_ := map:put($newParams,$identity,$id)
                let $_ := xdmp:log("Calling Funct")
                return 
                    xdmp:apply($funct, $domain-model,$newParams)   
        else fn:error(xs:QName("ERROR"), "No Reference function avaliable.")
 };
 
 (:~ 
 : This is a function will crate all the system specific noeds.
 : @param $domain-model The model of the domain that is being built
 : @param $params the parameters of the action being executed.
 :)
 declare private function model:create-system-node($domain-model as element(domain:model), $params as map:map) 
 as element()*
 {
    let $current := model:get($domain-model,$params)
    return
        if(fn:exists($current)) then 
           (
               $current/created,
               $current/createdBy,
               $current/modified,
               $current/modifiedBy,
               <modified>{fn:current-dateTime()}</modified>,
               <modifiedBy userId="{map:get($params,"userId")}">{map:get($params,"username")}</modifiedBy>
           )
        else
            (
                <created>{fn:current-dateTime()}</created>,
                <createdBy userId="{map:get($params,"userId")}">{map:get($params,"username")}</createdBy>
            )
};

(:~ 
: This is a function that will validate the params with the domain model
: @param domain-model the model to validate against
: @param $params the params to validate 
: @return return a set of validation errors if any occur.
:)
declare function model:validate($domain-model as element(domain:model), $params as map:map)
as element(validationError)*
{
   for $element in $domain-model/domain:element
   let $name := fn:data($element/@name)
   let $type := domain:resolve-datatype($element)
   let $value := map:get($params,$name)
   let $occurence := $element/@occurence
   return

        if( fn:data($occurence) eq "?" and fn:not(fn:count($value) <= 1) )  then
            <validationError>
                <element>{$name}</element>
                <type>{fn:local-name($occurence)}</type>
                <typeValue>{fn:data($occurence)}</typeValue>
                <error>The value of {$name} must have zero or one value.</error>
            </validationError>
        else if( fn:data($occurence) eq "+" and fn:not(fn:count($value) = 1) ) then 
             <validationError>
                <element>{$name}</element>
                <type>{fn:local-name($occurence)}</type>
                <typeValue>{fn:data($occurence)}</typeValue>
                <error>The value of {$name} must contain exactly one.</error>
            </validationError>
        else
            for $attribute in $element/domain:constraint/@*
            return
                typeswitch($attribute)
                case attribute(required) return
                    if(fn:data($attribute) = "true" and $value = "") then 
                        <validationError>
                            <element>{$name}</element>
                            <type>{fn:local-name($attribute)}</type>
                            <typeValue>{fn:data($attribute)}</typeValue>
                            <error>The value of {$name} can not be empty.</error>
                        </validationError>
                    else ()
                case attribute(minLength) return
                    if(xs:integer(fn:data($attribute)) > fn:string-length($value)) then
                            <validationError>
                                <element>{$name}</element>
                                <type>{fn:local-name($attribute)}</type>
                                <typeValue>{fn:data($attribute)}</typeValue>
                                <error>The length of {$name} must be longer than {fn:data($attribute)}.</error>
                            </validationError>
                        else ()
                case attribute(maxLength) return
                    if(xs:integer(fn:data($attribute)) < fn:string-length($value)) then
                        <validationError>
                            <element>{$name}</element>
                            <type>{fn:local-name($attribute)}</type>
                            <typeValue>{fn:data($attribute)}</typeValue>
                            <error>The length of {$name} must be shorter than {fn:data($attribute)}.</error>
                        </validationError>
                    else ()
                case attribute(minValue) return
                   let $attributeValue := xdmp:value(fn:concat("fn:data($attribute) cast as ", $type))
                   let $value := xdmp:value(fn:concat("$value cast as ", $type))
                   return
                       if($attributeValue > $value) then
                            <validationError>
                                 <element>{$name}</element>
                                 <type>{fn:local-name($attribute)}</type>
                                 <typeValue>{fn:data($attribute)}</typeValue>
                                 <error>The value of {$name} must be greater than {$attributeValue}.</error>
                             </validationError>
                        else ()
                case attribute(maxValue) return
                   let $attributeValue := xdmp:value(fn:concat("fn:data($attribute) cast as ", $type))
                   let $value := xdmp:value(fn:concat("$value cast as ", $type))
                   return
                       if($attributeValue < $value) then
                            <validationError>
                                 <element>{$name}</element>
                                 <type>{fn:local-name($attribute)}</type>
                                 <typeValue>{fn:data($attribute)}</typeValue>
                                 <error>The value of {$name} must be less than {$attributeValue}.</error>
                             </validationError>
                        else ()
                 case attribute(inList) return
                    let $options := $domain-model/domain:optionlist[@name = fn:data($attribute)]/domain:option/text()
                    return
                        if(fn:not($options = $value)) then
                            <validationError>
                                <element>{$name}</element>
                                <type>{fn:local-name($attribute)}</type>
                                <typeValue>{fn:data($attribute)}</typeValue>
                                <error>The value of {$name} must be one of the following values [{fn:string-join($options,",")}].</error>
                            </validationError>
                         else ()
                case attribute(pattern) return
                        if(fn:not(fn:matches($value,fn:data($attribute)))) then
                            <validationError>
                                <element>{$name}</element>
                                <type>{fn:local-name($attribute)}</type>
                                <typeValue>{fn:data($attribute)}</typeValue>
                                <error>The value of {$name} must match the regular expression {fn:data($attribute)}.</error>
                            </validationError>
                         else ()
                default return ()
};

(:~
 : Provides the ability to put a new document in the database.
~:)
declare function model:put($domain-model as element(domain:model), $body as node()) 
{   
    let $params := model:build-params-map-from-json($domain-model,$body)
    let $current := model:get($domain-model, $params)
    return 
        model:create($domain-model,$params)
};

(:~
 : Provides the ability to post an update to an existing model in the database
~:)
declare function model:post($domain-model as element(domain:model), $body as node())  {
    let $params := model:build-params-map-from-json($domain-model,$body)
    let $current := model:get($domain-model, $params)
    return 
        model:update($domain-model,$params)
};

(:~
 : This should not be here move to helper or controller
~:)
declare private function model:build-params-map-from-json($domain-model as element(domain:model), $body as node()) {
    let $params := map:map()
    let $_ := 
        for $jsonNode in $body/json/node()
        return
            if ($domain-model/domain:element[@name = fn:local-name($jsonNode)])
            then map:put($params,fn:local-name($jsonNode),$jsonNode/node())
            else if(fn:local-name($jsonNode) = "uuid") then map:put($params,fn:local-name($jsonNode),$jsonNode/node())
            else fn:error(xs:QName("DOMAIN-ELEMENT-DOES-NOT-EXIST"), "This JSON node does not exist within the domain-model", fn:local-name($jsonNode))
    return $params    
};