xquery version "1.0";

import module namespace wijmo = "http://www.xquerrail-framework.com/helper/wijmo" 
   at "/_framework/helpers/wijmo.xqy";
  
import module namespace js = "http://www.xquerrail-framework.com/helper/javascript" 
   at "/_framework/helpers/javascript.xqy";
  
<div xmlns="http://www.w3.org/1999/xhtml" class="inner-box">
     <div id="navigation-tabs">
         <ul>
             <li><a href="#datepager-tab">Date Pager</a></li>
             <li><a href="#menu-tab">Menu</a></li>
             <li><a href="#pager-tab">Pager</a></li>
             <li><a href="#tree-tab">Tree</a></li>
         </ul>
         <div id="datepager-tab" class="demo-tab">
             <h2>Date Pager</h2>
             {wijmo:datepager-template()}
         </div>
         <div id="menu-tab" class="demo-tab">
             <h2>Menu</h2>
             {wijmo:menu-template()}
         </div>
         <div id="tree-tab" class="demo-tab">
             <h2>Tree</h2>
             {wijmo:tree-template()}
         </div>
         <div id="pager-tab" class="demo-tab">
             <h2>Pager</h2>
             {wijmo:pager-template()}
         </div>     
    </div>    
    <script type="text/javascript"> 
    jQuery(window).ready(function(){{
         {fn:data(wijmo:tabs("#navigation-tabs",(
             js:pair("alignment",js:string("left")),
             js:pair("sortable",js:boolean(fn:true()))
         )
      ))}
    }});
    </script>
</div>



