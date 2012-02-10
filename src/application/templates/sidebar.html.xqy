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
    <div id="sidebar">
        <div class="sidebar-content">
            <a id="close_sidebar" class="btn ui-state-default full-link ui-corner-all" href="#drill">
                <span class="ui-icon ui-icon-circle-arrow-e"></span>
                Close Sidebar
            </a>
            <a id="open_sidebar" class="btn tooltip ui-state-default full-link icon-only ui-corner-all" title="Open Sidebar" href="#"><span class="ui-icon ui-icon-circle-arrow-w"></span></a>
            <div class="hide_sidebar">
                <div class="portlet ui-widget ui-widget-content ui-helper-clearfix ui-corner-all">
                    <div class="portlet-header ui-widget-header">Theme Switcher<span class="ui-icon ui-icon-circle-arrow-s"></span></div>
                    <div class="portlet-content">
                        <ul id="style-switcher" class="side-menu">
                            <li>
                                <a class="set_theme" id="black_rose" href="#" title="Black Rose Theme">Black Rose Theme</a>
                            </li>
                            <li>
                                <a class="set_theme" id="gray_standard" href="#" title="Gray Standard Theme">Gray Standard Theme</a>
                            </li>
                            <li>
                                <a class="set_theme" id="gray_lightness" href="#" title="Gray Lightness Theme">Gray Lightness Theme</a>
                            </li>
                            <li>
                                <a class="set_theme" id="apple_pie" href="#" title="Apple Pie Theme">Apple Pie Theme</a>
                            </li>
                            <li>
                                <a class="set_theme" id="blueberry" href="#" title="Blueberry Theme">Blueberry Theme</a>
                            </li>
                        </ul>
                    </div>
                </div>
                <!--
                <a class="fg-button btn ui-state-default full-link ui-corner-all" href="#">
                    <span class="ui-icon ui-state-zoomin"></span>
                    Example Link
                </a>
                -->
                <div class="portlet ui-widget ui-widget-content ui-helper-clearfix ui-corner-all">
                    <div class="portlet-header ui-widget-header">Change layout width</div>
                    <div class="portlet-content">
                        <ul class="side-menu layout-options">
                            <li>
                                What width would you like the page to have ?<br /><br />
                            </li>
                            <li>
                                <a href="javascript:void(0);" id="" title="Switch to 100% width layout">Switch to <b>100%</b> width</a>
                            </li>
                            <li>
                                <a href="javascript:void(0);" id="layout90" title="Switch to 90% width layout">Switch to <b>90%</b> width</a>
                            </li>
                            <li>
                                <a href="javascript:void(0);" id="layout75" title="Switch to 75% width layout">Switch to <b>75%</b> width</a>
                            </li>
                            <li>
                                <a href="javascript:void(0);" id="layout980" title="Switch to 980px layout">Switch to <b>980px</b> width</a>
                            </li>
                            <li>
                                <a href="javascript:void(0);" id="layout1280" title="Switch to 1280px layout">Switch to <b>1280px</b> width</a>
                            </li>
                            <li>
                                <a href="javascript:void(0);" id="layout1400" title="Switch to 1400px layout">Switch to <b>1400px</b> width</a>
                            </li>
                            <li>
                                <a href="javascript:void(0);" id="layout1600" title="Switch to 1600px layout">Switch to <b>1600px</b> width</a>
                            </li>
                        </ul>
                    </div>
                </div>
                
<!--                    
                <div class="box ui-widget ui-widget-content ui-corner-all">
                    <h3>Navigation</h3>
                    <div class="content">
                        <a class="btn ui-state-default full-link ui-corner-all" href="#">
                            <span class="ui-icon ui-icon-mail-closed"></span>
                            Dummy link
                        </a>
                        <a class="btn ui-state-default full-link ui-corner-all" href="#">
                            <span class="ui-icon ui-icon-arrowreturnthick-1-n"></span>
                            Dummy link
                        </a>
                        <a class="btn ui-state-default full-link ui-corner-all" href="#">
                            <span class="ui-icon ui-icon-scissors"></span>
                            Dummy link
                        </a>
                        <a class="btn ui-state-default full-link ui-corner-all" href="#">
                            <span class="ui-icon ui-icon-signal-diag"></span>
                            Dummy link
                        </a>
                        <a class="btn ui-state-default full-link ui-corner-all" href="#">
                            <span class="ui-icon ui-icon-alert"></span>
                            With icon and also quite large link
                        </a>
                    </div>
                </div>
                <div class="clear"></div>
                <div class="other-box yellow-box ui-corner-all ui-corner-all">
                    <div class="cont tooltip ui-corner-all" title="Check out the sortable examples below !!">
                        <h3>Sortable Section:</h3>
                        <p>Below you will find a sortable area. Enjoy! Also a tooltip example. You can add tooltips for any html elements.</p>
                    </div>
                </div>
                <div class="side_sort">
                    <div class="box ui-widget ui-widget-content ui-corner-all">
                        <h3>Sortable 1</h3>
                        <div class="content">
                            Lorem ipsum dolor sic amet dixit tu.
                        </div>
                    </div>
                    <div class="box ui-widget ui-widget-content ui-corner-all">
                        <h3>Sortable 2</h3>
                        <div class="content">
                            Lorem ipsum dolor sic amet dixit tu.
                        </div>
                    </div>
                    <div class="box ui-widget ui-widget-content ui-corner-all">
                        <h3>Datepicker</h3>
                        <div class="content">
                            Lorem ipsum dolor sic amet dixit tu.
                        </div>
                    </div>
                </div>
            -->
            </div>
        </div>
    </div>
    <div class="clear"></div>
</template>/*