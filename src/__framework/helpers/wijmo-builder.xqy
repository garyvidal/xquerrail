xquery version "1.0-ml";

module namespace wijbuilder = "http://www.xquerrail-framework.com/helper/wijmo-builder";

import module namespace wijmo    = "http://www.xquerrail-framework.com/helper/wijmo"       at "wijmo.xqy";
import module namespace js       = "http://www.xquerrail-framework.com/helper/javascript"  at "javascript.xqy";
import module namespace resource = "http://www.xquerrail-framework.com/helper/resource"    at "resource.xqy";
import module namespace form     = "http://www.xquerrail-framework.com/helper/formbuilder" at "formbuilder.xqy";

declare variable $tags as xs:QName()* := 
(
   "wijmo-scripts",
   "wijmo-stylesheets"
);

declare variable $functions as xs:QName()*  :=
(
   xs:QName("wijmo:accordion"),
   xs:QName("wijmo:barchart"),
   xs:QName("wijmo:bubblechart"),
   xs:QName("wijmo:calendar"),
   xs:QName("wijmo:carousel"),
   xs:QName("wijmo:checkbox"),
   xs:QName("wijmo:combobox"),
   xs:QName("wijmo:compositechart"),
   xs:QName("wijmo:datepager"),
   xs:QName("wijmo:dialog"),
   xs:QName("wijmo:editor"),
   xs:QName("wijmo:events-calendar"),
   xs:QName("wijmo:expander"),
   xs:QName("wijmo:gallery"),
   xs:QName("wijmo:grid"),
   xs:QName("wijmo:inputdate"),
   xs:QName("wijmo:inputmask"),
   xs:QName("wijmo:inputnumber"),
   xs:QName("wijmo:inputmask"),
   xs:QName("wijmo:inputnumber"),
   xs:QName("wijmo:lightbox"),
   xs:QName("wijmo:lineargauge"),
   xs:QName("wijmo:linechart"),
   xs:QName("wijmo:list"),
   xs:QName("wijmo:menu"),
   xs:QName("wijmo:pager"),
   xs:QName("wijmo:piechart"),
   xs:QName("wijmo:popup"),
   xs:QName("wijmo:progressbar"),
   xs:QName("wijmo:radialgauge"),
   xs:QName("wijmo:radio"),
   xs:QName("wijmo:rating"),
   xs:QName("wijmo:rating"),
   xs:QName("wijmo:ribbon"),
   xs:QName("wijmo:scatterchart"),
   xs:QName("wijmo:slider"),
   xs:QName("wijmo:splitter"),
   xs:QName("wijmo:superpanel"),
   xs:QName("wijmo:tabs"),
   xs:QName("wijmo:tooltip"),
   xs:QName("wijmo:tree"),
   xs:QName("wijmo:tree"),
   xs:QName("wijmo:uploader"),
   xs:QName("wijmo:videoplayer"),
   xs:QName("wijmo:wizard")
);

