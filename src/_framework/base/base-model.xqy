xquery version "1.0-ml";
(:~
: Model : Base
: @author Gary Vidal
: @version  1.0
~:)

module namespace model = "http://www.xquerrail-framework.com/model/base";

import module namespace search = "http://marklogic.com/appservices/search" at 
"/MarkLogic/appservices/search/search.xqy";

import module namespace domain = "http://www.xquerrail-framework.com/domain" at
"/_framework/domain.xqy";

import module namespace config = "http://www.xquerrail-framework.com/config" at
"/_framework/config.xqy";

declare default collation "http://marklogic.com/collation/codepoint";

(:Options Definition:)
declare option xdmp:mapping "false";

declare variable $COLLATION := "http://marklogic.com/collation/codepoint";

(:~
: Generates a UUID based on the SHA1 algorithm.
: Wallclock will be used to make the UUIDs sortable.
:)
declare function model:generate-uuid($seed as xs:integer?) 
as xs:string
{
  let $wallclock := xdmp:wallclock-to-timestamp(fn:current-dateTime() + xdmp:elapsed-time())
  let $sha1 := xdmp:sha1(fn:string($wallclock + $seed))
  let $guid := fn:replace($sha1,"(\c{8})(\c{4})(\c{4})(\c{4})(\c{12})","$1-$2-$3-$4-$5")
  return $guid
};

(:~
:
:)
declare function model:generate-uuid()
as xs:string
{
    model:generate-uuid(xdmp:random(1000)) 
};

(:~
: This function accepts a doc node and converts to an element node and 
: returns the first element node of the document
: @param - $doc - the doc
: @return - the root as a node
:)
declare function model:get-root-node($doc as node()) 
as node() {
     xdmp:unpath(xdmp:path(($doc/node())))[1]
};

(:~
: This function checks the parameters for an identifier that signifies the instance of a model
: @param - $domain-model - domain model of the content
: @param - $params - parameters of content that pertain to the domain model
: @return a identity or uuid value (repsective) for identifying the model instance
:)
declare function model:get-id-from-params(
   $domain-model as element(domain:model), 
   $params as map:map)  
as xs:string+
{
   let $id-field := domain:get-model-id-field($domain-model)
   let $id-key := 
     $domain-model/(domain:element|domain:attribute)[@name eq $id-field]
   return
      (domain:get-field-id($id-key),fn:data($id-key/@name))
};
(:~
 : Gets only the params for a given model
 : @param - $domain-model - is the model for the given params
 : @param - $params - parameters of content that pertain to the domain model
 : @param - $strict - boolean value on whether to be strict or not
 :)
declare function model:get-model-params(
   $domain-model as element(domain:model),
   $params as map:map,
   $strict as xs:boolean
   )
{
   let $model-params := map:map()
   return (
     for $f in $domain-model/(domain:element|attribute)
     return (
        map:put($model-params,$f/@name,map:get($params,$f/@name)),
        map:delete($model-params,$f/@name)
     ),  
     if(map:count($params) gt 0 and $strict) 
     then fn:error(xs:QName("INVALID-PARAMETERS"),"Additional Parameters are not allowed in strict mode")
     else (),     
        $model-params
   )
};

(:~ 
 : Creates a model for a given domain
 : @param - $domain-model - is the model for the given params
 : @param - $params - parameters of content that pertain to the domain model
 : @returns element
 :) 
