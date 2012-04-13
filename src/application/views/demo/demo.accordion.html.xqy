declare default element namespace "http://www.w3.org/1999/xhtml";
<div>
    <script type="text/javascript" src="/resources/js/ui/ui.accordion.js"></script>
    <link href="/resources/css/ui/ui.accordion.css" rel="stylesheet" media="all" />
    <div class="inner-page-title">
        <h2>Example 1</h2>
        <span>Opens on mouseover</span>
    </div>
    <div class="content-box">
        <div id="accordion">
            <h3><a href="#">Section 1</a></h3>
            <div>
                <p>Mauris mauris ante, blandit et, ultrices a, suscipit eget, quam. Integer ut neque. Vivamus nisi metus, molestie vel, gravida in, condimentum sit amet, nunc. Nam a nibh. Donec suscipit eros. Nam mi. Proin viverra leo ut odio. Curabitur malesuada. Vestibulum a velit eu ante scelerisque vulputate.</p>
                
            </div>
            <h3><a href="#">Section 2</a></h3>
            <div>
                <p>Sed non urna. Donec et ante. Phasellus eu ligula. Vestibulum sit amet purus. Vivamus hendrerit, dolor at aliquet laoreet, mauris turpis porttitor velit, faucibus interdum tellus libero ac justo. Vivamus non quam. In suscipit faucibus urna. </p>
            </div>
            <h3><a href="#">Section 3</a></h3>
            <div>
                
                <p>Nam enim risus, molestie et, porta ac, aliquam ac, risus. Quisque lobortis. Phasellus pellentesque purus in massa. Aenean in pede. Phasellus ac libero ac tellus pellentesque semper. Sed ac felis. Sed commodo, magna quis lacinia ornare, quam ante aliquam nisi, eu iaculis leo purus venenatis dui. </p>
                <ul>
                    <li>List item one</li>
                    <li>List item two</li>
                    <li>List item three</li>
                </ul>
            </div>
            
            <h3><a href="#">Section 4</a></h3>
            <div>
                <p>Cras dictum. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Aenean lacinia mauris vel est. </p><p>Suspendisse eu nisl. Nullam ut libero. Integer dignissim consequat lectus. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. </p>
            </div>
        </div>
    </div>
    <div class="clearfix"></div>
    <br /><br />
    <div class="inner-page-title">
        <h2>Accordion inserted into boxes</h2>
        <span>Below you will find an accordion example. Lorem ipsum dolor sic amet.</span>
    </div>
    <div class="two-column">
        <div class="column-fixed">
            <div class="portlet ui-widget ui-widget-content ui-helper-clearfix ui-corner-all form-container">
                <div class="portlet-header ui-widget-header">Examples, examples, examples ...<span class="ui-icon ui-icon-circle-arrow-s"></span></div>
                <div class="portlet-content">
                    <div id="accordion2">
                        <div>
                            <h3><a href="#">Forth</a></h3>
                            <div>Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet.</div>
                        </div>
                        <div>
                            <h3><a href="#">Dummy</a></h3>
                            <div>Phasellus mattis tincidunt nibh.</div>
                        </div>
                        <div>
                            <h3><a href="#">Dummy again</a></h3>
                            <div>Nam dui erat, auctor a, dignissim quis.</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="column-fixed">
            <div class="portlet ui-widget ui-widget-content ui-helper-clearfix ui-corner-all form-container">
                <div class="portlet-header ui-widget-header">Icons for buttons<span class="ui-icon ui-icon-circle-arrow-s"></span></div>
                <div class="portlet-content">
                    <ul id="icons" class="ui-widget ui-helper-clearfix">
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-carat-1-se"><span class="ui-icon ui-icon-carat-1-se"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-carat-1-s"><span class="ui-icon ui-icon-carat-1-s"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-carat-1-sw"><span class="ui-icon ui-icon-carat-1-sw"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-carat-1-w"><span class="ui-icon ui-icon-carat-1-w"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-carat-1-nw"><span class="ui-icon ui-icon-carat-1-nw"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-carat-2-n-s"><span class="ui-icon ui-icon-carat-2-n-s"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-carat-2-e-w"><span class="ui-icon ui-icon-carat-2-e-w"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-triangle-1-n"><span class="ui-icon ui-icon-triangle-1-n"></span></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
    <div class="clearfix"></div>
    <i class="note">* To see more boxes examples, like the ones above, visit for the menu, the Layout Options pages.</i>    
    <script type="text/javascript">
    $(document).ready(function() {{
    	$("#accordion").accordion({{}});
    	$("#accordion2").accordion({{}});
    }});
</script>
    <?template name='sidebar' ?>
</div>/*
