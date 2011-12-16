xquery version "1.0-ml";
(:~
 : Default Application Controller
 : @author gary.vidal@marklogic.com
~:)
module namespace controller = "http://www.xquerrail-framework.com/controller/default";

import module namespace request = "http://www.xquerrail-framework.com/request"
    at "/_framework/request.xqy";
    
import module namespace response = "http://www.xquerrail-framework.com/response"
    at "/_framework/response.xqy";

declare function controller:initialize($request as map:map)
{
  request:initialize($request)
};

declare function controller:main($request as map:map)
{
  controller:index($request)
};

declare function controller:index($request as map:map)
{
  if(xdmp:get-current-user() = ("nobody","validator-nobody")) then
  (
    response:set-controller("default"),
    response:set-action("home"),
    response:set-template("login"),
    response:set-view("login"),
    response:set-title("Login"),
    response:response() 
  ) else 
  (
    response:set-controller("default"),
    response:set-template("main"),
    response:set-view("home"),
    response:set-slot("headline",<div>I am a super slot</div>),
    response:set-title(fn:concat("Welcome: ",xdmp:get-current-user())),
    response:add-httpmeta("cache-control","public"),
    response:response()
  )
};
declare function controller:portlets($request as map:map)
{
  (
    response:set-controller("default"),
    response:set-template("main"),
    response:set-view("portlet"),
    response:set-slot("headline",<div>I am a super slot</div>),
    response:set-title("3 Column Sortable Portlets"),
    response:add-httpmeta("cache-control","public"),
    response:response()
  )
};
declare function controller:search($request as map:map)
{
  let $q := request:param("q")
  let $results := 
    <search-results>
    <count>300</count>
    <page>1</page>
    <pagesize>20</pagesize>
    <facet-item name="Countries">
      <facet-value count="32">United States</facet-value>
      <facet-value count="33">United Kingdom</facet-value>
    </facet-item>
    <search-result uri="/somedoc/1">
      <title>Here is a search result</title>
      <snippet>
        The output I want is html<span>html</span>
      </snippet>
    </search-result>
        <search-result uri="/somedoc/2">
      <title>Here is a search result</title>
      <snippet>
        The output I want is html<span>html</span>
      </snippet>
    </search-result>
  </search-results>
 let $results := if($q = "show") then $results else ()
 return
 (
    response:set-controller("default"),
    response:set-template("main"),
    response:set-view("search"),
    response:add-data("breadcrumb",("Search","Search Results","Page 2")),
    response:add-data("search_results",$results),
    response:set-slot("headline",<div>I am a super slot</div>),
    if($results) then response:set-title("Search Results Tian") else response:set-title("Search"),
    response:add-httpmeta("cache-control","public"),
    response:response()
  )
};  
declare function controller:login($request as map:map)
{
  let $user := request:param("username")
  let $password := request:param("password")
  let $return-url := request:param("returnUrl")
  let $_ := xdmp:login($user,$password)
  return
  (
      response:set-controller("default"),
      if($return-url ne "") 
      then response:redirect($return-url)
      else response:redirect("/"),
       response:response()
  )
};

declare function controller:logout($request as map:map)
{(
    xdmp:logout(),
    response:redirect("/"),
    response:response()
)};
declare function controller:accordion($request as map:map)
{
 
  (
    response:set-controller("default"),
    response:set-template("main"),
    response:set-view("accordion"),
    response:set-title("Accordion Demo"),
    response:add-httpmeta("cache-control","public"),
    response:response()
  )
};
declare function controller:charts($request as map:map)
{
 
  (
    response:set-controller("default"),
    response:set-template("main"),
    response:set-view("charts"),
    response:set-title("Charts Demo"),
    response:add-httpmeta("cache-control","public"),
    response:response()
  )
};
declare function controller:flexigrid($request as map:map)
{
 
  (
    response:set-controller("default"),
    response:set-template("main"),
    response:set-view("flexigrid"),
    response:set-title("FlexiGrid Demo"),
    response:set-slot("headline",<h3>I am a super slot</h3>),
    response:add-httpmeta("cache-control","public"),
    response:response()
  )
};
declare function controller:editinplace($request as map:map)
{
 
  (
    response:set-controller("default"),
    response:set-template("main"),
    response:set-view("editinplace"),
    response:set-title("Inplace Editor"),
    response:add-httpmeta("cache-control","public"),
    response:response()
  )
};
declare function controller:three-columns-layout($request as map:map)
{
 
  (
    response:set-controller("default"),
    response:set-template("main"),
    response:set-view("three-column-layout"),
    response:set-title("Three Column Layout"),
    response:add-httpmeta("cache-control","public"),
    response:response()
  )
};
declare function controller:two-column-layout($request as map:map)
{
 
  (
    response:set-controller("default"),
    response:set-template("main"),
    response:set-view("two-column-layout"),
    response:set-title("Two Column Layout"),
    response:add-httpmeta("cache-control","public"),
    response:response()
  )
};
declare function controller:page-left-sidebar($request as map:map)
{
 
  (
    response:set-controller("default"),
    response:set-template("main"),
    response:set-view("page-left-sidebar"),
    response:set-title("Two Column Layout"),
    response:add-httpmeta("cache-control","public"),
    response:response()
  )
};
declare function controller:msg($request as map:map)
{
 
  (
    response:set-controller("default"),
    response:set-template("main"),
    response:set-view("msg"),
    response:set-title("Messages"),
    response:add-httpmeta("cache-control","public"),
    response:response()
  )
};
declare function controller:icons($request as map:map)
{
 
  (
    response:set-controller("default"),
    response:set-template("main"),
    response:set-view("icons"),
    response:set-title("Icons"),
    response:add-httpmeta("cache-control","public"),
    response:response()
  )
};
declare function controller:gallery($request as map:map)
{
 
  (
    response:set-controller("default"),
    response:set-template("main"),
    response:set-view("gallery"),
    response:set-title("Image Gallery"),
    response:add-httpmeta("cache-control","public"),
    response:response()
  )
};
declare function controller:validate($request as map:map)
{
 
  (
    response:set-controller("default"),
    response:set-template("main"),
    response:set-view("validate"),
    response:set-title("Forms Builder with Validation"),
    response:add-httpmeta("cache-control","public"),
    response:response()
  )
};
declare function controller:forms($request as map:map)
{
  (
    response:set-controller("default"),
    response:set-template("main"),
    response:set-view("forms"),
    response:set-title("Forms Fields"),
    response:add-httpmeta("cache-control","public"),
    response:response()
  )  
};
declare function controller:dialog($request as map:map)
{
   (
    response:set-controller("default"),
    response:set-template("main"),
    response:set-view("dialog"),
    response:set-title("Dialogs"),
    response:add-httpmeta("cache-control","public"),
    response:response()
  ) 
};
declare function controller:tinymce($request as map:map)
{
   (
    response:set-controller("default"),
    response:set-template("main"),
    response:set-view("tinymce"),
    response:set-title("Tianr"),
    response:add-httpmeta("cache-control","public"),
    response:response()
  ) 
};
declare function controller:save($request as map:map)
{
    response:response()
};