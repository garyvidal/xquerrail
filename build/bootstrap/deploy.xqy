xquery version "1.0-ml";
 
module namespace deploy = "http://www.marklogic.com/deploy";

import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";
import module namespace dom = "http://marklogic.com/cpf/domains" at "/MarkLogic/cpf/domains.xqy";

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

declare variable $deploy:go-config as element(configuration) := admin:get-configuration();

declare function deploy:get-app-servers($names as xs:string*) {
  let $groups := deploy:read-config-file("groups.xml")/gr:groups
  return
    <http-servers xsi:schemaLocation="http://marklogic.com/xdmp/group group.xsd"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xmlns="http://marklogic.com/xdmp/group">
      {$groups/gr:group/gr:http-servers/gr:http-server[gr:http-server-name = $names]}
    </http-servers>
};

declare function deploy:get-forests($names as xs:string*) {
  let $assignments := deploy:read-config-file("assignments.xml")/as:assignments
  return
    <assignments xsi:schemaLocation="http://marklogic.com/xdmp/assignments assignments.xsd"
                 xmlns="http://marklogic.com/xdmp/assignments"
                 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      {$assignments/as:assignment[as:forest-name = $names]}
    </assignments>
};

declare function deploy:get-databases($names as xs:string*) {
  let $dbs := deploy:read-config-file("databases.xml")/db:databases
  return
    <databases xsi:schemaLocation="http://marklogic.com/xdmp/database database.xsd"
               xmlns="http://marklogic.com/xdmp/database"
               xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      {$dbs/db:database[db:database-name = $names]}
    </databases>
};

declare function deploy:get-mimetypes($names as xs:string*) {
  let $mimes := deploy:read-config-file("mimetypes.xml")/mt:mimetypes
  return
    <mimetypes xsi:schemaLocation="http://marklogic.com/xdmp/mimetypes mimetypes.xsd"
               xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
               xmlns="http://marklogic.com/xdmp/mimetypes">
      {$mimes/mt:mimetype[mt:name = $names]}
    </mimetypes>
};

declare function deploy:get-configuration() {
  let $app-servers := deploy:get-app-servers(("8037-hmh-pce", "8038-hmh-pce-dav", "8039-hmh-pce-modules-dav"))
  let $forests := deploy:get-forests(("hmh-pce", "hmh-pce-modules", "hmh-pce-triggers"))
  let $databases := deploy:get-databases(("hmh-pce", "hmh-pce-modules", "hmh-pce-triggers"))
  let $mimetypes := deploy:get-mimetypes(())
  return
    <configuration>
      {($app-servers, $forests, $databases, $mimetypes)}
    </configuration>
};

