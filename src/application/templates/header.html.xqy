 declare default element namespace "http://www.w3.org/1999/xhtml";
<div id="page-header">
    <div id="page-header-wrapper">
        <div id="top">
            <a href="/" class="logo" title="Orchestra Framework">Orchestra Framework</a>
            <div class="welcome">
              <?if xdmp:get-current-user() = "validator-nobody" ?>  
              <span class="note">Please Login</span>
              <?else?>          
                <span class="note">Welcome, <a href="#" 
                 title="Welcome, {xdmp:get-current-user()}">{xdmp:get-current-user()}</a></span>
                <a class="btn ui-state-default ui-corner-all" href="#">
                    <span class="ui-icon ui-icon-wrench"></span>
                    Settings
                </a>
                <a class="btn ui-state-default ui-corner-all" href="/my-account.html">
                    <span class="ui-icon ui-icon-person"></span>
                    My account
                </a>
                <a class="btn ui-state-default ui-corner-all" href="/logout.html">
                    <span class="ui-icon ui-icon-power"></span>
                    Logout
                </a>                        
                <?endif?>
            </div>
        </div>
        <?if xdmp:get-current-user() = "validator-nobody"?>
        <?else?>
        <?template name="toolbar"?>
        <div id="search-bar">
            <form method="post" action="http://www.google.com/">
                <input type="text" name="q" value="live search demo" />
            </form>
        </div>
        <?endif?>
    </div>
    
</div>