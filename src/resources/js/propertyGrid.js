function PropertyGrid() {

    //private variables
    var Properties = new Array();
    var PropertiesLookup = new Array();
    var groupCount = 0;
    var subGroupCount = 0;
    var cssItem = 0;
    //could attach public property here
    var styleOnChange = "Styler.UpdateCSSEditor";

    //public variables
    this.OutputDivId = "pg1";
    this.DefaultSizeType = "px";
    this.PropertyGridOnChange = styleOnChange;

    //public methods
    PropertyGrid.prototype.GroupCount = function () { return Properties.length; }

    //LOAD EVENT
    $().ready(function () {

        //Fill css2 standard - put css3 in with drop down to switch property grid
        PropertyGrid.FillXmp();
    });
    
    var CreateItem = function (groupName, rowType, cssName, drpFields, isSubGroup) {
        //create css property
        //first check if groupName exists
        var foundGroup = false;
        for (var i = 0; i < Properties.length; i++) {
            if (Properties[i].GroupName == groupName) {
                //found group - check if its going to be a sub group or a item within group?
                if (isSubGroup != "") {
                    //sub group - search the inner subgroups loop
                    var foundSubGroup = false;
                    for (var x = 0; x < Properties[i].SubGroups.length; x++) {
                        if (Properties[i].SubGroups[x].GroupName == isSubGroup) {
                            //sub group found add item
                            foundSubGroup = true;
                            Properties[i].SubGroups[x].Items[Properties[i].SubGroups[x].Items.length] = new ClassItem(cssName, rowType, drpFields, cssItem);
                            cssItem++;
                        }
                    }
                    if (!foundSubGroup) {
                        //create sub group
                        Properties[i].SubGroups[Properties[i].SubGroups.length] = new Group(isSubGroup, subGroupCount, true);
                        Properties[i].SubGroups[Properties[i].SubGroups.length - 1].Items[Properties[i].SubGroups[Properties[i].SubGroups.length - 1].Items.length] = new ClassItem(cssName, rowType, drpFields, cssItem);
                        cssItem++;
                        subGroupCount++;
                    }
                }
                else {
                    //item within group
                    Properties[i].Items[Properties[i].Items.length] = new ClassItem(cssName, rowType, drpFields, cssItem);
                    cssItem++;
                }
                foundGroup = true;
            }
        }
        if (!foundGroup) {
            //create new group with item
            Properties[Properties.length] = new Group(groupName, groupCount, false);
            Properties[Properties.length - 1].Items[Properties[Properties.length - 1].Items.length] = new ClassItem(cssName, rowType, drpFields, cssItem);
            groupCount++;
            cssItem++;
        }
    }

    PropertyGrid.prototype.UpdateStyle = function (cssName, newStyle) {
        //clean object up if dirty
        cssName = cssName.replace(/^\s*|\s*$/g, '');
        cssName = cssName.toLowerCase();

        var propLookup = "";
        for (var i = 0; i < PropertiesLookup.length; i++) {
            if (PropertiesLookup[i][0] == cssName) {
                propLookup = PropertiesLookup[i][1];
                document.getElementById(propLookup).value = newStyle;
                //check for col or drop type
                if (PropertiesLookup[i][2] == "color") {
                    var colorPalette = document.getElementById("color" + PropertiesLookup[i][1]);
                    if (colorPalette != null) {
                        try {
                            document.getElementById("color" + PropertiesLookup[i][1]).style.backgroundColor = newStyle;
                        } catch (e) { }
                    }
                }
                //make section visible
                if (document.getElementById(propLookup).parentNode.parentNode.parentNode.id.indexOf("subgroup") != -1) {
                    //item is in a subgroup sp show this and its parent 
                    document.getElementById(propLookup).parentNode.parentNode.parentNode.style.display = "block";
                    var groupId = document.getElementById(propLookup).parentNode.parentNode.parentNode.id;
                    groupId = groupId.replace('child', '');
                    document.getElementById(propLookup).parentNode.parentNode.parentNode.parentNode.style.display = "block";
                    var subGroupId = document.getElementById(propLookup).parentNode.parentNode.parentNode.parentNode.id;
                    subGroupId = subGroupId.replace('child', '');
                    $("#image" + groupId).removeClass('bkExpand').addClass('bkMinimise');
                    $("#image" + subGroupId).removeClass('bkExpand');
                    $("#image" + subGroupId).removeClass('bkExpandSub').addClass('bkMinimiseSub');
                }
                else {
                    var groupId = document.getElementById(propLookup).parentNode.parentNode.parentNode.id;
                    groupId = groupId.replace('child', '');
                    document.getElementById(propLookup).parentNode.parentNode.parentNode.style.display = "block";
                    $("#image" + groupId).removeClass('bkExpand').addClass('bkMinimise');
                }
            }
        }
    }

    PropertyGrid.prototype.SelectStyle = function (cssName) {
        for (var i = 0; i < PropertiesLookup.length; i++) {
            if (PropertiesLookup[i][0] == cssName) {
                return document.getElementById(propLookup).value;
            }
        }
        return null;
    }

    var RenderGrid = function () {
        //creates the html output from Properties Object
        var htmlOut = "<div id=\"propertyGridContainer\">";
        try {
            for (var i = 0; i < Properties.length; i++) {
                htmlOut += "<div id=\"" + Properties[i].OutputDivId + "\" onclick=\"javascript:PropertyGrid.Expand('" + Properties[i].OutputDivId + "',false);\" class=\"pgGroup\"><div id=\"image" + Properties[i].OutputDivId + "\" class=\"pgGroupShrink bkMinimise\">&nbsp;</div><div class=\"pgGroupText\">" + Properties[i].GroupName + "</div></div>";
                //render group items
                htmlOut += "<div id=\"child" + Properties[i].OutputDivId + "\">";
                for (var x = 0; x < Properties[i].Items.length; x++) {
                    htmlOut += RenderGridInput(Properties[i].Items[x].Type, Properties[i].Items[x].OutputDivId, Properties[i].Items[x].CssId, Properties[i].Items[x].DropFields);
                }
                //check for subgroups
                if (Properties[i].SubGroups.length > 0) {
                    for (var ii = 0; ii < Properties[i].SubGroups.length; ii++) {
                        htmlOut += "<div id=\"" + Properties[i].SubGroups[ii].OutputDivId + "\" class=\"pgSubGroup\" onclick=\"PropertyGrid.Expand('" + Properties[i].SubGroups[ii].OutputDivId + "','true');\"><div id=\"image" + Properties[i].SubGroups[ii].OutputDivId + "\" class=\"pgSubGroupShrink bkMinimiseSub\">&nbsp;</div><div class=\"pgSubGroupText\">" + Properties[i].SubGroups[ii].GroupName + "</div></div>";
                        //render sub group items
                        htmlOut += "<div id=\"child" + Properties[i].SubGroups[ii].OutputDivId + "\">";
                        for (var xx = 0; xx < Properties[i].SubGroups[ii].Items.length; xx++) {
                            htmlOut += RenderGridInput(Properties[i].SubGroups[xx].Items[xx].Type, Properties[i].SubGroups[ii].Items[xx].OutputDivId, Properties[i].SubGroups[ii].Items[xx].CssId, Properties[i].SubGroups[ii].Items[xx].DropFields);
                        }
                        htmlOut += "</div>";
                    }
                }
                htmlOut += "</div>";
            }
        } catch (e) { alert(e); }
        document.getElementById(PropertyGrid.OutputDivId).innerHTML = htmlOut + "</div>";
        //$("input[class*='pgInputNum']").spinbox();
        $("input[class*='pgInputDate']").datepicker({ dateFormat: 'yy-mm-dd'});
    }

    var RenderGridInput = function (type, outputDivId, cssId, fields) {
        //creates the output row with the input controls for different types
        switch (type) {
            case 'input':
                return "<div id=\"hold" + outputDivId + "\" class=\"pgGroupItem\"><div class=\"pgGroupItemText\">" + cssId + "</div><div class=\"pgInputHolder\"><input id=\"" + outputDivId + "\" class=\"pgInput\" onchange=\"javascript:PropertyGrid.UpdateStyleInner('" + cssId + "', this.value);\"></input></div></div>";
            case 'color':
                return "<div id=\"hold" + outputDivId + "\" class=\"pgGroupItem\"><div class=\"pgGroupItemText\">" + cssId + "</div><div class=\"pgInputHolder\"><input id=\"" + outputDivId + "\" class=\"pgInputColor\"></input><div id=\"color" + outputDivId + "\" onmouseover=\"javascript:PropertyGrid.AttachColorPicker('" + cssId + "','" + outputDivId + "');\" class=\"pgBtnColor\"></div></div></div>";
            case 'num':
                return "<div id=\"hold" + outputDivId + "\" class=\"pgGroupItem\"><div class=\"pgGroupItemText\">" + cssId + "</div><div class=\"pgInputHolder\"><input id=\"" + outputDivId + "\" class=\"pgInputNum\" onchange=\"javascript:PropertyGrid.UpdateStyleInnerNum('" + cssId + "', this.value);\"></input></div></div>";
            case 'date':
                return "<div id=\"hold" + outputDivId + "\" class=\"pgGroupItem\"><div class=\"pgGroupItemText\">" + cssId + "</div><div class=\"pgInputHolder\"><input id=\"" + outputDivId + "\" class=\"pgInputDate\" onclick=\"javascript:PropertyGrid.AttachDatePicker('" + cssId + "', this.value);\"></input></div></div>";
            case 'dialog':
                return "<div id=\"hold" + outputDivId + "\" class=\"pgGroupItem\"><div class=\"pgGroupItemText\">" + cssId + "</div><div class=\"pgInputHolder\"><input id=\"" + outputDivId + "\" class=\"pgInputDialog\" onchange=\"javascript:PropertyGrid.UpdateStyleDialog('" + cssId + "', this.value);\"></input><button class=\"dialog\">&hellip;</button></div></div>";
            case 'drop':
                return "<div id=\"hold" + outputDivId + "\" class=\"pgGroupItem\"><div class=\"pgGroupItemText\">" + cssId + "</div><div class=\"pgInputHolder\"><select id=\"" + outputDivId + "\" class=\"pgInputDrop\" onchange=\"javascript:PropertyGrid.UpdateStyleInner('" + cssId + "',this.value);\"><option value='none'>none</option><option value='solid'>solid</option><option value='ridge'>ridge</option><option value='dashed'>dashed</option><option value='dotted'>dotted</option><option value='double'>double</option><option value='groove'>groove</option><option value='inset'>inset</option></select></div></div>";
            case 'cdrop':
                //custom drop
                var dropHtml = "<div id=\"hold" + outputDivId + "\" class=\"pgGroupItem\"><div class=\"pgGroupItemText\">" + cssId + "</div><div class=\"pgInputHolder\"><select id=\"" + outputDivId + "\" class=\"pgInputDrop\" onchange=\"javascript:PropertyGrid.UpdateStyleInner('" + cssId + "',this.value);\">";
                var items = fields.split('|');
                //loop round items[]
                for (i = 0; i < items.length; i++) {
                    dropHtml += "<option value=\"" + items[i] + "\">" + items[i] + "</option>";
                }
                dropHtml += "</select></div></div>";
                return dropHtml;
            default:
                return "<div id=\"hold" + outputDivId + "\" class=\"pgGroupItem\"><div class=\"pgGroupItemText\">" + cssId + "</div><div class=\"pgInputHolder\"><input id=\"" + outputDivId + "\" class=\"pgInput\"></input></div></div>";
        }
    }

    PropertyGrid.prototype.UpdateStyleInnerNum = function (cssId, value) {
        if (value.indexOf('px') != -1 || value.indexOf('em') != -1) {
            PropertyGrid.UpdateStyleInner(cssId, value);
        }
        else {
            //add default value extension
            PropertyGrid.UpdateStyleInner(cssId, value + this.DefaultSizeType);
        }
    }
    PropertyGrid.prototype.UpdateStyleInner = function (cssId, value) {
        //fire back to handler
        if (styleOnChange.indexOf('.') == -1) {
            gthis[styleOnChange](cssId, value);
        }
        else {
            gthis[styleOnChange.substring(0, styleOnChange.indexOf('.'))][styleOnChange.substring(styleOnChange.indexOf('.') + 1)](cssId, value);
        }
    }
    //global this function for callback
    var gthis = (function () { return this; })();

    PropertyGrid.prototype.AttachColorPicker = function (cssId, outputDivId) {
        $("#color" + outputDivId).ColorPicker({
            onSubmit: function (hsb, hex, rgb, el) {
                //$(el).val(hex);
                $(el).css("backgroundColor", "#" + hex);
                $(el).ColorPickerHide();
                PropertyGrid.UpdateStyleInner(cssId, "#" + hex);
            },
            onChange: function (hsb, hex, rgb) {
                $("#color" + outputDivId).css('backgroundColor', '#' + hex);
                $("input[id='" + outputDivId + "']").val('#' + hex);
                PropertyGrid.UpdateStyleInner(cssId, "#" + hex);
            },
            onBeforeShow: function () {
                var color = $("input[id='" + outputDivId + "']").val();
                $(this).ColorPickerSetColor($("input[id='" + outputDivId + "']").val());
            }
        });
    }
    PropertyGrid.prototype.AttachDatePicker = function (cssId, outputDivId) {
       $( "#pgInputDate" ).datepicker({
			showOn: "button",
			buttonImage: "images/calendar.gif",
			buttonImageOnly: true
		});
    }
    PropertyGrid.prototype.ClearValues = function () {
        for (var i = 0; i < PropertiesLookup.length; i++) {
            var propLookup = PropertiesLookup[i][1];
            document.getElementById(propLookup).value = "";
        }
    }

    PropertyGrid.prototype.EmptyGrid = function () {
        Properties = new Array();
        PropertiesLookup = new Array();
        groupCount = 0;
        subGroupCount = 0;
        cssItem = 0;
    }

    PropertyGrid.prototype.HideItems = function () {
        //hide groups and sub groups
        $("div[id*=childpg1_group_]").css('display', 'none');
        $("div[id*=childpg1_subgroup_]").css('display', 'none');
        $("div[id*=imagepg1_group_]").removeClass('bkMinimise').addClass('bkExpand');
        $("div[id*=imagepg1_subgroup_]").removeClass('bkMinimiseSub').addClass('bkExpandSub');
    }

    PropertyGrid.prototype.Expand = function (id, sub) {
        //SHOW / HIDE PARTICLUAR LEVELS
        if (document.getElementById('child' + id).style.display == "" || document.getElementById('child' + id).style.display == "block") {
            //MAKE SMALL
            document.getElementById('child' + id).style.display = "none";
            if (sub == 'true') {
                $("#image" + id).removeClass('bkMinimiseSub').addClass('bkExpandSub');
            }
            else {
                $("#image" + id).removeClass('bkMinimise').addClass('bkExpand');
            }
        }
        else {
            //SHOW
            document.getElementById('child' + id).style.display = "block";
            if (sub == 'true') {
                $("#image" + id).removeClass('bkExpandSub').addClass('bkMinimiseSub');
            }
            else {
                $("#image" + id).removeClass('bkExpand').addClass('bkMinimise');
            }
        }
    }

    PropertyGrid.prototype.RetrieveCSSName = function () {
        //returns all loaded css names loaded into propery grid
        return PropertiesLookup;
    }

    var Group = function (groupName, id, subgroup) {
        this.GroupName = groupName;
        if (subgroup) {
            this.OutputDivId = 'pg1_subgroup_' + id;
        }
        else {
            this.OutputDivId = 'pg1_group_' + id;
        }
        this.Items = new Array();
        this.SubGroups = new Array();
    }
    var ClassItem = function (cssName, rowType, drpFields, id) {
        this.CssId = cssName;
        this.OutputDivId = 'pg1_item_' + id;
        this.Type = rowType;
        this.Value = '';
        this.DropFields = drpFields;
        //add an item to PropertiesLookup its a quick way to reference css keyname with id needs to be output to
        PropertiesLookup[PropertiesLookup.length] = [cssName, this.OutputDivId, rowType];
    }
    PropertyGrid.prototype.FillXmp = function () {
          PropertyGrid.EmptyGrid();
          //in format [groupName],[rowType],[cssName],[drpFields],[isSubGroup]
          //rowTypes can  be [input],[color],[num],[drop],[cdrop] cdrop is customized drop list
          
            CreateItem("Photo Metadata", "cdrop", "Content Type", "|application/vnd-excel|application/x-indesign","");
            CreateItem("Photo Metadata", "dialog", "Mime Type", "", "");
            CreateItem("Photo Metadata", "input", "Format", "", "");
            CreateItem("Photo Metadata", "input", "Width", "", "");
            CreateItem("Photo Metadata", "input", "Height", "", "");  
            
            CreateItem("XMP Metadata", "date", "Create Date", "", "");
            CreateItem("XMP Metadata", "date", "Modify Date", "", "");
            CreateItem("XMP Metadata", "date", "Metadata Date", "", "");
            CreateItem("XMP Metadata", "dialog", "Thumbnail", "", "");
            CreateItem("XMP Metadata", "input", "CreatorTool", "", "");
           ;
          //Render the grid
          RenderGrid();
    }

    PropertyGrid.prototype.FillCss2 = function () {
        PropertyGrid.EmptyGrid();
        //in format [groupName],[rowType],[cssName],[drpFields],[isSubGroup]
        //rowTypes can  be [input],[color],[num],[drop],[cdrop] cdrop is customized drop list
        CreateItem("background", "input", "background", "", "");
        CreateItem("background", "input", "background-image", "", "");
        CreateItem("background", "input", "background-position", "", "");
        CreateItem("background", "color", "background-color", "", "");
        CreateItem("background", "drop", "background-repeat", "|repeat|no-repeat|repeat-x|repeat-y", "");

        CreateItem("margin", "input", "margin", "", "");
        CreateItem("margin", "num", "margin-top", "", "");
        CreateItem("margin", "num", "margin-left", "", "");
        CreateItem("margin", "num", "margin-right", "", "");
        CreateItem("margin", "num", "margin-bottom", "", "");

        CreateItem("border", "input", "border", "", "");
        CreateItem("border", "input", "border-top", "", "border-top");
        CreateItem("border", "num", "border-top-width", "", "border-top");
        CreateItem("border", "color", "border-top-color", "", "border-top");
        CreateItem("border", "drop", "border-top-style", "", "border-top");
        CreateItem("border", "input", "border-right", "", "border-right");
        CreateItem("border", "num", "border-right-width", "", "border-right");
        CreateItem("border", "color", "border-right-color", "", "border-right");
        CreateItem("border", "drop", "border-right-style", "", "border-right");
        CreateItem("border", "input", "border-bottom", "", "border-bottom");
        CreateItem("border", "num", "border-bottom-width", "", "border-bottom");
        CreateItem("border", "color", "border-bottom-color", "", "border-bottom");
        CreateItem("border", "drop", "border-bottom-style", "", "border-bottom");
        CreateItem("border", "input", "border-left", "", "border-left");
        CreateItem("border", "num", "border-left-width", "", "border-left");
        CreateItem("border", "color", "border-left-color", "", "border-left");
        CreateItem("border", "drop", "border-left-style", "", "border-left");

        CreateItem("padding", "input", "padding", "", "");
        CreateItem("padding", "num", "padding-top", "", "");
        CreateItem("padding", "num", "padding-left", "", "");
        CreateItem("padding", "num", "padding-right", "", "");
        CreateItem("padding", "num", "padding-bottom", "", "");

        CreateItem("font", "input", "font", "", "");
        CreateItem("font", "cdrop", "font-family", " |Arial|Arial Black|Bookman Old Style|Comic Sans MS|Courier|Courier New|Gadget|Garamond|Georgia|Helvetica|Impact|Lucida Console|Lucida Sans Unicode|Lucida Grande|MS Sans Serif|MS Serif|Palatino Linotype|Symbol|Tahoma|Times New Roman|Trebuchet MS|Verdana|Webdings|Wingdings", "");
        CreateItem("font", "cdrop", "font-style", "|normal|italic|oblique|inherit", "");
        CreateItem("font", "num", "font-size", "", "");
        CreateItem("font", "num", "font-weight", "bold|bolder|lighter|normal", "");
        CreateItem("font", "cdrop", "font-varient", "|normal|small-caps", "");

        CreateItem("text", "input", "text", "", "");
        CreateItem("text", "cdrop", "text-align", "|center|justify|left|right", "");
        CreateItem("text", "cdrop", "text-decoration", "|underline|overline|none|blink|both", "");
        CreateItem("text", "input", "text-indent", "", "");
        CreateItem("text", "cdrop", "text-justify", "|auto|distribute|distribute-all-lines|inter-word|newspaper", "");
        CreateItem("text", "cdrop", "text-transform", "|capitalize|lowercase|none|uppercase", "");
        CreateItem("text", "color", "color", "", "");

        CreateItem("outline", "color", "outline-color", "", "");
        CreateItem("outline", "drop", "outline-style", "", "");
        CreateItem("outline", "num", "outline-width", "", "");

        CreateItem("general", "input", "bottom", "", "");
        CreateItem("general", "cdrop", "clear", "|both|left|none|right", "");
        CreateItem("general", "cdrop", "cursor", "|auto|crosshair|default|e-resize|hand|help|move|n-resize|ne-resize|nw-resize|s-resize|se-resize|sw-resize|pointer|text|w-resize|wait", "");
        CreateItem("general", "cdrop", "direction", "|inherit|ltr|rtl", "");
        CreateItem("general", "cdrop", "display", "|block|inline|inline-block|list-item|none|table-header-group|table-footer-group", "");
        CreateItem("general", "input", "filter", "", "");
        CreateItem("general", "cdrop", "float", "|left|none|right", "");
        CreateItem("general", "input", "height", "", "");
        CreateItem("general", "input", "left", "", "");
        CreateItem("general", "input", "letter-spacing", "", "");
        CreateItem("general", "input", "line-height", "", "");
        CreateItem("general", "cdrop", "overflow", "|auto|hidden|scroll|visible", "");
        CreateItem("general", "cdrop", "page-break-after", "|always|auto|left|right", "");
        CreateItem("general", "cdrop", "page-break-before", "|always|auto|left|right", "");
        CreateItem("general", "cdrop", "position", "|absolute|relative|static", "");
        CreateItem("general", "input", "src", "", "");
        CreateItem("general", "input", "right", "", "");
        CreateItem("general", "input", "top", "", "");
        CreateItem("general", "cdrop", "unicode-bidi", "|bidi-override|embed|normal", "");
        CreateItem("general", "cdrop", "vertical-align", "|baseline|bottom|middle|sub|super|text-bottom|text-top|top", "");
        CreateItem("general", "cdrop", "visibility", "|hidden|inherit|visible", "");
        CreateItem("general", "cdrop", "white-space", "|normal|nowrap|pre", "");
        CreateItem("general", "input", "width", "", "");
        CreateItem("general", "input", "word-spacing", "", "");
        CreateItem("general", "input", "z-index", "", "");

        CreateItem("list", "input", "list-style-image", "", "");
        CreateItem("list", "cdrop", "list-style-position", "|inside|outside", "");
        CreateItem("list", "cdrop", "list-style-type", "|circle|decimal|disc|lower-alpha|lower-roman|none|swuare|upper-alpha|upper-roman", "");

        //RENDER THE ITEMS
        RenderGrid();
    }

    PropertyGrid.prototype.FillCss3 = function () {
        PropertyGrid.EmptyGrid();

        //in format [groupName],[rowType],[cssName],[drpFields],[isSubGroup]
        //rowTypes can  be [input],[color],[num],[drop],[cdrop] cdrop is customized drop list
        CreateItem("background", "input", "background", "", "");
        CreateItem("background", "cdrop", "background-attachment", "|scroll|fixed", "");
        CreateItem("background", "cdrop", "background-break", "|bounding-box|each-box|continuous", "");
        CreateItem("background", "num", "background-clip", "", "");
        CreateItem("background", "input", "background-image", "", "");
        CreateItem("background", "input", "background-position", "", "");
        CreateItem("background", "color", "background-color", "", "");
        CreateItem("background", "cdrop", "background-origin", "|border-box|padding-box|content-box", "");
        CreateItem("background", "cdrop", "background-repeat", "|repeat|no-repeat|repeat-x|repeat-y", "");
        CreateItem("background", "input", "background-size", "", "");

        CreateItem("border", "input", "border", "", "");
        CreateItem("border", "input", "border-top", "", "border-top");
        CreateItem("border", "num", "border-top-width", "", "border-top");
        CreateItem("border", "color", "border-top-color", "", "border-top");
        CreateItem("border", "drop", "border-top-style", "", "border-top");
        CreateItem("border", "input", "border-right", "", "border-right");
        CreateItem("border", "num", "border-right-width", "", "border-right");
        CreateItem("border", "color", "border-right-color", "", "border-right");
        CreateItem("border", "drop", "border-right-style", "", "border-right");
        CreateItem("border", "input", "border-bottom", "", "border-bottom");
        CreateItem("border", "num", "border-bottom-width", "", "border-bottom");
        CreateItem("border", "color", "border-bottom-color", "", "border-bottom");
        CreateItem("border", "drop", "border-bottom-style", "", "border-bottom");
        CreateItem("border", "input", "border-left", "", "border-left");
        CreateItem("border", "num", "border-left-width", "", "border-left");
        CreateItem("border", "color", "border-left-color", "", "border-left");
        CreateItem("border", "drop", "border-left-style", "", "border-left");
        CreateItem("border", "cdrop", "border-collapse", "|collapse|separate", "");
        CreateItem("border", "color", "border-color", "", "");
        CreateItem("border", "input", "border-image", "", "");
        CreateItem("border", "num", "border-width", "", "");
        CreateItem("border", "num", "border-top-right-radius", "", "");
        CreateItem("border", "num", "border-bottom-right-radius", "", "");
        CreateItem("border", "num", "border-top-left-radius", "", "");
        CreateItem("border", "num", "border-bottom-left-radius", "", "");
        CreateItem("border", "num", "border-shadow", "", "");
        CreateItem("border", "cdrop", "border-style", "|none|hidden|dotted|dashed|solid|double|groove|ridge|inset|outset", "");

        CreateItem("font", "input", "font", "", "");
        CreateItem("font", "cdrop", "font-family", " |Arial|Arial Black|Bookman Old Style|Comic Sans MS|Courier|Courier New|Gadget|Garamond|Georgia|Helvetica|Impact|Lucida Console|Lucida Sans Unicode|Lucida Grande|MS Sans Serif|MS Serif|Palatino Linotype|Symbol|Tahoma|Times New Roman|Trebuchet MS|Verdana|Webdings|Wingdings", "");
        CreateItem("font", "cdrop", "font-style", "|normal|italic|oblique|inherit", "");
        CreateItem("font", "num", "font-size", "", "");
        CreateItem("font", "num", "font-size-adjust", "", "");
        CreateItem("font", "cdrop", "font-stretch", "|normal|wider|narrower|ultra-condensed|extra-condensed|condensed|semi-condensed|semi-condensed|semi-expanded|expanded|extra-expanded-ultra-expanded", "");
        CreateItem("font", "num", "font-weight", "|bold|bolder|lighter|normal|100|200|300|400|500|+00|700|800|900", "");
        CreateItem("font", "cdrop", "font-varient", "|normal|small-caps", "");

        CreateItem("box-model", "cdrop", "clear", "|left|right|both|none", "");
        CreateItem("box-model", "cdrop", "display", "|none|inline|block|inline-block|list-item|run-in|compact|table|inline-table|table-row-group|table-header-group|table-footer-group|table-row|table-column-group|table-column|table-cell|table-caption|ruby|ruby-base|ruby-text|ruby-base-group|ruby-text-group", "");
        CreateItem("box-model", "cdrop", "float", "|left|right|none", "");
        CreateItem("box-model", "num", "height", "", "");
        CreateItem("box-model", "num", "max-height", "", "");
        CreateItem("box-model", "num", "max-width", "", "");
        CreateItem("box-model", "num", "min-height", "", "");
        CreateItem("box-model", "num", "min-width", "", "");
        CreateItem("box-model", "num", "width", "", "");
        CreateItem("box-model", "num", "height", "", "");
        CreateItem("box-model", "cdrop", "overflow-style", "|auto|marquee-line|marquee-block", "");
        CreateItem("box-model", "cdrop", "overflow-x", "|visible|hidden|scroll|auto|no-display|no-content", "");
        CreateItem("box-model", "cdrop", "overflow-y", "|visible|hidden|scroll|auto|no-display|no-content", "");
        CreateItem("box-model", "num", "rotation", "", "");
        CreateItem("box-model", "num", "rotation-point", "", "");
        CreateItem("box-model", "cdrop", "visibility", "|visible|hidden|collapse", "");

        CreateItem("margin", "input", "margin", "", "");
        CreateItem("margin", "num", "margin-top", "", "");
        CreateItem("margin", "num", "margin-left", "", "");
        CreateItem("margin", "num", "margin-right", "", "");
        CreateItem("margin", "num", "margin-bottom", "", "");

        CreateItem("padding", "input", "padding", "", "");
        CreateItem("padding", "num", "padding-top", "", "");
        CreateItem("padding", "num", "padding-left", "", "");
        CreateItem("padding", "num", "padding-right", "", "");
        CreateItem("padding", "num", "padding-bottom", "", "");

        CreateItem("marquee", "cdrop", "marquee-direction", "|forward|reverse", "");
        CreateItem("marquee", "num", "marquee-loop", "", "");
        CreateItem("marquee", "cdrop", "marquee-speed", "|slow|normal|fast", "");
        CreateItem("marquee", "cdrop", "marquee-style", "|scroll|slide|alternate", "");

        CreateItem("text", "input", "text", "", "");
        CreateItem("text", "cdrop", "direction", "|ltr|rtl", "");
        CreateItem("text", "cdrop", "hanging-punctuation", "|none|start|end|adjacent", "");
        CreateItem("text", "cdrop", "text-align", "|start|end|center|justify|left|right", "");
        CreateItem("text", "cdrop", "text-align-last", "|start|end|center|justify|left|right", "");
        CreateItem("text", "cdrop", "text-decoration", "|underline|overline|none|blink|line-through", "");
        CreateItem("text", "cdrop", "text-emphasis", "|none|ascent|dot|circle|disc|before|after", "");
        CreateItem("text", "num", "text-indent", "", "");
        CreateItem("text", "cdrop", "text-justify", "|auto|inter-word|inter-ideograph|inter-cluster|distribute|kashida|tibeatan", "");
        CreateItem("text", "num", "text-outline", "", "");
        CreateItem("text", "num", "text-shadow", "", "");
        CreateItem("text", "cdrop", "text-transform", "|capitalize|lowercase|none|uppercase", "");
        CreateItem("text", "cdrop", "text-wrap", "|normal|unrestricted|none|suppress", "");
        CreateItem("text", "cdrop", "unicode-bidi", "|normal|embed|bidi-override", "");
        CreateItem("text", "cdrop", "white-space", "|normal|[re|nowrap|pre-wrap|pre-line", "");
        CreateItem("text", "cdrop", "white-space-collaspse", "|preserve|collapse|preserve-breaks|discard", "");
        CreateItem("text", "cdrop", "word-break", "|normal|keep-all|loose|break-strict|break-all", "");
        CreateItem("text", "num", "word-spacing", "", "");
        CreateItem("text", "cdrop", "word-wrap", "|normal|break-word", "");

        CreateItem("column", "num", "column-count", "", "");
        CreateItem("column", "cdrop", "column-fill", "|auto|balance", "");
        CreateItem("column", "num", "column-gap", "", "");
        CreateItem("column", "color", "column-rule-color", "", "");
        CreateItem("column", "drop", "column-rule-style", "", "");
        CreateItem("column", "num", "column-rule-width", "", "");
        CreateItem("column", "num", "column-width", "", "");
        CreateItem("column", "num", "column-count", "", "");
        CreateItem("column", "num", "column-span", "", "");

        CreateItem("color", "color", "color", "", "");
        CreateItem("column", "num", "opcaity", "", "");

        CreateItem("flexible-box-layout", "cdrop", "box-align", "|start|end|center|base-line|stretch", "");
        CreateItem("flexible-box-layout", "cdrop", "box-direction", "|normal|reverse", "");
        CreateItem("flexible-box-layout", "num", "box-flex", "", "");
        CreateItem("flexible-box-layout", "num", "box-flex-group", "", "");
        CreateItem("flexible-box-layout", "cdrop", "box-lines", "|ingle|multiple", "");
        CreateItem("flexible-box-layout", "num", "box-ordinal-group", "", "");
        CreateItem("flexible-box-layout", "cdrop", "box-orient", "|horizontal|vertical|inline-axis|block-axis", "");
        CreateItem("flexible-box-layout", "cdrop", "box-pack", "|start|end|center|justify", "");
        CreateItem("flexible-box-layout", "cdrop", "box-sizing", "|content-box|padding-box|border-box|margin-box", "");
        CreateItem("flexible-box-layout", "cdrop", "tab-side", "|top|bottom|left|right", "");

        CreateItem("table", "cdrop", "border-collapse", "|collapse|seperate", "");
        CreateItem("table", "num", "border-spacing", "", "");
        CreateItem("table", "cdrop", "caption-side", "|top|bottom|left|right", "");
        CreateItem("table", "cdrop", "empty-cells", "|show|hide", "");
        CreateItem("table", "cdrop", "table-layout", "|auto|fixed", "");

        CreateItem("speech", "cdrop", "cue", "|cue-before|cue-after", "");
        CreateItem("speech", "num", "cue-before", "", "");
        CreateItem("speech", "num", "cue-after", "", "");
        CreateItem("speech", "input", "mark-before", "", "");
        CreateItem("speech", "input", "mark-after", "", "");
        CreateItem("speech", "input", "pause-before", "", "");
        CreateItem("speech", "input", "pause-after", "", "");
        CreateItem("speech", "input", "phonemes", "", "");
        CreateItem("speech", "input", "rest-before", "", "");
        CreateItem("speech", "input", "rest-after", "", "");
        CreateItem("speech", "cdrop", "speak", "|none|normal|spell-out|digits|literal-punctuation|no-punctuation", "");
        CreateItem("speech", "cdrop", "voice-balance", "|left|center|right|leftwards|rightwards", "");
        CreateItem("speech", "input", "voice-duration", "", "");
        CreateItem("speech", "input", "voice-family", "", "");
        CreateItem("speech", "input", "voice-rate", "", "");
        CreateItem("speech", "input", "voice-pitch", "", "");
        CreateItem("speech", "input", "voice-pitch-range", "", "");
        CreateItem("speech", "cdrop", "voice-stress", "|strong|moderate|none|reduced", "");
        CreateItem("speech", "input", "voice-volumne", "", "");

        CreateItem("list", "input", "list-style-image", "", "");
        CreateItem("list", "cdrop", "list-style-position", "inside|outside", "");
        CreateItem("list", "cdrop", "list-style-type", "|none|astericks|box|check|circle|diamond|disc|hyphen|square|decimal|decimal-leading-zero|lower-roman|upper-roman|lower-alpha|upper-alpha|lower-greek|lower-latin|upper-latin|hebrew|armenian|georgian|cjk-ideographic|hiragana|katakana|hiragana-iroha|katakana-iroha", "");
        CreateItem("list", "num", "list-offset", "", "");

        CreateItem("animation", "input", "animation-delay", "", "");
        CreateItem("animation", "cdrop", "animation-direction", "|normal|alternate", "");
        CreateItem("animation", "input", "animation-duration", "", "");
        CreateItem("animation", "input", "animation-iteration-count", "", "");
        CreateItem("animation", "input", "animation-name", "", "");
        CreateItem("animation", "cdrop", "animation-play-state", "|running|paused", "");
        CreateItem("animation", "input", "animation-timing-function", "", "");

        CreateItem("transition", "input", "transition-delay", "", "");
        CreateItem("transition", "input", "transition-duration", "", "");
        CreateItem("transition", "cdrop", "transition-property", "|none|all", "");
        CreateItem("transition", "input", "transition-timing-function", "", "");

        CreateItem("grid-positioning", "input", "grid-columns", "", "");
        CreateItem("grid-positioning", "input", "grid-row", "", "");

        CreateItem("outline", "color", "outline-color", "", "");
        CreateItem("outline", "num", "outline-offset", "", "");
        CreateItem("outline", "drop", "outline-style", "", "");
        CreateItem("outline", "num", "outline-width", "", "");

        CreateItem("2d-3d transform", "cdrop", "backface-visibility", "|visible|hidden", "");
        CreateItem("2d-3d transform", "num", "perspective", "", "");
        CreateItem("2d-3d transform", "input", "perspective-origin", "", "");
        CreateItem("2d-3d transform", "cdrop", "transform", "|none|matrix|matrix3d|translate3d|translatex|translatey|translatez|scale|scale3d|scalex|scaley|scalez|rotate|rotate3d|rotatex|rotatey|rotatez|skewx|skewy|skew|perspective", "");
        CreateItem("2d-3d transform", "input", "transform-origin", "", "");
        CreateItem("2d-3d transform", "cdrop", "transform-style", "|flat|preserve-3d", "");

        CreateItem("generated-content", "input", "bookmark-label", "", "");
        CreateItem("generated-content", "num", "bookmark-level", "", "");
        CreateItem("generated-content", "input", "bookmark-target", "", "");
        CreateItem("generated-content", "num", "border-length", "", "");
        CreateItem("generated-content", "input", "content", "", "");
        CreateItem("generated-content", "input", "content-increment", "", "");
        CreateItem("generated-content", "input", "content-reset", "", "");
        CreateItem("generated-content", "input", "crop", "", "");
        CreateItem("generated-content", "cdrop", "display", "|normal|none|list-item", "");
        CreateItem("generated-content", "num", "float-offset", "", "");
        CreateItem("generated-content", "num", "hyphenate-after", "", "");
        CreateItem("generated-content", "num", "hyphenate-before", "", "");
        CreateItem("generated-content", "input", "hyphenate-character", "", "");
        CreateItem("generated-content", "num", "hyphenate-lines", "", "");
        CreateItem("generated-content", "input", "hyphenate-resource", "", "");
        CreateItem("generated-content", "cdrop", "hyphens", "|none|manual|auto", "");
        CreateItem("generated-content", "input", "image-resolution", "", "");
        CreateItem("generated-content", "input", "marks", "", "");
        CreateItem("generated-content", "input", "move-to", "", "");
        CreateItem("generated-content", "cdrop", "page-policy", "|start|first|last", "");
        CreateItem("generated-content", "input", "quotes", "", "");
        CreateItem("generated-content", "input", "string-set", "", "");
        CreateItem("generated-content", "input", "text-replace", "", "");

        CreateItem("line-box", "cdrop", "alignment-adjust", "|auto|baseline|before-edge|text-before-edge|middle|central|after-edge|text-after-edge|ideographic|alphabetic|hanging|mathematical", "");
        CreateItem("line-box", "cdrop", "alignment-baseline", "|baseline|use-script|before-edge|text-before-edge|after-edge|text-before-edge|after-edge|text-after-edge|central|middle|ideographic|alphabetic|hanging|mathematical", "");
        CreateItem("line-box", "num", "baseline-shift", "", "");
        CreateItem("line-box", "cdrop", "dominant-baseline", "|baseline|use-script|before-edge|text-before-edge|after-edge|text-before-edge|after-edge|text-after-edge|central|middle|ideographic|alphabetic|hanging|mathematical", "");
        CreateItem("line-box", "cdrop", "drop-initial-after-align", "|baseline|use-script|before-edge|text-before-edge|after-edge|text-before-edge|after-edge|text-after-edge|central|middle|ideographic|alphabetic|hanging|mathematical", "");
        CreateItem("line-box", "input", "drop-initial-after-adjust", "", "");
        CreateItem("line-box", "cdrop", "drop-initial-before-align", "|baseline|use-script|before-edge|text-before-edge|after-edge|text-before-edge|after-edge|text-after-edge|central|middle|ideographic|alphabetic|hanging|mathematical", "");
        CreateItem("line-box", "input", "drop-initial-before-adjust", "", "");
        CreateItem("line-box", "num", "drop-initial-value", "", "");
        CreateItem("line-box", "num", "drop-initial-size", "", "");
        CreateItem("line-box", "num", "drop-initial-align", "", "");
        CreateItem("line-box", "num", "drop-initial-height", "", "");
        CreateItem("line-box", "cdrop", "line-stacking-strategy", "|inline-line-height|block-line-height|max-height|grid-height", "");
        CreateItem("line-box", "cdrop", "line-stacking-ruby", "|exclude-ruby|include-ruby", "");
        CreateItem("line-box", "cdrop", "line-stacking-shift", "|consider-shifts|disregard-shifts", "");
        CreateItem("line-box", "cdrop", "text-height", "|auto|font-size|text-size|max-size", "");
        CreateItem("line-box", "input", "vertical-align", "", "");

        CreateItem("hyperlink", "input", "target-name", "", "");
        CreateItem("hyperlink", "cdrop", "target-new", "|window|tab|none", "");
        CreateItem("hyperlink", "cdrop", "target-position", "|above|behind|front", "");

        CreateItem("positioning", "num", "bottom", "", "");
        CreateItem("positioning", "input", "clip", "", "");
        CreateItem("positioning", "num", "left", "", "");
        CreateItem("positioning", "cdrop", "position", "|static|relative|absolute|fixed", "");
        CreateItem("positioning", "num", "right", "", "");
        CreateItem("positioning", "num", "top", "", "");
        CreateItem("positioning", "num", "z-index", "", "");

        CreateItem("ruby", "cdrop", "ruby-align", "|auto|start|left|center|end|right|distribute-letter|distribute-space|line-edge", "");
        CreateItem("ruby", "cdrop", "ruby-overhang", "|auto|start|end|none", "");
        CreateItem("ruby", "cdrop", "ruby-position", "|before|after|right|inline", "");
        CreateItem("ruby", "input", "ruby-span", "", "");

        //RENDER THE ITEMS
        RenderGrid();
    }
}