xquery version "1.0-ml";
module namespace tag = "http://www.xquerrail-framework.com/tag";
import module namespace response = "http://www.xquerrail-framework.com/response"
   at "/_framework/response.xqy";

declare function tag:type()
{
   "inline"
};
declare function tag:buffers()
{
   "tag:breadcrumb"
};
declare function tag:apply($node,$response)
{
 let $data := response:data("breadcrumb")
 return
   <span>{
    for $b  at $pos in $data 
    return 
       if($pos ne fn:count($data)) 
       then  (<a href="#" title="{$b}">{$b}</a>, "&gt;")
       else $b
    }</span>
};
