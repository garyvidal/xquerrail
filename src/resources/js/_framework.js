var indexGrid = null;
var codeMirrors = [];
function xmlListReaderSettings(rootField, rowField) {
    var settings = {
        root: 'list',
        row: rowField,
        id: 'uuid',
        page: 'list>currentpage',
        total: 'list>totalpages',
        records: 'list>totalrecords',
        repeatitems: false
    };
    return settings;
}

function showForm(controller, idfield, id) {
    $.ajax({
        url: '/' + controller + '/show.html',
        data: {
            id: id, _partial: true
        },
        success: function (r) {
            $("#form-content").empty().stop().html(r);
        }
    });
}

// Sends the partial form back to UI
function editForm(controller, id) {
    var url = "/" + controller + "/edit.html?_partial=true&uuid=" + id;
    jQuery.get(url, function (data) {
        jQuery('#form-content').html(data);
    });
}

// Convert a form to a map of name:value sets for each field
function convertFormSerilizationArray(formname) {
    var serializedArray = jQuery('#' + formname).serializeArray();
    var map = {
    };
    jQuery.each(serializedArray, function () {
        if (map[ this.name] !== undefined) {
            if (! map[ this.name].push) {
                map[ this.name] =[map[ this.name]];
            }
            map[ this.name].push(this.value || '');
        } else {
            map[ this.name] = this.value || '';
        }
    });    
    return map;
}
function validateSave(formName, gridId) {

    var c = confirm("Are you sure you want to save these changes?");
    if (c) {
        // Save changes to all code mirrors
        if (codeMirrors != null) {
            for (var editor in codeMirrors) {
                codeMirrors[editor].toTextArea();
            }
        }
        
        // Start to build form submission
        var form = jQuery('#' + formName);
        var action = form.attr('action') + "?_partial=true";
        var params = convertFormSerilizationArray(formName);
        
        // Build all the grids information        
        var grids = jQuery(".complexGrid");
        if (grids != null) {
            jQuery.each(grids, function (index, object) {
                var id = jQuery(object).attr('id');
                var grid = jQuery("#" + id);
                params[id] = grid.getRowData();;
            });
        }
        
       jQuery.ajax({
           type: "POST",
           url: action,
           dataType: "json",
           contentType: "application/json",
           data: JSON.stringify(params,null,2),
           success: function(html){
               jQuery('#form-content').html(html);
               // Reload the Grid
               jQuery("#" + gridId).trigger("reloadGrid");
           }
        });
    
    } else return false;
}

function initToolbar(props) {
  var id = jQuery(indexGrid).jqGrid('getGridParam', 'selrow');
  if(props.new == true){
     jQuery("#toolbar").append("<a id='new-button' class='ui-state-default ui-corner-all ui-button'>New </a>");
     jQuery("#new-button").click(function() {editForm(controller,-1);});
  }
  if(props.edit == true) {
     jQuery("#toolbar").append("<a id='edit-button' class='ui-state-default ui-corner-all ui-button'>Edit</a>");
     jQuery("#new-button").click(function() {editForm(controller,id);});
  }
  if(props.delete == true) {
     jQuery("#toolbar").append("<a id='delete-button' class='ui-state-default ui-corner-all ui-button'>Delete</a>");
     jQuery("#delete-button").click(function() {editForm(controller,id);});
  }
  if(props.export == true) {
     jQuery("#toolbar").append("<a id='export-button' class='ui-state-default ui-corner-all ui-button'>Export</a>");
     jQuery("#export-button").click(function() {exportForm(controller);});
  }  
  if(props.import == true) {
     jQuery("#toolbar").append("<a id='import-button' class='ui-state-default ui-corner-all ui-button'>Import</a>");
     jQuery("#import-button").click(function() {importForm(controller);});
  } 
  jQuery("#toolbar").buttonset();  
}

function populateRelatedOptions(name, values, occurence) {
    if (name) {
        var url = "/" + name + "/lookup.xml";
        
        jQuery.get(url, function (xml) {
            
            // Iterate through the xml nodes and pull key value pairs out
            jQuery(xml).find('lookup').each(function (index, data) {
                // Extract Key and Label
                var $node = jQuery(data);
                var key = $node.find('key').text()
                var label = $node.find('label').text();
                
                // Select the option if it is in the model
                var selected = '';
                if (values.indexOf(key) >= 0) {
                    selected = 'selected="selected"';
                }
                
                // Build HTML option node and append
                var option = '<option value="' + key + '"' + selected + '>' + label + '</option>';
                jQuery('#' + name).append(option);
            });
            
            // Invoke the multi select UI element
            if (occurence == "*")
               jQuery('#' + name).multiselect();
        });
    }
}

function initListGrid(gridId, gridParams) {
    indexGrid = gridId;
    jQuery(gridId).jqGrid(gridParams)
    .navGrid(gridId + '_pager', {
        edit: false, add: false, del: false, search: true, reload: true
    })
    .trigger("reloadGrid");   
    resizeGrid();    
}
function resizeGrid() {
    jQuery(indexGrid).setGridWidth(jQuery("#list-wrapper").innerWidth());
    jQuery(indexGrid).setGridHeight(jQuery("#list-wrapper").innerHeight() -48);
}


function resizeLayout() {
  outerLayout.resizeAll();
  resizeGrid();
}

function initLayout() {
    var outerLayout = jQuery(".body-wrapper").layout({
       onresize:'resizeLayout',
       north__spacing:0,
       north__spacing_open:0,
       north__resizable:false,
       north__size:40,
       east__size:600,
       east__closed:true
   }); 
}
