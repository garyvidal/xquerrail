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

module namespace routing ="http://www.xquerrail-framework.com/routing";
    
import module namespace config = "http://www.xquerrail-framework.com/config"
at "config.xqy";

declare variable $routes := xdmp:invoke("/_config/routes.xml");
declare function get-routes()
{
   $routes
};

declare function get-route($url as xs:string)
{
  let $front-controller := config:get-controller()
  let $path := if(fn:contains($url,"?")) then fn:substring-before($url,"?") else $url
  let $params := if(fn:contains($url,"?")) then fn:substring-after($url,"?") else ()
  let $map := map:map()
  let $log := xdmp:log($path)
  let $matching-route := $routes//routing:route[fn:matches($path,./@pattern)]
  let $defaults := 
     for $default in $matching-route/routing:default
     return
       if($default/@key eq "controller") 
       then 
          for $d at $pos in  fn:tokenize($default/text(),":") 
          return
          (
            if($pos eq 1) then fn:concat("_application=",$d) else (),
            if($pos eq 2) then fn:concat("_controller=",$d) else (),
            if($pos eq 3) then fn:concat("_action=",$d) else (),
            if($pos eq 4) then fn:concat("_format=",$d) else ()
          )
       else ()
          
  return 
  if($matching-route) then
  <route>{$matching-route[1]/@id,fn:concat($front-controller,"?", fn:string-join(($defaults,$params),"&amp;"))}</route>
  else ()
};