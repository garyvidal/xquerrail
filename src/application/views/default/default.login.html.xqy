declare default element namespace "http://www.w3.org/1999/xhtml";
<div id="login-container">
<div id="tabs">
    <ul>
        <li><a href="#login-tab">Login</a></li>
        <li><a href="#recover-tab">Recover password</a></li>
    </ul>
    <div id="login-tab">
           <?if response:has-flash()?>
           <div class="response-msg error ui-corner-all">
               <span>Login Error <?flash-message name="login"?></span>
           </div>
           <?endif?>
        <form action="/default/login.html">
            <ul>
                <li>
                    <label for="username" class="desc">         
                        User Name:
                    </label>
                    <div>
                        <input type="text" tabindex="1" maxlength="255" value="" class="field text full" name="username" id="username" />
                    </div>
                </li>
                <li>
                    <label for="password" class="desc">
                        Password:
                    </label>
                    <div>
                        <input type="password" tabindex="1" maxlength="255" value="" class="field text full" name="password" id="password" />
                    </div>
                </li>
                <li class="buttons">
                    <div>
                        <button class="ui-state-default ui-corner-all float-right ui-button" type="submit">Login</button>
                    </div>
                </li>
            </ul>
        </form>
    </div>
    <div id="recover-tab">
        <form action="/default/index.html">
            <ul>
                <li>
                    <label for="email" class="desc">
                        Registered Email:
                    </label>
                    <div>
                        <input id="_email" type="text" tabindex="1" maxlength="255" value="" class="field text full" name="email"  />
                    </div>
                </li>
                <li class="buttons">
                    <div>
                        <button class="ui-state-default ui-corner-all float-right ui-button" type="submit">Send new password</button>
                    </div>
                </li>
            </ul>
        </form>
    </div>

</div>
<div class="clear"></div>
<script type="text/javascript" src="/resources/js/ui/ui.tabs.js"></script>
<script type="text/javascript">
    $(document).ready(function() {{
        // Tabs
        $('#tabs, #tabs2, #tabs5').tabs();
    }});
    </script>

</div>