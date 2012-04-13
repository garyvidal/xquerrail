declare default element namespace "http://www.w3.org/1999/xhtml";

<ul id="navigation" style="font-size:.8em;">
<li><a href="#">Demo Stuff</a>
  <ul>    <li>
        <a href="dashboard" class="sf-with-ul">Dashboard</a>
        <ul>
            <li><a href="/">Demo Stuff</a></li>
            <li><a href="search">Search Interface</a></li>
            <li>
                <a href="forms">Forms</a>
                <ul>
                    <li><a href="/default/validate">Form validation</a></li>
                    <li><a href="/default/table_modal"><b>Add to table modal</b></a></li>
                    <li><a href="/default/editinplace"><b>Edit in Place</b></a></li>
                    <li><a href="/default/tinymce"><b>WYSIWYG Editor</b></a></li>
                </ul>
            </li>
            <li>
                <a href="/default/tables">Tables</a>
                <ul>
                    <li><a href="/default/tables">Sortable Tables</a></li>
                    <li><a href="/default/flexigrid"><b>FlexiGrid</b></a></li>
                </ul>
            </li>
            <li>
                <a href="#">Widgets</a>
                    <ul>
                    <li><a href="/default/accordion">Accordion</a></li>
                    <li><a href="/default/flexigrid"><b>FlexiGrid</b></a></li>
                    <li><a href="/default/editinplace"><b>Edit in Place</b></a></li>
                    <li><a href="/default/tinymce"><b>WYSIWYG Editor</b></a></li>
                    <li><a href="/default/charts"><b>Charts</b></a></li>
                    <li><a href="/default/tabs">Tabs</a></li>
                    <li><a href="/default/slider">Slider</a></li>
                    <li><a href="/default/datepicker">Datepicker</a></li>
                    <li><a href="/default/progress">Progress Bar</a></li>
                    <li><a href="/default/dialog">Dialogs and Modals</a></li>
                    <li><a href="/default/overlays">Overlays</a></li>
                    <li><a href="/default/photo_manager">Photo Manager</a></li>
                    <li><a href="/default/file_browser">File Browser</a></li>
                </ul>
            </li>
            <li><a href="/default/msg">Response Messages</a></li>
            <li><a href="/default/icons">Icons</a></li>
            <li><a href="/default/icons">Buttons and Elements</a></li>
            <li><a href="/default/logout">Logout (Login Page)</a></li>

        </ul>
    </li>
    <li><a href="/default/gallery">Photo Gallery</a></li>
    <li>
        <a href="#" class="sf-with-ul">Layout Options</a>
        <ul>
            <li>
                <a href="/default/three-columns-layout">Three columns</a>
            </li>
            <li>
                <a href="/default/two-column-layout">Two columns</a>
            </li>
            <li>
                <a href="/default/no-rounded">No rounded corners</a>
            </li>
            <li>
                <a href="/default/content_boxes">Available content boxes</a>
            </li>
        </ul>
    </li>
    <li>
        <a href="#" class="sf-with-ul">Theme Options</a>
        <ul>
            <li>
                <a href="/default/page-left-sidebar">Page with left sidebar</a>
            </li>
            <li>
                <a href="/default/page_dynamic_sidebar">Page with dynamic sidebar</a>
            </li>
            <li>
                <a href="#">Avaiable Themes</a>
                <ul id="style-switcher">
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
            </li>
            <li>
                <a href="#"><i>Dummy Link</i></a>
            </li>
        </ul>
    </li>
    <li>
        <a href="#" class="sf-with-ul">Widgets</a>
        <ul>
            <li><a href="accordion">Accordion</a></li>
            <li><a href="flexigrid"><b>FlexiGrid</b></a></li>
            <li><a href="editinplace"><b>Edit in Place</b></a></li>
            <li><a href="tinymce"><b>WYSIWYG Editor</b></a></li>
            <li><a href="charts"><b>Charts</b></a></li>
            <li><a href="tabs">Tabs</a></li>
            <li><a href="slider">Slider</a></li>
            <li><a href="datepicker">Datepicker</a></li>
            <li><a href="progress">Progress Bar</a></li>
            <li><a href="dialog">Dialogs and Modals</a></li>
            <li><a href="overlays">Overlays</a></li>
            <li><a href="photo_manager">Photo Manager</a></li>
            <li><a href="file_browser">File Browser</a></li>
        </ul>
    </li> 
    </ul></li>
    <li><a href="">Controllers</a>
      <ul>
         <?controller-list?>        
      </ul>
    </li>
</ul>