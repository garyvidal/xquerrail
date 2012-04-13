(:@GENERATED@:)
xquery version "1.0-ml";

declare default element namespace "http://www.w3.org/1999/xhtml";

import module namespace form = "http://www.xquerrail-framework.com/formbuilder" at "/_framework/helpers/formbuilder.xqy";
import module namespace response = "http://www.xquerrail-framework.com/response" at "/_framework/response.xqy";

declare option xdmp:output "indent-untyped=yes";
declare variable $response as map:map external;
let $init := response:initialize($response)
return
<div id="show-wrapper">
   <div class="inner-page-title">
      <h2>Show {response:controller()}</h2>
   </div>
   <div id="show-box" class="content-box">
      <form name="form_{response:controller()}" method="get" action="/{response:controller()}/edit.html">
         <ul>
          <?template name="fields"?>
         </ul>
      </form>
      <h2>XML Format</h2>
      <div style="width:400px">
         <pre>{xdmp:quote(response:body())}</pre>
      </div>
   </div>
   <script type="text/javascript">
      var controller  = '{response:controller()}';
      var action  = '{response:action()}';
   </script>
   <div class="clearfix"/>
</div>