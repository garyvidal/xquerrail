xquery version "1.0-ml";
declare default element namespace "http://www.w3.org/1999/xhtml";
declare namespace domain = "http://www.xquerrail-framework.com/domain";

import module namespace form = "http://www.xquerrail-framework.com/formbuilder" at "/_framework/helpers/formbuilder.xqy";
import module namespace response = "http://www.xquerrail-framework.com/response" at "/_framework/response.xqy";

declare option xdmp:output "indent-untyped=yes";
declare variable $response as map:map external;

let $init := response:initialize($response)
let $domain-model := response:model()
return
<div class="body-wrapper">
    <div class="inner-page-title ">
        <div class="toolbar">
          <h2>Export {response:controller()}</h2>
        </div>
    </div>
 
  <div class="content-box">
     <script type="text/javascript">
      var controller  = '{response:controller()}';
      var action = '{response:action()}';
     </script>
     <form name="export">
      <ul class="editPanel">
        <li>
            <label for="export-type">Export Format:</label>
            <select name="export-type">
               <option value="">Select Export Format</option>
               <option value="xml">Xml (*.xml)</option>
               <option value="xslx">Excel 2007 (*.xlsx)</option>
               <option value="tab">Tab Delimited Format (*.txt)</option>
               <option value="csv">Comma Seperated Values (*.csv)</option>
            </select>
         </li>
         <li>
            <label for="filename">File Name:</label>
            <input id="filename" name="filename" type="text" value=""/>
         </li>
         <li>
          <fieldset>
             <legend>Field Names:</legend>
             {()}
          </fieldset>
         </li>
         <li class="buttons">
            <button type="submit">Export</button>
         </li>
      </ul>
     </form>
  </div>
</div>