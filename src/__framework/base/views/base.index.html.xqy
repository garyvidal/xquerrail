(:@GENERATED@:)
xquery version "1.0-ml";
declare default element namespace "http://www.w3.org/1999/xhtml";
import module namespace response = "http://www.xquerrail-framework.com/response" at "/_framework/response.xqy";

import module namespace domain = "http://www.xquerrail-framework.com/domain" at "/_framework/domain.xqy";

declare option xdmp:output "indent-untyped=yes";
declare variable $response as map:map external;

let $init := response:initialize($response)
let $domain-model := response:model()
let $modelName := fn:data($domain-model/@name)
let $modelLabel := (fn:data($domain-model/@label),$modelName)[1]
let $gridCols :=
    for $item in $domain-model/(domain:element|domain:attribute)
    let $name := fn:data($item/@name)
    let $label := fn:data($item/@label)
    let $dataType := fn:data($item/@type)
    let $listable := $item/domain:navigation/@listable
    let $colWidth := (fn:data($item/domain:ui/@gridWidth),"40")[1]
    return
    if(fn:not($listable = 'false')) then
        fn:concat("{",fn:string(<stmt>
            name:'{$name}', 
            label:'{$label}', 
            index:'{$name}', 
            xmlmap:'{$name}', 
            jsonmap:'{$name}', 
            dataType:'{$dataType}', 
            resizable: true, 
            sortable: true,  
            width:'{$colWidth}'
         </stmt>),"}")
     else ()
let $editButtons := fn:string(<stmt>{{new:true,edit:true,show:true,delete:true,import:true,export:true}}</stmt>)
let $uuidMap :=  fn:string(<stmt>{{ name:'uuid', label:'UUID', index:'uuid',hidden:true }}</stmt>)
let $gridColsStr := fn:string-join(($uuidMap,$gridCols),",")
let $uuidKey := domain:get-field-key($domain-model/domain:element[@name = "uuid"])

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
    <div class="column-content-box ui-layout-east">
        <div id="form-content" class="form-box-wrapper">
        <h2>Please select {$modelLabel} or New</h2>
        </div>
    </div>    
    <script type="text/javascript">
            var toolbarMode = {$editButtons}
            var gridModel = {{
                url: '/{response:controller()}/list.xml',
                pager: jQuery('#{response:controller()}_table_pager'),
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
                onSelectRow: function(id){{ 
                    if(id){{ 
                       alert('foo');
                       editForm('{fn:concat("/",response:controller(),"/edit.html?", $uuidKey, "=")}',id,true);
                    }} 
                    return true;
                }}
            }};
            
            /*initialize your grid model*/
            $(document).ready(function(){{
               initListGrid("#{response:controller()}_table",gridModel)
               initToolbar(toolbarMode);
               initLayout();
            }});
            var _controller = '{response:controller()}';
            var _action = '{response:action()}';
           </script>
</div>