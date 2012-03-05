
xquery version "1.0-ml";
(:~
 : Demo Controller used for templates and inspiration
 : @author garyvidal@hotmail.com
~:)
module namespace controller = "http://www.xquerrail-framework.com/demo/controller/wijmo";

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
    response:set-controller("wijmo"),
    response:set-action("index"),
    response:set-template("wijmo-main"),
    response:set-view("index"),
    response:set-title("Wijmo Tests"),
    response:flush() 
};
declare function controller:containers()
{(
    response:set-controller("wijmo"),
    response:set-action("containers"),
    response:set-template("wijmo-main"),
    response:set-view("containers"),
    response:set-title("Wijmo Container Tests"),
    response:flush() 
)};
declare function controller:navigation()
{(
    response:set-controller("wijmo"),
    response:set-action("navigation"),
    response:set-template("wijmo-main"),
    response:set-view("navigation"),
    response:set-title("Wijmo Navigation Tests"),
    response:flush() 
)};
declare function controller:controls()
{(
    response:set-controller("wijmo"),
    response:set-action("controls"),
    response:set-template("wijmo-main"),
    response:set-view("controls"),
    response:set-title("Wijmo Control Tests"),
    response:flush()      
)};