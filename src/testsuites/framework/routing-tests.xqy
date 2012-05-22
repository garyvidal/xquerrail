xquery version "1.0-ml";

module namespace test = "http://github.com/robwhitby/xray/test";

import module namespace assert = "http://github.com/robwhitby/xray/assertions" at "/_framework/lib/xray/src/assertions.xqy";
import module namespace route = "http://www.xquerrail-framework.com/routing" at "/_framework/routing.xqy";


(:~ setup 
 :)
declare function setup()
{
  xdmp:document-insert("doc1.xml", <doc1>foo bar</doc1>, xdmp:default-permissions(), "test")
};

(:~ teardown 
 :)
declare function teardown()
{
  xdmp:document-delete("doc1.xml")
};

(:~ test module Loading
 :
 :)
declare function moduleLoading()
{
  let $foo := "foo"
  let $bar := "bar"
  return (
    assert:not-empty($foo),
    assert:equal($foo, "foo"),
    assert:not-equal($foo, $bar)
  )
};


declare function testParams()
{
 assert:equal(1,1)
};


declare function testRequest(){

let $c := route:get-route('/')
return
assert:equal($c,'/_framework/dispatchers/dispatcher.web.xqy?_action=index&amp;_application=application&amp;_controller=default&amp;_format=html&amp;_route=_default')
};
