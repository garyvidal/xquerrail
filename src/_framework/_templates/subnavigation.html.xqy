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
<div id="sub-nav">
    <div class="page-title">
        <h1><?title?></h1>
        <?breadcrumb?>
    </div>
    <div id="top-buttons">
        <a id="modal_confirmation_link" class="btn ui-state-default ui-corner-all" href="#">
            <span class="ui-icon ui-icon-grip-dotted-horizontal"></span>
            Modal window
        </a>
        <ul class="drop-down">
            <li>
                <a class="btn ui-state-default ui-corner-all" href="javascript:void(0);">
                    <span class="ui-icon ui-icon-carat-2-n-s"></span>
                    Change Theme
                </a>
                <ul id="style-switcher" class="drop-down-container box ui-widget ui-widget-content .ui-corner-tl .ui-corner-tr">
                    <li>
                        <a id="black_rose" href="#" class="btn ui-state-default full-link ui-corner-all set_theme" title="Black Rose Theme">
                            <span class="ui-icon ui-icon-zoomin"></span>
                            Black Rose Theme
                        </a>
                    </li>
                    <li>
                        <a id="gray_standard" href="#" class="btn ui-state-default full-link ui-corner-all set_theme" title="Gray Standard Theme">
                            <span class="ui-icon ui-icon-zoomin"></span>
                            Gray Standard Theme
                        </a>
                    </li>
                    <li>
                        <a id="gray_lightness" href="#" class="btn ui-state-default full-link ui-corner-all set_theme" title="Gray Lightness Theme">
                            <span class="ui-icon ui-icon-zoomin"></span>
                            Gray Lightness Theme
                        </a>
                    </li>
                    <li>
                        <a id="apple_pie" href="#" class="btn ui-state-default full-link ui-corner-all set_theme" title="Apple Pie Theme">
                            <span class="ui-icon ui-icon-zoomin"></span>
                            Apple Pie Theme
                        </a>
                    </li>
                    <li>
                        <a id="blueberry" href="#" class="btn ui-state-default full-link ui-corner-all set_theme" title="Blueberry Theme">
                            <span class="ui-icon ui-icon-zoomin"></span>
                            Blueberry Theme
                        </a>
                    </li>                   
                </ul>
            </li>
        </ul>   
    </div>
    <div id="dialog" title="Dialog Title">
        <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>
    </div>
    <div id="modal_confirmation" title="An example modal title ?">
        <p><span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span>Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>
    </div>
</div>