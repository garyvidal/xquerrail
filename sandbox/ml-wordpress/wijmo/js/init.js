jQuery(function($) {

	//Wijmo Menu
	$("#wijmomenu").wijmenu();

	$("#wijmofootermenu").wijmenu({
		orientation: 'vertical'
	});

	var menuitem = $("#home");
	$("#wijmomenu").wijmenu("activate", null, menuitem);

	//$(".current_page_item a, .current_page_item").addClass('ui-state-active');

	//Wijmo TextBox 
	$(":input[type='text'],:input[type='password'],:input[type='textarea']").wijtextbox();

	//jQuery UI Button 
	$(":input[type='submit'], :input[type='button'], #wijlogin, #wijlogout, .button").button();

	//Wijmo Tooltip
	$("#content [title]").wijtooltip();

	//Wijmo Accordion
	$("#wijmoaccordion").wijaccordion({
		header: "h3"
	});

	//Wijmo Expander

	$(".single-post #comments-wrapper").wijexpander({
		expanded: true,
		header: ".comments-title"
	});


	$(".single-post #respond").wijexpander({
		expanded: false,
		header: "#reply-title"
	});



	//Wijmo Dialog
	$('#wijmodialog').wijdialog({
		autoOpen: false,
		modal: true,
		height: 275,
		width: 300,
		captionButtons: {
			pin: {
				visible: false
			},
			refresh: {
				visible: false
			},
			toggle: {
				visible: false
			},
			minimize: {
				visible: false
			},
			maximize: {
				visible: false
			}
		}
	});


	//Wijmo Superpanel
//	var len = 0;
//	$("#wijmosuperpanel").find("img").each(function(index, el) {
//		len += $(this).width();
//	}).parent().width(len).parent().wijsuperpanel({
//		allowResize: false,
//		hScroller: {
//			scrollMode: 'buttons'
//		},
//		vScroller: {
//			scrollBarVisibility: 'hidden'
//		}
//	});


	//Wijmo Superpaner
	$("#wijmosuperpanel").wijsuperpanel({
		allowResize: false,
		hScroller: {
			scrollMode: 'buttons'
		},
		vScroller: {
			scrollBarVisibility: 'hidden'
		}
	});

	//Wijmo Checkbox
	$(":input[type='checkbox']").wijcheckbox();

	//Wijmo Dropdown
	$("select").wijdropdown();

	//Wijmo Radio
	$(":input[type='radio']").wijradio();

	//Wijmo Calendar
	$('#wijmocalendar').wijcalendar();


	$('.byuser').addClass('ui-state-highlight ui-corner-all');
	
	//$('#switcher').themeswitcher();


	$('#switcher-trigger').click(function(){
		$('#switcher').toggle('fast');
		$('#switcher-trigger .ui-icon').toggleClass('ui-icon-arrowthickstop-1-w').toggleClass('ui-icon-arrowthickstop-1-e');						  
	});
	

});