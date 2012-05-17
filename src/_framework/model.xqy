xquery version "1.0-ml";
(:~
 : Model model Application framework model functions
~:)
module namespace model = "http://www.xquerrail-framework.com/model";

import module namespace js = "http://www.xquerrail-framework.com/helper/javascript" at "/_framework/helpers/javascript.xqy";
import module namespace domain = "http://www.xquerrail-framework.com/domain" at "/_framework/domain.xqy";

declare option xdmp:mapping "false";

declare variable $NL as xs:string := 
    if(xdmp:platform() eq "winnt") 
    then fn:codepoints-to-string((13,10))
    else "&#xA;"
;    
(:~
 :  Does an update by iterating the element structure and looking for named element 
 :  by local-name and updating it with a new value
~:)
declare function model:update-partial($current as element(), $update as map:map)
{  
   let $cur-map := $update
   let $name-keys :=  map:keys($update)
   let $update-nodes  := 
      for $node in $current/element()
      let $lname     := fn:local-name($node)
      let $nname     := fn:node-name($node)
      let $positions := (fn:index-of($name-keys,$lname), fn:index-of($name-keys,$nname))[1]
      let $match-key := 
        if($positions) then
          $name-keys[$positions]
        else
          ()
      return
        if($match-key) then
            (
             element {fn:node-name($node)}
             {
              let $value := map:get($update,$match-key)
              return 
              if($value instance of node()) then
                 $value/node()
              else 
                $value
             },
             map:delete($cur-map,$match-key)
            )
        else $node
   return
        element {fn:node-name($current)}
        {
          $current/@*,
          $update-nodes
        }
};

declare function model:eval-document-insert(
  $uri as xs:string,
  $root as node()
)
{
   let $stmt := 
   '
    declare variable $uri as xs:string external;
    declare variable $root as node() external;
    xdmp:document-insert($uri,$root)
   '
   return
     xdmp:eval($stmt,
      (
       xs:QName("uri"),$uri,
       xs:QName("root"),$root
      )
      ,
      <options xmlns="xdmp:eval">
         <isolation>different-transaction</isolation>
         <prevent-deadlocks>false</prevent-deadlocks>
      </options>
      )
};

declare function model:eval-document-insert(
  $uri as xs:string,
  $root as node(),
  $permissions as element(sec:permission)+
)
{
  let $stmt := 
   '
    declare variable $uri as xs:string external;
    declare variable $root as node() external;
    declare variable $permissions as element(sec:permission)+ external;

    xdmp:document-insert($uri,$root,$permissions)
   '
   return
     xdmp:eval($stmt,
      (
       xs:QName("uri"),$uri,
       xs:QName("root"),$root,
       xs:QName("permissions"),$permissions
      )
      ,
      <options xmlns="xdmp:eval">
         <isolation>different-transaction</isolation>
         <prevent-deadlocks>false</prevent-deadlocks>
      </options>
      )
};

declare function model:eval-document-insert(
  $uri as xs:string,
  $root as node(),
  $permissions as element(sec:permission)+,
  $collections as xs:string+
)
{
  let $stmt := 
   '
    declare variable $uri as xs:string external;
    declare variable $root as node() external;
    declare variable $permissions as element(sec:permission)+ external;
    declare variable $collections as xs:string+ external;
    xdmp:document-insert($uri,$root,$permissions,$collections)
   '
   return
     xdmp:eval($stmt,
      (
       xs:QName("uri"),$uri,
       xs:QName("root"),$root,
       xs:QName("permissions"),$permissions,
       xs:QName("collections"),$collections
      )
      ,
      <options xmlns="xdmp:eval">
         <isolation>different-transaction</isolation>
         <prevent-deadlocks>false</prevent-deadlocks>
      </options>
      )
};

