xquery version "1.0-ml";

import module namespace setup = "http://marklogic.com/ps/setup" at "lib-setup.xqy";
import module namespace display = "http://marklogic.com/ps/setup/lib-display" at "lib-display.xqy";

declare namespace xs="http://www.w3.org/2001/XMLSchema";
declare namespace db="http://marklogic.com/xdmp/database";
declare namespace gr="http://marklogic.com/xdmp/group";
declare namespace err="http://marklogic.com/xdmp/error";
declare namespace ho="http://marklogic.com/xdmp/hosts";
declare namespace as="http://marklogic.com/xdmp/assignments";
declare namespace sec="http://marklogic.com/xdmp/security";
declare namespace fs="http://marklogic.com/xdmp/status/forest";
declare namespace mt="http://marklogic.com/xdmp/mimetypes";
declare namespace pki="http://marklogic.com/xdmp/pki";


declare function local:remap-objects($import-config)
{
  local:xform-remap-objects($import-config, ())
};

declare function local:xform-remap-objects($x as node(), $arg)
{
  let $FN_XFORM := xdmp:function(xs:QName("local:xform-remap-objects"))
  return
  typeswitch ($x) 

  case element(db:database) return
    let $name := xs:string($x/db:database-name)
    let $include := xdmp:get-request-field(fn:concat("database-include|", $name), "")
    let $log := xdmp:log(fn:concat($name, " ", $include))
    return
      if ($include eq "on") then
        local:preserve-and-recurse($FN_XFORM, $x, $arg)
      else
        ()
        
  case element(db:database-name) return
    let $old-name := xs:string($x)
    let $new-name := xdmp:get-request-field(fn:concat("database|", $old-name), $old-name)
    let $log := xdmp:log(fn:concat($old-name, " ", $new-name))
    return
      if ($old-name eq $new-name) then
        $x
      else
        <db:database-name>{$new-name}</db:database-name>
        
  case element(as:assignment) return
    let $name := xs:string($x/as:forest-name)
    let $include := xdmp:get-request-field(fn:concat("forest-include|", $name), "")
    let $log := xdmp:log(fn:concat($name, " ", $include))
    return
      if ($include eq "on") then
        local:preserve-and-recurse($FN_XFORM, $x, $arg)
      else
        ()
        
  case element(as:forest-name) return
    let $old-name := xs:string($x)
    let $new-name := xdmp:get-request-field(fn:concat("forest|", $old-name), $old-name)
    return
      if ($old-name eq $new-name) then
        $x
      else
        <as:forest-name>{$new-name}</as:forest-name>
        
  case element(as:data-directory) return
    let $old-name := xs:string($x/../as:forest-name)
    let $directory := xdmp:get-request-field(fn:concat("forest-dir|", $old-name), "")
    return
      <as:data-directory>{$directory}</as:data-directory>
        
  case element(gr:http-server) return
    let $name := xs:string($x/gr:http-server-name)
    let $include := xdmp:get-request-field(fn:concat("server-include|", $name), "")
    let $log := xdmp:log(fn:concat($name, " ", $include))
    return
      if ($include eq "on") then
        local:preserve-and-recurse($FN_XFORM, $x, $arg)
      else
        ()
        
  case element(gr:xdbc-server) return
    let $name := xs:string($x/gr:xdbc-server-name)
    let $include := xdmp:get-request-field(fn:concat("server-include|", $name), "")
    let $log := xdmp:log(fn:concat($name, " ", $include))
    return
      if ($include eq "on") then
        local:preserve-and-recurse($FN_XFORM, $x, $arg)
      else
        ()
        
  case element(gr:port) return
    let $name := xs:string(($x/../gr:http-server-name, $x/../gr:xdbc-server-name))
    let $old-port := xs:string($x)
    let $new-port := xdmp:get-request-field(fn:concat("server-port|", $name), $old-port)
    return
      if ($old-port eq $new-port) then
        $x
      else
        <gr:port>{$new-port}</gr:port>
    
  case element(gr:http-server-name) return
    let $old-name := xs:string($x/../gr:http-server-name)
    let $new-name := xdmp:get-request-field(fn:concat("server|", $old-name), $old-name)
    return
      if ($old-name eq $new-name) then  
        $x
      else
        <gr:http-server-name>{$new-name}</gr:http-server-name>
    
  case element(gr:xdbc-server-name) return
    let $old-name := xs:string($x/../gr:xdbc-server-name)
    let $new-name := xdmp:get-request-field(fn:concat("server|", $old-name), $old-name)
    return
      if ($old-name eq $new-name) then  
        $x
      else
        <gr:xdbc-server-name>{$new-name}</gr:xdbc-server-name>
    
  case element() return
    local:preserve-and-recurse($FN_XFORM, $x, $arg)
              
  case document-node() return 
    local:xform-remap-objects($x/*[1], $arg)

  case processing-instruction() return 
    $x
    
  case comment() return 
    $x
    
  case text() return 
    $x

  default return 
    local:preserve-and-recurse($FN_XFORM, $x, $arg)
};

declare function local:transform-children($xform as xdmp:function, $x as element(), $arg) as node()*
{
  for $z in $x/node() 
  return xdmp:apply($xform, $z, $arg)
};

declare function local:preserve-and-recurse($xform as xdmp:function, $x as element(), $arg) as element()
{
  element { fn:node-name($x) }
  {
    $x/attribute::*,
    local:transform-children($xform, $x, $arg)
  }
};



let $import-config := xdmp:get-session-field("config", ())
let $import-config := local:remap-objects($import-config)

return
display:template("Import configuration",
<ul>
{ display:vertical-spacer(3) }

{
let $messages := setup:do-setup($import-config)
for $message in $messages
return <li>{$message}</li>
}

{ display:vertical-spacer(30) }
</ul>,
display:left-links()
)
