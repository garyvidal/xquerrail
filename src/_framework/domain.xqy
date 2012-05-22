xquery version "1.0-ml";
module namespace domain = "http://www.xquerrail-framework.com/domain";

import module namespace config = "http://www.xquerrail-framework.com/config"
at "/_framework/config.xqy";

declare variable $DOMAIN-FIELDS := 
   for  $fld in ("domain:model","domain:container","domain:element","domain:attribute") 
   return  xs:QName($fld);
   
declare variable $DOMAIN-NODE-FIELDS := 
   for  $fld in ("domain:container","domain:element","domain:attribute") 
   return  xs:QName($fld);

declare function domain:get-model-id-field($model as element(domain:model)) {
  $model/(domain:element|domain:attribute)
  [fn:node-name(.) = $DOMAIN-NODE-FIELDS][./@identity eq "true" or ./@type eq "identity"]/fn:string(@name)
};
declare function domain:resolve-datatype($field)
{
   let $data-type := element{$field/@type}{$field}
   return 
     typeswitch($data-type)
     case element(uuid) return "xs:string"
     case element(identity) return "xs:ID"
     case element(create-timestamp) return "xs:dateTime"
     case element(create-user) return "xs:string"
     case element(update-timestamp) return "xs:dateTime"
     case element(update-user) return "xs:string"
     case element(modify-user) return "xs:string"
     case element(binary) return "binary()"
     case element(schema-element) return "schema-element()"
     case element(query) return "cts:query"
     case element(point) return "cts:point"
     case element(string) return "xs:string"
     case element(integer) return "xs:integer"
     case element(int) return "xs:int"
     case element(long) return "xs:long"
     case element(double) return "xs:double"
     case element(decimal) return "xs:decimal"
     case element(float) return "xs:float"
     case element(boolean) return "xs:boolean"
     case element(anyURI) return "xs:anyURI"
     case element(dateTime) return "xs:dateTime"
     case element(date) return "xs:date"
     case element(duration) return "xs:duration"
     case element(dayTime) return "xs:dayTimeDuration"
     case element(yearMonth) return "xs:yearMonthDuration"
     case element(monthDay) return "xs:monthDayDuration"
     case element(reference) return "element()"
     default return fn:error(xs:QName("UNRESOLVED-DATATYPE"),$field)
};

declare function domain:get-controller(
   $application-name as xs:string,
   $controller-name as xs:string
) as element(domain:controller)? 
{
    let $domain := config:get-domain($application-name)
    return 
        $domain/domain:controller[@name eq $controller-name]  
};
declare function domain:get-controller-model(
    $application-name as xs:string, 
    $controller-name as xs:string
)
{
     let $domain := config:get-domain($application-name)
     let $controller := domain:get-controller($application-name,$controller-name)
     let $model := domain:get-domain-model(fn:data($controller/@model))
     return 
        $model
};

declare function domain:get-controller-name($application as xs:string, $model-name as xs:string)
{
    let $domain := config:get-domain($application)
    return
        fn:data($domain/domain:controller[@model = $model-name]/@name)
};

declare function domain:get-domain-model($domain-name as xs:string*) {
    domain:get-domain-model("application", $domain-name)
};

declare function domain:get-domain-model($application as xs:string, $domain-name as xs:string*)  
as element()*
{
  let $path := config:get-application($application)/config:domain/@resource
  let $domain := xdmp:invoke($path)  
  let $models := 
    for $modelName in $domain-name
    let $model := $domain/domain:model[@name = $modelName]
    return
        if($model/@extends) then
            let $extendedDomain := $domain/domain:model[@name = fn:data($model/@extends)]
            return
                element { fn:node-name($model) } {
                    $model/@*,
                    for $f in  $extendedDomain/(domain:element | domain:container | domain:attribute)
                    return 
                        element { fn:node-name($f) } {
                            if($f/@namespace) 
                            then $f/@namespace
                            else $extendedDomain/@namespace
                            
                            , $f/@*[. except $f/@namespace] 
                            , $f/node()
                        }
                    , $model/node()
                }
        else $model
    return $models
};

declare function domain:get-controllers(
$application-name as xs:string
){
   config:get-domain($application-name)/domain:controller
};

declare function domain:get-default-application(){
    config:default-application()
};

declare function domain:get-default-namespace(
$application-name as xs:string
) {
    let $application := config:get-domain($application-name)
    return 
       $application/domain:content-namespace
};

declare function domain:get-in-scope-namespaces(
$application-name as xs:string
) as element(namespace)
{
  ()   
};

declare function domain:get-namespaces($application-name as xs:string) {
    let $application := config:get-domain($application-name)
    return 
    $application/(domain:content-namespace | domain:declare-namespace)
};

declare function domain:model-selector( 
   $application-name as xs:string,
   $class as xs:string
) as element(domain:model)*
{ 
   let $domain := config:get-domain($application-name)
   return
       $domain/domain:model[@class eq $class]
};
declare function domain:model-selector( 
   $class as xs:string
) as element(domain:model)*
{ 
  domain:model-selector(config:default-application(),$class)
};

