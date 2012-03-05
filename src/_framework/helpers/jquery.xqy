xquery version "1.0-ml;";

(:~
 : Supports JQuery Rending libraries for common jquery functions and utilities
~:)
module namespace jquery = "http://www.xquerrail-framework.com/helpers/jquery";

import module namespace js = "http://www.xquerrail-framework.com/helpers/js"
   at "javascript.xqy";

declare function jquery:ajax-settings()
{
   ("accepts","async","beforeSend","cache","complete",
    "contents","contentType","context","converters",
    "crossDomain","data","string:dataType","function:error","boolean:global"
    
};
declare function jquery:ajax(
$url as xs:string,
$settings as item()*
)
{
  ()
};


