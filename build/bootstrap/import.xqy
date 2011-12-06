xquery version "1.0-ml";

import module namespace setup = "http://marklogic.com/ps/setup" at "lib-setup.xqy";
import module namespace display = "http://marklogic.com/ps/setup/lib-display" at "lib-display.xqy";


let $set := xdmp:set-session-field("config", ())

return
display:template("Choose file to import",
<div>
{ display:vertical-spacer(3) }
<form method="POST" action="import2.xqy" name="import" enctype="multipart/form-data">
  <p>Choose configuration file to import</p>
  <input type="file" name="configfile" size="100"/> 
  <input type="submit" name="submit" value="Import"/>
</form>
{ display:vertical-spacer(30) }
</div>,
display:left-links()
)
