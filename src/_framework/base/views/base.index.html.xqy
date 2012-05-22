(:@GENERATED@:)
xquery version "1.0-ml";
declare default element namespace "http://www.w3.org/1999/xhtml";

import module namespace response = "http://www.xquerrail-framework.com/response" at "/_framework/response.xqy";

import module namespace domain = "http://www.xquerrail-framework.com/domain" at "/_framework/domain.xqy";

import module namespace js = "http://www.xquerrail-framework.com/helper/javascript" at "/_framework/helpers/javascript.xqy";
import module namespace form = "http://www.xquerrail-framework.com/helper/form-builder" at "/_framework/helpers/form-builder.xqy";


declare option xdmp:output "indent-untyped=yes";
declare variable $response as map:map external;

declare variable $default-col-width := 40;
declare variable $default-resizable := fn:true();
declare variable $default-sortable  := fn:false();
declare variable $default-pagesize  := 100;

let $init := response:initialize($response)
let $domain-model := response:model()
let $model := $domain-model
let $modelName := fn:data($domain-model/@name)
let $modelLabel := (fn:data($domain-model/@label),$modelName)[1]
let $gridCols :=
    for $item in $domain-model/(domain:element|domain:attribute)
    return form:field-grid-column($item)
let $editButtons := 
     js:o((
         js:p("new",($model/domain:navigation/@newable,"true")[1]),
         js:p("edit",($model/domain:navigation/@editable,"true")[1]),
         js:p("delete",($model/domain:navigation/@removable,"true")[1]),
         js:p("show",($model/domain:navigation/@showable,"true")[1]),
         js:p("import",($model/domain:navigation/@importable,"true")[1]),
         js:p("export",($model/domain:navigation/@exportable,"true")[1])
     ))
let $uuidMap :=  fn:string(<stmt>{{ name:'uuid', label:'UUID', index:'uuid',hidden:true }}</stmt>)
let $gridColsStr := fn:string-join(($uuidMap,$gridCols),",")
let $uuidKey := domain:get-field-id($domain-model/domain:element[@name = "uuid"])

return
<div xmlns="http://www.w3.org/1999/xhtml" class="body-wrapper">
    <div class="inner-page-title ui-layout-north">
        <div class="toolbar">
          <h2><?title?></h2>    
        </div>
    </div>
    <div class="column-content-box ui-layout-center">
        <div id="toolbar" class="ui-state-default ui-corner-top ui-box-header">
        </div>
        <div id="list-wrapper" class="content-box-wrapper">
           <table id="{response:controller()}_table"/>
            <div id="{response:controller()}_table_pager"/>
        </div>
    </div>
    <!--
    <div class="column-content-box ui-layout-east">
        <div id="form-content" class="form-box-wrapper">
        <h3>Please select {$modelLabel} or New</h3>
        </div>
    </div>   --> 
    <script type="text/javascript">
            {form:context($response)}
            var _id = null;
            var toolbarMode = {$editButtons}
            var gridModel = {{
                url: '/{response:controller()}/list.xml',
                pager: jQuery('#{response:controller()}_table_pager'),
                id : "{domain:get-model-id-field(response:model())}",
                datatype: "xml",
                colModel: [{$gridColsStr}],
                loadonce:false,
                rowNum:20,
                pgbuttons: false,
                sortname: '{$domain-model/element[@identity eq 'true']/@name}',
                sortorder: 'desc',   
                
                //Grid Text
                emptyrecords: "No {$modelLabel}'s Found",
                loadtext: "Loading {$modelLabel}'s",
                gridview: true,
                viewrecords :true,
                rownumbers:true,
                width: '500',
                height: '500',
                multiselect: false,
                xmlReader : xmlListReaderSettings('{$modelName}s','{$modelName}'),
                onSelectRow   : function(rowid,e) {{
                   _id = rowid;
                   return 
                      true;
                }},
                ondblClickRow : function(rowid) {{
                    window.location.href = "/{response:controller()}/edit.html?" + context.model_id_field +  '=' + rowid;
                }}
            }};
            
            /*initialize your grid model*/
            $(document).ready(function(){{
               initListGrid("#{response:controller()}_table",gridModel)
               initToolbar(toolbarMode);
            }});
             
           </script>
           
</div>