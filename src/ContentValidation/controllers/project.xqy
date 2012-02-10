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



(:@AUTO-GENERATED@:)
xquery version "1.0-ml";
(:~
 : Controller :  project 
 :               Content Validation Framework
 : @author   Gary Vidal
 : @version  1.0  
~:)

module namespace controller = "/controller/project";

import module namespace response =  "http://www.xquerrail-framework.com/response"
   at "../../_framework/response.xqy";
   
import module namespace request =  "http://www.xquerrail-framework.com/request"
   at "../../_framework/request.xqy";

(:Default Imports:)
declare namespace search = "http://marklogic.com/appservices/search";

(:~
 : Controller Definition 
~:)
declare variable $domain:controller as element(domain:controller) := 
<controller xmlns="http://www.xquerrail-framework.com/domain" name="project" model="project">
        <!--Rest Actions-->
        <action name="list" handles="list" default-template="list"/>
        <action name="update" handles="update"/>
        <action name="delete" handles="delete"/>
        <action name="add" handles="create"/>
        <action name="collection" handles="collection"/>
        <action name="get" handles="get"/>
        <action name="info" handles="info"/>
        <action name="search" handles="search"/>
        <action name="validate" handles="validate"/>          
        <!--Web Actions-->
        <action name="index"/>
        <action name="find"/>
        <action name="show"/>
        <action name="edit"/>
        <action name="remove"/>
        <action name="new"/>
    </controller>
;
(:~
 : Search Options Configuration
~:)



(:Options Definition:)
declare option xdmp:mapping "false";

declare variable $collation := "http://marklogic.com/collation/codepoint";

  
(:Controller Required Functions:)
 
declare function controller:name() {
"project"
}; 

declare function controller:main($request)
{
   if(request:format() eq "xml") 
   then (
      response:format(request:format()),
      response:template("main"),
      response:view("info"),
      response:flush()
   ) else (
     controller:index()  
   )
);

  declare function controller:info() { 
  <info xmlns:domain="http://www.xquerrail-framework.com/domain"
      xmlns:search="http://marklogic.com/appservices/search"
      xmlns:util="http://www.xquerrail-framework.com/lib/utilities"/>
};

 

(:Controller HTML Functions:)
 
(:~
 : Default Index Page 
~:)
declare function controller:index()
{
  response:template("main"),
  response:view("index"),
  response:data(controller:list(request:request())),
  response:flush()
};

 (:~ Show a record ~:) 
 
declare function controller:index()
{
   let $get := controller:show()
   return
   (
        response:data("context",$update),
        ,
        response:template("main"),
        response:view("new"),  
        response:flush()
    )     
};   

declare function controller:new()
{
	   let $create := controller:create()
	   return
	   (
	      response:data("context",$create),
	      ,
	      response:template("main"),
	      response:view("new"),  
	      response:flush()
	   )  
}; 

  declare function controller:edit()
  {
     let $update := controller:get(request:params())
     return
     (
        response:data("context",$update),
        ,
        response:template("main"),
        response:view("edit"),  
        response:flush()
     )
  };


declare function controller:remove()
{
  let $delete := 
  try { 
     controller:delete(request:params())
  } catch($exception) {
    response:error("404",$exception) 
  }
  return
  if(response:has-error()) then (
     response:flash("error_message","Could not Delete"),
     response:flush()
   ) else ( 
      response:flash("status",fn:status($delete)), 
      response:redirect(controller:url(controller:name(),"index"))
      response:flush()
  )
};

(:~
 : Finds Records
~:)
declare function controller:find()
{
  let $find := 
  try { 
    controller:search()
  } catch($exception) {
    response:error("404",$exception) 
  }
  return
	  if(response:error()) then (
	     response:flash("error_message",re