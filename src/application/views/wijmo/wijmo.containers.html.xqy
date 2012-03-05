xquery version "1.0";

import module namespace wijmo = "http://www.xquerrail-framework.com/helper/wijmo" 
  at "/_framework/helpers/wijmo.xqy";
import module namespace js = "http://www.xquerrail-framework.com/helper/javascript" 
  at "/_framework/helpers/javascript.xqy";

<div xmlns="http://www.w3.org/1999/xhtml" class="page-content-wrapper">
 <div id="tabs">
     <ul>
        <li><a href="#accordion-tab">Accordion</a></li>
        <li><a href="#carousel-tab">Carousel</a></li>
        <li><a href="#dialog-tab">Dialog</a></li>
        <li><a href="#event-tab">Events Calendar</a></li>
        <li><a href="#expander-tab">Expander</a></li>
        <li><a href="#gallery-tab">Gallery</a></li>
        <li><a href="#lightbox-tab">Lightbox</a></li>
        <li><a href="#popup-tab">Popup</a></li>
        <li><a href="#superpanel-tab">Super Panel</a></li>

        <li><a href="#wizard-tab">Wizard</a></li>
        <li><a href="#js-tab">JS API Tests</a></li>
     </ul>

     <div id="accordion-tab" class="demo-tab">
        <h2>Accordion</h2>
        {wijmo:accordion-template()}
     </div>
     <div id="carousel-tab"  class="demo-tab">
         <h2>Carousel</h2>
         {wijmo:carousel-template()}
     </div>

     <div id="dialog-tab"  class="demo-tab">
        <h2>Dialog</h2>
        {wijmo:dialog-template()}
     </div>
     <div id="event-tab"  class="demo-tab">
        <h2>Event Calendar</h2>
        {wijmo:events-calendar-template()}
     </div>
     <div id="expander-tab"  class="demo-tab">
         <h2>Expander</h2>
         {wijmo:expander-template()}
     </div>
     <div id="gallery-tab"  class="demo-tab">
          <h2>Gallery</h2>
          {wijmo:gallery-template()}
     </div>
     <div id="lightbox-tab"  class="demo-tab">
          <h2>Lightbox</h2>
          {wijmo:lightbox-template()}
     </div>
     <div id="popup-tab"  class="demo-tab">
        <h2>Popup</h2>
        {wijmo:popup-template()}
     </div>
     <div id="superpanel-tab"  class="demo-tab">
        <h2>Super Panel</h2>
        {wijmo:superpanel-template()}
     </div>
     <div id="wizard-tab"  class="demo-tab" style="height:500px;">
         <h2>Wizard</h2>
         {wijmo:wizard-template()}
     </div>
     <div id="js-tab"  class="demo-tab">
        <h2>JSON Test</h2>
        <div id="expander-test">
            <div>
                header
            </div>
            <div>
                content
            </div>
        </div>
     </div>
     {wijmo:expander("expander-test",(
         js:pair("expanded",js:boolean(fn:false())),
         js:pair("allowExpand",js:boolean("true")),
         js:pair("afterExpand",js:function("e","alert('After Expand');"))
      ))}   
</div>
<script type="text/javascript"> 
  jQuery(window).ready(function(){{
     {fn:data(wijmo:tabs("#tabs",(
       js:pair("alignment",js:string("left")),
       js:pair("sortable",js:boolean(fn:true()))
     )
     ))}
  }});
</script>
</div>

