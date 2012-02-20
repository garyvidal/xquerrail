xquery version "1.0-ml";

module namespace test = "http://github.com/robwhitby/xray/test";
import module namespace assert = "http://github.com/robwhitby/xray/assertions" at "/lib/xray/src/assertions.xqy";

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
(
assert:equal($route:routes,       <routes xmlns="http://www.xquerrail-framework.com/routing">
	<route id="_resources" pattern="^/resources/*" is-resource="true">
	  <prepend></prepend>
	</route>
	<route id="_xray" pattern="^/xray/?$" is-resource="true">
	  <to>/_framework/xray/index.xqy</to>
	</route>
	<!--Default Controller Routes-->
	<route id="_default" pattern="^/(index\.html)?$">
	  <default key="_controller">application:default:index:html</default>
	</route>
	<route id="_logout" pattern="^/(logout\.html)?$">
	  <default key="_controller">application:default:logout:html</default>
	</route>
	<route id="_search" pattern="^/(search\.html)?$">
	  <default key="_controller">application:default:search:html</default>
	</route>
	<!--Default Routes-->
	<route id="controller_index" pattern="^/(\i\c*)/?$">
	  <default key="_controller">application:$1:index:html</default>
	</route>
	<route id="controller_index_format" pattern="^/(\i\c*)/(\i\c*)(\.xml|\.json|\.html)$">
	  <default key="_controller">application:$1:$2:$3</default>
	</route>
	<route id="controller_default_get" pattern="^/(.*[^/])/(\i\c*[^/])(\.xml|\.json|\.html)$" method="get">
	  <default key="_controller">application:$1:get:$3</default>
	</route>
	<route id="controller_default_update" pattern="^/(.*[^/])/(\i\c*[^/])(\.xml|\.json|\.html)$" method="post">
	  <default key="_controller">application:$1:update:$3</default>
	</route>
	<route id="controller_default_delete" pattern="^/(\i\c*)/(\i\c*[^/])\.(json|html)$" method="delete">
	  <default key="_controller">application:$1:delete:$3</default>
	</route>
	<route id="controller_default_create" pattern="^/(.*[^/])/(\i\c*[^/])\.(json|html)$" method="put">
	  <default key="_controller">application:$1:put:$3</default>
	</route>
	<route id="controller_default_action" pattern="^/(\i\c*[^/])/(\i\c*[^/])(\.json|\.html|\.xml)?$" method="post">
	  <default key="_controller">application:$1:$2:$3</default>
	</route>
      </routes>)
)
};


declare function testRequest(){

let $c := route:get-route('/')
return
assert:equal($c,'/_framework/dispatchers/dispatcher.web.xqy?_action=index&amp;_application=application&amp;_controller=default&amp;_format=html&amp;_route=_default')
};
