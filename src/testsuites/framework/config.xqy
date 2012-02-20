xquery version "1.0-ml";
(:~ tests for depx config module
:)
(: -------------------------------------------------------------------------------------------------------- :)
module namespace test = "http://github.com/robwhitby/xray/test";
import module namespace assert = "http://github.com/robwhitby/xray/assertions" at "/lib/xray/src/assertions.xqy";
(: -------------------------------------------------------------------------------------------------------- :)

import module namespace config = "http://www.xquerrail-framework.com/config" at "/_framework/config.xqy";

(: -------------------------------------------------------------------------------------------------------- :)

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
assert:not-empty($config:CONFIG),
assert:not-empty($config:ENGINE-PATH)
)
};


