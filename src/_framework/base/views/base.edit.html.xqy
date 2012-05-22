xquery version "1.0-ml";
(:~
 : Base Edit Template used for rendering output
~:)
declare default element namespace "http://www.w3.org/1999/xhtml";

import module namespace form = "http://www.xquerrail-framework.com/helper/form-builder" at "/_framework/helpers/form-builder.xqy";
import module namespace response = "http://www.xquerrail-framework.com/response" at "/_framework/response.xqy";

declare option xdmp:output "indent-untyped=yes";
declare variable $response as map:map external;

let $init := response:initialize($response)
let $domain-model := response:model()

let $labels := ("Update","Cancel")
return
<div class="body-wrapper">
 <div class="content-box" style="display:block;">
   <div class="content-box-wrapper">
       <ul class="icons">
           <li><a class="btn ui-state-default ui-corner-all" href="/{response:controller()}/index.html"><span class="ui-icon ui-icon-grip-dotted-horizontal"></span>Back</a></li>
       </ul>
    </div>
 </div>  
<div class="content-box content-box-header ui-corner-all">
     <div class="content-box-wrapper">
         <h2><?title?></h2>  
         <form id="form_{response:controller()}" name="form_{response:controller()}" method="post"
              action="/{response:controller()}/save.html">        
             <?template name="fields"?> 
          <ul>
             <li class="buttons">
                 <button type="submit" class="ui-state-default ui-corner-all ui-button" href="#">Save</button>
                 <a class="ui-state-default ui-corner-all ui-button" href="#" 
                    onclick="return validateDelete('form_{response:controller()}','{response:controller()}_table');">
                    Delete
                 </a>
                 <a class="ui-state-default ui-corner-all ui-button" href="#" 
                    onclick="return cancelUpdate()">Cancel</a>
            </li>
         </ul>
        </form>
     </div> <!-- end content-box -->
     <script type="text/javascript"> {
        form:context($response)
     }</script>
 </div>
 </div>