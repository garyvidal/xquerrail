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
(:~
 : Utility library for common functions used in application
 : Mostly to support validation 
~:)
module namespace lib = "http://marklogic.com/ps/lib/utilities";

declare option xdmp:mapping "false";

declare variable $REBASE_FUNCTION := 
'
declare namespace local = "urn:local";

declare function local:copy-node($nodes as node()*)
{
   for $node in $nodes
    return
   typeswitch($node)
     case document-node() return document {local:copy-node($node/*)}
     case element() return 
       element {fn:QName(fn:namespace-uri($node),fn:local-name($node))} 
               { $node/@*,
                 local:copy-node($node/node())
               }
       default return $node
};
'
;
(:~
 : Recursively Rebases all elements from one namespace to another
 : does not apply any attribute based changes
 : @param $nodes - Nodes to rebase namespace
 : @param $from-ns - Namespace to replace if exists
 : @param $to-ns - Namespace to replace with
~:)
declare function lib:rebase-ns($nodes as node()*,$from-ns as xs:string, $to-ns as xs:string)
{
  for $node in $nodes
  return
   typeswitch($node)
     case document-node() return document {lib:rebase-ns($node/*,$from-ns,$to-ns)}
     case element() return 
       element {if(fn:namespace-uri($node) eq $from-ns) then 
                  fn:QName($to-ns,fn:local-name($node))
                else
                  fn:QName(fn:namespace-uri($node),fn:local-name($node))
               } 
               { lib:rebase-ns($node/@*,$from-ns,$to-ns),
                 lib:rebase-ns($node/node(),$from-ns,$to-ns)
               }
     case attribute() return
       if(fn:namespace-uri($node) eq $from-ns and 
          fn:namespace-uri($node) ne "") then
       attribute {fn:QName($to-ns,fn:local-name($node))}
       {fn:data($node)}
       else $node
       default return $node
};
(:~
 : Function validates a schema at a known location.  In order for this to work properly
 : a copy is generated of the document to force it to use the schema at the import statement
 : i dont know why this works but it does.
~:)
declare function lib:validate-with-schema(
  $node as node(),
  $schema-namespace as xs:string,
  $schema-uri as xs:string
)
{
 let $node-name   := fn:local-name($node)
 let $import-stmt := fn:concat(' xquery version "1.0-ml"; import schema namespace _SCHEMA_ = "', $schema-namespace, '" at "',$schema-uri, '" ;')
 let $exec        := fn:concat(' declare variable $_DOC_ as node() external; ',
                               ' let $doc := local:copy-node($_DOC_)',
                               ' let $validate as schema-element(_SCHEMA_:', $node-name,') := $doc', 
                               ' return validate {$validate}')
 let $stmt        :=  
    fn:concat($import-stmt,$REBASE_FUNCTION,$exec)                             
 return
     xdmp:eval($stmt, (xs:QName("_DOC_"),$node), 
     <options xmlns="xdmp:eval">
        <isolation>different-transaction</isolation>
        <root>/</root>
     </options>)  
}; 