xquery version "1.0";

import module namespace wijmo = "http://www.xquerrail-framework.com/helper/wijmo" 
  at "/_framework/helpers/wijmo.xqy";
import module namespace js = "http://www.xquerrail-framework.com/helper/javascript" 
  at "/_framework/helpers/javascript.xqy";

<div xmlns="http://www.w3.org/1999/xhtml">
 <div id="index-tabs">
     <ul>
        <li><a href="/wijmo/containers.html?_partial=true">Containers</a></li>
        <li><a href="/wijmo/navigation.html?_partial=true">Navigation</a></li>
        <li><a href="/wijmo/controls.html?_partial=true">Controls</a></li>
        <li><a href="/wijmo/visualizations.html?_partial=true">Visualizations</a></li>
        <li><a href="/wijmo/grids.html?_partial=true">Grids</a></li>
        <li><a href="/wijmo/javascript.html?_partial=true">Javascript</a></li>
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

