xquery version "1.0-ml";

module namespace updater = "http://www.xquerrail-framework.com/lib/updater";

declare option xdmp:mapping "false"; 
declare variable $UNEDITABLE-NAMES := ("createdOn","createdBy");

(:~ 
: Do an in memory update of a document
: @param $uri this is the uri of the document ot fetch from the DB
: @param $map a map of key/values which contain xpaths and changes to be made
: @return The changed document and an audit map for the changes that were made.
:)
declare function updater:update($uri as xs:string,$map as map:map)
as item()*
{
    (: Update the global map to retain values for recursion :)
    let $deltaMap := map:map()
      
    return 
        if (map:count($map)) then 
            (: Create the new document from the old document :)
            recurse-internal-update(fn:doc($uri),$map, $deltaMap)
        else ()
};

(:~
: Traverse the node and replace what is specified by the user
: @node the node to be traversed and replaced
: return the node that is placed  
:)
declare private function updater:recurse-internal-update($node as node(),$update-map as map:map, $delta-map as map:map)
as item()*
{
    let $path := xdmp:path($node)
    return
    if (map:count($update-map) gt 0) then 
                (: Replace attributes and elements if the map contains it :)
                (: Switch on the types of nodes you can have :)
                typeswitch($node)
                case document-node() return 
                    (recurse-internal-update($node/node(),$update-map, $delta-map),($delta-map + $update-map)) 
                case attribute() return  
                    updater:convert-attribute($node,$update-map, $delta-map)
                case element() return 
                    updater:convert-element($node,$update-map, $delta-map)
                default return $node
    else ($node,$delta-map)
    
};

(:~
: Convert an attribute from a value specifed by the update-map
: @param $node the attribute node to be converted
: @param $update-map a map of key/values which contain xpaths and changes to be made
: @param $delta-map a map of key/values which contain the current audit process
: @return the conversion or original node depending on the changes requested
:)
declare private function updater:convert-attribute($node as node(),$update-map as map:map, $delta-map as map:map)
as item()
{
     let $path := xdmp:path($node)
     return
         if(map:get($update-map,$path)) then
            (: Fetch the change and then put it in to the audit to track changes :)
             attribute { fn:node-name($node) } {
                let $replacement := map:get($update-map,$path) 
                return 
                   ( 
                    $replacement,
                    map:delete($update-map,$path),
                    map:put($delta-map,$path,($node,$replacement))
                   )
              }
        else $node
};

(:~
: Convert an element from a value specifed by the update-map
: @param $node the element node to be converted
: @param $update-map a map of key/values which contain xpaths and changes to be made
: @param $delta-map a map of key/values which contain the current audit process
: @return the conversion or original node depending on the changes requested
:)
declare private function updater:convert-element($node as node(),$update-map as map:map, $delta-map as map:map)
as item()*
{

    let $path := updater:find-namespaces($node)
    let $localName := fn:local-name($node)
    return
      if(map:get($update-map,$path)) then
          (: Do not allow a user to edit specific elements :)
          if ($localName = $UNEDITABLE-NAMES) then
              if(map:get($update-map,$path)) then
                  (
                      map:put(
                          $delta-map,
                          $path, 
                          fn:concat("WARNING: Trying to convert the unedibalte node '", $localName, "'")
                      )
                      , $node 
                  )
              else () 
         else
            (: Fetch the change and then put it in to the audit to track changes :)
            element { fn:node-name($node) } { 
               for $a in $node/@*
               return 
                    recurse-internal-update($a,$update-map, $delta-map), 
                     
                let $replacement := map:get($update-map,$path) 
                return 
                   ( 
                    $replacement,
                    map:delete($update-map,$path),
                    map:put($delta-map,$path,($node,$replacement))
                   )
             }
           else 
               (: If there is no change for the current element recurse the node :)
               if($node/(element() | attribute())) then  
                   element { fn:node-name($node) } {
                        (: Convert all the attributs of the node :)
                        for $a in $node/@*
                        return 
                           recurse-internal-update($a,$update-map, $delta-map),
                        
                        (: Convert all the children nodes :)
                        for $n in $node/node()
                        return
                           recurse-internal-update($n,$update-map, $delta-map) 
                   }
               else 
                   (: If there are no more changes return the deltas :)
                   if (map:count($update-map) eq 0) then  ($node,$delta-map) else $node
};

(:~ 
: Find all the possible namespaces for prefix used within the scope
: @param $node the node to be analyized 
: @return a sequence of strings which contain prefix, uri 
:)
declare private function updater:find-namespaces($node as node()) 
as xs:string*
{
    let $seq := 
        (: Only try to get the inscope namespaces if the node is an element :)
        if($node instance of element()) then 
            let $prefixes := fn:in-scope-prefixes($node)
            
            (: Itterate the prefixes and get the uri for the prefix :)
            let $namespaces := 
                for $prefix in $prefixes
                return 
                    ($prefix, fn:namespace-uri-for-prefix($prefix, $node))
                    
            return xdmp:with-namespaces($namespaces, xdmp:path($node))
        else ()
        
    return $seq
};