/*Initialize Grid*/
jQuery(document).ready(function () {
    
    jQuery(".toolbar-new").button({
        text: true,
        icons: {
            primary: "ui-icon-plusthick"
        }
    });
    jQuery(".toolbar-help").button({
        text: true,
        icons: {
            primary: "ui-icon-help"
        }
    });
    jQuery(".cnp-button").button({
    });
    
    jQuery(".subPanel h3").click(function (el) {
        jQuery(el.parent).toggle()
    });
    //initLayout();
    initDropPanels();
    
    
    // Enable the DropDown Menus for the navigation
	jQuery('#navigation').superfish();

	// Enable the toggle feature 
	jQuery('.toggle').live('click',function() {
		jQuery(this).parent().toggle('slide',{ direction: "up" });
	});
	
	// Enable Calendar 
	jQuery('.date').live('focus',function () {
		jQuery(this).datepicker({ dateFormat: 'yy-mm-dd' });
	});

    
	// Enable panels
	jQuery(".panel h3").live('click',function(){
	   var parent = jQuery(this).parent();
	   parent.children(".panelContent").toggle('slow');
	});
});


function createNew(node) {
    var url = jQuery(node).attr('href') + "?_partial=true";
    
    jQuery('#form-content').html("Loading...");
    jQuery.get(url, function (data) {
        jQuery('#form-content').html(data);
    });
    return false;
};

function validateDelete(node, gridId) {
    
    var c = confirm("Are you really sure you want to delete this item?");
    if (c) {
        var url = jQuery(node).attr('href') + "&_partial=true";
        jQuery('#form-content').html("Loading...");
        jQuery.get(url, function (data) {
            jQuery('#form-content').html(data);
            
            // Reload the Grid
            jQuery("#" + gridId).trigger("reloadGrid");
        });
    }
    return false;
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

function editForm(controller, id) {
    var url = "/" + controller + "/edit.html?_partial=true&uuid=" + id;
    jQuery.get(url, function (data) {
        jQuery('#form-content').html(data);
    });
}

function initListGrid(gridId, gridParams) {
    jQuery(gridId).jqGrid(gridParams)
    .navGrid(gridId + '_pager', {
        edit: false, add: false, del: false, search: true, reload: true
    })
    .trigger("reloadGrid");
    
    jQuery(gridId).setGridWidth($(".content-box").width());
    jQuery(gridId).setGridHeight($(".content-box").height());
}


function initDropPanels() {
    $(function () {
        $('.dragbox')
        .each(function () {
            $(this).hover(function () {
                $(this).find('h2').addClass('collapse');
            },
            function () {
                $(this).find('h2').removeClass('collapse');
            })
            .find('h2').hover(function () {
                $(this).find('.configure').css('visibility', 'visible');
            },
            function () {
                $(this).find('.configure').css('visibility', 'hidden');
            })
            .click(function () {
                $(this).siblings('.dragbox-content').toggle();
            })
            .end()
            .find('.configure').css('visibility', 'hidden');
        });
        $('.column').sortable({
            connectWith: '.column',
            handle: 'h2',
            cursor: 'move',
            placeholder: 'placeholder',
            forcePlaceholderSize: true,
            opacity: 0.4,
            stop: function (event, ui) {
                $(ui.item).find('h2').click();
                var sortorder = '';
                $('.column').each(function () {
                    var itemorder = $(this).sortable('toArray');
                    var columnId = $(this).attr('id');
                    sortorder += columnId + '=' + itemorder.toString() + '&';
                });
                //alert('SortOrder: '+sortorder);
                /*Pass sortorder variable to server using ajax to save state*/
            }
        })
        .disableSelection();
    });
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

/************ jqGrid Utils ************/

// Build a grid for a specified grid name
// this will generate the jqGrid as well
// as the appoperite callouts for CRUD
function buildJqGrid(gridName, colNamesArray, colModelArray, colValues) {
    var grid = jQuery("#" + gridName);
    var pagerName = "#" + gridName + "_pager";
    var pager = jQuery(pagerName);
    grid.jqGrid({
        gridId: gridName,
        datatype: 'local',
        colNames: colNamesArray,
        colModel: colModelArray,
        xmlReader: {
            root: "items",
            row: "item",
            id: "id",
            repeatitems: false,
        },
        gridview: true,
        autowidth: true,
        viewrecords: true,
        sortorder: "desc",
        loadonce: true,
        pager: pager,
        editurl: "/resources/editPlaceholder.html",
        onSelectRow: function (id) {
            selectedRow = id;
        }
    })
    .navGrid(pagerName, {
        edit: false, add: false, del: false, search: false, reload: false
    })
    .navButtonAdd(pagerName, {
        id: 'filter_add',
        title: "Add",
        caption: "Add",
        onClickButton: rowAdd
    })
    .navButtonAdd(pagerName, {
        id: 'filter_edit',
        title: "Edit",
        caption: "Edit",
        onClickButton: rowEdit
    })
    .navButtonAdd(pagerName, {
        id: 'filter_save',
        title: "Save",
        caption: "Save",
        onClickButton: rowSave
    })
    .navButtonAdd(pagerName, {
        id: 'filter_cancel',
        title: "Cancel",
        caption: "Cancel",
        onClickButton: rowCancel
    })
    .navButtonAdd(pagerName, {
        id: 'filter_delete',
        title: "Delete",
        caption: "Delete",
        onClickButton: rowDelete
    });
    
    // Populate Table
    for (var x=0; x<=colValues.length; x++) {
        grid.jqGrid('addRowData', x+1, colValues[x]);
    }
    
}


// Edit a row for a given jqGrid
// instance
function rowEdit() {
    var grid = jQuery(this);
    if (selectedRow != null)
    grid.editRow(selectedRow);
}

// Save a row for a given jqGrid
// instance
function rowSave() {
    var grid = jQuery(this);
    if (selectedRow != null) {
       grid.saveRow(selectedRow, false, 'clientArray');
    }
}

// Restore a row  in editfor a
// given jqGrid instance
function rowCancel() {
    var grid = jQuery(this);
    if (selectedRow != null){
    grid.restoreRow(selectedRow);
    } else {
       alert('Select a row before restoring');
    }
}

// Remove a row for a given jqGrid
// instance
function rowDelete() {
    var grid = jQuery(this);
    if (selectedRow != null) {
        grid.delRowData(selectedRow);
        selectedRow = null;
    } else {
       alert('Select a row before deleting');
    }
}

// Add a row to the table being edited.
// This will increment the based on the
// number of items in the grid.
function rowAdd() {
    
    var grid = jQuery(this);
    var size = grid.jqGrid('getDataIDs').length;
    var id = size + 1;
    var data = { "id":id };

    grid.jqGrid('addRowData', id, data);
    grid.jqGrid('setSelection', id, true);
    grid.editRow(id);
}