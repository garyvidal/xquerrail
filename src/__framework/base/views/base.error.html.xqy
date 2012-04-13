xquery version "1.0-ml";
(:~
 : Base Error Handling Template used for rendering output
~:)
import module namespace response = "http://www.xquerrail-framework.com/response" at "/_framework/response.xqy";

declare namespace domain = "http://www.xquerrail-framework.com/domain";
declare namespace local = "urn:local";

declare default element namespace "http://www.w3.org/1999/xhtml";

declare option xdmp:output "indent-untyped=no";

declare variable $response as map:map external;

declare function local:render-error($error)
{
   typeswitch($error)
     case element(error:error) return
        <div class="error-container">
          <table id="error-header" cellpadding="0" cellspacing="0" border="0" width="90%">
             <tr><td>Code:</td><td>{fn:data($error/error:code)}</td></tr>
             <tr><td>Name:</td><td>{fn:data($error/error:name)}</td></tr>
             <tr><td>XQuery Version:</td><td>{fn:data($error/error:xquery-version)}</td></tr>
             <tr><td>Message:</td><td>{fn:data($error/error:message)}</td></tr>
             <tr><td>Formatted:</td><td>{fn:data($error/error:format-string)}</td></tr>
             <tr><td>Retryable:</td><td>{fn:data($error/error:retryable)}</td></tr>
             <tr><td>Expression:</td><td>{fn:data($error/error:expr)}</td></tr>
          </table>
        {
          for $n in $error/element()
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
        <tr class="variable-header"><td colspan="2">Variables:</td></tr>
        {for $v in $error/error:variable 
         return 
            <tr class="variable-item">
              <td class="variable-name">${fn:data($v/error:name)}</td>
              <td class="variable-value">{fn:data($v/error:value)}</td>
            </tr>
        }
        </table>
     default return ()
};

let $init := response:initialize($response)
return
    <div>
     <div class="content-box">
       <h2>Error</h2>
       <p>Oops!  An error occurred in processing your request</p>
     </div> 
     <pre>
       local:render-error(map:get(response:get-data("error")))
     </pre>
     <!-- end content-box -->
    </div>
