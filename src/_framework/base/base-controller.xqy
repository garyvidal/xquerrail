xquery version "1.0-ml";
(:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
   Copyright 2011 - Gary Vidal

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::)

(:~
 : Controller :  Base Controller
 :               Provides Base Controller support for dynamic domain controllers support
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


(:~
 : Initializes the request with the controller.
 : This is important to support the ability to use the request and response functions properly.
~:)
declare function controller:initialize($request)
{(
   request:initialize($request),
   response:initialize(map:map(),$request),
   response:set-partial(request:partial())
)};
(:~
 : Returns the model associated with a given controller.
~:)
declare function controller:model()
{
   domain:get-controller-model(request:application(),request:controller())
};
(:~
 : Returns the controller definition defined in $application/$application-domain.xml
~:)
declare function controller:controller()
{
    domain:get-controller(request:application(),request:controller())
};
(:~
 : This supports the ability to dynamically invoke the controller directly.
 : The dispatcher will call invoke.  Changes to this function allow to support 
 : new methods not available across all controllers.
~:)
declare function controller:invoke($action)
{
 response:set-model(controller:model()),
 (
   (:REST:)
   if($action eq "create")      then controller:list()
   else if($action eq "update") then controller:update()
   else if($action eq "get")    then controller:get()
   else if($action eq "delete") then controller:delete()
   else if($action eq "list")   then controller:list()
   else if($action eq "search") then controller:search()
   else if($action eq "put") then controller:put()
   else if($action eq "post") then controller:post()
   (:HTML:)   
   else if($action eq "new")    then controller:new()
   else if($action eq "edit")   then controller:edit()
   else if($action eq "remove") then controller:remove()  
   else if($action eq "save")   then controller:save()
   else if($action eq "index")  then controller:index()
   else if($action eq "show")   then controller:show()
   else if($action eq "lookup") then controller:lookup()
   else if($action eq "fields") then controller:fields()
   else controller:main()   
 )
};
(:Controller Required Functions:)
 
(:~
 : Returns the name of a given controller
 : 
~:) 
declare function controller:name() {
   request:controller()[1]
}; 
(:~
 : The Main controller method is the fall through method
 : when no method/action is specified.  This is done to support
 : actionless methods such as put, post, get, delete, head, options
~:)
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
(:~
 : Returns an XML representation of the calls and parameters available
 : from a given controller.  This information should be based on the
 : public methods of the base controller and action parameters.
~:)
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
 : Creates an asset based on supplied parameters
~:) 
declare function controller:create() {
  model:create(controller:model(),request:params())
};

(:~
 :  Gets a model instance based on its defined parameters for retrieval
~:) 
declare function controller:get()
{
   model:get(controller:model(),request:params())
   
};
 
(:~
 : Updates a model instance.
 :) 
declare function controller:update()
{
  model:update(
    controller:model(),
    request:params()
  )
};
 
(:~
 :  Deletes a model instance
~:)  
declare function controller:delete()
{
    model:delete(
       controller:model(),
       request:params()
    )
};
 
(:~
 : Provide search interface for a model instance.
 : @param $query - Search query 
 : @param $pg  - Is the start index for the results
 : @param $ps    - Is the size of pages returned for the results
 : @param $sort  - Sorting element defined by model instance. Model field must have constraint/@sortable 
 :                 attribute defined.
~:)
declare function controller:search()
{
    model:search(
      controller:model(),
      request:params()
   )
};
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

(:~ 
 : Show a record 
~:)  
declare function controller:show()
{
 (   
    response:set-body(controller:get()),
    response:set-template("main"),
    response:set-view("show"),  
    response:flush()
 )     
};   

(:~ 
 : Create a new Record with Edit Capabilites for HTML forms 
~:) 
declare function controller:new()
{(  
    response:set-template("edit"),
    response:set-view("edit"),  
    response:flush()
)}; 

(:~
 :  HTML Action to make Saves a controller
~:)
declare function controller:save()
{
   let $uuid := request:param("uuid")
   let $_ := xdmp:log(request:body())
   let $update := 
       try {
         if ($uuid and $uuid ne "") 
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
    response:set-template("edit"),
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

(:~
 : Performs a lookup list from domain model based on 
 : key and keyLabel fields.  Make sure your model defines 
 : these keys for lookup to work properly
~:)
declare function controller:lookup()
{(
     response:set-body(model:lookup(controller:model(),request:params()))
    ,response:flush()
)};

(:~
 : Controller action to use HTTP PuT verb.  A put against the controller
 : will create a new instance of a given model
~:)
declare function controller:put() 
{
    model:put(controller:model(),request:body())
};

(:~
 : Controller action to perform POST(update) against a given controller model
 : It is required to pass in the uuid or id field defined by @identity attribute
 : for this to work properly.
~:)
declare function controller:post() 
{
    let $uuid := request:body()//*:uuid
    return
    if($uuid) then 
        model:post(controller:model(),request:body())
    else 
        controller:put()
};

(:~
 : HTML Method to support rendering only the fields with values populated
 : Will render only the fields from an html form.
~:)
declare function controller:fields()
{(
    response:set-view("fields"), 
    response:flush()
)};
