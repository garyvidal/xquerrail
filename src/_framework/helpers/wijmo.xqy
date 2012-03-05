xquery version "1.0-ml";

module namespace wijmo = "http://www.xquerrail-framework.com/helper/wijmo";

import module namespace js = "http://www.xquerrail-framework.com/helper/javascript"
at "javascript.xqy";

declare default element namespace "http://www.w3.org/1999/xhtml";

(:====================================================:)
(:Controls                                            :)
(:====================================================:)


(:====================================================:)
(:Container                                           :)
(:====================================================:)
(:Accordion and Options:)
declare function wijmo:accordion-template()
{(
    <div id="accordion-template">
    <h1>header</h1>
        <div>content</div>
    <h2>header</h2>
        <div>content</div>
        <div>header</div>
        <div>content</div>
    </div>,
    wijmo:accordion("accordion-template",())
)};

declare function wijmo:accordion-options($options)
{
  ()    
};

declare function wijmo:accordion(
  $id as xs:string
){
  wijmo:accordion($id,()) 
};

declare function wijmo:accordion(
  $id as xs:string,
  $options as item()*
) 
{
   <script>
   jQuery("#{$id}").wijaccordion({{
    {  wijmo:accordion-options($options)}   
   }})
   </script>
};

(:Wizard and Options:)
declare function wijmo:wizard-template()
{(
    <div id="pages">
       <div>Page 1</div>
       <div>Page 2</div>
       <div>Page 3</div>
    </div>,
    wijmo:wizard("pages")
)};
declare function wijmo:wizard-options($options)
{
  ()
};

declare function wijmo:wizard(
  $id as xs:string
){
  wijmo:wizard($id,()) 
};

declare function wijmo:wizard(
  $id as xs:string,
  $options as item()*
) 
{
   <script>
   jQuery("#{$id}").wijwizard({{
    {wijmo:wizard-options($options)}
   }})
   </script>
};


(:Carousel:)
declare function wijmo:carousel-options(
$options)
{
  ()
};
declare function wijmo:carousel($id)
{
   wijmo:carousel($id,())
};
declare function wijmo:carousel(
  $id as xs:string,
  $options as item()*
) 
{
   <script>
   jQuery("#{$id}").wijcarousel({{
    {wijmo:carousel-options($options)}
   }})
   </script>
};
declare function wijmo:carousel-template()
{(
      <div id="wijcarousel0">
        <ul>
            <li><img alt="1" src="http://lorempixum.com/200/150/sports/1" title="Word" /><span>Word Caption 1</span></li>
            <li><img alt="2" src="http://lorempixum.com/200/150/sports/2" title="Word2" /><span>Word Caption 2</span></li>
            <li><img alt="3" src="http://lorempixum.com/200/150/sports/3" title="Word3" /><span>Word Caption 3</span></li>
            <li><img alt="4" src="http://lorempixum.com/200/150/sports/4" title="Word4" /><span>Word Caption 4</span></li>
            <li><img alt="5" src="http://lorempixum.com/200/150/sports/5" title="Word5" /><span>Word Caption 5</span></li>
            <li><img alt="6" src="http://lorempixum.com/200/150/sports/6" title="Word" /><span>Word Caption 6</span></li>
        </ul>
    </div>,
    wijmo:carousel("wijcarousel0")
)};

(:datepager:)
declare function wijmo:datepager-options(
$options)
{
  ()
};
declare function wijmo:datepager($id)
{
   wijmo:datepager($id,())
};
declare function wijmo:datepager(
  $id as xs:string,
  $options as item()*
) 
{
   <script>
   jQuery("#{$id}").wijdatepager({{
    {wijmo:datepager-options($options)}
   }})
   </script>
};
declare function wijmo:datepager-template()
{(
    <div id="datepager" style="margin-top:20px"></div>,
    wijmo:datepager("datepager")
)};

(:Events Calendar:)
declare function wijmo:events-calendar-options(
$options)
{
  ()
};

declare function wijmo:events-calendar($id)
{
   wijmo:events-calendar($id,())
};

declare function wijmo:events-calendar(
  $id as xs:string,
  $options as item()*
) 
{
   <script>
   jQuery("#{$id}").wijevcal({{
    {wijmo:events-calendar-options($options)}
   }})
   </script>
};

