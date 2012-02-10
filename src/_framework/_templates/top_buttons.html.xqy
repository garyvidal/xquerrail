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



declare default element namespace = "http://www.w3.org/1999/xhtml";
<template>
<div id="top-buttons">
    <a id="dialog_link" class="btn ui-state-default ui-corner-all" href="#">
        <span class="ui-icon ui-icon-newwin"></span>
        Dialog Window
    </a>
    <a class="btn ui-state-default ui-corner-all" id="drop" href="#drop_down">
        <span class="ui-icon ui-icon-carat-2-n-s"></span>
        DropDown Menu
    </a>
    <div id="drop_down" class="hidden">
        <ul>
            <li><a href="#">Google</a></li>
            <li><a href="#">Yahoo</a></li>
            <li><a href="#">MSN</a></li>
            <li><a href="#">Ask</a></li>
            <li><a href="#">AOL</a></li>
        </ul>
    </div>
    <a id="modal_confirmation_link" class="btn ui-state-default ui-corner-all" href="#">
        <span class="ui-icon ui-icon-grip-dotted-horizontal"></span>
        Modal Confirmation
    </a>
</div>
<div id="dialog" title="Dialog Title">
    <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>
</div>
<div id="modal_confirmation" title="An example modal title ?">
    <p><span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span>Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>
</div>

</template>