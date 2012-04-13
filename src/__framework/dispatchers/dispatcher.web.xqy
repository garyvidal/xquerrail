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
 : The controller centralizes request/response and controls access to the server.
 : The controller directs all requests to the rest interface.
 : The controller is used to send all request with the action parameter to the action method name in the REST interface.
 : Reformat the incoming search request parameters as elements.
 : <br/>For example, given the rewritten URL:
 : <br/>Return the rest function output.
 :
 :)
import module namespace request     = "http://www.xquerrail-framework.com/request"     at "/_framework/request.xqy";
import module namespace response    = "http://www.xquerrail-framework.com/response"    at "/_framework/response.xqy";
import module namespace config      = "http://www.xquerrail-framework.com/config"      at "/_framework/config.xqy";
import module namespace interceptor = "http://www.xquerrail-framework.com/interceptor" at "/_framework/interceptor.xqy";
import module namespace base        = "http://www.xquerrail-framework.com/controller/base" at "/_framework/base/base-controller.xqy";

declare namespace dispatcher     = "http://www.xquerrail-framework.com/dispatcher";
declare namespace controller     = "http://www.xquerrail-framework.com/controller";
declare namespace engine         = "http://www.xquerrail-framework.com/engine";
declare namespace htm            = "http://www.w3.org/1999/xhtml";
declare namespace error          = "http://marklogic.com/xdmp/error";

(:~ convert error into html page or as simple element :)
declare variable $controller:REPORT-HTML-ERRORS as xs:boolean := fn:true();

declare option xdmp:mapping "false";
declare option xdmp:output "indent=yes";
declare option xdmp:output "method=xml";
declare option xdmp:ouput "omit-xml-declaration=yes";

(:~
 : Returns whether the controller exists or not
~:)
declare function dispatcher:controller-exists($controller-uri as xs:string) as xs:boolean {
	if (xdmp:modules-database()) then
		xdmp:eval(fn:concat('fn:doc-available("', $controller-uri, '")'), (),
			<options xmlns="xdmp:eval">
				<database>{xdmp:modules-database()}</database>
			</options>
		)
	else
		xdmp:uri-is-file($controller-uri)
};

declare function dispatcher:view-exists($view-uri as xs:string) as xs:boolean
{
	if (xdmp:modules-database()) then
		xdmp:eval(fn:concat('fn:doc-available("', $view-uri, '")'), (),
			<options xmlns="xdmp:eval">
				<database>{xdmp:modules-database()}</database>
			</options>
		)
	else
		xdmp:uri-is-file($view-uri)
};

(:~
 :  Returns an errorcode for a given response/request.
 :  If defined the routing will use the application error handler
 :  or if not will use the framework internal one.
 :  @param $ex - Error XML response
~:)
declare function dispatcher:error(
$ex as element(error:error)
){
  let $error-map := map:map()
  let $request := if(request:request() instance of map:map) then request:request() else map:map()
  let $_:= 
    (
     map:put($error-map,"error",$ex),
     map:put($error-map,"request",request:request()),
     map:put($error-map,"response",response:response())
    )
  return (
      xdmp:log(("Error::[",$ex,"]"),"debug"),
      xdmp:invoke( config:error-handler(),(xs:QName("_ERROR"),$error-map))
  )
};


(:~
 :  Executes a named controller using REST methods interface
~:)
declare function dispatcher:invoke-controller()
{ 
   let $application as xs:string? := (request:application(),config:default-application())[1]
   let $controller as xs:string   := (request:controller(),config:default-controller())[1]
   let $action as xs:string       := (request:action(),config:default-action())[1]
   let $route  as xs:string?      := request:route()
   let $controller-location       := fn:concat(config:get-application($application)/@uri,'/controller/', $controller,'-controller.xqy')
   let $controller-uri            := fn:concat(config:get-application($application)/@namespace,'/controller/', $controller)
   let $results := 
     if(dispatcher:controller-exists($controller-location))
     then 
        let $stmt :=  fn:concat(
           ' xquery version "1.0-ml";',
           ' import module namespace controller = "',$controller-uri,'" at "',$controller-location, '";',
           ' declare variable $request as map:map external;',
           ' controller:initialize($request),',
           ' controller:',$action, '()'
         )
         return  
             xdmp:eval($stmt,
             (xs:QName("request"),request:request()),
               <options xmlns="xdmp:eval">
               </options>
             )
     else base:invoke($action)
    return     
          $results
};

