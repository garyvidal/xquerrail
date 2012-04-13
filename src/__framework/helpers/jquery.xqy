xquery version "1.0-ml;";

(:~
 : Supports JQuery Rending libraries for common jquery functions and utilities
~:)
module namespace jquery = "http://www.xquerrail-framework.com/helpers/jquery";

import module namespace js = "http://www.xquerrail-framework.com/helpers/js"
   at "javascript.xqy";

declare function jquery:jquery(
 $selector as xs:string,
 $chain as item()
){
   fn:concat("jQuery('",
     $selector,
     "').",
     fn:string-join($chain,"."),
     ";")        
};

declare function jquery:when(
 $selector as xs:string,
 $when as item(),
 $then as item()
){
   ()
};

declare function jquery:ajax(
$url as xs:string,
$settings as item()*
){
    ()
};

declare function jquery:addClass(
  $selector as xs:string,
  $className as xs:string
){(

)};

declare function jquery:addClassF(
  $selector as xs:string,
  $function as item()
){(

)};


