<?php include('header.php'); ?>
<script type="text/javascript" src="js/charts.js"></script>
		<script type="text/javascript">
			$(function(){
				//make some charts
				$('table').visualize({type: 'pie', pieMargin: 10, title: '2009 Total Sales by Individual'});	
				$('table').visualize({type: 'line'});
				$('table').visualize({type: 'area'});
				$('table').visualize();
			});
		</script>
<link href="css/charts.css" rel="stylesheet" media="all" />

		<div id="sub-nav"><div class="page-title">
			<h1>Charts</h1>
			<span>You can edit the table values by clicking each cell. You will see the chars update immediately !</span>
		</div>
<?php include('top_buttons.php'); ?></div>
		<div id="page-layout"><div id="page-content">
			<div id="page-content-wrapper">
				<div class="inner-page-title">
					<h2>Charts</h2>
					<span>Create charts from tables on the fly.</span>
				</div>
				<div class="content-box">
					<table>
						<caption>2009 Individual Sales by Category</caption>
						<thead>
							<tr>
								<td></td>
								<th>food</th>
								<th>auto</th>
								<th>household</th>
			
								<th>furniture</th>
								<th>kitchen</th>
								<th>bath</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<th>Mary</th>
								<td>150</td>
								<td>160</td>
								<td>40</td>
								<td>120</td>
								<td>30</td>
								<td>70</td>
							</tr>
							<tr>
								<th>Tom</th>
								<td>3</td>
								<td>40</td>
								<td>30</td>
			
								<td>45</td>
								<td>35</td>
								<td>49</td>
							</tr>
							<tr>
								<th>Brad</th>
								<td>10</td>
			
								<td>180</td>
								<td>10</td>
								<td>85</td>
								<td>25</td>
								<td>79</td>
							</tr>
			
							<tr>
								<th>Kate</th>
								<td>40</td>
								<td>80</td>
								<td>90</td>
								<td>25</td>
			
								<td>15</td>
								<td>119</td>
							</tr>		
						</tbody>
					</table>
				</div>
				<div id="charts">
				</div>
				<div class="clearfix"></div>
			</div>
			<div class="clear"></div>
		</div>
</div><?php include('sidebar.php'); ?>
	</div>
<?php include('footer.php'); ?>
</body>
</html>