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

