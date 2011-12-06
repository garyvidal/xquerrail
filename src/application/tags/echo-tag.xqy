xquery version "1.0-ml";
module namespace tag = "http://www.xquerrail-framework.com/tag";
import module namespace response = "http://www.xquerrail-framework.com/response"
   at "/_framework/response.xqy";
declare function tag:apply($node,$response)
{
   let $data := fn:data($node)
   return
     text {fn:replace($data,"%(.*)%","$1")}
};