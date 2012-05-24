(:@GENERATED@:)
xquery version "1.0-ml";

declare default element namespace "http://www.w3.org/1999/xhtml";

import module namespace form = "http://www.xquerrail-framework.com/helper/form-builder" at "/_framework/helpers/form-builder.xqy";
import module namespace response = "http://www.xquerrail-framework.com/response" at "/_framework/response.xqy";
import module namespace model = "http://www.xquerrail-framework.com/model" at "/_framework/model.xqy";

declare option xdmp:output "indent-untyped=yes";
declare variable $response as map:map external;
let $init := response:initialize($response)
return
<div id="show-wrapper">
   <div class="inner-page-title">
      <h2>Show {response:controller()}</h2>
   </div>
   <div id="show-box" class="content-box content-box-header">
     <div class="content-box-wrapper">
         <form name="form_{response:controller()}" method="get" action="/{response:controller()}/edit.html">
            <ul>
             <?template name="fields"?>
            </ul>
         </form>
      </div>
   </div>
   <div class="content-box content-box-header">
      <div class="content-box-wrapper">
      <h2>XML Format</h2>
         <div style="width:400px">
            <pre class="codemirror">{xdmp:quote(response:body())}</pre>
         </div>
      </div>
   </div>
   <div class="content-box content-box-header">
     <div class="content-box-wrapper">   
          <h2>JSON Format</h2>
          <div style="width:400px">
             <pre>{model:to-json(response:model(),response:body())}</pre>
          </div>
      </div>
   </div>
   <div class="clearfix"/>
</div>