declare variable $css-dependencies as map:map  := 
  let $deps := map:map()
  return (
     map:put($deps,"accordion",      ("jquery.wijmo.wijutil","jquery.wijmo.wijaccordion")),
     map:put($deps,"barchart",       ()),
     map:put($deps,"bubblechart",    ()),
     map:put($deps,"calendar",       ("jquery.wijmo.wijutil","jquery.wijmo.wijcalendar")),
     map:put($deps,"carousel",       ()),
     map:put($deps,"checkbox",       ("jquery-wijmo","jquery.wijmo.wijcheckbox")),
     map:put($deps,"combobox",       ("jquery-wijmo","jquery.wijmo.wijcombobox")),
     map:put($deps,"compositechart", ()),
     map:put($deps,"datepager",      ()),
     map:put($deps,"dialog",         ()),
     map:put($deps,"dropdown",       ("jquery-wijmo","jquery.wijmo.wijdropdown")),
     map:put($deps,"editor",         ()),
     map:put($deps,"events-calendar",()),
     map:put($deps,"expander",       ()),
     map:put($deps,"gallery",        ()),
     map:put($deps,"grid",           ()),
     map:put($deps,"inputdate",      ("jquery-wijmo","jquery.wijmo.wijinputdate")),
     map:put($deps,"inputmask",      ("jquery-wijmo","jquery.wijmo.wijinputmask")),
     map:put($deps,"inputnumber",    ("jquery-wijmo","jquery.wijmo.wijinputnumber")),
     map:put($deps,"lightbox",       ()),
     map:put($deps,"lineargauge",    ()),
     map:put($deps,"linechart",      ()),
     map:put($deps,"list",           ("jquery-wijmo","jquery.wijmo.wijlist")),
     map:put($deps,"menu",           ("jquery-wijmo","jquery.wijmo.wijmenu")),
     map:put($deps,"pager",          ()),
     map:put($deps,"piechart",       ()),
     map:put($deps,"popup",          ()),
     map:put($deps,"progressbar",    ()),
     map:put($deps,"radialgauge",    ()),
     map:put($deps,"radio",          ("jquery-wijmo","jquery.wijmo.wijradio")),
     map:put($deps,"rating",         ()),
     map:put($deps,"ribbon",         ()),
     map:put($deps,"scatterchart",   ()),
     map:put($deps,"slider",         ()),
     map:put($deps,"splitter",       ()),
     map:put($deps,"superpanel",     ()),
     map:put($deps,"tabs",           ()),
     map:put($deps,"textbox",        ("jquery-wijmo","jquery.wijmo.wijtextbox")),
     map:put($deps,"tooltip",        ("jquery-wijmo","jquery.wijmo.wijtooltip")),
     map:put($deps,"tree",           ()),
     map:put($deps,"uploader",       ()),
     map:put($deps,"videoplayer",    ()),
     map:put($deps,"wizard",         ()),
     $deps  
  )[1];
