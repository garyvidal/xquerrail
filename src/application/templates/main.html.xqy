declare default element namespace "http://www.w3.org/1999/xhtml";
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
   <?template name="head"?>
    <body>
        <div id="page_wrapper">
           <?template name="header"?>
           <div class="clear"></div>
           <div id="page-layout">
                <div id="page-content">
                    <div id="page-content-wrapper" class="no-bg-image wrapper-full"> 
                        <?view?>
                        <div class="clear"></div>
                    </div>          
                    <div class="clear"></div>
                </div>
            </div>          
        </div> 
        <div class="clear"></div>
        <?template name="footer"?> 
        <div id="popup">

        </div>
    </body>
</html>