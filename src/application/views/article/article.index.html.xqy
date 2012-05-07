xquery version "1.0-ml";

import module namespace response = "http://www.xquerrail-framework.com/response" 
at "/_framework/response.xqy";

declare variable $response as map:map external;

<div>
{ response:initialize($response),
  response:body()
}</div>