declare variable $js-dependencies as map:map:= 
  let $deps := map:map()
  return (
     map:put($deps, "accordion",      ("jquery","jquery.ui.core","jquery.ui.widget","jquery.wijmo.wijutil","jquery.wijmo.wijaccordion")),
     map:put($deps, "barchart",       ("raphael","globalize.min","jquery.ui.widget","jquery.wijmo.wijchartcore")),
     map:put($deps, "bubblechart",    ("raphael","globalize.min","jquery.ui.widget","jquery.wijmo.wijchartcore")),
     map:put($deps, "barchart",       ("raphael","globalize.min","jquery.ui.widget","jquery.wijmo.wijchartcore")),
     map:put($deps, "calendar",       ("jquery", "jquery.ui.core", "jquery.wijmo.wijutil", "jquery.wijmo.wijcalendar", "jquery.wijmo.widget", "jquery.wijmo.wijpopup", "jquery.effects.core", "jquery.effects.blind", "jquery.effects.slide", "jquery.effects.scale", "globalize")),
     map:put($deps, "carousel",       ("jquery", "jquery.ui.core", "jquery.ui.widget","jquery.ui.position")),
     map:put($deps, "checkbox",       ("jquery", "jquery.ui.core","jquery.ui.widget")),
     map:put($deps, "combobox",       ("jquery", "jquery.ui.core","jquery.ui.widget","jquery.ui.position","jquery.wijmo.wijlist","jquery.wijmo.wijcombobox")),
     map:put($deps, "compositechart", ("raphael","globalize.min","jquery.ui.widget","jquery.wijmo.wijchartcore")),
     map:put($deps, "datepager",      ("jquery","jquery.ui.core","jquery.ui.widget","globalize","jquery.ui.wijutil","jquery.wijmo.wijpopup","jquery.wijmo.wijdatepager")),
     map:put($deps, "dialog",         ("jquery","jquery.ui.core","jquery.ui.widget","jquery.wijmo.wijutil")),
     map:put($deps, "editor",         ("jquery","jquery.ui.core","jquery.ui.widget","jquery.ui.resizable","jquery.ui.draggable","jquery.effects.core","jquery.mousewheel","jquery.bgiframe","jquery.wijmo.wijsuperpanel")),
     map:put($deps, "events-calendar",("jquery.ui.core","jquery.ui.widget","globalize","jquery.mousewheel","jquery.plugin.wijtextselection","jquery.wijmo.wijutil","jquery.wijmo.wijinputcore","jquery.wijmo.wijinputdate","jquery.wijmo.wijinputnumber","jquery.wijmo.wijcalendar","jquery.wijmo.wijdialog","jquery.wijmo.wijcombobox","jquery.wijmo.wijdatepager")),
     map:put($deps, "expander",       ("jquery","jquery.ui.core","jquery.ui.widget","jquery.wijmo.wijutil","jquery.wijmo.wijexpander")),
     map:put($deps, "gallery",        ("jquery","jquery.ui.core","jquery.ui.widget","jquery.ui.position","jquery.wijmo.wijutil","jquery.wijmo.wijgallery")),
     map:put($deps, "grid",           ("jquery","jquery.ui.core","jquery.ui.widget","jquery.glob","jquery.wijmo.wijutil","jquery.wijmo.wijdatasource")),
     map:put($deps, "inputdate",      ("jquery","jquery.ui.core","jquery.ui.widget","jquery.ui.position","jquery.plugin.wijtextselection","globalize","jquery.effects.core","jquery.effects.blind","jquery.wijmo.wijpopup","jquery.wijmo.wijinputcore","jquery.wijmo.wijcalendar","jquery.mousewheel")),
     map:put($deps, "inputmask",      ("jquery","jquery.ui.core","jquery.ui.widget","jquery.ui.position","jquery.plugin.wijtextselection","globalize","jquery.effects.core","jquery.effects.blind","jquery.wijmo.wijpopup","jquery.wijmo.wijinputcore")),
     map:put($deps, "inputnumber",    ("jquery","jquery.ui.core","jquery.ui.widget","jquery.ui.position","jquery.plugin.wijtextselection","globalize","jquery.effects.core","jquery.effects.blind","jquery.wijmo.wijpopup","jquery.wijmo.wijinputcore")),
     map:put($deps, "lightbox",       ("jquery","jquery.ui.core","jquery.ui.widget","jquery.ui.position","jquery.effects.core","jquery.cookie","jquery.wijmo.wijutil")),
     map:put($deps, "lineargauge",    ("jquery","jquery.ui.core","jquery.ui.widget","raphael","jquery.wijmo.raphael","jquery.wijmo.wijgauge")),
     map:put($deps, "linechart",      ("raphael","jquery.wijmo.raphael","globalize.min","jquery","jquery.ui.widget","jquery.wijmo.wijchartcore")),
     map:put($deps, "list",           ("jquery.ui.core","jquery.ui.widget","jquery.wijmo.wijsuperpanel","jquery.wijmo.wijutil")),
     map:put($deps, "menu",           ("jquery.ui.core","jquery.ui.widget","jquery.wijmo.wijutil","jquery.ui.position","jquery.ui.effects.core","jquery.mousewheel","jquery.bgiframe","jquery.wijmo.wijsuperpanel")),
     map:put($deps, "pager",          ("jquery","jquery.ui.core","jquery.ui.widget","jquery.wijmo.wijpager")),
     map:put($deps, "piechart",       ("raphael","globalize.min","jquery.ui.widget","jquery.wijmo.raphael","jquery.wijmo.wijchartcore")),
     map:put($deps, "popup",          ("jquery","jquery.ui.core","jquery.ui.position","jquery.ui.widget","jquery.wijmo.wijpopup")),
     map:put($deps, "progressbar",    ("jquery","jquery.ui.core","jquery.ui.widget","jquery.wijmo.wijprogressbar")),
     map:put($deps, "radialguage",    ("jquery","jquery.ui.core","jquery.ui.widget","raphael","jquery.wijmo.raphael","jquery.wijmo.wijgauge","globalize.min")),
     map:put($deps, "radio",          ("jquery","jquery.ui.core","jquery.wijmo.widget")),
     map:put($deps, "rating",         ("jquery","jquery.ui.core","jquery.wijmo.widget")),
     map:put($deps, "ribbon",         ("jquery","jquery.ui.core","jquery.ui.widget","jquery.wijmo.wijtabs","jquery.wijmo.wijribbon")),
     map:put($deps, "scatterchart",   ("jquery","jquery.ui.core","jquery.ui.widget","jquery.wijmo.wijutil","jquery.effects.core","jquery.ui.slider")),
     map:put($deps, "slider",         ("jquery","jquery.ui.core","jquery.ui.widget","jquery.wijmo.wijutil","jquery.effects.core","jquery.ui.slider")),
     map:put($deps, "splitter",       ("jquery.ui.core","jquery.ui.widget","jquery.ui.resizable","jquery.ui.mouse","jquery.wijmo.wijutil")),
     map:put($deps, "superpanel",     ("jquery.ui.core","jquery.ui.widget","jquery.ui.resizable","jquery.ui.draggable","jquery.effects.core","jquery.mousewheel")),
     map:put($deps, "tabs",           ("jquery","jquery.ui.core","jquery.ui.widget","jquery.ui.position","jquery.effects.core","jquery.cookie","jquery.wijmo.wijsuperpanel","jquery.wijmo.wijutiltabs")),
     map:put($deps, "textbox",        ("jquery","jquery.ui.core","jquery.ui.widget")),
     map:put($deps, "tooltip",        ("jquery","jquery.ui.core","jquery.ui.widget","jquery.ui.position")),
     map:put($deps, "videoplayer",    ("jquery.ui.core","jquery.ui.widget","jquery.wijmo.wijtooltip")),
     map:put($deps, "wizard",         ("jquery-1.7.1","jquery.ui.core","jquery.ui.widget","jquery.ui.position","jquery.effects.core","jquery.cookie","jquery.wijmo.wijutil","jquery.wijmo.wijsuperpanel","jquery.wijmo.wijwizard")),
     $deps
  )[1];


