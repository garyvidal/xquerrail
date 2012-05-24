xquery version "1.0-ml";
(:~
 : Base Edit Template used for rendering output
~:)
declare default element namespace "http://www.w3.org/1999/xhtml";

import module namespace form     = "http://www.xquerrail-framework.com/helper/form-builder" at "/_framework/helpers/form-builder.xqy";
import module namespace response = "http://www.xquerrail-framework.com/response" at "/_framework/response.xqy";
import module namespace domain   = "http://www.xquerrail-framework.com/domain" at "/_framework/domain.xqy";

declare option xdmp:output "indent-untyped=yes";
declare variable $response as map:map external;

let $init := response:initialize($response)
let $domain-model := response:model()
let $id-field := fn:data(response:body()//*[fn:local-name(.) eq domain:get-model-id-field($domain-model)])
let $labels := ("Update","Cancel")
return
<div class="body-wrapper"> 
  <div class="content-box content-box-header ui-corner-all">
       <div class="content-box-wrapper">
           <h2>Edit <?title?></h2>  
           <form id="form_{response:controller()}" name="form_{response:controller()}" method="post"
                action="/{response:controller()}/save.html">        
               <?template name="fields"?> 
            <ul>
               <li class="buttons">
                   <button type="submit" class="ui-state-default ui-corner-all ui-button" href="#">Save</button>
                   <button type="button" class="ui-state-default ui-corner-all ui-button" 
                      onclick="return deleteForm('form_{response:controller()}','{response:controller()}_table');">
                      Delete
                   </button>
                   <button type="button" class="ui-state-default ui-corner-all ui-button" href="#" 
                      onclick="window.location.href='/{response:controller()}';">Cancel</button>
              </li>
           </ul>
          </form>
       </div> <!-- end content-box -->
       <script type="text/javascript" src="/resources/js/validate.js">//</script>
       <script type="text/javascript">
          var _id = "{$id-field}";
          {form:context($response)}
          $("#form_{response:controller()}").validate({form:build-validation($domain-model)})
          </script>
   </div>
 </div>