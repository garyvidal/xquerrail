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
 : View Helper for REST MVC framework
~:)
module namespace view = "http://www.xquerrail-framework.com/view-helper";

declare option xdmp:mapping "false";

declare variable $view-root := "/application/view/";

declare function view:create-view(
    $view as xs:string,
    $action as xs:string,
    $params as item()?
) 
{  
   let $invoker := fn:concat($view-root,$view,"/",$action,"-view.xqy")
   let $parms := if(fn:empty($params)) then map:map() else $params
   return
     xdmp:invoke($invoker,(xs:QName("DATA"),$parms)) 
};

declare function view:params-to-map($params as item()*) 
as map:map
{
   let $map := map:map()
   let $count := (fn:count($params) div 2) cast as xs:integer
   let $_  :=
       for $p at $pos in $params
       return
         if($pos mod 2 eq 0) then
            map:put($map,fn:subsequence($params,$pos),fn:subsequence($params, $pos + 1))
         else
            ()
   return $map     
};