declare function deploy:create-http-server($config as element(configuration),
                                           $http-server as element(gr:http-server),
                                           $modules-db-name as xs:string,
                                           $db-name as xs:string) {

  let $config := admin:http-server-create($config, xdmp:group(),
                                          $http-server/gr:http-server-name,
                                          $http-server/gr:root,
                                          $http-server/gr:port,
                                          admin:database-get-id($config, $modules-db-name),
                                          admin:database-get-id($config, $db-name))
  let $config :=
    <configuration>
      {$config/*[fn:not(self::gr:groups)]}
      <groups xsi:schemaLocation="http://marklogic.com/xdmp/group group.xsd"
              xmlns="http://marklogic.com/xdmp/group"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
        <group>
          {$config/gr:groups/gr:group/*[fn:not(self::gr:http-servers)]}
          <http-servers>
            {$config/gr:groups/gr:group/gr:http-servers/gr:http-server[gr:http-server-name != $http-server/gr:http-server-name]}
            {
              let $new-server := $config/gr:groups/gr:group/gr:http-servers/gr:http-server[gr:http-server-name = $http-server/gr:http-server-name]
              return
                <http-server>
                {
                  $new-server/gr:http-server-id,
                  $new-server/gr:modules,
                  $new-server/gr:database,
                  $new-server/gr:default-user,
                  $new-server/gr:ssl-require-client-certificate,
                  $http-server/*[fn:not(self::gr:http-server-id) and
                                 fn:not(self::gr:modules) and
                                 fn:not(self::gr:database) and
                                 fn:not(self::gr:default-user)]
                }
                </http-server>
            }
          </http-servers>
        </group>
      </groups>
    </configuration>
  return
    $config
};

declare function deploy:create-webdav-server($config as element(configuration),
                                             $http-server as element(gr:http-server),
                                             $db-name as xs:string) {

  let $config := admin:webdav-server-create($config,
                                            xdmp:group(),
                                            $http-server/gr:http-server-name,
                                            $http-server/gr:root,
                                            $http-server/gr:port,
                                            admin:database-get-id($config, $db-name))
  let $config :=
    <configuration>
      {$config/*[fn:not(self::gr:groups)]}
      <groups xsi:schemaLocation="http://marklogic.com/xdmp/group group.xsd"
              xmlns="http://marklogic.com/xdmp/group"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
        <group>
          {$config/gr:groups/gr:group/*[fn:not(self::gr:http-servers)]}
          <http-servers>
            {$config/gr:groups/gr:group/gr:http-servers/gr:http-server[gr:http-server-name != $http-server/gr:http-server-name]}
            {
              let $new-server := $config/gr:groups/gr:group/gr:http-servers/gr:http-server[gr:http-server-name = $http-server/gr:http-server-name]
              return
                <http-server>
                {
                  $new-server/gr:http-server-id,
                  $new-server/gr:modules,
                  $new-server/gr:database,
                  $new-server/gr:default-user,
                  $new-server/gr:ssl-require-client-certificate,
                  $http-server/*[fn:not(self::gr:http-server-id) and
                                 fn:not(self::gr:modules) and
                                 fn:not(self::gr:database) and
                                 fn:not(self::gr:default-user)]
                }
                </http-server>
            }
          </http-servers>
        </group>
      </groups>
    </configuration>
  return
    $config
};

declare function deploy:delete-app-server($config as element(configuration), $server-name as xs:string) {
  admin:appserver-delete($config,
                         admin:appserver-get-id($config, xdmp:group(), $server-name))
};

declare function deploy:create-database($config as element(configuration),
                                        $db as element(db:database),
                                        $old-config as element(configuration)) {
  let $config := admin:database-create($config, $db/db:database-name, xdmp:database("Security"), xdmp:database("Schemas"))
  let $config :=
    <configuration>
      <databases xsi:schemaLocation="http://marklogic.com/xdmp/database database.xsd"
                 xmlns="http://marklogic.com/xdmp/database"
                 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
        {$config/db:databases/db:database[db:database-name != $db/db:database-name]}
        {
          let $new-db := $config/db:databases/db:database[db:database-name = $db/db:database-name]
          let $forest-names as xs:string* := 
            for $forest-id as xs:unsignedLong in $db/db:forests/db:forest-id
            return
              admin:forest-get-name($old-config, $forest-id)
          let $forest-ids as xs:unsignedLong* := 
            for $forest-name in $forest-names
            return
              admin:forest-get-id($config, $forest-name)
          return
            <database>
            {
              $new-db/db:database-id,
              $new-db/db:security-database,
              $new-db/db:schema-database,
              $new-db/db:triggers-database,
              if ($forest-ids) then
                <forests>
                {
                  for $forest-id in $forest-ids
                  return
                    <forest-id>{$forest-id}</forest-id>
                }
                </forests>
              else
                $new-db/db:forests,
              $new-db/db:reindexer-timestamp,
              $db/*[fn:not(self::db:database-id) and
                    fn:not(self::db:security-database) and
                    fn:not(self::db:schema-database) and
                    fn:not(self::db:triggers-database) and
                    fn:not(self::db:forests) and
                    fn:not(self::db:reindexer-timestamp)]
            }
            </database>
          }
      </databases>
      {$config/*[fn:not(self::db:databases)]}
    </configuration>
  return
    $config
};

declare function deploy:delete-database($config as element(configuration), $database-name as xs:string) {
  admin:database-delete($config, admin:database-get-id($config, $database-name))
};

declare function deploy:create-forest($config as element(configuration), $as as element(as:assignment)) {
  let $config := admin:forest-create($config, $as/as:forest-name, xdmp:host(), ())
  return
    $config
};


declare function deploy:delete-forest($config as element(configuration),
                                      $forest-name as xs:string,
                                      $delete-data as xs:boolean) {
  admin:forest-delete($config, admin:forest-get-id($config, $forest-name), $delete-data)
};

declare function deploy:go($config as element(configuration)) {
  let $create-forests :=
    for $as in $config/as:assignments/as:assignment
    let $next-config := deploy:create-forest($deploy:go-config, $as)
    return
      xdmp:set($deploy:go-config, $next-config)
  let $save-forests := admin:save-configuration-without-restart($deploy:go-config)

  let $update-config := xdmp:set($deploy:go-config, admin:get-configuration())

  let $create-databases :=
    for $db in $config/db:databases/db:database
    let $next-config := deploy:create-database($deploy:go-config, $db, $config)
    return
      xdmp:set($deploy:go-config, $next-config)
  let $save-databases := admin:save-configuration-without-restart($deploy:go-config)
  
  let $update-config := xdmp:set($deploy:go-config, admin:get-configuration())
  
  let $update-databases :=
    for $db in $config/db:databases/db:database
    let $next-config := 
      let $db-id := admin:database-get-id($deploy:go-config, $db/db:database-name)
      let $trig-name as xs:string? := 
        if ($db/db:triggers-database != 0) then
          admin:database-get-name($config, $db/db:triggers-database)
        else ()
      let $log := xdmp:log("trigger-db-name:")
      let $log := xdmp:log($trig-name)
      return
        if ($trig-name) then
          let $trig-id := admin:database-get-id($deploy:go-config, $trig-name)
          return
            admin:database-set-triggers-database($deploy:go-config, $db-id, $trig-id)
        else $deploy:go-config
    return
      xdmp:set($deploy:go-config, $next-config)
  let $save-databases := admin:save-configuration-without-restart($deploy:go-config)

  let $update-config := xdmp:set($deploy:go-config, admin:get-configuration())

  let $create-http-servers :=
    for $http-server in $config/gr:http-servers/gr:http-server[gr:webDAV = fn:false()]
    let $modules-db-name as xs:string := admin:database-get-name($config, $http-server/gr:modules)
    let $db-name as xs:string := admin:database-get-name($config, $http-server/gr:database)
    let $next-config := deploy:create-http-server($deploy:go-config, $http-server, $modules-db-name, $db-name)
    return
      xdmp:set($deploy:go-config, $next-config)
  let $save-http-servers := admin:save-configuration($deploy:go-config)

  let $update-config := xdmp:set($deploy:go-config, admin:get-configuration())

  let $create-webdav-servers :=
    for $webdav-server in $config/gr:http-servers/gr:http-server[gr:webDAV = fn:true()]
    let $modules-db-name as xs:string := admin:database-get-name($config, $webdav-server/gr:modules)
    let $next-config := deploy:create-webdav-server($deploy:go-config, $webdav-server, $modules-db-name)
    return
      xdmp:set($deploy:go-config, $next-config)
  let $save-webdav-servers := admin:save-configuration($deploy:go-config)

  return
    $deploy:go-config
};

declare function deploy:read-config-file($filename as xs:string) as document-node() {
  xdmp:security-assert("http://marklogic.com/xdmp/privileges/admin-module-read",
                       "execute"),
  xdmp:read-cluster-config-file($filename) 
};

declare function deploy:insert-domain($domain-name as xs:string,
                                      $domain-description as xs:string?,
                                      $document-scope as xs:string,
                                      $uri as xs:string?,
                                      $depth as xs:string?,
                                      $modules-database as xs:unsignedLong?,
                                      $root as xs:string,
                                      $triggers-db as xs:unsignedLong) as xs:unsignedLong
{
  let $existing-domains := deploy:domain-exists($domain-name)
  return
    if ($existing-domains eq fn:false()) then
      let $changes := 
        <dom:holder>
          <dom:domain-name>{$domain-name}</dom:domain-name>
          <dom:domain-description>{$domain-description}</dom:domain-description>
          <dom:document-scope>{$document-scope}</dom:document-scope>
          {
            if ($uri) then
              <dom:uri>{$uri}</dom:uri>
            else (),
            if ($depth) then
              <dom:depth>{$depth}</dom:depth>
            else (),
            if ($modules-database) then
              <dom:database>{$modules-database}</dom:database>
            else (),
            if ($root) then
              <dom:root>{$root}</dom:root>
            else ()
          }
        </dom:holder>
      
      let $runme :=
        'import module namespace dom = "http://marklogic.com/cpf/domains" at "/MarkLogic/cpf/domains.xqy";
         declare namespace sec = "http://marklogic.com/xdmp/security";
      
         declare variable $changes as element() external;
      
         let $domain-scope := dom:domain-scope($changes/dom:document-scope, $changes/dom:uri, $changes/dom:depth)
         let $context := dom:evaluation-context($changes/dom:database, $changes/dom:root)
         return 
          dom:create($changes/dom:domain-name,
                     $changes/dom:domain-description,
                     $domain-scope,
                     $context,
                     (), 
                     ())'
       return
          deploy:eval-in-triggers($runme, (xs:QName("changes"), $changes))
    else ()
};

declare function deploy:domain-exists($name as xs:string) as xs:boolean {
  let $runme := 
    'import module namespace dom = "http://marklogic.com/cpf/domains" at "/MarkLogic/cpf/domains.xqy";
     declare variable $name as xs:string external;
     dom:domains()[dom:domain-name eq $name]'
  return
    fn:count(deploy:eval-in-triggers($runme, (xs:QName("name"), $name))) = 1
};

declare function deploy:eval-in-triggers($runme as xs:string, $vars) {
  xdmp:eval($runme, $vars, 
            <options xmlns="xdmp:eval">
              <database>{admin:database-get-triggers-database(admin:get-configuration(), xdmp:database())}</database>
            </options>)
};

declare function deploy:insert-schema($uri as xs:string, $schema as element()) {
  let $runme :=
    'declare $uri as xs:string external;
     declare $schema as document-node() external;
     xdmp:document-insert($uri, $schema)'
  return
    xdmp:eval($runme, (xs:QName("uri"), $uri, xs:QName("schema"), $schema),
              <options xmlns="xdmp:eval">
                <database>{xdmp:database("Schemas")}</database>
              </options>)
};