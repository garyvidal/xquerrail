 declare default element namespace "http://www.w3.org/1999/xhtml"; 
 <head>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <?include-metas?>
        <title><?title?></title>
        
        <link href="/resources/css/ui/ui.base.css" rel="stylesheet" media="all" />

        <link href="/resources/css/themes/black_rose/ui.css" rel="stylesheet" title="style" media="all" />
        <?if response:user() = config:anonymous-user(response:application())?>
        <link href="/resources/css/ui/ui.login.css" rel="stylesheet" title="style" media="all" />   
        <?endif?>
        <link href="/resources/css/ui/ui.jqgrid.css" rel="stylesheet" title="style" media="all"/>
        <link href="/resources/css/ui/ui.layout.css" rel="stylesheet" title="style" media="all"/>
        <?controller-stylesheet?>
        <script type="text/javascript" src="/resources/js/jquery-1.4.2.js"></script>
        <script type="text/javascript" src="/resources/js/ui/ui.core.js"></script>
        <script type="text/javascript" src="/resources/js/ui/ui.widget.js"></script>
        <script type="text/javascript" src="/resources/js/ui/ui.mouse.js"></script>
        <script type="text/javascript" src="/resources/js/ui/ui.layout.js"></script>
        <script type="text/javascript" src="/resources/js/ui/ui.sortable.js"></script>
        <script type="text/javascript" src="/resources/js/ui/ui.draggable.js"></script>
        <script type="text/javascript" src="/resources/js/ui/ui.resizable.js"></script>
        <script type="text/javascript" src="/resources/js/ui/ui.position.js"></script>
        <script type="text/javascript" src="/resources/js/ui/ui.button.js"></script>
        <script type="text/javascript" src="/resources/js/ui/ui.dialog.js"></script>
        <script type="text/javascript" src="/resources/js/ui/ui.multiselect.js"></script>
        
        <script type="text/javascript" src="/resources/js/superfish.js"></script>
        <script type="text/javascript" src="/resources/js/live_search.js"></script>
        <script type="text/javascript" src="/resources/js/tooltip.js"></script>
        <script type="text/javascript" src="/resources/js/cookie.js"></script>
        
        <script type="text/javascript" src="/resources/js/codemirror/theme/xquery/xquery.js">//</script>
        <script type="text/javascript" src="/resources/js/codemirror.js"></script>
        
        <script type="text/javascript" src="/resources/js/i18n/grid.locale-en.js">//</script>
        <script type="text/javascript" src="/resources/js/jquery.jqgrid.min.js">//</script>
        
        <script type="text/javascript" src="/resources/js/_framework.js">//</script>
        <script type="text/javascript" src="/resources/js/custom.js">//</script>
        
        <?controller-script?>
        <link href="/resources/css/ui/ui.accordion.css" rel="stylesheet" media="all" />        
        <!--[if IE 6]>
            <link href="/resources/css/ie6.css" rel="stylesheet" media="all" />    
            <script src="/resources/js/pngfix.js"></script>
            <script>
            /* Fix IE6 Transparent PNG */
              DD_belatedPNG.fix('.logo, ul#dashboard-buttons li a, .response-msg, #search-bar input');
            </script>
        <![endif]-->
    </head>
