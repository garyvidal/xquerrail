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
<div>
    <div class="inner-page-title">
        <h2>Sidebar positioned left</h2>
        <span>As you can see, on this page the sidebar is positioned on the left of the page.</span>
    </div>
    <div class="content-box content-box-header">
        <div class="content-box-wrapper">
            <h3>How to achieve this ?</h3>
            <p>All you have to do is add <b>id="sidebar-left"</b> to the body tag.</p>
        </div>
    </div>
    <div class="clearfix"></div>
    <?template  name='sidebar' ?>
</div>/*    
