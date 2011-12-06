xquery version "1.0-ml";

import module namespace setup = "http://marklogic.com/ps/setup" at "lib-setup.xqy";
import module namespace display = "http://marklogic.com/ps/setup/lib-display" at "lib-display.xqy";


let $config := xdmp:unquote(xdmp:get-request-field("configfile"))/configuration
let $set := xdmp:set-session-field("config", $config)

return
display:template("Map object names",
<div>
{ display:vertical-spacer(3) }
<form method="POST" action="import3.xqy" name="import">

<h3>Databases</h3>
<table>
<tr><th>Name</th><th>Import?</th><th>Name after import</th></tr>
{
for $database in setup:get-databases-from-config($config)
let $name := setup:get-database-name-from-database-config($database)
return
  <tr>
    <td>{$name}</td>
    <td><input type="checkbox" name="database-include|{$name}" checked="checked" /></td>
    <td><input type="text" name="database|{$name}" value="{$name}" size="20" /></td>
  </tr>
}
</table>

<h3>Forests</h3>
<table>
<tr><th>Name</th><th>Import?</th><th>Name after import</th><th>Data directory</th></tr>
{
for $forest in setup:get-forests-from-config($config)
let $name := setup:get-forest-name-from-forest-config($forest)
return
  <tr>
    <td>{$name}</td>
    <td><input type="checkbox" name="forest-include|{$name}" checked="checked" /></td>
    <td><input type="text" name="forest|{$name}" value="{$name}" size="20" /></td>
    <td><input type="text" name="forest-dir|{$name}" value="" size="30" /></td>
  </tr>
}
</table>


<h3>App Servers</h3>
<table>
<tr><th>Name</th><th>Type</th><th>Import?</th><th>Name after import</th><th>Port after import</th></tr>
{
let $servers := setup:get-servers-from-config($config)
for $i in (1 to fn:count($servers) idiv 3)
let $name := $servers[3 * $i - 2]
let $type := $servers[3 * $i - 1]
let $port := $servers[3 * $i]
return
  <tr>
    <td>{$name}</td>
    <td>{$type}</td>
    <td><input type="checkbox" name="server-include|{$name}" checked="checked" /></td>
    <td><input type="text" name="server|{$name}" value="{$name}" size="20" /></td>
    <td><input type="text" name="server-port|{$name}" value="{$port}" size="20" /></td>
  </tr>
}
</table>

{ display:vertical-spacer(2) }
<input type="submit" name="submit" value="Import"/>
</form>
{ display:vertical-spacer(25) }
</div>,
display:left-links()
)
