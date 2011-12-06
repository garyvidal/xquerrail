xquery version "1.0-ml";

import module namespace admin = "http://marklogic.com/xdmp/admin" 
    at "/MarkLogic/admin.xqy";

declare variable $config := admin:get-configuration();

let $groupid := xdmp:group()
for $x in ("8036-hmh-cs", "8037-pce", "8038-pce-dav", "8039-pce-modules-dav", "8040-pce-test", "8041-pce-schemas", "8042-pce-xcc", "8043-hmh-cs", "8037-hmh-pce", "8038-hmh-pce-dav", "8039-hmh-pce-modules-dav", "8040-hmh-pce-test", "8041-hmh-pce-schemas", "8042-hmh-pce-xcc", "8093-pce-test-dav", "8094-pce-modules-test-dav", "8095-pce-test-schemas", "8096-pce-test-xcc")
return
  try{
    xdmp:set($config, admin:appserver-delete($config, admin:appserver-get-id($config, $groupid, $x)))
  } catch($ex){()}
,
admin:save-configuration-without-restart($config);

xquery version "1.0-ml";

import module namespace admin = "http://marklogic.com/xdmp/admin" 
    at "/MarkLogic/admin.xqy";

declare variable $config := admin:get-configuration();

let $groupid := xdmp:group()
for $x in ("pce", "pce-modules", "pce-test", "pce-schemas", "pce-triggers", "hmh-pce", "hmh-pce-modules", "hmh-pce-test", "hmh-pce-schemas", "hmh-pce-triggers", "pce-test-modules", "pce-test-schemas", "pce-test-triggers")
return
    try { xdmp:set($config, admin:database-delete($config, admin:database-get-id($config, $x))) } catch ($e) {}
,
admin:save-configuration-without-restart($config);

xquery version "1.0-ml";

import module namespace admin = "http://marklogic.com/xdmp/admin" 
    at "/MarkLogic/admin.xqy";

declare variable $config := admin:get-configuration();

let $groupid := xdmp:group()

for $x in ("pce", "pce-modules", "pce-test", "pce-schemas", "pce-triggers", "hmh-pce", "hmh-pce-modules", "hmh-pce-test", "hmh-pce-schemas", "hmh-pce-triggers", "pce-test-modules", "pce-test-schemas", "pce-test-triggers")
return
    try { xdmp:set($config, admin:forest-delete($config, admin:forest-get-id($config, $x), fn:true())) } catch ($e) {}
,

admin:save-configuration($config);

xdmp:eval('import module namespace sec="http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy";
           try { sec:remove-user("hmh-nobody") } catch ($e) {}',
           (), <options xmlns="xdmp:eval"><database>{xdmp:database("Security")}</database></options>),
           
xdmp:eval('import module namespace sec="http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy";
           try { sec:remove-user("pce-default-user") } catch ($e) {}',
           (), <options xmlns="xdmp:eval"><database>{xdmp:database("Security")}</database></options>),
           
xdmp:eval('import module namespace sec="http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy";
           try { sec:remove-user("cs-default-user") } catch ($e) {}',
           (), <options xmlns="xdmp:eval"><database>{xdmp:database("Security")}</database></options>),
           
xdmp:eval('import module namespace sec="http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy";
           try { sec:remove-user("pce-test-user") } catch ($e) {}',
           (), <options xmlns="xdmp:eval"><database>{xdmp:database("Security")}</database></options>),

xdmp:eval('import module namespace sec="http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy";
           try { sec:remove-role("hmh-pce") } catch ($e) {}',
           (), <options xmlns="xdmp:eval"><database>{xdmp:database("Security")}</database></options>),

xdmp:eval('import module namespace sec="http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy";
           try { sec:remove-role("hmh-cs") } catch ($e) {}',
           (), <options xmlns="xdmp:eval"><database>{xdmp:database("Security")}</database></options>),

xdmp:eval('import module namespace sec="http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy";
           try { sec:remove-role("hmh-pce-test") } catch ($e) {}',
           (), <options xmlns="xdmp:eval"><database>{xdmp:database("Security")}</database></options>),

xdmp:eval('import module namespace sec="http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy";
           try { sec:remove-role("hmh-user") } catch ($e) {}',
           (), <options xmlns="xdmp:eval"><database>{xdmp:database("Security")}</database></options>)
