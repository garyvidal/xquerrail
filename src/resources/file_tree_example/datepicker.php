<?php include('header.php'); ?>
<script type="text/javascript" src="js/ui/ui.datepicker.js"></script>
	<script type="text/javascript">
	$(function() {
		$('#datepicker').datepicker({
			changeMonth: true,
			changeYear: true,
			showButtonPanel: true
		});
	});

	$(function() {
		$('#datepicker2').datepicker({
			numberOfMonths: 3,
			changeYear: true
		});
	});
	</script>

		<div id="sub-nav"><div class="page-title">
			<h1>Datepicker</h1>
			<span><a href="#" title="Widgets">Widgets</a> > Datepicker</span>
		</div>
<?php include('top_buttons.php'); ?></div>
		<div id="page-layout"><div id="page-content">
			<div id="page-content-wrapper">
				<div class="inner-page-title">
					<h2>Example 1</h2>
					<span>Create datepickers.</span>
				</div>
				<p style="padding: 4px;" class="ui-state-default ui-corner-all ui-helper-clearfix">
					<span class="ui-icon float-left ui-icon-calendar"></span>
					Show month and year dropdowns in place of the static month/year header to facilitate navigation through large timeframes.
				</p>
				<br />
				<input type="text" id="datepicker" />

				<div class="clearfix"></div>
				<div class="inner-page-title">
					<h3>Example 2</h3>
				</div>
				<div class="content-box">
					<p style="padding: 4px;" class="ui-state-default ui-corner-all">
						<span class="ui-icon float-left ui-icon-calendar"></span>
						Example with multiple months with change year option
					</p>
					<br />
					<input type="text" id="datepicker2" />
					<div class="clearfix"></div>
				</div>
				<div class="clearfix"></div>
				<i class="note">* Example note ( class="note" ).</i>
			</div>
			<div class="clear"></div>
		</div>
</div><?php include('sidebar.php'); ?>
	</div>
<?php include('footer.php'); ?>
</body>
</html>