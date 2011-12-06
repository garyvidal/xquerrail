xquery version "1.0-ml";

import module namespace admin = "http://marklogic.com/xdmp/admin" 
    at "/MarkLogic/admin.xqy";

declare variable $config := admin:get-configuration();

let $groupid := xdmp:group()
for $x in ("8093-pce-test-dav", "8094-pce-modules-test-dav", "8095-pce-test-schemas", "8096-pce-test-xcc")
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
for $x in ("pce-test-modules", "pce-test-schemas", "pce-test-triggers")
return
    try { xdmp:set($config, admin:database-delete($config, admin:database-get-id($config, $x))) } catch ($e) {}
,
admin:save-configuration-without-restart($config);

xquery version "1.0-ml";

import module namespace admin = "http://marklogic.com/xdmp/admin" 
    at "/MarkLogic/admin.xqy";

declare variable $config := admin:get-configuration();

let $groupid := xdmp:group()

for $x in ("pce-test-modules", "pce-test-schemas", "pce-test-triggers")
return
    try { xdmp:set($config, admin:forest-delete($config, admin:forest-get-id($config, $x), fn:true())) } catch ($e) {}
,

admin:save-configuration($config)
