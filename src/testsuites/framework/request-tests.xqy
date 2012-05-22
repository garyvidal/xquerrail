xquery version "1.0-ml";

module namespace test = "http://github.com/robwhitby/xray/test";

import module namespace assert = "http://github.com/robwhitby/xray/assertions" at "/_framework/lib/xray/src/assertions.xqy";
import module namespace request = "http://www.xquerrail-framework.com/request" at "/_framework/request.xqy";


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
(
assert:equal($request:BODY, "request:body"),
assert:equal($request:BODY-XML, "request:body-xml")
)
};


declare function testRequest(){

let $c := request:request()
return
assert:equal($c,
<map:map xmlns:map="http://marklogic.com/xdmp/map" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema"></map:map>)

};
