xquery version "1.0-ml";
(:~ tests for depx config module
:)
(: -------------------------------------------------------------------------------------------------------- :)
module namespace test = "http://github.com/robwhitby/xray/test";
import module namespace assert = "http://github.com/robwhitby/xray/assertions" at "/_framework/lib/xray/src/assertions.xqy";
(: -------------------------------------------------------------------------------------------------------- :)

import module namespace config = "http://www.xquerrail-framework.com/config" at "/_framework/config.xqy";

(: -------------------------------------------------------------------------------------------------------- :)

declare variable $test-config := 
<config xmlns="http://www.xquerrail-framework.com/config">

    <!--Configurations-->
    <routes-config  resource="/_config/routes.xml"/>
    <routing-module resource="/_framework/routing.xqy"/>
    
    <interceptor-config resource="/_config/interceptor.xml"/>
    <interceptor-module resource="/_framework/interceptor.xqy"/>
    
    <environment-config resource="/_config/env.xml"/>
    
    <plugin-config resource="/_config/plugin.xml"/>
    
    <controller-scripts-directory value="/resources/scripts"/> 
    <controller-stylesheet-directory value="/resources/stylesheets"/>
    
    <error-handler resource="/_framework/error.xqy"/>    
    <resource-directory resource="/resources/test"/>
  
    <!--Suffix Configuration-->
    <controller-suffix value="-controller"/>
    <model-suffix value="-model"/>
    <library-suffix value="-lib"/>

    <anonymous-user value="anonymous-test"/> 
    
    <dispatcher resource="/_framework/dispatchers/dispatcher.web.xqy"/>
    
    <!--Register Default Values for engine-->
    <default-engine value="engine.html"/>
    <default-application value="test-application"/>
    <default-controller value="test"/> 
    <default-action value="test"/>    
    <default-format value="test"/>
    <default-template-directory resource="/_framework/base/templates/"/>
    <default-view-directory resources="/_framework/base/views/"/>    
  
    <application name="test" namespace="http://www.xquerrail-framework.com/test" uri="/test-application">
        <domain resource="/test-application/domains/domain.xml"/>
        <script-directory value="scripts"/>
        <stylesheet-directory value="stylesheets"/>
    </application>

    <!--Interceptors-->
    <interceptors config="/_config/interceptor.xml">
        <interceptor 
            name="ml-security" 
            resource="/_config/ml-security.xml"
            before-request="false" 
            after-request="true" 
            before-response="false" 
            after-response="false"
        />
    </interceptors>
</config>;
(:~ setup 
 :)
declare function setup()
{
   xdmp:set($config:CONFIG,$test-config)
};

(:~ 
teardown 
 :)
declare function teardown()
{()
};

declare function assert_default_application() {(
   setup(),
   assert:equal(config:default-application(),"test-application")
)};

declare function assert_default_controller() {(
   setup(),
   assert:equal(config:default-controller(),"test")  
)};

declare function assert_default_format() {(
   setup(),
   assert:equal(config:default-format(),"test")
)};

declare function assert_resource-directory() {(
   setup(),
   assert:equal(config:resource-directory(),"/resources/test")
)};
declare function assert_resource_application-directory() {(
   setup(),
   assert:equal(config:application-directory("test"),"/test-application")
)};

declare function assert_base-view-directory() {(
   setup(),
   assert:equal(config:base-view-directory(),"/_framework/base/views")
)};

declare function assert-anonymous-user-is-valid() {(
   setup(),
   assert:equal(config:anonymous-user(),"anonymous-test")
)};
declare function assert-anonymous-user-override-application() {(
   setup(),
   assert:equal(config:anonymous-user("test"),"anonymous-test")
)};

declare function assert_get-domain-is-not-empty() {(
   setup(),
   assert:not-empty(config:get-domain("test"))
)};

declare function assert_get-domain-is-error() {(
  setup(),
   assert:error-code(try { config:get-domain("foo")}catch($ex){$ex},"SVC-FILOPN")
)};

declare function assert_routes-is-not-empty() {(
   setup(),
   assert:not-empty(config:get-routes())
)};
declare function assert_get-engine(){
   let $response := map:map()
   let $_ := (map:put($response,"response:format","html"))
   return
     assert:equal(config:get-engine($response),"engine.html")
};