declare function wijmo:events-calendar-template()
{(
    <div id="eventscalendar" style="margin-top:20px"></div>,
    wijmo:events-calendar("eventscalendar")
)};

(:Expander and Options:)
declare function wijmo:expander-options(
$options)
{
  fn:string-join($options,",")
};

declare function wijmo:expander($id)
{
   wijmo:expander($id,())
};

declare function wijmo:expander(
  $id as xs:string,
  $options as item()*
) 
{
   <script>
   jQuery("#{$id}").wijexpander({{
    {wijmo:expander-options($options)}
   }})
   </script>
};

declare function wijmo:expander-template()
{(
    <div id="expander">
        <div>
            header
        </div>
        <div>
            content
        </div>
   </div>,
    wijmo:expander("expander")
)};


(:Gallery:)
declare function wijmo:gallery-options(
$options)
{
  ()
};
declare function wijmo:gallery($id)
{
   wijmo:gallery($id,())
};
declare function wijmo:gallery(
  $id as xs:string,
  $options as item()*
) 
{
   <script>
   jQuery("#{$id}").wijgallery({{
    {wijmo:gallery-options($options)}
   }})
   </script>
};

declare function wijmo:gallery-template()
{(
    <div id="gallery">
        <ul class="">
            <li class=""><a href="http://lorempixum.com/750/300/sports/1">
                <img alt="1" src="http://lorempixum.com/200/150/sports/1" title="Word Caption 1" />
            </a></li>
            <li class=""><a href="http://lorempixum.com/750/300/sports/2">
                <img alt="2" src="http://lorempixum.com/200/150/sports/2" title="Word Caption 2" />
            </a></li>
            <li class=""><a href="http://lorempixum.com/750/300/sports/3">
                <img alt="3" src="http://lorempixum.com/200/150/sports/3" title="Word Caption 3" />
            </a></li>
            <li class=""><a href="http://lorempixum.com/750/300/sports/4">
                <img alt="4" src="http://lorempixum.com/200/150/sports/4" title="Word Caption 4" />
            </a></li>
            <li class=""><a href="http://lorempixum.com/750/300/sports/5">
                <img alt="5" src="http://lorempixum.com/200/150/sports/5" title="Word Caption 5" />
            </a></li>
        </ul>
    </div>,
    wijmo:gallery("gallery")
)};

(:dialog and Options:)
declare function wijmo:dialog-options(
$options)
{
  fn:string-join($options,",")
};

declare function wijmo:dialog($id)
{
   wijmo:dialog($id,())
};

declare function wijmo:dialog(
  $id as xs:string,
  $options as item()*
) 
{
   <script>
   jQuery("#{$id}").wijdialog({{
    {wijmo:dialog-options($options)}
   }})
   </script>
};

declare function wijmo:dialog-template()
{(
    <div id="dialog" title="Dialog Title">
       Dialog Content
   </div>,
    wijmo:dialog("dialog")
)};
(:editor and Options:)
declare function wijmo:editor-options(
$options)
{
  fn:string-join($options,",")
};

declare function wijmo:editor($id)
{
   wijmo:editor($id,())
};

declare function wijmo:editor(
  $id as xs:string,
  $options as item()*
) 
{
   <script>
   jQuery("#{$id}").wijeditor({{
    {wijmo:editor-options($options)}
   }})
   </script>
};

declare function wijmo:editor-template()
{(
    <textarea id="editor-template" style="width:100%">
      <h2>Sample Header</h2>
      <div>
        Here is some sample content
      </div>
    </textarea>,
    wijmo:editor("editor-template")
)};
(:tabs and Options:)
declare function wijmo:tabs-options(
$options)
{
  fn:string-join($options,",")
};

declare function wijmo:tabs($id)
{
   wijmo:tabs($id,())
};

declare function wijmo:tabs(
  $selector as xs:string,
  $options as item()*
) 
{
   <script type="text/javascript">
   jQuery("{$selector}").wijtabs({{
    {wijmo:tabs-options($options)}
   }})
   </script>
};

