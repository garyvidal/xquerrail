xquery version "1.0-ml";
(:~
 : Default Application Controller
 : @author garyvidal@hotmail.com
~:)
module namespace controller = "http://www.xquerrail-framework.com/demo/controller/article";

import module namespace request = "http://www.xquerrail-framework.com/request"
    at "/_framework/request.xqy";
    
import module namespace response = "http://www.xquerrail-framework.com/response"
    at "/_framework/response.xqy";

declare function controller:initialize($request)
{
  request:initialize($request),
  response:initialize(map:map(),$request)
};

declare function controller:main()
{
  controller:index()
};
declare function controller:index()
{
  ()
};
declare function controller:show()
{(
    response:set-controller("article"),
    response:set-body(<h2>hello world  {request:param("title")}</h2>),
    response:set-action("index"),
    response:set-template("main"),
    response:set-view("index"),
    
    response:set-title(fn:concat(request:param("title"))),
    response:add-httpmeta("cache-control","public"),
    response:flush()
)};