declare function model:eval-document-insert(
  $uri as xs:string,
  $root as node(),
  $permissions as element(sec:permission)+,
  $collections as xs:string+,
  $quality as xs:int?
)
{
  let $stmt := 
   '
    declare variable $uri as xs:string external;
    declare variable $root as node() external;
    declare variable $permissions as element(sec:permission)* external;
    declare variable $collections as xs:string* external;
    declare variable $quality as xs:int? external;
    xdmp:document-insert($uri,$root,$permissions,$collections,$quality)
   '
   return
     xdmp:eval($stmt,
      (
       xs:QName("uri"),$uri,
       xs:QName("root"),$root,
       xs:QName("permissions"),$permissions,
       xs:QName("collections"),$collections,
       xs:QName("quality"),$quality
      )
      ,
      <options xmlns="xdmp:eval">
         <isolation>different-transaction</isolation>
         <prevent-deadlocks>false</prevent-deadlocks>
      </options>
      )
};

declare function model:eval-document-insert(
  $uri as xs:string,
  $root as node(),
  $permissions as element(sec:permission)*,
  $collections as xs:string*,
  $quality as xs:int?,
  $forest-ids as xs:unsignedLong*
)
{
   let $stmt := 
   '
    declare variable $uri as xs:string external;
    declare variable $root as node() external;
    declare variable $permissions as element(sec:permission)* external;
    declare variable $collections as xs:string external;
    declare variable $quality as xs:int? external;
    declare variable $forest-ids as xs:unsignedLong external;
    (:Parse forest-ids and $collections:)
    xdmp:document-insert($uri,$root,$permissions,$collections,$quality,$forest-ids)
   '
   return
     xdmp:eval($stmt,
      (
       xs:QName("uri"),$uri,
       xs:QName("root"),$root,
       xs:QName("permissions"),$permissions,
       xs:QName("collections"),$collections,
       xs:QName("quality"),$quality,
       xs:QName("forest-ids"),$forest-ids
      )
      ,
      <options xmlns="xdmp:eval">
         <isolation>different-transaction</isolation>
         <prevent-deadlocks>false</prevent-deadlocks>
      </options>
      )
}; 

(:
   Eval insert over xdmp:node-insert-child
:)
declare function model:eval-node-insert-child(
  $parent as node(),
  $new as node()
)
{
  let $stmt := 
  '  declare variable $parent as node() external;
     declare variable $new as node() external;
     xdmp:node-insert-child($parent,$new)
  ' 
  return
    xdmp:eval($stmt,
    (
        xs:QName("parent"),$parent,
        xs:QName("new"),$new
    ),
      <options xmlns="xdmp:eval">
         <isolation>different-transaction</isolation>
         <prevent-deadlocks>false</prevent-deadlocks>
      </options>
    )
};

declare function model:build-json(
  $field as element(),
  $instance as element()
){
   typeswitch($field)
     case element(domain:element) return
        let $field-key := domain:get-field-id($field)
        let $field-path := domain:get-field-xpath($field,$field-key)
        let $field-value := domain:get-field-value($field,$field-key,$instance)
        return       
        if($field/domain:attribute) then 
           js:no($field/@name,(
               js:no("_attributes",
                 for $field in $field/(domain:attribute)
                 return 
                   model:build-json($field,$instance)
               ),
               js:pair("_text",$field-value)
           ))
       else if($field/@occurrence = ("+","*")) then
           let $field-key := domain:get-field-id($field)
           let $field-path := domain:get-field-xpath($field,$field-key)
           let $field-value := domain:get-field-value($field,$field-key,$instance)
           return 
               js:na($field/@name,$field-value)
       else 
           js:pair($field/@name,$field-value)
     case element(domain:attribute) return
         let $field-key := domain:get-field-id($field)
         let $field-path := domain:get-field-xpath($field,$field-key)
         let $field-value := domain:get-field-value($field,$field-key,$instance)
         return        
             js:pair(fn:concat("@",$field/@name),$field-value)
     case element(domain:container) return 
         js:no($field/@name, (
            for $field in $field
            return model:build-json($field,$instance)
          ))
     default return ()
};

declare function model:to-json(
  $model as element(domain:model),
  $instance as element()
 ) {
   if($model/@name eq $instance/fn:local-name(.)) then 
   js:o((
      for $field in $model/(domain:element|domain:attribute|domain:container)
      return
        model:build-json($field,$instance)
   ))
   else fn:error(xs:QName("MODEL-INSTANCE-MISMATCH"),
      fn:string(
        <msg>{$instance/fn:local-name(.)} does not have same signature model name:{fn:data($model/@name)}</msg>)
      )
 };