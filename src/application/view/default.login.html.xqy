(:
 : Copyright 2011 - Gary Vidal
 :
 : Licensed     under the Apache License, Version 2.0 (the "License");
 : you may not use this file except in compliance with the License.
 : You may obtain a copy of the License at
 :
 :    http://www.apache.org/licenses/LICENSE-2.0
 :
 : Unless required by applicable law or agreed to in writing, software
 : distributed under the License is distributed on an "AS IS" BASIS,
 : WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 : See the License for the specific language governing permissions and
 : limitations under the License.
 :)



declare default element namespace "http://www.w3.org/1999/xhtml";
<template>

 
<div id="tabs">
    <ul>
        <li><a href="#login">Login</a></li>
        <li><a href="#tabs-2">Register</a></li>
        <li><a href="#tabs-3">Recover password</a></li>
    </ul>
    <div id="login">
        <?slot slot="login_success" ?>
        <div class="response-msg success ui-corner-all">
            <span>Success message</span>
            Lorem ipsum dolor sit amet, consectetuer adipiscing elit
        </div>
        <?endslot?>
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
                        <input type="text" tabindex="1" maxlength="255" value="" class="field text full" name="password" id="password" />
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
<script type="text/javascript" src="/web/js/ui/ui.tabs.js"></script>
<script type="text/javascript">
    $(document).ready(function() {{
        // Tabs
        $('#tabs, #tabs2, #tabs5').tabs();
    }});
    </script>

</template>/*