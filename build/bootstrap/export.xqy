xquery version "1.0-ml";

import module namespace setup = "http://marklogic.com/ps/setup" at "lib-setup.xqy";
import module namespace display = "http://marklogic.com/ps/setup/lib-display" at "lib-display.xqy";
declare namespace sec="http://marklogic.com/xdmp/security";


let $databases := xdmp:get-request-field("databases", "")
let $forests := xdmp:get-request-field("forests", "")
let $servers := xdmp:get-request-field("servers", "")
let $user-ids as xs:unsignedLong* := 
  for $x in xdmp:get-request-field("users", ())
  return
    xs:unsignedLong($x)
let $role-ids as xs:unsignedLong* :=
  for $x in xdmp:get-request-field("roles", ())
  return
    xs:unsignedLong($x)
let $submit := xdmp:get-request-field("submit", "")

return
if ($submit eq "Export") then

  let $config := setup:get-configuration($databases, $forests, $servers, $user-ids, $role-ids, ())
  let $type := xdmp:add-response-header("Content-Type", "text/xml")
  let $disp := xdmp:add-response-header("Content-Disposition", "attachment; filename=config.xml")
  return $config
  
else
display:template("Export Configuration",
<div>
<form method="POST" action="export.xqy" name="export">
  <table class="foo" width="100%" style="border-width:0px">
  <tr>
    <td valign="top" style="border-width:0px">
      <h3>Databases</h3>
      {
        let $databases := xdmp:database-name(xdmp:databases())
        for $database in $databases
        order by $database
        return (<input type="checkbox" name="databases" value="{$database}" />, $database, <br/>)
      }
    </td>
    <td valign="top" style="border-width:0px">
      <h3>Forests</h3>
      {
        let $forests := xdmp:forest-name(xdmp:forests())
        for $forest in $forests
        order by $forest
        return (<input type="checkbox" name="forests" value="{$forest}" />, $forest, <br/>)
      }
    </td>
    <td valign="top" style="border-width:0px">
      <h3>App Servers</h3>
      {
        let $servers := xdmp:server-name(xdmp:servers())
        for $server in $servers
        order by $server
        return (<input type="checkbox" name="servers" value="{$server}" />, $server, <br/>)
      }
    </td>
    <td valign="top" style="border-width:0px">
      <h3>Users</h3>
      {
        for $user in xdmp:eval("/sec:user", (), <options xmlns="xdmp:eval">
                                                  <database>{xdmp:database("Security")}</database>
                                                </options>)
        order by $user/sec:user-name
        return (<input type="checkbox" name="users" value="{$user/sec:user-id}" />, $user/sec:user-name, <br/>)
      }
    </td>
    <td valign="top" style="border-width:0px">
      <h3>Roles</h3>
      {
        for $user in xdmp:eval("/sec:role", (), <options xmlns="xdmp:eval">
                                                  <database>{xdmp:database("Security")}</database>
                                                </options>)
        order by $user/sec:role-name
        return (<input type="checkbox" name="roles" value="{$user/sec:role-id}" />, $user/sec:role-name, <br/>)
      }
    </td>
  </tr>
  </table>
  
  <input type="submit" name="submit" value="Export"/>
</form>
</div>,
display:left-links()
)
