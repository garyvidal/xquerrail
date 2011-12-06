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