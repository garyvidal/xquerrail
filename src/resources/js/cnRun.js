/*****************************************/
/*  Conde Nast DAM JavaScript Include 	 */
/*	This JS file is used to enable all 	 */
/*  functions for nav and UI enrichment  */
/*****************************************/

// Execute functions afte rthe page has succesfully loaded
jQuery(document).ready(function() {

	// Enable the DropDown Menus for the navigation
	jQuery('#navigation').superfish();

	// Enable the toggle feature 
	jQuery('.toggle').live('click',function() {
		jQuery(this).parent().toggle('slide',{ direction: "up" });
	});
	
	// Enable Calendar 
	jQuery('.date').live('focus',function () {
		jQuery(this).datepicker();
	});

    
	// Enable panels
	jQuery(".panel h3").live('click',function(){
	   var parent = jQuery(this).parent();
	   parent.children(".panelContent").toggle('slow');
	});
	
});

