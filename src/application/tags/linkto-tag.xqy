xquery version "1.0-ml";

module namespace tag = "http://www.xquerrail-framework.com/tag";

import module namespace response = "http://www.xquerrail-framework.com/response" at "/_framework/response.xqy";   
declare function tag:apply($node,$response)
{
   let $data := xdmp:unquote("<tag:linkto ",fn:data($node),"/>")/*
   return
     element a {
       attribute href {$data/@url},
       $data/@*[. except ($data/@text|$data/@url)],
       text {$data/@text}
     }    
};