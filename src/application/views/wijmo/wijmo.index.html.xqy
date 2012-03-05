
xquery version "1.0";

import module namespace wijmo = "http://www.xquerrail-framework.com/helper/wijmo" 
  at "/_framework/helpers/wijmo.xqy";
import module namespace js = "http://www.xquerrail-framework.com/helper/javascript" 
  at "/_framework/helpers/javascript.xqy";

<div xmlns="http://www.w3.org/1999/xhtml" class="page-content-wrapper">
 <div id="index-tabs">
     <ul>
        <li><a href="/wijmo/containers.html">Containers</a></li>
        <li><a href="/wijmo/navigation.html">Navigation</a></li>
        <li><a href="/wijmo/controls.html?_partial=true">Controls</a></li>
        <li><a href="/wijmo/visualizations.html">Visualizations</a></li>
    </ul>
</div>    
<script type="text/javascript"> 
  jQuery(window).ready(function(){{
     {fn:data(wijmo:tabs("#index-tabs",(
       js:pair("alignment",js:string("top")),
       js:pair("sortable",js:boolean(fn:true()))
     )
     ))}
  }});
</script>
</div>

