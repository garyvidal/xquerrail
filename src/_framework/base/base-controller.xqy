xquery version "1.0-ml";
(:~
 : Controller :  Base Controller
 :               
 : @author   : Gary Vidal
 : @version  : 1.0  
~:)

module namespace controller = "http://www.xquerrail-framework.com/controller/base";

(:Global Import Module:)
import module namespace request =  "http://www.xquerrail-framework.com/request"
   at "/_framework/request.xqy";
   
import module namespace response = "http://www.xquerrail-framework.com/response"
   at "/_framework/response.xqy";   

import module namespace model = "http://www.xquerrail-framework.com/model/base"
   at "/_framework/base/base-model.xqy";

import module namespace domain = "http://www.xquerrail-framework.com/domain"
   at "/_framework/domain.xqy";
   
declare default collation "http://marklogic.com/collation/codepoint";
  
(:Default Imports:)
declare namespace search = "http://marklogic.com/appservices/search";


(:Global Option:)
declare option xdmp:mapping "false";
declare variable $collation := "http://marklogic.com/collation/codepoint";


declare function controller:initialize($request)
{(
   xdmp:log(("initialize::",$request),"debug"),
   request:initialize($request),
   response:initialize(map:map(),$request),
   response:set-partial(request:partial())
)};

declare function controller:model()
{
   domain:get-controller-model(request:application(),request:controller())
};

declare function controller:controller()
{
    domain:get-controller(request:application(),request:controller())
};

declare function controller:invoke($action)
{
 response:set-model(controller:model()),
 (
   if($action eq "create")      then controller:create()
   else if($action eq "update") then controller:update()
   else if($action eq "get")    then controller:get()
   else if($action eq "delete") then controller:delete()
   else if($action eq "list")   then controller:list()
   else if($action eq "search") then controller:search()
   else if($action eq "put")    then controller:put()
   else if($action eq "post")   then controller:post()
   (:HTML:)   
   else if($action eq "new")    then controller:new()
   else if($action eq "edit")   then controller:edit()
   else if($action eq "remove") then controller:remove()  
   else if($action eq "save")   then controller:save()
   else if($action eq "index")  then controller:index()
   else if($action eq "show")   then controller:show()
   else if($action eq "lookup") then controller:lookup()
   else if($action eq "fields") then controller:fields()
   else if($action eq "export") then controller:export()
   else if($action eq "import") then controller:import()
   else controller:main()   
 )
};
(:Controller Required Functions:)
 
declare function controller:name() {
   "base"
}; 

declare function controller:main()
{
   if(request:format() eq "xml") 
   then (
      response:set-controller(controller:name()),
      response:set-format(request:format()),
      response:set-template("main"),
      response:set-view("info"),
      response:flush()
   ) else (
     controller:index()  
   )
};

  declare function controller:info() { 
  <info xmlns:domain="http://www.xquerrail-framework.com/domain"
      xmlns:search="http://marklogic.com/appservices/search"
      xmlns:builder="http://www.xquerrail-framework.com/builder">
   
   <action name="create" method="PUT">
    {()}   
   </action>
   
   <action name="get" method="GET">
      <param name="_uuid" required="false"/>
      <param name="id" requred="true"/>
   </action>

   <action name="update" method="UPDATE">
      <param name="id" required="true"/>
   </action>
   
   <action name="delete" method="DELETE">
      <param name="id" required="true"/>
   </action>
   
   <action name="search">
      <param name="query" required="false"/>
      <param name="start" required="true" default="1"/>
      <param name="pg" required="true" default="1"/>
      <param name="ps" required="false" default="ascending" />      
      <param name="sort-order" required="false" default="ascending" />
   </action>
   
   <action name="list" required="true">
      <param name="start" required="true" default="1"/>
      <param name="page" required="true" default="1"/>
      <param name="sort" required="false" />      
      <param name="sort-order" required="false" default="ascending" />
   </action>  
  
  </info>
    
};

(:~
 : Create contentType
~:) 
declare function controller:create() {(
  xdmp:log(("controller:create::",request:params()),"debug"),
  model:create(controller:model(),request:params())
)};

