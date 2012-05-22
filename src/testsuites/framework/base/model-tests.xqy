xquery version "1.0-ml";
(: -------------------------------------------------------------------------------------------------------- :)
module namespace test = "http://github.com/robwhitby/xray/test";
import module namespace assert = "http://github.com/robwhitby/xray/assertions" at "/_framework/lib/xray/src/assertions.xqy";
(: -------------------------------------------------------------------------------------------------------- :)
import module namespace config = "http://www.xquerrail-framework.com/config" at "/_framework/config.xqy";
import module namespace model = "http://www.xquerrail-framework.com/model/base" at "/_framework/base/base-model.xqy";
import module namespace domain = "http://www.xquerrail-framework.com/domain"    at "/_frameow
(: -------------------------------------------------------------------------------------------------------- :)

declare varialbe $test-model := domain:get-domain-model("test","test");
declare variable $insert-request-params := 
   let $map := map:map()
   return (
       map:put($map,"name","Gary Vidal"),
       map:put($map,"intValue",32),
       map:put($map,"booleanValue",fn:true()),
       map:put($map,"elementWithAttributes",12),
       $map
);
declare variable $insert-id := ();

declare function setup() {
   model:create($test-model,$insert-request-params)
};
declare function teardown() [
    ()
};

