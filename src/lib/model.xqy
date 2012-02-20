xquery version "1.0-ml";
(:~
 : Model model Application framework model functions
~:)
module namespace model = "http://www.xquerrail-framework.com/model";
   
declare namespace dc = "http://purl.org/dc/elements/1.1/";
declare namespace dcterms = "http://purl.org/dc/terms/";
declare namespace local = "urn:local";
declare namespace rest = "http://marklogic.com/ps/restmvc";

declare option xdmp:mapping "false";

declare variable $NL as xs:string := fn:codepoints-to-string((13,10));
(:~Converts a set of request params to a mode instance
~:)
declare function model:params-to-model(
  $model as element(domain:model),
  $params as map:map
) as element()?
{

};
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