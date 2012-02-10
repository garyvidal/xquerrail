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



xquery version "1.0-ml";

module namespace lib = "http://www.xquerrail-framework.com/notification";

declare function add-notification(
$title,
$message,
$status
){
 let $id :=  xdmp:random()
 return
 (
  xdmp:document-insert(
     fn:concat("/notifications/notification-",$id,".xml"),
     <notification>
        <created>{fn:current-dateTime()}</created>
        <user>{xdmp:get-current-user()}</user>
        <received></received>
        <title>{$title}</title>
        <message>{$message}</message>
        <status>{$status}</status>
     </notification>,
     xdmp:default-permissions(),
     ("notification")
 ),
  $id
 )
};
(:
 : Returns a list 
:)
declare function get-notifications()
{
   for $n in /notification[user eq xdmp:get-current-user() and received eq ""]
   let $received := $n/received
   return
   (
     xdmp:node-replace($received,<received>{fn:current-dateTime()}</received>),
     $n 
   )
};