declare function wijbuilder:render-control(
$name as xs:string,
$type as xs:string,
$values as item()*,
$opts as item(),
$ui as item()
) {
  let $options := form:parse-options($opts)
  let $qtype := element {xs:QName($type)} {$options}
  return
    typeswitch($qtype)
     (: Complex Element :)
      case element(schema-element) return 
        (
          form:render-complex($name,$type,$value,$options)
    
        )
      case element(reference) return form:render-reference($name,$type,$value,$options)
      case element(grid) return form:render-grid($name,$type,$value,$options,$ui)
      case element(query) return form:render-query($name,$type,$value,$options,$ui)

     (:Text Elements:)
      case element(string) return form:render-text($name,$type,$value,$options)
      case element(integer) return form:render-text($name,$type,$value,$options)
      case element(long) return form:render-text($name,$type,$value,$options)
      case element(decimal) return form:render-text($name,$type,$value,$options)
      case element(float) return form:render-text($name,$type,$value,$options)
      case element(anyURI) return form:render-text($name,$type,$value,$options)
      case element(yearMonth) return form:render-text($name,$type,$value,$options)
      case element(monthDay) return render-text($name,$type,$value,$options)

      case element(money) return form:render-money($name,$type,$value,$options)     
      case element(number) return form:render-number($name,$type,$value,$options)  
      case element(password) return form:render-password($name,$type,$value,$options)
      case element(email) return form:render-email($name,$type,$value,$options)
      case element(search) return form:render-search($name,$type,$value,$options)
      case element(url) return form:render-url($name,$type,$value,$options)
      
      case element(boolean) return form:render-text($name,'checkbox',$value,$options)
      
      (:Choice Elements:)
      case element(choice) return form:render-choice($name,$type,$value,$options)
      case element(entity) return form:render-entity($name,$type,$value,$options)
      case element(country) return form:render-country($name,$type,$value,$options)
      case element(locale) return form:render-locale($name,$type,$value,$options)
      case element(timezone) return form:render-timezone($name,$type,$value,$options)    
      
      (:Date Time Controls:)
      case element(date) return form:render-date($name,$type,$value,$options)
      case element(dateTime) return form:render-dateTime($name,$type,$value,$options)
      case element(time) return form:render-dateTime($name,$type,$value,$options)
      case element(birthday) return form:render-birthday($name,$type,$value,$options)
      
      (:Repeating Controls:)
      case element(collection) return form:render-collection($name,$type,$value,$options)
      case element(repeated) return form:render-repeated($name,$type,$value,$options)
      
      (:Button Controls:)
      case element(hidden) return form:render-hidden($name,$type,$value,$options)
      case element(button) return form:render-button($name,$type,$value,$options)
      case element(submit) return form:render-submit($name,$type,$value,$options)
      case element(clear) return form:render-clear($name,$type,$value,$options)
      
      (:Other Controls:)
      case element(csrf) return form:render-csrf($name,$type,$value,$options)
      case element(file) return form:render-file($name,$type,$value,$options)
 
      (:Custom Rendering:)
      case element() return form:render-custom($name,$type,$value,$options)
      
      default return ()  
};