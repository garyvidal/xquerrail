xquery version "1.0-ml";

declare namespace local = "urn:local";

declare variable $_ERROR as map:map external;
declare variable $ERROR as map:map := 
try{
  $_ERROR}
  catch($ex){map:map()};
declare function local:render-error($error)
{
   typeswitch($error)
     case document-node() return local:render-error($error/node())
     case element(error:error) return
        <div class="error-container">
          <table id="error-header" cellpadding="0" cellspacing="0" border="0" width="90%">
             <tr><td>Code:</td><td>{fn:data($error/error:code)}</td></tr>
             <tr><td>Name:</td><td>{fn:data($error/error:name)}</td></tr>
             <tr><td>XQuery Version:</td><td>{fn:data($error/error:xquery-version)}</td></tr>
             <tr><td>Message:</td><td>{fn:data($error/error:message)}</td></tr>
             <tr>
                 <td>Formatted:</td>
                 <td>{fn:data($error/error:format-string)}</td>
             </tr>
             <tr>
                <td>Retryable:</td>
                <td>{fn:data($error/error:retryable)}</td>
             </tr>
             <tr>
                <td>Expression:</td>
                <td>{fn:data($error/error:expr)}</td>
             </tr>
          </table>
        {
          for $n in $error/error:stack
          return 
             local:render-error($n)
        }</div>
     case element(error:stack) return
        <div id="error-stack" class="ui-widget-container">
          <h2>Stack Output:</h2>
          <table id="error-table" cellpadding="0" cellspacing="0" border="0" >
            <thead>
             <tr class="header">
                <th>Module URI</th>
                <th>Line</th>
                <th>Column</th>
                <th style="width:500px;">Operation</th>
                <th>Variables</th>
             </tr>
           </thead>
          {for $s in $error/error:frame 
           return local:render-error($s)
          }
          </table>
        </div>
     case element(error:frame) return 
        <tr class="error-item">
           <td class="error-uri">{fn:data($error/error:uri)}</td>
           <td class="error-line"   align="right">{fn:data($error/error:line)}</td>
           <td class="error-column" align="right">{fn:data($error/error:column)}</td>
           <td class="operation">{fn:data($error/error:operation)}&nbsp;</td>
           <td>{local:render-error($error/error:variables)}&nbsp;</td>
        </tr>
     case element(error:variables) return
        <table class="variables" cellspacing="0" cellpadding="0" border="0">
        <tr class="variable-header">
           <td colspan="2">Variables:</td>
        </tr>
        {
         for $v in $error/error:variable 
         return 
            <tr class="variable-item">
              <td class="variable-name">${fn:data($v/error:name)}</td>
              <td class="variable-value">{fn:data($v/error:value)}</td>
            </tr>
        }
        </table>
     default return ()
};
declare function local:render-request($request)
{(
 <table xmlns="http://www.w3.org/1999/xhtml">{
   for $k in map:keys($request)
   return
      <tr><td>{$k}</td>
          <td>{map:get($request,$k)}
          </td>
      </tr>
 }</table>
)};
declare function local:render-response($request)
{(
 <table xmlns="http://www.w3.org/1999/xhtml">{
   for $k in map:keys($request)
   return
      <tr><td>{$k}</td>
          <td>{map:get($request,$k)}
          </td>
      </tr>
 }</table>
)};
xdmp:set-response-content-type("text/html"), 
xdmp:set-response-code(500,<e>{map:get($ERROR,"error")}</e>//error:format-string),
xdmp:log($ERROR),
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>    
     <title>Application Error</title>
     <link type="text/css" rel="stylesheet" href="/resources/css/error.css" media="all"/>
     <link type="text/css" rel="stylesheet" href="/resources/css/jquery-ui-1.8.17.custom.css" media="all"/>
  </head>
  <body>
     <h1 class="error-header">Application Error!</h1>
     {local:render-error(map:get($ERROR,"error"))}
     <h2>Request Variables</h2>
     {local:render-request(map:get($ERROR,"request"))}
     <h2>Response Variables</h2>
     {local:render-request(map:get($ERROR,"response"))}
     <script type="text/javascript" src="/resources/js/jquery-1.7.1.min.js">//</script>
     <script type="text/javascript" src="/resources/js/error.js">//</script>
  </body>
</html>