xquery version "1.0-ml";

module namespace test = "http://github.com/robwhitby/xray/test";

import module namespace assert = "http://github.com/robwhitby/xray/assertions" at "/_framework/lib/xray/src/assertions.xqy";
import module namespace route = "http://www.xquerrail-framework.com/routing" at "/_framework/routing.xqy";

declare variable $test-response := 
map:map(
<map:map>
 

</map:map>
);
(:~ setup 
 :)
declare function setup()
{
  ()
};

(:~ teardown 
 :)
declare function teardown()
{
 ()
};
 