declare function model:create(
    $domain-model as element(domain:model), 
    $params as map:map
) 
as element()?
{
  (:  let $params := model:get-model-params($domain-model,$params,fn:false()) :)
  let $id := model:get-id-from-params($domain-model,$params)
  let $current := model:get($domain-model,$params)
  return
      (: Check if the document exists  first before trying to create it :)
      if ($current) then 
          fn:error(xs:QName("DOCUMENT-EXISTS"),fn:concat("The document already exists. Duplicate ID: ", $id),$current)
      else 
        (: Validate the parameters before trying to build the document :)
        let $validation :=  () (: model:validate($domain-model,$params) :)
        return
         if(fn:count($validation) > 0) 
         then fn:error(xs:QName("VALIDATION-ERROR"), fn:concat("The document trying to be created contains validation errors"), $validation)    
         else 
           let $name := $domain-model/@name
           let $persistence := $domain-model/@persistence
           let $update := model:recursive-create($domain-model,$params) 
           return (
               (: Return the update node :)
               $update,
               (: Creation for doucment persistence :)
               if ($persistence = 'document') then
                   let $path := $domain-model/domain:document/text() 
                   let $doc := fn:doc($path)
                   let $root-node := fn:data($domain-model/domain:document/@root)
                   let $root-namespace := domain:get-field-namespace($domain-model)
                   return 
                       if ($doc) then
                            (: create the instance of the model in the document :)      
                            xdmp:node-insert-child(model:get-root-node($doc),$update)
                       else
                           xdmp:document-insert(
                             $path,
                             element { fn:QName($root-namespace,$root-node) } { $update },
                             xdmp:default-permissions(),
                             xdmp:default-collections()
                          )
               (: Creation for directory persistence :)
               else if ($persistence = 'directory') then
                    let $path := fn:concat($domain-model/domain:directory/text() , $update/*:uuid/text(), ".xml")
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
declare function model:get(
   $domain-model as element(domain:model), 
   $params as map:map
) as element()? {    
    (: Get document identifier from parameters :)
    (: Retrieve document identity and namspace to help build query :)
    let $id-field   := domain:get-model-id-field($domain-model)
    let $id-fields  := model:get-id-from-params($domain-model,$params)
    let $id-value   := (for $k in $id-fields return map:get($params, $k))[1]
    let $name := fn:data($domain-model/@name)
    let $nameSpace := domain:get-field-namespace($domain-model)
    let $stmt := 
      fn:normalize-space(fn:string(
      <stmt>cts:search({
                    (: Build a query to search within the give document :)
                    if ($domain-model/@persistence = 'document') then
                        let $rootNode := fn:data($domain-model/domain:document/@root)
                        (: if namespaces are given use it :)
                        let $xpath := 
                            if($nameSpace) then
                               fn:concat("/*:", $rootNode, "[fn:namespace-uri(.) = '", $nameSpace, "']/*:", $name, "[fn:namespace-uri(.) = '", $nameSpace, "']")
                            else 
                                fn:concat("/", $rootNode, "/", $name)
                        return
                            (: Create a constraint :)
                            fn:concat('fn:doc("', $domain-model/domain:document/text() , '")', $xpath )
                    else 
                        (: otherwise for document persistance search against the proper root node :)
                        fn:concat("/*:",$name, "[fn:namespace-uri(.) = '", $nameSpace, "']") 
                },
                cts:or-query(
                       (cts:element-range-query(fn:QName("{$nameSpace}","{$id-field}"),"=","{$id-value}"))  
                ), ("filtered"))
        </stmt>))

    return (
        (: Execute statement :)
        xdmp:log(("model:get::",$stmt)),
        xdmp:value($stmt)
        )
};

(:~
 : Creates an update statement for a given model.
~:)
declare function model:update($domain-model as element(domain:model), $params as map:map)
{
   let $current := model:get($domain-model,$params)
   let $_ := xdmp:log(("model:update::",$params))
   let $id := $domain-model//(domain:container|domain:element|domain:attribute)[@identity eq "true"]/@name
   return 
     if($current) then (
        let $build := model:recursive-update($domain-model,$current,$params)
        let $validation := () (: model:validate($domain-model,$params) :)
        return
            if(fn:count($validation) > 0) then
                fn:error(xs:QName("VALIDATION-ERROR"), fn:concat("The document trying to be updated contains validation errors"), $validation)    
            else 
                xdmp:node-replace($current,$build)
                (:Create delta map and save and logged:)
     )
     else 
       fn:error(xs:QName("ERROR"), "Trying to update a document that does not exist.")
};

(:~
 :  Returns all namespaces from model,application
~:)
declare function model:get-namespaces($model as element(domain:model)) {
   let $ns-map := map:map()
   let $nses := 
      for $kv in (
        fn:root($model)/(domain:content-namespace|domain:declare-namespace),
        $model/domain:declare-namespace
     )
      return map:put($ns-map, ($kv/@prefix),fn:data($kv/@namespace-uri))
   for $ns in map:keys($ns-map)
   return 
     <ns prefix="{$ns}" namespace-uri="{map:get($ns-map,$ns)}"/>
};

declare function model:recursive-update-partial(
$context,$current,$updates)
{
  let $current := ()
  return $current
};

declare function model:recursive-create(
   $context as node(),
   $updates as map:map
){
    model:recursive-build( $context, (), $updates) 
};

declare function model:recursive-update(   
   $context as node(),
   $current as node(),
   $updates as map:map
) 
{
    model:recursive-build( $context, $current, $updates) 
};

declare function model:recursive-build(
   $context as node(),
   $current as node()?,
   $updates as map:map
) {
   let $type := fn:data($context/@type)
   let $key  := domain:get-field-id($context)
   let $current-value := domain:get-field-value($context,$key,$current)
   return    
   typeswitch($context)
   (: Build out any domain Models :)
   case element(domain:model) return
        let $attributes := 
            for $a in $context/domain:attribute 
            return 
               model:recursive-build($a, $current,$updates)
        let $ns := domain:get-field-namespace($context)
        let $nses := model:get-namespaces($context)
        let $localname := fn:data($context/@name)
        let $default   := fn:data($context/@default)
        return 
            element {(fn:QName($ns,$localname))} {
                for $nsi in $nses
                return 
                  namespace {$nsi/@prefix}{$nsi/@namespace-uri},
                $attributes,
                for $n in $context/(domain:element|domain:container)
                return 
                    model:recursive-build($n,$current,$updates)             
            }
     (: Build out any domain Elements :)     
     case element(domain:element) return
        let $attributes := 
            for $a in $context/domain:attribute 
            return 
                model:recursive-build($a,$current, $updates)
        let $ns := domain:get-field-namespace($context)
        let $localname := fn:data($context/@name)
        let $default   := (fn:data($context/@default),"")[1]
        let $occurrence := ($context/@occurrence,"?")
        let $map-values := map:get($updates,$key)
        let $map-values := 
            if ($map-values) 
            then $map-values 
            else $default
        return 
          if ($context/@type eq "reference" and $context/@reference ne "") 
          then model:build-value($context, $map-values, $current-value)
          else  
            if ($type = "schema-element") then
               element {(fn:QName($ns,$localname))}{
                  model:build-value($context, $map-values, $current-value)
               }
            else
                for $value in $map-values
                return
                   element {(fn:QName($ns,$localname))}{
                      $attributes,
                      model:build-value($context,  $value, $current-value)
                    }
                    
     (: Build out any domain Attributes :)              
     case element(domain:attribute) return
        let $ns := ($context/@namespace-uri,$context/@namespace)[1] (:Attributes are only in namespace if they are declared:)
        let $localname := fn:data($context/@name)
        let $default   := (fn:data($context/@default),"")[1]
        let $occurrence := ($context/@occurrence,"?")
        let $map-value := map:get($updates,$key)
        let $value := ($map-value,$default)[1]
        return 
          attribute {(fn:QName($ns,$localname))}{
            model:build-value($context, $value,$current-value)
          }
          
     (: Build out any domain Containers :)     
     case element(domain:container) return
        let $ns := domain:get-field-namespace($context)
        let $localname := fn:data($context/@name)
        return 
          element {(fn:QName($ns,$localname))}{
           for $n in $context/(domain:attribute|domain:element|domain:container)
           return 
             model:recursive-build($n,  $current ,$updates)
           }
           
     (: Return nothing if the type is not of Model, Element, Attribute or Container :)      
     default return ()
     
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

declare function model:lookup($domain-model as element(domain:model), $params as map:map) 
{
    let $key := fn:data($domain-model/@key)
    let $label := fn:data($domain-model/@keyLabel)
    let $name := fn:data($domain-model/@name)
    let $nameSpace :=  fn:data(model:get-namespaces($domain-model)/@namespace-uri)
        
    let $values := 
        if($domain-model/@persistence = 'document') then
            let $loc :=  $domain-model/domain:document
            let $rootNode := fn:data($loc/@root)
            
            let $xpath := 
                if($nameSpace) then
                    fn:concat("/*:", $rootNode, "[fn:namespace-uri(.) = '", $nameSpace, "']/*:", $name, "[fn:namespace-uri(.) = '", $nameSpace, "']")
                else 
                    fn:concat("/", $rootNode, "/", $name)
            
            let $stmt :=  fn:string(<stmt>{fn:concat('fn:doc("', $loc/text() , '")', $xpath)}</stmt>)
            let $nodes := xdmp:value($stmt)
            return
              for $node in $nodes
              return 
                  <lookup>
                      <key>{$node/*[fn:local-name(.) = $key]/text()}</key>
                      <label>{$node/*[fn:local-name(.) = $label]/text()}</label>
                  </lookup>
        else if ($domain-model/@persistence = 'directory') then 
              let $query := cts:element-query(fn:QName($nameSpace,$name), cts:and-query(cts:directory-query($domain-model/domain:directory/text())))
              return 
                for $item in cts:element-value-co-occurrences(fn:QName($nameSpace,$key),fn:QName($nameSpace,$label),(),$query)
                return 
                  <lookup>
                      <key>{fn:data($item/cts:value[1])}</key>
                      <label>{fn:data($item/cts:value[2])}</label>
                  </lookup>
        else ()
    return
        <lookups type="{$domain-model/@name}">{$values}</lookups>
};

(:~
: Returns a list of packageType
: @return  element(packageType)*   
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
     <list type="{$name}">
         <currentpage>{$page}</currentpage>
         <pagesize>{$pageSize}</pagesize>
         <totalpages>{fn:ceiling($total div $pageSize)}</totalpages>
         <totalrecords>{$total}</totalrecords>
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

let $properties := $domain-model//(domain:element|domain:attribute)[domain:navigation/@searchable = ('true')]
let $modelNamespace :=  fn:data(model:get-namespaces($domain-model)/@namespace-uri)

let $nav := $domain-model/domain:navigation
let $constraints := 
        for $prop in $properties
        let $type := ($prop/domain:navigation/@search-type,"value")[1]
        let $ns := ($prop/@namespace,$prop/ancestor::domain:model/@namespace, $modelNamespace)[1]
        return
            <search:constraint name="{$prop/@name}">{
              element { fn:QName("http://marklogic.com/appservices/search",$type) } {
                    attribute collation {$COLLATION}
                    ,
                    if ($type eq 'range') then
                      attribute type { "xs:string" }
                    else ()
                    ,
                    <search:element name="{$prop/@name}" ns="{$ns}" >{
                        (
                            if ($nav/@facetable = 'true') then
                                 attribute facet { fn:true() }
                            else ()
                        ,
                            if ($prop instance of attribute()) then
                              <search:attribute name="{$prop/@name}" ns="{$ns}"/> 
                            else ()
                        )
                    }</search:element>
              }
            }</search:constraint>
            
  let $sortOptions := 
     for $prop in $properties
     let $ns := ($prop/@namespace,$prop/ancestor::domain:model/@namespace, $modelNamespace)[1]
     return
        ( <search:state name="{$prop/@name}">
             <search:sort-order direction="ascending" type="{$prop/@type}" collation="{$COLLATION}">
              <search:element ns="{$ns}" name="{$prop/@name}"/>
             </search:sort-order>
             <search:sort-order>
              <search:score/>
             </search:sort-order>
        </search:state>,
        <search:state name="{$prop/@name}-descending">
             <search:sort-order direction="descending" type="{$prop/@type}" collation="{$COLLATION}">
              <search:element ns="{$ns}" name="{$prop/@name}"/>
             </search:sort-order>
             <search:sort-order>
              <search:score/>
             </search:sort-order>
      </search:state>,
      <search:state name="{$prop/@name}-ascending">
             <search:sort-order direction="ascending" type="{$prop/@type}" collation="{$COLLATION}">
              <search:element ns="{$ns}" name="{$prop/@name}"/>
             </search:sort-order>
             <search:sort-order>
              <search:score/>
             </search:sort-order>
      </search:state>)
        
   let $persistence := fn:data($domain-model/@persistence)
   let $addQuery := 
        if ($persistence = "document") then 
           cts:document-query($domain-model/domain:document/text())
        else if($persistence = "directory") then
            cts:directory-query($domain-model/domain:directory/text())
        else ()
        
    let $options :=     
        <search:options>
            <search:return-query>{fn:true()}</search:return-query>
            <search:return-facets>{fn:true()}</search:return-facets>
            <search:additional-query>{$addQuery}</search:additional-query>
             {$constraints}
             <search:operator name="sort">{$sortOptions}</search:operator>
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
   let $pageLength as xs:integer  := map:get($params, "page-length") cast as xs:integer
   let $final := fn:concat($query," ",$sort)
   
   let $options := model:build-search-options($domain-model)
   return
     search:search($final,$options,$start,$pageLength)
};


declare function model:get-references($field as element(), $params as map:map) {
    let $refTokens := fn:tokenize(fn:data($field/@reference), ":")
    let $element := element {$refTokens[1]} { $refTokens[1] }
    return 
        typeswitch ($element) 
        case element(model) 
        return model:get-model-references($field,$params)
        case element(application)
        return model:get-application-reference($field,$params)
        default return ()
};

(:~
: This function will call the appropriate reference type model to build 
: a relationship between two models types.
: @param $reference is the reference element that is used to contain the references
: @param $params the params items to build the relationship
:)
 declare function model:get-model-references($reference as element(domain:element), $params as map:map)
 as element()* 
 {
    let $fieldKey := domain:get-field-id($reference)
    let $name := fn:data($reference/@name)
    let $tokens := fn:tokenize($reference/@reference, ":")
    let $type := $tokens[2]
    let $path := config:get-model-xqy-path($type)
    let $ns := "http://www.xquerrail-framework.com/model/base"
    let $funct := xdmp:function(fn:QName($ns,$tokens[3]),$path)
    return
        if(fn:function-available($tokens[3])) then
            let $domain-model := domain:get-domain-model($type)
            let $identity := domain:get-model-id-field($domain-model)
            let $key := domain:get-field-id($domain-model//(domain:element|domain:attribute)[@name  = $identity])  
            return
                for $id at $pos in map:get($params,$fieldKey)
                let $newParams := map:map()
                let $_ := map:put($newParams,$key,$id)
                return 
                    xdmp:apply($funct, $domain-model,$newParams)   
        else fn:error(xs:QName("ERROR"), "No Reference function avaliable.")
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
    let $keyLabel := fn:data($domain-model/@keyLabel)
    let $key := fn:data($domain-model/@key)
    let $modelReference := model:get($domain-model,$params)
    
    let $name := fn:data($domain-model/@name)
    let $ns := $domain-model/@namespace
    let $qName := fn:QName($ns,$name)

    return
        if($modelReference) then
             element { $qName } {
                 attribute ref-type { "model" },
                 attribute ref-uuid { $modelReference/*:uuid/text() },
                 attribute ref-id { $modelReference/node()[fn:local-name(.) = $key]/text() },
                 attribute ref { $name },
                 $modelReference/node()[fn:local-name(.) = $keyLabel]/text()
             }
        else ()
};

declare private function model:get-application-reference($field,$params){
   let $reference := fn:data($field/@reference)
   let $ref-tokens := fn:tokenize($reference,":")
   let $ref-parent   := $ref-tokens[1]
   let $ref-type     := $ref-tokens[2]
   let $ref-action   := $ref-tokens[3]
   
   
   let $localName := fn:data($field/@name)
   let $ns := ($field/@namespace,$field/ancestor::domain:model/@namespace)[1]
   let $qName := fn:QName($ns,$localName)
  
   return
      if($ref-parent eq "application" and $ref-type eq "model")
      then 
        let $domains := xdmp:value(fn:concat("domain:model-",$ref-action))
        let $key := domain:get-field-id($field)
        return
            for $value in map:get($params, $key)
            let $domain := $domains[@name = $value] 
            return
                if($domain) then
                     element { $qName } {
                         attribute ref-type { "application" },
                         attribute ref-id { fn:data($domain/@name) },
                         attribute ref { $field/@name },
                         fn:data($domain/@label)
                     }
                else ()
      else if($ref-parent eq "application" and $ref-type eq "controller")
      then 
        xdmp:value(fn:concat("domain:controller-",$ref-action))
      else fn:error(xs:QName("REFERENCE-ERROR"),"Invalid Application Reference",$ref-action)
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
   for $element in $domain-model/(domain:attribute | domain:element)
   let $name := fn:data($element/@name)
   let $key := domain:get-field-id($element)
   let $type := domain:resolve-datatype($element)
   let $value := model:build-value($element, map:get($params,$key),())
   let $occurence := $element/@occurence
   return
        (
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
        else (),
        
        for $attribute in $element/domain:constraint/@*
        return
            typeswitch($attribute)
            case attribute(required) return
                if(fn:data($attribute) = "true" and fn:exists($value)) then 
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
            )
};


declare function model:put($domain-model as element(domain:model), $body as node()) 
{   
    let $params := model:build-params-map-from-json($domain-model,$body)
    return 
        model:create($domain-model,$params)
};

declare function model:post($domain-model as element(domain:model), $body as node())  {
    let $params := model:build-params-map-from-json($domain-model,$body)
    return 
        model:update($domain-model,$params)
};

declare function model:build-params-map-from-json($domain-model as element(domain:model), $body as node()) {
    let $params := map:map()
    let $_ := 
        for $jsonNode in $body/json/node()
        return
            map:put($params,fn:string(fn:node-name($jsonNode)),$jsonNode/node())
    return $params    
};

declare function model:build-value(
  $field as element(),
  $value as item()*,
  $current as item()*)
{
  let $localName := fn:data($field/@name)
  let $ns := domain:get-field-namespace($field)
  let $qName := fn:QName($ns,$localName)
  let $qtype := element {xs:QName(fn:data($field/@type))} { fn:data($field/*) }
  return
    typeswitch($qtype)
    case element(identity) return 
        if(fn:data($current)) 
        then fn:data($current)
        else model:generate-uuid()
    case element(reference) return
        let $fieldKey := domain:get-field-id($field)
        let $map := map:map()
        let $_ := map:put($map, $fieldKey, $value)
        let $_ := xdmp:log(("reference::",$fieldKey,$value))
        return
            for $ref in model:get-references($field,$map)
            return 
            element { fn:QName($ns, $localName) } {
                $ref/@*,
                $ref/text()
            }
    case element(instance-of) return ()
    case element(update-timestamp) return 
        fn:current-dateTime()
    case element(update-user) return  
        xdmp:get-current-user()
    case element(create-timestamp) return 
        if(fn:data($current))
        then fn:data($current)
        else fn:current-dateTime()
    case element(create-user) return 
        if(fn:data($current))
        then fn:data($current)
        else xdmp:get-current-user()
    case element(file) return 
        $value/binary()
    case element(schema-element) return 
        $value
    case element(query) return 
        $value
    default return 
        fn:data($value) 
};
