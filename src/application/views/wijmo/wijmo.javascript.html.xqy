    xquery version "1.0-ml";
  
import module namespace js = "http://www.xquerrail-framework.com/helper/javascript" 
   at "/_framework/helpers/javascript.xqy";

import module namespace wijmo = "http://www.xquerrail-framework.com/helper/wijmo" 
   at "/_framework/helpers/wijmo.xqy";
   
<div xmlns="http://www.w3.org/1999/xhtml" class="inner-box">
     <div id="javascript-tabs">
         <ul>
             <li><a href="#datepager-tab">JSON Tests</a></li>
         </ul>
         <div id="pa-tab" class="demo-tab">
         <h2>JSON Tests</h2>
<pre type="text/javascript">
var customer = {
  js:o((
     js:p("customerId", js:s("12312312")),
     js:p("firstName",  js:s("Gary")),
     js:p("lastName",   js:s("Vidal")),
     js:p("isOld",      js:b(fn:true())),
     js:a((1212312,12312,1231,213123534534,234234))
))};
var mdarray = {
  js:no("array",(
     js:a((
       12312,js:s("1"),222,js:s("222222"),3333
     ))
  ))
}
</pre>             
         </div>     
    </div>  
    <script type="text/javascript"> 
    jQuery(window).ready(function(){{
         {fn:data(wijmo:tabs("#javascript-tabs",(
             js:pair("alignment",js:string("top")),
             js:pair("sortable",js:boolean(fn:true()))
         )
      ))}
        }});
    </script>    
</div>




