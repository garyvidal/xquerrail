xquery version "1.0-ml";
(:Set Permissions on Unsecure Uris:)
let $stmt := 
'
    let $unsecure-uris := (
    "/default.xqy",
    "/login.xqy",
    "/checklogin.xqy",
    "/logout.xqy",
    "/rewriter.xqy",
    "/controller.xqy",
    "/application/view/common/common-view.xqy",
    "/application/model/user-model.xqy",
    "/application/lib/security.xqy",
    "/application/model/vendor-model.xqy"
)

let $permissions := (
   xdmp:permission("validator-nobody","execute"),
   xdmp:permission("validator-nobody","read"),  
   xdmp:permission("validator-modules","read"),
   xdmp:permission("validator-modules","insert"),
   xdmp:permission("validator-modules","update"),
   xdmp:permission("validator-modules","execute")
 )
for $uri in $unsecure-uris
return
xdmp:document-add-permissions($uri,$permissions)
'
return
xdmp:eval($stmt,(),
  <options xmlns="xdmp:eval">
    <database>{xdmp:modules-database()}</database>
  </options>
)
;

(:Initialize Webdav Modules filesystem:)
let $stmt := '
 let $permissions := (
   xdmp:permission("validator-modules","read"),
   xdmp:permission("validator-modules","insert"),
   xdmp:permission("validator-modules","update"),
   xdmp:permission("validator-modules","execute")
 )
return
if(xdmp:document-properties("/")) then
   xdmp:document-add-permissions("/",$permissions)
else 
   xdmp:directory-create("/",$permissions)
'
return
xdmp:eval($stmt,(),
  <options xmlns="xdmp:eval">
    <database>{xdmp:modules-database()}</database>
  </options>
);
xquery version "1.0-ml";

(:Set Permissions on Unsecure Uris:)
let $stmt := '
let $resources := cts:uris()[fn:starts-with(.,"/resources/")]

let $permissions := (
   xdmp:permission("validator-nobody","execute"),
   xdmp:permission("validator-nobody","read")
 )
for $uri in $resources
return
xdmp:document-add-permissions($uri,$permissions)
'
return
xdmp:eval($stmt,(),
  <options xmlns="xdmp:eval">
    <database>{xdmp:modules-database()}</database>
  </options>
);
"Executing FileSystem Done"
