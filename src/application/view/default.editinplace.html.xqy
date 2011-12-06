declare default element namespace "http://www.w3.org/1999/xhtml";
<div>
    <div class="inner-page-title">
        <h2>Example 1</h2>
        <span>The most basic example with the zero configuration, with a table converted into flexigrid</span>
    </div>
    <div class="inner-page-title">
        <h3>Normal textarea</h3>
    </div>
    <p class="editable_textarea" id="paragraph_1">R &amp;D</p>
        
        <h2>Inlined select</h2>
        <p><b class="editable_select" id="select_1" style="display: inline"> Edit me!</b> dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh <b class="editable_select_json" id="select_2" style="display: inline"> E</b> euismod tincidunt ut laoreet dolore magna aliquam erat volutp</p>    
        
        <div class="inner-page-title">
            <h3>Big textarea</h3>
        </div>
        
        <div class="editable_textile" id="paragraph_2">	<p>Lorem ipsum dolooooooor sit amet, consectetuer adipiscing <em>elit, sed diam nonummy nibh</em> euismod <strong>tincidunt</strong> ut laoreet dolore magna <strong>aliquam</strong> erat volutpat.</p>
            
            <p>	<ul>
                
                <li>Foo</li>
                <li>jllkjlkjfgfd gfgf gf</li>
                <li>Bar</li>
                <li>Foo bar</li>
                <li>ttt</li>
            </ul>
                
                <ul>
                    <li>	<ul>
                        <li>dfdfsdfs</li>
                    </ul></li>
                </ul><br />
                uis autem vel eum in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto.</p></div>
        
        <div class="inner-page-title">
            <h3>Different events</h3>
        </div>
        
        
        <p>
            <b class="click" style="display: inline">Click me if you dare!</b> or maybe you should 
            <b class="dblclick" style="display: inline">doubleclick</b> instead? Really lazy people can just
            <b class="mouseover" style="display: inline">mouseover me</b>...
        </p>
        
        
        
        <div class="clearfix"></div>
        <?template name='sidebar' ?>
        <script type="text/javascript" src="/web/js/jeditable.js"></script>
        <script type="text/javascript" charset="utf-8"><![CDATA[
        
        $(function() {
                
          $(".editable_select").editable("save", { 
            indicator : '<img src="img/indicator.gif">',
            data   : "{'Lorem ipsum':'Lorem ipsum','Ipsum dolor':'Ipsum dolor','Dolor sit':'Dolor sit'}",
            type   : "select",
            submit : "OK",
            style  : "inherit",
            submitdata : function() {
              return {id : 2};
            }
          });
          $(".editable_select_json").editable("save", { 
            indicator : '<img src="img/indicator.gif">',
            loadurl : "http://www.appelsiini.net/projects/jeditable/php/json",
            type   : "select",
            submit : "OK",
            style  : "inherit"
          });
          $(".editable_textarea").editable("save", { 
              indicator : "<img src='img/indicator.gif'>",
              type   : 'textarea',
              submitdata: { _method: "put" },
              select : true,
              submit : 'OK',
              cancel : 'cancel',
              cssclass : "editable"
          });
          $(".editable_textile").editable("save?renderer=textile", { 
              indicator : "<img src='img/indicator.gif'>",
              loadurl   : "http://www.appelsiini.net/projects/jeditable/php/load",
              type      : "textarea",
              submit    : "OK",
              cancel    : "Cancel",
              tooltip   : "Click to edit..."
          });
          
          $(".click").editable("echo", { 
              indicator : "<img src='img/indicator.gif'>",
              tooltip   : "Click to edit...",
              style  : "inherit"
          });
          $(".dblclick").editable("echo", { 
              indicator : "<img src='img/indicator.gif'>",
              tooltip   : "Doubleclick to edit...",
              event     : "dblclick",
              style  : "inherit"
          });
          $(".mouseover").editable("echo", { 
              indicator : "<img src='img/indicator.gif'>",
              tooltip   : "Move mouseover to edit...",
              event     : "mouseover",
              style  : "inherit"
          });
          
          /* Should not cause error. */
          $("#nosuch").editable("echo", { 
              indicator : "<img src='img/indicator.gif'>",
              type   : 'textarea',
              submit : 'OK'
          });
        
        });
        ]]>
        </script>
</div>

