declare default element namespace "http://www.w3.org/1999/xhtml";
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
    <?template name="head"?>
    <body>
        <div id="page_wrapper">
           <?template name="header"?>
           <?template name="subnavigation"?>    
           <div class="clear"></div>
            <div id="page-layout">
                <div id="page-content">
                    <div id="page-content-wrapper"> 
                    <?view?> 
                    </div>
                    <div class="clear"></div>
                </div>
            </div>
        </div>     
    </body>
</html>