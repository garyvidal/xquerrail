declare default element namespace "http://www.w3.org/1999/xhtml";
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
    <head>
       <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <?include-metas?>
        <title><?title?></title>
        
        <!--jQuery References-->
        <script src="/resources/js/jquery-1.7.1.min.js" type="text/javascript"></script>
        <script src="/resources/js/jquery-ui-1.8.17.custom.min.js" type="text/javascript"></script>
         
        <!--Theme-->
        <link href="/resources/wijmo/themes/sterling/jquery-wijmo.css" rel="stylesheet" type="text/css" title="rocket-jqueryui" />
         
        <!--Wijmo Widgets CSS-->
        <link href="/resources/wijmo/css/jquery.wijmo-complete.all.2.0.0.min.css" rel="stylesheet" type="text/css" />

        <!--Wijmo Widgets JavaScript-->
        <script src="/resources/wijmo/js/jquery.wijmo-open.all.2.0.0.min.js" type="text/javascript"></script>
        <script src="/resources/wijmo/js/jquery.wijmo-complete.all.2.0.0.min.js" type="text/javascript"></script>
        <?controller-script?>
    
       <!--[if IE 6]>
            <link href="/resources/css/ie6.css" rel="stylesheet" media="all" />    
            <script src="/resources/js/pngfix.js"></script>
            <script>
            /* Fix IE6 Transparent PNG */
              DD_belatedPNG.fix('.logo, ul#dashboard-buttons li a, .response-msg, #search-bar input');
            </script>
        <![endif]-->
        <?controller-stylesheet?>    
    </head>
    <body>
        <div id="page_wrapper">
           <div class="clear"></div>
           <div id="page-layout">
                <div id="page-content">
                    <div id="page-content-wrapper" class="no-bg-image wrapper-full">
                        <h1><?title?></h1>                    
                        <?view?>
                        <div class="clear"></div>
                    </div>          
                    <div class="clear"></div>
                </div>
            </div>          
        </div> 
        <div class="clear"></div>    
    </body>
</html>
