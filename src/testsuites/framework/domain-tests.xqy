xquery version "1.0-ml";
(:~ tests for depx config module
:)
(: -------------------------------------------------------------------------------------------------------- :)
module namespace test = "http://github.com/robwhitby/xray/test";


(: -------------------------------------------------------------------------------------------------------- :)
import module namespace assert = "http://github.com/robwhitby/xray/assertions" at "/_framework/lib/xray/src/assertions.xqy";
import module namespace domain = "http://www.xquerrail-framework.com/domain" at "/_framework/domain.xqy";
import module namespace config = "http://www.xquerrail-framework.com/config" at "/_framework/config.xqy";
(: -------------------------------------------------------------------------------------------------------- :)

(:~ 
 : Setup 
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

let $field := <test type="point"/>
let $c := domain:resolve-datatype($field)
return
  assert:equal ($c, 'cts:point')
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


declare function get-controllers-match-count(){

let $c := domain:get-controllers("test")
return
  assert:equal (fn:count($c),6)
};

declare function assert_get-domain-model() {(

let $c := domain:get-domain-model("countryCode")
return
  assert:not-empty($c)
)};

declare function assert_get-controller-model-is-valid() {(
    assert:equal(domain:get-controller-model("test","countryCodes")/fn:string(@name),"countryCode")
)};

declare function assert_get-domain-model_without_application_name() {
   assert:empty(domain:get-domain-model("countryCodes"))
};

declare function assert_get-controller-name() {( 
    assert:equal(domain:get-controller-name("test","countryCode"),"countryCodes")
)};

declare function assert_get-domain-model-extends-2-param() {(
   assert:not-empty(domain:get-domain-model("test","countryCode")//*:uuid)
)};

declare function assert_get-default-application() {(
   assert:equal(domain:get-default-application(),"application")
)};

declare function assert_get-default-namespace-1-param() {(
   assert:equal(domain:get-default-namespace("test"),"http://www.xquerrail-framework.com/test")
)};

declare function assert_get-inscope-namespaces() {
   assert:equal(domain:get-domain-model("test","countryCode"),"foo")
};

declare function assert_model-selector(){
   assert:equal(
      domain:model-selector("test","authority")/fn:data(@name),
      ("countryCode","timezone")
   )   
};
