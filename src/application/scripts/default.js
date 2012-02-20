

	$(function() {
		$("#slider-range").slider({
			range: true,
			min: 0,
			max: 500,
			values: [75, 300],
			slide: function(event, ui) {
				$("#amount").val('$' + ui.values[0] + ' - $' + ui.values[1]);
			}
		});
		$("#amount").val('$' + $("#slider-range").slider("values", 0) + ' - $' + $("#slider-range").slider("values", 1));
	});
	function hexFromRGB (r, g, b) {
		var hex = [
			r.toString(16),
			g.toString(16),
			b.toString(16)
		];
		$.each(hex, function (nr, val) {
			if (val.length == 1) {
				hex[nr] = '0' + val;
			}
		});
		return hex.join('').toUpperCase();
	}
	function refreshSwatch() {
		var red = $("#red").slider("value")
			,green = $("#green").slider("value")
			,blue = $("#blue").slider("value")
			,hex = hexFromRGB(red, green, blue);
		$("#swatch").css("background-color", "#" + hex);
	}
	$(function() {
		$("#red, #green, #blue").slider({
			orientation: 'horizontal',
			range: "min",
			max: 255,
			value: 127,
			slide: refreshSwatch,
			change: refreshSwatch
		});
		$("#red").slider("value", 255);
		$("#green").slider("value", 140);
		$("#blue").slider("value", 60);
	});
	$(function() {
		// change defaults for range, animate and orientation
		$.extend($.ui.slider.defaults, {
			range: "min",
			animate: true,
			orientation: "vertical"
		});
		// setup master volume
		$("#master").slider({
			value: 60,
			orientation: "horizontal"
		});
		// setup Example
		$("#eq > span").each(function() {
			// read initial values from markup and remove that
			var value = parseInt($(this).text());
			$(this).empty();
			$(this).slider({
				value: value
			})
		});
	});