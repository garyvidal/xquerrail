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


//new Form
function newForm() {
   window.location.href = "/" + context.controller + "/new.html";
}

// Sends the partial form back to UI
function editForm() {
    window.location.href = "/" + context.controller + "/edit.html?" + context.model_id_field + "=" + _id;
}

function deleteForm() {
   var c = confirm("Delete Record?");
   if(c) {
          window.location.href = "/" + context.controller + "/remove.html?" + context.model_id_field + "=" + _id;
   }
};

function showForm(){
  var url = "/" + context.controller + "/show.html?_partial=true&" + context.model_id_field + "=" + _id;;
  jQuery('#popup').html("<div class='loading'>...</div>");
  jQuery.get(url, function (data) {
        jQuery('#popup').html(data);
  });
  jQuery("#popup").dialog({ 
     width: 800, 
     height: 600, 
     autoOpen: true,
     resizable:false,
     modal:true,
     zIndex:999999,
     title:'Show ' + _id   
  });   
}
// Sends the partial form back to UI
function importForm() {
 var url = "/" + context.controller + "/import.html?_partial=true";
 jQuery('#popup').html("<div class='loading'>...</div>");
  jQuery.get(url, function (data) {
        jQuery('#popup').html(data);
  });
  jQuery("#popup").dialog({ 
     width: 800, 
     height: 600, 
     autoOpen: true,
     resizable:false,
     modal:true,
     zIndex:999999,
     title:'Import Options'     
  });
}

//Popup Dialog Form
function exportForm() {
  var url = "/" + context.controller + "/export.html?_partial=true";
  jQuery('#popup').html("<div class='loading'>...</div>");
  jQuery.get(url, function (data) {
        jQuery('#popup').html(data);
  });
  jQuery("#popup").dialog({ 
     width: 840, 
     height: 500, 
     autoOpen: true ,
     modal:true ,
     title:'Export Options'     
  });
}
// Convert a form to a map of name:value sets for each field
function convertFormSerializationArray(formname) {
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

/*function validateSave(formName, gridId) {

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
           contentType: "",
           data: params,
           success: function(html){
               window.location.href = "/" + _context.controller;
           }
        });
    
    } else return false;
}*/
function toggleToolbarState() {
  
}
function initToolbar(props) {
  var id = jQuery(indexGrid).jqGrid('getGridParam', 'selrow');
  if(props.new == true){
     jQuery("#toolbar").append("<a id='new-button' class='ui-state-default ui-corner-all ui-button'>New</a>");
     jQuery("#new-button").click(function() {newForm();});
  }
  if(props.edit == true) {
     jQuery("#toolbar").append("<a id='edit-button' class='ui-state-default ui-corner-all ui-button'>Edit</a>");
     jQuery("#edit-button").click(function() {editForm();});
  }
  if(props.delete == true) {
     jQuery("#toolbar").append("<a id='delete-button' class='ui-state-default ui-corner-all ui-button'>Delete</a>");
     jQuery("#delete-button").click(function() {deleteForm();});
  }
    if(props.show == true){
     jQuery("#toolbar").append("<a id='show-button' class='ui-state-default ui-corner-all ui-button'>Show</a>");
     jQuery("#show-button").click(function() {showForm();});
  }
  if(props.export == true) {
     jQuery("#toolbar").append("<a id='export-button' class='ui-state-default ui-corner-all ui-button'>Export</a>");
     jQuery("#export-button").click(function() {exportForm();});
  }  
  if(props.import == true) {
     jQuery("#toolbar").append("<a id='import-button' class='ui-state-default ui-corner-all ui-button'>Import</a>");
     jQuery("#import-button").click(function() {importForm();});
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

function resizeGrid() {
    jQuery(indexGrid).setGridWidth(jQuery("#list-wrapper").innerWidth());
    jQuery(indexGrid).setGridHeight(jQuery("#list-wrapper").innerHeight() - 40);
}


function resizeLayout() {
  outerLayout.resizeAll();
  resizeGrid();
}

function initListGrid(gridId, gridParams) {
    indexGrid = gridId;
    jQuery(gridId).jqGrid(gridParams)
    .navGrid(gridId + '_pager', {
        edit: false, add: false, del: false, search: true, reload: true,
    },{},{},{multipleSearch:true})
    .trigger("reloadGrid");   
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
   if(jQuery("#popup") != null) {
     jQuery(body).append("<div id='popup'></div>");
   }
}
