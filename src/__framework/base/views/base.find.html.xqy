xquery version "1.0-ml";
import module namespace response = "http://www.xquerrail-framework.com/response" at "/_framework/response.xqy";
declare variable $response as map:map external;

response:initialize($response),
<ul>{
  for $f in response:body()//*:find
  return  
     <li>
        <a href="/{response:controller()}/show.html?id={$f/*:key}">{fn:string($f/*:label)}</a>
     </li>
}</ul>
