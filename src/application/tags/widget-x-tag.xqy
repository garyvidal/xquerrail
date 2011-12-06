xquery version "1.0-ml";
module namespace tag = "http://www.xquerrail-framework.com/tag";
import module namespace response = "http://www.xquerrail-framework.com/response"
   at "/_framework/response.xqy";
   
declare function tag:apply($node,$response)
{
   let $data := xdmp:unquote(fn:concat("<tag ", fn:data($node)," />"))
   let $condition := $data/@condition
   return
     if($condition eq "true") 
     then <span>This is true</span>
     else <span>This is false</span>
};