(:~
 :  Retrieves a contentType
~:) 
declare function controller:get()
{
   model:get(controller:model(),request:params())
};
 
(:~
 : Update Operation contentType
 :) 
declare function controller:update()
{
  model:update(
    controller:model(),
    request:params()
  )
};
 
(:~
 :  Deletes a contentType
~:)  
declare function controller:delete()
{
    model:delete(
       controller:model(),
       request:params()
    )
};
 
(:~
 : Provide search interface for contentType
 : @param $query - Search query 
 : @param $sort -  Sorting Key to sort results by
 : @param $start 
~:)
declare function controller:search()
{(

   response:set-template("main"),
   response:set-view("find"),
   response:set-title(fn:concat("Search ", controller:controller()/@label)),
   response:set-body(( 
    model:search(controller:model(),request:params()),
    model:build-search-options(controller:model())
   )),
  response:flush()
)};


(:~
 : Returns a list of records
~:)
declare function controller:list()
{
    model:list(
      controller:model(),
      request:params()  
    )
};

(:
 : ==================================
 : Controller HTML Functions
 : ==================================
 :)
 
(:~
 : Default Index Page 
~:)
declare function controller:index()
{(
   controller:list()[0],
   response:set-template("main"),
   response:set-view("index"),
   response:set-title(controller:controller()/@label),
   response:flush()
)};

 (:~ Show a record ~:) 
 
declare function controller:show()
{
 (   
    response:set-body(controller:get()),
    response:set-template("main"),
    response:set-view("show"),  
    response:flush()
 )     
};   

declare function controller:new()
{(  
    response:set-template("main"),
    response:set-title(controller:model()/@label),
    response:set-view("new"),  
    response:flush()
)}; 

(:~
 :  Saves a controller
~:)
declare function controller:save()
{
   let $identity-field := model:get-id-from-params(controller:model(),request:params())
   let $identity-value := for $fi in $identity-field return map:get(request:params(),$fi)[1]
   let $update := 
       try {
         if (fn:not($identity-value  = "") and fn:exists($identity-value)) 
         then controller:update()
         else controller:create()
   } catch($exception) {
         xdmp:rethrow()
       }
   return
   if(response:has-error()) 
   then (
     response:set-flash("error_message","Could not save"),
     response:flush()
   ) else (
      response:set-body($update),
      response:set-template("main"),
      response:set-format("html"),
      response:set-view("save"),  
      response:flush()
   )
};
 
declare function controller:edit()
{(
    response:set-body(controller:get()),
    response:set-title((controller:model()/@label, controller:model()/@name)[1]),
    response:set-template("main"),
    response:set-view("edit"), 
    response:flush()
)};

declare function controller:remove()
{
  let $delete := 
  try { 
     controller:delete( )
  } catch($exception) {
    response:set-error("404",$exception) 
  }
  return
  if(response:has-error()) then (
     response:set-flash("error_message","Could not Delete"),
     response:flush()
   ) else ( 
    response:set-flash("status",fn:string($delete)), 
    response:redirect(controller:name(),"remove")
  )
};

declare function controller:lookup()
{(
     response:set-body(model:lookup(controller:model(),request:params()))
    ,response:flush()
)};

declare function controller:put() 
{
    model:put(controller:model(),request:body())
};

declare function controller:post() 
{
    let $model := controller:model()
    let $uuidField := $model/domain:element[@name = "uuid"]
    let $key := domain:get-field-id($uuidField)
        
    let $uuid := fn:data(request:body()//*[fn:local-name(.) = $key])
    let $product :=     
        if($uuid and $uuid ne "") then 
            model:post(controller:model(),request:body())
        else 
            controller:put()
   return
   if(response:has-error()) 
   then (
     response:set-flash("error_message","Could not save"),
     response:flush()
   ) else (
      response:set-body($product),
      response:set-template("main"),
      response:set-format("html"),
      response:set-view("save"),  
      response:flush()
   )
};

declare function controller:fields()
{(
    response:set-view("fields"), 
    response:flush()
)};

declare function controller:import() {
    response:set-template("main"),
    response:set-view("import"),  
    response:flush()
};

declare function controller:export() {
    response:set-template("main"),
    response:set-view("export"),  
    response:flush()
};