declare function wijmo:tabs-template()
{(
 <div id="tabs-template">
    <ul>
      <li><a href="#tabs-1">tab1</a></li>
      <li><a href="#tabs-2">tab2</a></li>
    </ul>
    <div id="tabs-1">
         <p>
         It was four o'clock when the ceremony was over and the carriages began
         to arrive. There had been a crowd following all the way, owing to the
         exuberance of Marija Berczynskas. The occasion rested heavily upon
         Marija's broad shoulders--it was her task to see that all things went
         in due form, and after the best home traditions; and, flying wildly
         hither and thither, bowling every one out of the way, and scolding and
         exhorting all day with her tremendous voice, Marija was too eager to
         see that others conformed to the proprieties to consider them herself.
         </p>
    </div>
    <div id="tabs-2">
        <p>Words, words, words…</p>
    </div>
</div>,
    wijmo:tabs("tabs-template")
)};

(:menu and Options:)
declare function wijmo:menu-options(
$options)
{
  fn:string-join($options,",")
};

declare function wijmo:menu($id)
{
   wijmo:menu($id,())
};

declare function wijmo:menu(
  $id as xs:string,
  $options as item()*
) 
{
   <script type="text/javascript">
   jQuery("#{$id}").wijmenu({{
    {wijmo:menu-options($options)}
   }})
   </script>
};

declare function wijmo:menu-template()
{(
 <ul id="menu-template" style="height:100%; z-index:100">
    <li><a>menuitem1</a>
        <ul>
           <li><a>menuitem1a</a></li>
           <li><a>menuitem2a</a></li>
        </ul>
    </li>
    <li><a>menuitem2</a></li>
    <li><a>menuitem3</a></li>
</ul>,
    wijmo:menu("menu-template")
)};

(:lightbox and Options:)
declare function wijmo:lightbox-options(
$options)
{
  fn:string-join($options,",")
};

declare function wijmo:lightbox($id)
{
   wijmo:lightbox($id,())
};

declare function wijmo:lightbox(
  $id as xs:string,
  $options as item()*
) 
{
   <script type="text/javascript">
   jQuery("#{$id}").wijlightbox({{
    {wijmo:lightbox-options($options)}
   }})
   </script>
};

declare function wijmo:lightbox-template()
{(
<div id="lightbox-template">
	<a href="http://lorempixum.com/600/400/sports/1" rel="wijlightbox[stock];player=img">
		<img src="http://lorempixum.com/200/150/sports/1" title="Sports 1" alt="Lorem ipsum dolor sit amet, consectetur adipiscing elit." /></a>
	<a href="http://lorempixum.com/600/400/sports/2" rel="wijlightbox[stock];player=img">
		<img src="http://lorempixum.com/200/150/sports/2" title="Sports 2" alt="Lorem ipsum dolor sit amet, consectetur adipiscing elit." /></a>
	<a href="http://lorempixum.com/600/400/sports/3" rel="wijlightbox[stock];player=img">
		<img src="http://lorempixum.com/200/150/sports/3" title="Sports 3" alt="Lorem ipsum dolor sit amet, consectetur adipiscing elit." /></a>
	<a href="http://lorempixum.com/600/400/sports/4" rel="wijlightbox[stock];player=img">
		<img src="http://lorempixum.com/200/150/sports/4" title="Sports 4" alt="Lorem ipsum dolor sit amet, consectetur adipiscing elit. " /></a>
</div>,
    wijmo:lightbox("lightbox-template")
)};

(:pager and Options:)
declare function wijmo:pager-options(
$options)
{
  fn:string-join($options,",")
};

declare function wijmo:pager($id)
{
   wijmo:pager($id,())
};

declare function wijmo:pager(
  $id as xs:string,
  $options as item()*
) 
{
   <script type="text/javascript">
   jQuery("#{$id}").wijpager({{
    {wijmo:pager-options($options)}
   }})
   </script>
};

declare function wijmo:pager-template()
{(
    <div id="pager-template"></div>,
    wijmo:pager("pager-template",(
      js:pair("pageCount",js:number(20)),
      js:pair("pageIndex", js:number(10)),
      js:pair("mode",js:string("numericFirstLast"))      
    ))
)};


(:popup and Options:)
declare function wijmo:popup-options(
$options)
{
  fn:string-join($options,",")
};

declare function wijmo:popup($id)
{
   wijmo:popup($id,())
};