declare function domain:get-node-key($node as node()) {
    let $items := $node/(ancestor-or-self::attribute() | ancestor-or-self::*)
    return
        fn:concat(
         $node/@name,
         "__",
         xdmp:md5(
            fn:string-join(
            for $item in $items
            return
                xdmp:key-from-QName(fn:node-name($item))
            , "/"
         )))
};

declare function domain:get-field-id($context as node()) {
    let $items := $context/ancestor-or-self::*[fn:node-name($context) = $DOMAIN-FIELDS]
    let $ns := domain:get-field-namespace($context)
    let $path := 
    fn:string-join(
        for $item in $items
        return
            fn:concat("{" , $ns, "}", $item/@name)
        ,"/"
    )
    return 
    fn:concat($context/@name,"__", xdmp:md5($path))
};

declare function domain:get-field-namespace(
$field as node()
) as xs:string?
{(
   $field/(@namespace-uri|@namespace)/fn:string(),
   $field/ancestor::domain:model/(@namespace-uri|@namespace)/fn:string(),
   $field/ancestor::domain:domain/domain:content-namespace/(@namespace-uri|/text()),
   "")[1]
};

declare function domain:get-field-value(
   $model as element(), 
   $key as xs:string, 
   $current-node as node()?
) {
    if($current-node) then 
         let $xpath := domain:get-field-xpath($model,$key)
         let $value :=       
             if($xpath) 
             then try{ xdmp:value(fn:concat("$current-node",$xpath))} catch($ex){$ex}
             else ()
         return 
             $value
     else ()

};


declare function domain:get-field-xpath($model, $key) { 
 domain:get-field-xpath($model, $key, 2)  
};

declare function domain:get-field-xpath($model, $key, $level) { 
     let $elementField := $model/descendant-or-self::*[fn:node-name(.) = $DOMAIN-NODE-FIELDS][$key = domain:get-field-id(.)]    
     (:let $level := if($elementField instance of element(domain:attribute)) then 1 else $level:)
     let $ns := domain:get-field-namespace($model) 
     let $path := 
        fn:string-join(
        for $chain in ($elementField/ancestor-or-self::*[fn:node-name(.) = $DOMAIN-FIELDS])[$level to fn:last()]
        return
           if($chain instance of element(domain:element))
           then fn:concat("*:",$chain/@name)
           else if($chain instance of element(domain:attribute)) 
                then fn:concat("@",$chain/@name)
                else ()
        , "/")

    return 
        if(fn:normalize-space($path) eq "") 
        then () 
        else fn:concat("/",$path)
};

declare function domain:build-value-map($doc as node()?,$retain as xs:string*) 
as map:map?
{
  let $map := map:map()
  let $results :=  domain:recurse($doc,$map,$retain)
  return
    $results
};

declare function domain:recurse($node as node()?,$map as map:map, $retain as xs:string*) {
  let $key := domain:get-node-key($node)
  let $_ :=
    typeswitch ($node) 
    case document-node() return domain:recurse($node/node(),$map,$retain)
    case text() return 
        if(fn:string-length($node) > 0) then
            let $key := domain:get-node-key($node/..) 
            return map:put($map, $key, (map:get($map,$key), $node))
        else ()
    case element() return 
         if($node/(element()|attribute()) and fn:not(fn:local-name($node) = $retain)) 
         then 
           for $n in $node/(element()|attribute()| text())
           return domain:recurse($n,$map,$retain)
         else 
           let $value := $node/node()
           return map:put($map, $key,(map:get($map,$key),$value))
    case attribute() return 
      map:put($map, $key,(map:get($map,$key),fn:data($node)))
    default return ()
 return $map
};

declare function domain:get-key-by-model-xpath($path as xs:string) 
as xs:string?
{

    let $domain := config:get-domain("application")
    let $subpath :=
    fn:string-join(
        for $item at $pos in fn:tokenize($path, "/")[2 to fn:last()]
        let $item := 
          (: Remove any namespace bindings since we are fining :)
          (: the content in the application domain :)
          if(fn:contains($item, ":"))
          then fn:tokenize($item, ":")[fn:last()]
          else $item
          
        let $item := 
          (: Drop attributes since we are finding it in the domain :)
          if(fn:starts-with($item, "@")) 
          then fn:substring($item, 2)
          else $item
         return 
        fn:concat('*[@name ="', $item, '"]')
     , "/")    
    let $xpath := if ($subpath) then fn:concat( "/", $subpath) else ()
    let $key := 
        if($xpath) then 
            let $stmt := fn:string(<stmt>$domain{$xpath}</stmt>)
            let $domain-node :=  xdmp:value($stmt)
            return domain:get-field-id($domain-node)
        else ()
    
    return $key
};
(:~
 : Returns a controller based on the model name
 : @param $application - name of the application
 : @param $model-name  - name of the model
~:)
declare function domain:get-model-controller($application, $model-name) {
    let $domain := config:get-domain("application")
    return $domain/domain:controller[@model = $model-name]
};

declare function domain:get-model(
$application-name as xs:string,
$model-name as xs:string*
) as element(domain:model)* {
   domain:get-domain-model($application-name,$model-name)
};
declare function domain:get-model(
  $model-name as xs:string*
) {
   domain:get-domain-model($model-name)
};