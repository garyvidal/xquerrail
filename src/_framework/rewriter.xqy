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

let $request := xdmp:get-request-url()
return
   routing:get-route($request)