xquery version "1.0-ml";
declare default element namespace "http://www.w3.org/1999/xhtml";
declare namespace domain = "http://www.xquerrail-framework.com/domain";

import module namespace response = "http://www.xquerrail-framework.com/response" at "/_framework/response.xqy";
import module namespace js = "http://www.xquerrail-framework.com/helper/javascript" at "/_framework/helpers/javascript.xqy";

declare option xdmp:output "indent-untyped=yes";
declare variable $response as map:map external;

let $init := response:initialize($response)
let $domain-model := response:model()
return
<div >
    <div class="inner-page-title ">
        <div class="toolbar">
          <h2>Export Options</h2>
        </div>
    </div>
  <div id="export" class="content-box">
     <script type="text/javascript">
      var controller  = '{response:controller()}';
      var action = '{response:action()}';
     </script>
     <form name="export">
     <div id="export-tabs">
          <ul>
             <li><a href="#export-common">Default</a></li>
             <li><a href="#export-fields">Fields</a></li>
             <li><a href="#export-filter">Filter</a></li>
             <li><a href="#export-sort">Sort</a></li>
          </ul>
          <div id="export-common">
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
                       <input id="filename" name="filename" type="text" value="{response:controller()}"/>
                    </li>
               </ul>
          </div>
          <div id="export-fields">
             <label for="export-all-fields">Export All Fields:
               <input  name="export-all-fields" type="checkbox" value="true" class="field text medium"/>
             </label>
             <table id="export-fields-table">
                 <thead>
                    <tr>
                      <th>Field Name</th>
                      <th>Header Name</th>
                      <th>Format Expression</th>
                      <th>Export</th>
                    </tr>
                 </thead>
                 <tbody>
                 { 
                   if(fn:not(response:model())) 
                   then ()
                   else 
                    for $field in response:model()/(domain:element|domain:attribute)
                    return
                      if($field/domain:navigation/@exportable eq "true" or 
                         $field/domain:navigation/fn:not(fn:exists(@exportable))
                      ) then
                       <tr>
                         <td>{fn:data(($field/@name)[1])}:</td>
                         <td><input type="text" name="fieldName__{($field/@name)}" value="{($field/@label,$field/@name)[1]}"/></td>
                         <td><input type="text" name="format__{($field/@name)}" value=""/></td>
                         <td><input type="checkbox" name="export__{($field/@name)}" value="true"/></td>                    
                       </tr>
                     else ()
                 }</tbody>
             </table>
          </div>
          <div id="export-filter">      
                <textarea name="cts-expression" id="cts-expression" style="width:100%;height:100%;position:relative">cts:and-query(())
                </textarea>
          </div>
          <div id="export-sort">
            Sorting Code 
          </div>
      </div>
      </form>
      <link href="/resources/css/ui/ui.tabs.css" type="text/css" rel="stylesheet"/>
      <script type="text/javascript" src="/resources/js/ui/ui.tabs.js"></script>
      <script type="text/javascript">
        jQuery(function(){{
            jQuery("#export-tabs").tabs({
               js:o((
                 
               ))
            });
         }});  
      </script>
  </div>
</div>