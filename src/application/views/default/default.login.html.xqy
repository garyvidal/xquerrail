declare default element namespace "http://www.w3.org/1999/xhtml";
<template>
<div id="tabs">
    <ul>
        <li><a href="#login">Login</a></li>
        <li><a href="#tabs-2">Register</a></li>
        <li><a href="#tabs-3">Recover password</a></li>
    </ul>
    <div id="login">
           <?if fn:exists(response:flash()) and response:flash() ne ""?>
           <div class="response-msg error ui-corner-all">
               <span>Login Error</span>
               <?flash-message?>
           </div>
           <?endif?>
        <form action="default/login">
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
    <div id="tabs-2">
      <!--
        <div class="other-box gray-box ui-corner-all">
            <div class="cont ui-corner-all tooltip" title="Example tooltip!">
                <h3>Example information message</h3>
                <p>Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium.</p>
            </div>
        </div>
        -->
        <p>You can put a register form here.</p>
    </div>
    <div id="tabs-3">
        <form action="dashboard.html">
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

</template>/*