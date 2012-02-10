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
 : <br/>Responsible for URL rewriting
 : <br/>The rewriter intercepts URLs and rewrites the URL.
 : <br/>The rewriter is used to invoke the controller, run tests, and simulate the REST web service.
 : <br/>In most cases it delegates to the controller (/controller.xqy).
 : <br/>For example, given the original URL in the browser:
 : <br/>http://host:port/search?term=science&amp;from=1&amp;to=12
 : <br/>The URL rewriter would rewrite and pass the url to the server as:
 : <br/>http://host:port/app/controller.xqy?action=search&amp;term=science&amp;from=1&amp;to=12
 : <br/>return $request-url A url ready for server resolution.
 :
 : @see http://developer.marklogic.com
 : Setting Up URL Rewriting for an HTTP App Server
 : @see app/controller.xqy
 :
 :)
import module namespace routing = "http://www.xquerrail-framework.com/routing"
at "/_framework/routing.xqy"; 

declare option xdmp:mapping "false";

declare variable $app-root as xs:string := '';
declare variable $resource-dir as xs:string := fn:concat($app-root, '/web/');
declare variable $unsecure-uris as xs:string* := ();
declare variable $unsecure-urisxx as xs:string* :=
     ("/","/default.xqy","/checklogin.xqy","/login.xqy","/logout.xqy");

declare function local:module-exists($uri as xs:string) as xs:boolean {
    if (xdmp:modules-database() ) then
        xdmp:eval(fn:concat('fn:doc-available("', $uri, '")'), (),
            <options xmlns="xdmp:eval">
                <database>{xdmp:modules-database()}</database>
            </options>
        )
    else
        xdmp:uri-is-file($uri)
};

declare function local:get-controller-uri($controller-name as xs:string) as xs:string {
	fn:concat("/application/controller/", $controller-name,".controller.xqy")
};

declare function local:get-resource-uri($resource-uri as xs:string) as xs:string {
	fn:concat($resource-dir, $resource-uri)
};
declare function local:is-unsecure($check as xs:string)
{
   some $uri in $unsecure-uris[2 to fn:last()]
   satisfies fn:starts-with($check,$uri)
};
(:if(xdmp:get-request-url() = $unsecure-uris or
   fn:contains(xdmp:get-request-url(),"resources/") or
   local:is-unsecure(xdmp:get-request-url())
   ) then
 (   
    xdmp:get-request-url()
 )
else (:Only Route Requests to controller:)
:)
    
let $request-url := xdmp:get-request-url()
let $request-path := xdmp:get-request-path()
let $query := if (fn:contains($request-url, "?")) then fn:substring-after($request-url, "?") else ()

let $resource-path := local:get-resource-uri($request-path)
let $route := routing:get-route($request-url)
let $is-resource := 
    if(fn:starts-with($request-path,$resource-dir)) 
    then fn:true()
    else fn:false() 
return
if($is-resource) then  $request-url
else if($route)  then $route
else if($request-url eq "/") then
 fn:concat("/_kernel/marklogic/controllers/controller.web.xqy?_controller=default&amp;action=index")
else
let $log :=  xdmp:log(text { "original url:", $request-url})
let $request-url :=
    		(:RESTFUL Controller should have pattern /controller-name/action?params :)
    		let $request-paths := fn:tokenize($request-path,"/")
    		let $controller-name  := ($request-paths[2],"default")[1]
    		let $controller-name  := 
    		   if(fn:contains($controller-name,".")) 
    		   then fn:string-join(fn:tokenize($controller-name,"\.")[1 to fn:last() - 1 ],".")
    		   else $controller-name
    		let $format := fn:string-join(fn:tokenize($controller-name,"\.")[fn:last()],"html")[1]
    		
    		let $controller-uri := local:get-controller-uri($controller-name)
    		let $controller-exists := local:module-exists($controller-uri)
    		let $log := ()(:xdmp:log(text{"controller:", $controller-uri, " exists: ", $controller-exists}):)
    		return
    		  if ($controller-exists) then
    			 let $action := $request-paths[3]
    			 let $action  := 
        		   if(fn:contains($action,".")) 
        		   then fn:string-join(fn:tokenize($action,"\.")[1 to fn:last() - 1 ],".")
        		   else $action
        		 let $format := fn:string-join(fn:tokenize($action,"\.")[fn:last()],"html")[1]
    			 let $new-url :=
    				fn:string-join((
    					"/_kernel/marklogic/controllers/controller.web.xqy?_controller=", $controller-name,
    					if ($action) then ("&amp;_action=",$action) else (), 
    					if($format) then ("&amp;_format=",$format) else (),
    					if ($query) then ("&amp;",$query) else ()
    				),'')
    			 return (xdmp:log($new-url),$new-url)
    		  else
    			(:Let all methods just hit main controller:)
    			let $request-url := fn:replace($request-url, "^/([a-zA-Z_\-]+)\?(.*)$", "/_kernel/marklogic/controllers/controller.web.xqy/controller.xqy?_action=$1&amp;$2")
    			let $request-url := fn:replace($request-url, "^/([a-zA-Z_\-]+)/?$", "/_kernel/marklogic/controllers/controller.web.xqy?_action=$1")
    			return
    			  (xdmp:log(("REQ-URL",$request-url)),$request-url)
    return $request-url
         
          
