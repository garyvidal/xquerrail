xquery version "1.0-ml";

(:~
 : The controller centralizes request/response and controls access to the server.
 : The controller directs all requests to the rest interface.
 : The controller is used to send all request with the action parameter to the action method name in the REST interface.
 : Reformat the incoming search request parameters as elements.
 : <br/>For example, given the rewritten URL:
 : <br/><![CDATA[http://host:port/ app/controller.xqy?action=search&term=science&from-grade=1&to-grade=12]]>
 : <br/>The controller would call the rest-method on the server as:
 : <br/><![CDATA[search(<params><from-grade>1</from-grade><to-grade>12</to-grade></params>)]]>
 : <br/>Return the rest function output.
 :
 :)
import module namespace request = "http://www.xquerrail-framework.com/request" at "/_framework/request.xqy";
import module namespace response = "http://www.xquerrail-framework.com/response" at "/_framework/response.xqy";
import module namespace config   = "http://www.xquerrail-framework.com/config" at "/_framework/config.xqy";


declare namespace controller = "http://www.xquerrail-framework.com/controller";
declare namespace engine = "http://www.xquerrail-framework.com/engine";
declare namespace htm = "http://www.w3.org/1999/xhtml";
declare namespace error = "http://marklogic.com/xdmp/error";

(:~ convert error into html page or as simple element :)
declare variable $controller:REPORT-HTML-ERRORS as xs:boolean := fn:true();

declare option xdmp:mapping "false";

(:~
: handle formatting the error message as html or as element(error)
: @param $response-text The string message of the errror
: @return element containing error
:)
declare function controller:report-error($response-code as xs:integer, $title as xs:string, $response-text as xs:string) as element()
{
  if ($controller:REPORT-HTML-ERRORS) then
    controller:html-wrapper($response-code, $title, $response-text)
  else
    <error code="{$response-code}" title="{$title}">{$response-text}</error>
};

(:~
: Wrap the specified string in html for friendly message display.
: @param $response-text The string message of the errror
: @return element(htm:html) An element(htm:html) containing the html response.
:)
declare function controller:html-wrapper($response-code as xs:integer, $title as xs:string, $response-text as xs:string) as element()
{
  xdmp:add-response-header("Content-Type", "text/html"),
  <html xmlns="http://www.w3.org/1999/xhtml">
    <head><title>HTTP {$response-code}{' '}{$title}</title></head>
    <body>
		<h3>{$response-code}{' '}{$title}</h3>
		<p>{$response-text}</p>
	</body>
  </html>
};

declare function controller:profiler-enable($val as xs:boolean)
{
   if($val) 
   then   prof:enable(xdmp:request())
   else ()
};

declare function controller:profiler-disable($val as xs:boolean)
{
  if($val) 
  then  prof:disable(xdmp:request())
  else ()
};

declare function controller:profile-log($value)
{
   ()
};

(:~
 :  Executes a named controller using REST methods interface
~:)
declare function controller:controller()
{ 
   let $controller as xs:string := request:controller()
   let $action as xs:string  := request:action()
   let $stmt := 
        fn:concat(
          ' xquery version "1.0-ml";',
          ' import module namespace controller = "http://www.xquerrail-framework.com/controller/', $controller,'"',
          ' at "/application/controller/', $controller,'.controller.xqy";',
          ' declare variable $request as map:map external;',
          ' controller:initialize($request),',
          ' controller:',$action, '($request)'
        )
    return
      try
        {
          (
              xdmp:eval($stmt,
               (xs:QName("request"),request:request()),
               <options xmlns="xdmp:eval">
                 <isolation>different-transaction</isolation>
                 <prevent-deadlocks>true</prevent-deadlocks>
               </options>)
           )
        }
        catch($ex)
        {
			if ($ex/error:code = "XDMP-UNDFUNxxx") then
				controller:report-error(501, "Unsupported action", fn:concat("Action ", $action, " is not supported",$ex/error:message,"[",$stmt,"]"))
			else
			if ($ex/error:name eq "MISSINGPARAM") then
				controller:report-error(404, "Missing param", $ex/error:message)
			else
			if ($ex/error:name eq "NOTFOUND") then
				controller:report-error(404, "Not found", $ex/error:message)
			else (
				controller:report-error(500, "Unexpected error", $ex/error:message),
				xdmp:rethrow()
			)
        }
};
declare function controller:controller-exists($controller-uri as xs:string) as xs:boolean {
	if (xdmp:modules-database()) then
		xdmp:eval(fn:concat('fn:doc-available("', $controller-uri, '")'), (),
			<options xmlns="xdmp:eval">
				<database>{xdmp:modules-database()}</database>
			</options>
		)
	else
		xdmp:uri-is-file($controller-uri)
};

let $request := request:parse(())
let $initialize := request:initialize($request)
let $controller := request:controller()
let $action := request:action()
let $exists := controller:controller-exists(fn:concat("/application/controller/", $controller ,".controller.xqy"))
return 
      if($controller and $exists) then
        let $response := controller:controller()
        return 
          if(response:set-response($response))
          then 
            let $engine := config:get-engine($response)
            let $engine-uri := fn:concat($config:ENGINE-PATH,"/",$engine,".xqy")
            let $engine-func := xdmp:function(xs:QName("engine:initialize"),$engine-uri)
            return
               xdmp:apply($engine-func,$response,$request )
          else $response
      else 
           <error>
            <exists>{$exists}</exists>
            <controller>{$controller}</controller>
            {$request}
           </error>
     