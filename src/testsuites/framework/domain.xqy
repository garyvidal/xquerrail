xquery version "1.0-ml";
(:~ tests for depx config module
:)
(: -------------------------------------------------------------------------------------------------------- :)
module namespace test = "http://github.com/robwhitby/xray/test";
import module namespace assert = "http://github.com/robwhitby/xray/assertions" at "/lib/xray/src/assertions.xqy";
(: -------------------------------------------------------------------------------------------------------- :)

import module namespace domain = "http://www.xquerrail-framework.com/domain" at "/_framework/domain.xqy";

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



declare function testResolveDatatype1(){

let $field := <test type="uuid"/>
let $c := domain:resolve-datatype($field)
return
  assert:equal ($c, 'xs:string')
};

declare function testResolveDatatype2(){

let $field := <test type="grid"/>
let $c := domain:resolve-datatype($field)
return
  assert:equal ($c, 'element()')
};

declare function testResolveDatatype3(){

let $field := <test type="identity"/>
let $c := domain:resolve-datatype($field)
return
  assert:equal ($c, 'xs:ID')
};

declare function testResolveDatatype4(){

let $field := <test type="create-timestamp"/>
let $c := domain:resolve-datatype($field)
return
  assert:equal ($c, 'xs:dateTime')
};

declare function testResolveDatatype5(){

let $field := <test type="uuid"/>
let $c := domain:resolve-datatype($field)
return
  assert:equal ($c, 'xs:string')
};

declare function testResolveDatatype6(){

let $field := <test type="reference"/>
let $c := domain:resolve-datatype($field)
return
  assert:equal ($c, 'element()')
};


declare function testGetControllers(){

let $c := domain:get-controllers("application")
return
  assert:equal ($c,
      (<controller name="countryCodes" model="countryCode" label="Country Codes" xmlns="http://www.xquerrail-framework.com/domain"></controller>,
      <controller name="timezones" model="timezone" label="Time Zones" xmlns="http://www.xquerrail-framework.com/domain"></controller>,
      <controller name="locales" model="locale" label="Locales" xmlns="http://www.xquerrail-framework.com/domain"></controller>,
      <controller name="users" model="user" label="Users" xmlns="http://www.xquerrail-framework.com/domain"></controller>,
      <controller name="roles" model="role" label="Roles" xmlns="http://www.xquerrail-framework.com/domain"></controller>,
      <controller name="taxonomy" model="taxonomy" label="Taxonomies" xmlns="http://www.xquerrail-framework.com/domain"></controller>,
      <controller name="term" model="term" label="Terms" xmlns="http://www.xquerrail-framework.com/domain"></controller>,
      <controller name="foos" model="foo" label="Foo Baby" xmlns="http://www.xquerrail-framework.com/domain"></controller>)
)
};



declare function testGetDomainModel(){

let $c := domain:get-domain-model("countryCode")
return
  assert:equal ($c,
      <model name="countryCode" description="Country Code Controlled Vocabulary" persistence="document" key="id" keyLabel="name" xmlns="http://www.xquerrail-framework.com/domain">
	<document root="countryCodes">/codetables/countryCodes.xml</document>
	<declare-namespace prefix="demo" namespace-uri="www.xquerrail-framework.com/demo/application"></declare-namespace>
	<element name="id" type="string" identity="true" label="ISO Country Code">
	  <navigation searchable="true" sortable="true" facetable="true"></navigation>
	  <constraint required="true"></constraint>
	</element>
	<element name="name" type="string" label="Name">
	  <navigation searchable="true" sortable="true"></navigation>
	  <constraint required="true"></constraint>
	</element>
	<element name="ISO3" type="string" label="ISO 3">
	  <navigation searchable="true" sortable="true"></navigation>
	  <constraint required="true"></constraint>
	</element>
	<element name="ISO4" type="string" label="ISO 4">
	  <navigation searchable="true" sortable="true"></navigation>
	  <constraint required="true"></constraint>
	</element>
      </model>
)
};



