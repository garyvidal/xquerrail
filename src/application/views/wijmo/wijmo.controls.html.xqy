xquery version "1.0";

import module namespace wijmo = "http://www.xquerrail-framework.com/helper/wijmo" 
   at "/_framework/helpers/wijmo.xqy";
import module namespace js = "http://www.xquerrail-framework.com/helper/javascript" 
   at "/_framework/helpers/javascript.xqy";
<div xmlns="http://www.w3.org/1999/xhtml" class="inner-box">
     <div id="control-tabs">
         <ul>
            <li><a href="#editor-tab">Editor</a></li>
            <li><a href="#video-tab">Video</a></li>
        </ul>
        <div id="editor-tab"  class="demo-tab">
            <h2>Editor</h2>
            {wijmo:editor-template()}
        </div>
        <div id="video-tab"  class="demo-tab">
            <h2>Video</h2>
            {wijmo:video-template()}
         </div>
    </div>    
    <script type="text/javascript"> 
      jQuery(window).ready(function(){{
         {fn:data(wijmo:tabs("#control-tabs",(
           js:pair("alignment",js:string("top")),
           js:pair("sortable",js:boolean(fn:true()))
         )
         ))}
      }});
    </script>
</div>