(:~
 : Renders the output 
~:)
declare function dispatcher:invoke-response($response,$request)
{
    let $application := request:application()
    let $controller := request:controller()
    let $action := request:action()
    let $format := request:format()
    let $view-uri := fn:concat("/",$application,"/",$controller,"/",$controller,".",$action,".",$format,".xqy")        
    return
    if($response instance of map:map) then 
           if(response:set-response($response,$request)) then 
              let $engine := config:get-engine($response)
              let $engine-uri := fn:concat($config:DEFAULT-ENGINE-PATH,"/",$engine,".xqy")
              let $engine-func := xdmp:function(xs:QName("engine:initialize"),$engine-uri)
              let $_ := 
                  if(fn:not(dispatcher:view-exists($view-uri))) 
                  then response:set-base(fn:true())
                  else () 
              return
                xdmp:apply($engine-func,response:flush(),$request)
           else $response         
      else 
         if($format eq "json") then 
            (:Initialize the JSON Response:)
            let $_ := response:set-response(map:map(),$request)
            let $_ := (response:set-format("json"))
            let $_ :=  (response:set-body($response))
            let $response := response:response()
            let $engine := config:get-engine($response)
            let $engine-uri := fn:concat($config:DEFAULT-ENGINE-PATH,"/",$engine,".xqy")
            let $engine-func := xdmp:function(xs:QName("engine:initialize"),$engine-uri)
            return
                xdmp:apply($engine-func,$response,$request)
          else if($format eq "html") then 
            (:Initialize the HTML Response:)
            let $_ := response:set-response(map:map(),$request)
            let $_ := (
                response:set-format("html"),
                response:set-template("main"),
                response:set-view($action)
            )
            let $_ := 
                if($action eq "get") 
                then response:set-view("show")
                else if($action eq "list") then response:set-view("index")
                else if($action eq "search") then response:set-view("find")
                else ()
            let $_ :=  (response:set-body($response))
            let $response := response:response()
            let $engine := config:get-engine($response)
            let $engine-uri := fn:concat($config:DEFAULT-ENGINE-PATH,"/",$engine,".xqy")
            let $engine-func := xdmp:function(xs:QName("engine:initialize"),$engine-uri)
            return
                xdmp:apply($engine-func,$response,$request)
         else if($response) 
         then (xdmp:log($response),$response)
         else <html/>         
};
try {
   (:Initialize Interceptors:)
   let $init := interceptor:before-request()
   return
       if(fn:normalize-space(request:redirect()) ne "" and fn:exists(request:redirect()))
       then  (
         (),
         xdmp:log(xdmp:log(string-join(("dispatcher::after-request-aaa::[",request:redirect(),"]"),""))
       ))  
         
       else 
         let $request := request:parse(())
         return
             let $request  := interceptor:after-request()
             let $log := xdmp:log(string-join(("dispatcher::after-request-xxx::[",request:redirect(),"]"),""))
             return (
               if(fn:normalize-space(request:redirect()) ne ""  and fn:exists(request:redirect()))
               then xdmp:redirect-response(request:redirect())
               else (),
                  let $response  := (
                    interceptor:before-response(),
                    dispatcher:invoke-controller()
                  )
                  return (
                    dispatcher:invoke-response($response,$request),
                    interceptor:after-response()
                  )
              )
} catch($ex) {(
   dispatcher:error($ex)
   )
}