declare function wijmo:popup(
  $id as xs:string,
  $options as item()*
) 
{
   <script type="text/javascript">
   jQuery("#{$id}").wijpopup({{
    {wijmo:popup-options($options)}
   }})
   </script>
};

declare function wijmo:popup-template()
{(
    <div id="popup-template"></div>,
    wijmo:popup("popup-template",(
       js:pair("showEffect",js:string("blind"))
    ))
)};

(:superpanel and Options:)
declare function wijmo:superpanel-options(
$options)
{
  fn:string-join($options,",")
};

declare function wijmo:superpanel($id)
{
   wijmo:superpanel($id,())
};

declare function wijmo:superpanel(
  $id as xs:string,
  $options as item()*
) 
{
   <script type="text/javascript">
   jQuery("#{$id}").wijsuperpanel({{
	{wijmo:superpanel-options($options)}
   }})
   </script>
};

declare function wijmo:superpanel-template()
{(
<div id="superpanel-template" style="width: 440px; height: 280px;">
    <div class="elements">
         <ul>
           <li style="background-color:Red"></li>
           <li style="background-color:Blue"></li>
           <li style="background-color:Fuchsia"></li>
           <li style="background-color:Green"></li>
           <li style="background-color:Purple"></li>
           <li style="background-color:Black"></li>
         </ul>
    </div>
</div>,
	wijmo:superpanel("superpanel-template")
)};

	(:tooltip and Options:)
	declare function wijmo:tooltip-options(
	$options)
	{
	  fn:string-join($options,",")
	};

	declare function wijmo:tooltip($id)
	{
	   wijmo:tooltip($id,())
	};

	declare function wijmo:tooltip(
	  $id as xs:string,
	  $options as item()*
	) 
	{
	   <script type="text/javascript">
	   jQuery("#{$id}").wijtooltip({{
		{wijmo:tooltip-options($options)}
	   }})
	   </script>
	};

declare function wijmo:tooltip-template()
{(
<div id="tooltip" style="width: 440px; height: 280px;">
    <div class="elements">
         <ul>
           <li style="background-color:Red"></li>
           <li style="background-color:Blue"></li>
           <li style="background-color:Fuchsia"></li>
           <li style="background-color:Green"></li>
           <li style="background-color:Purple"></li>
           <li style="background-color:Black"></li>
         </ul>
    </div>
    </div>,
    wijmo:tooltip("tooltip-template")
)};

(:Tree and Options:)
declare function wijmo:tree-options(
$options as item()*
)
{
  fn:string-join($options,",")
};

declare function wijmo:tree($id)
{
   wijmo:tree($id,())
};

declare function wijmo:tree(
  $id as xs:string,
  $options as item()*
) 
{
   <script type="text/javascript">
   jQuery("#{$id}").wijtree({{
	{wijmo:tree-options($options)}
   }})
   </script>
};

declare function wijmo:tree-template()
{(
    <ul id="tree-template">
      <li><a>Tree Node 1</a>
          <ul>
            <li>Child Node 1</li>
            <li>Child Node 2</li>
          </ul>
      </li>
    <li><a>Tree Node 2</a></li>
    </ul>,
    wijmo:tree("tree-template")
)};

(:Video and Options:)
declare function wijmo:video-options(
$options)
{
  fn:string-join($options,",")
};

declare function wijmo:video($id)
{
   wijmo:video($id,())
};

declare function wijmo:video(
  $id as xs:string,
  $options as item()*
) 
{
   <script type="text/javascript">
   jQuery("#{$id}").wijvideo({{
	{wijmo:video-options($options)}
   }})
   </script>
};

declare function wijmo:video-template()
{(
    <video controls="controls" id="vid1" width="720" height="486">
        <source src="http://cdn.wijmo.com/movies/wijmo.theora.ogv" type='video/ogg; codecs="theora, vorbis"'/>
        <source src="http://cdn.wijmo.com/movies/wijmo.mp4video.mp4" type='video/mp4; codecs="avc1.42E01E, mp4a.40.2"'/>
    </video>,
    wijmo:video("video-template")
)};


(:Now the Hard Shit:)
declare function wijmo:grid(
   $selector as xs:string,
   $options as item()
){(
   

)};

declare function wijmo:gridColumn(
  $options as item()
) 
{(
   
)};

