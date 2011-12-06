xquery version "1.0-ml";

module namespace display = "http://marklogic.com/ps/setup/lib-display";

declare default element namespace "http://www.w3.org/1999/xhtml";


declare function display:template($title, $main-content, $left-content)
{
	<html xmlns="http://www.w3.org/1999/xhtml">
		<head>
      <title>Cluster Configurator -- {$title}</title>
			<link rel="stylesheet" type="text/css" media="screen" href="css/style.css" />
		</head>
		<body>

		<div id="header">
			<!-- <p>Text above heading</p> -->
      <h1>Cluster Configurator</h1>
			<h2>{$title}</h2>
			<p></p>
			<!-- <p id="layoutdims">Right aligned bar</p>-->
		</div>
		<div class="colmask leftmenu">
			<div class="colleft">
				<div class="col1">
					<!-- Column 1 start -->
					{
						$main-content
					}
					<!-- Column 1 end -->
				</div>
				<div class="col2">
					<!-- Column 2 start -->
					{
						$left-content
					}
					<!-- Column 2 end -->
				</div>
			</div>
		</div>
		<div id="footer">
			<p>&copy; Copyright 2010 Mark Logic Corporation.  All rights reserved.</p>
		</div>
		</body>
	</html>
};

declare function display:tab-bar($labels, $links, $index)
{
	(
	<span id="buttonbar">
		<ul>
		{
			for $label at $i in $labels
			return
				<li>
				{
						element a
						{
							if ($i = $index) then
								attribute class {"active"}
							else
								(),
							attribute href {$links[$i]},
							$label
						}
				}
				</li>
		}
		</ul>
	</span>,
	<p><br/>&nbsp;<br/></p>
	)
};

declare function dropdown($name, $options, $selected, $disabled)
{
	element select
	{
		attribute id {$name},
		attribute name {$name},
		
		if ($disabled) then
			attribute disabled {"disabled"}
		else
			()
		,
		
		for $option in $options
		return
		element option
		{
			attribute value {$option},
			if ($selected eq $option) then
				attribute selected {"selected"} 
			else 
				(),
			$option
		}
	}
};

declare function radio($name, $value, $selected)
{
	element input
	{
		attribute type {"radio"},
		attribute name {$name},
		attribute value {$value},
		
		if ($value eq $selected) then
			attribute checked {"checked"}
		else
			()
	}
};

declare function vertical-spacer($n)
{
	<p>
	{
		for $i in (1 to $n)
		return ("&nbsp;", <br />)
	}
	</p>
};


declare function left-links()
{
<div>
&nbsp;<br/>
&nbsp;<br/>
&nbsp;<br/>
<p><a href="export.xqy">Export</a></p>
<p><a href="import.xqy">Import</a></p>
</div>
};








