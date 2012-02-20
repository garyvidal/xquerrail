declare default element namespace "http://www.w3.org/1999/xhtml";
<div id="page-content-wrapper">
    <div class="inner-page-title">
        <h3>Example Title</h3>
    </div>
    <div class="content-box">
        If you would like to remove all rounded corners from a page, just add class="no-rounded" to the body tag. That is all !
        <p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa.</p>
        
        <p> Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem.</p>
        
        <p> Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo.</p>
        
        <p> Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, </p>
        <div id="dialog" title="Empty the recycle bin?">
            <p><span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span>These items will be permanently deleted and cannot be recovered. Are you sure?</p>
        </div>
        
        <!-- Sample page content to illustrate the layering of the dialog -->
        <div class="hiddenInViewSource" style="padding:20px;">
            <p>Sed vel diam id libero <a href="http://example.com">rutrum convallis</a>. Donec aliquet leo vel magna. Phasellus rhoncus faucibus ante. Etiam bibendum, enim faucibus aliquet rhoncus, arcu felis ultricies neque, sit amet auctor elit eros a lectus.</p>
            <form>
                
                <input value="text input" /><br />
                <input type="checkbox" />checkbox<br />
                <input type="radio" />radio<br />
                <select>
                    <option>select</option>
                </select><br /><br />
                <textarea>textarea</textarea><br />
                
            </form>
        </div><!-- End sample page content -->
        
    </div>
    <div class="clear"></div>
    <?template name="sidebar" ?>
    <script type="text/javascript"><![CDATA[
	$(function() {
		$("#dialog").dialog({
			bgiframe: true,
			resizable: false,
			height:120,
			width:650,
			modal: true,
			overlay: {
				backgroundColor: '#000',
				opacity: 0.5
			},
			buttons: {
				'Delete all items in recycle bin': function() {
					$(this).dialog('close');
				},
				Cancel: function() {
					$(this).dialog('close');
				}
			}
		});
	});]]>
</script>
</div>/*

