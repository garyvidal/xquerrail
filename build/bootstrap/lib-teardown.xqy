xquery version "1.0-ml";

module namespace teardown = "http://marklogic.com/ps/teardown";

import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";
import module namespace sec="http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy";

declare namespace xdmp="http://marklogic.com/xdmp";
declare namespace xs="http://www.w3.org/2001/XMLSchema";
declare namespace db="http://marklogic.com/xdmp/database";
declare namespace gr="http://marklogic.com/xdmp/group";
declare namespace ex="http://marklogic.com/xdmp/error";
declare namespace ho="http://marklogic.com/xdmp/hosts";
declare namespace as="http://marklogic.com/xdmp/assignments";
declare namespace fs="http://marklogic.com/xdmp/status/forest";
declare namespace mt="http://marklogic.com/xdmp/mimetypes";
declare namespace pki="http://marklogic.com/xdmp/pki";
declare namespace sc="http://marklogic.com/xdmp/security";

declare option xdmp:mapping "false";

declare variable $default-group := xdmp:group();
declare variable $default-host := xdmp:host();
declare variable $default-database := xdmp:database();
declare variable $default-modules := xdmp:database("Modules");
declare variable $default-schemas := xdmp:database("Schemas");
declare variable $default-security := xdmp:database("Security");
declare variable $default-user := xdmp:user("nobody");

declare variable $context-path := fn:resolve-uri(".", xdmp:get-request-path());

declare function teardown:delete-appserver($appserver as element())
{
  let $name := 
            typeswitch($appserver)
              case element(gr:http-server) return fn:string($appserver/gr:http-server-name)
              case element(gr:xdbc-server) return fn:string($appserver/gr:xdbc-server-name)
              default return ()
return 
 try 
 {
      let $config := admin:get-configuration()
      let $group-ids := admin:get-group-ids($config)
      let $appserver-id := admin:appserver-get-id($config,$group-ids,$name)
      let $_ :=  
              admin:save-configuration-without-restart(
                admin:appserver-delete($config,$appserver-id)
              )
      return  
        fn:concat("App Server Deleted ", $name)
             
 } catch($ex) {
    fn:concat("Could not delete App-server",$name)
 } 
};

declare function teardown:unassign-forest($dbname as xs:string, $forestname as xs:string)
{
try
{
      let $config := admin:get-configuration()
      let $forest-id := xdmp:forest($forestname)
      let $database-id := xdmp:database($dbname)
      let $_ := 
            admin:save-configuration-without-restart(
                admin:database-detach-forest($config,$database-id,$forest-id)
            )
          return
             fn:concat("Forest-unassigned ",$forestname)
 }
 catch($ex)
 {
    fn:concat("Could Not Remove Forest ",$forestname," from ",$dbname," ", $ex//ex:format-string)
 }
};
declare function teardown:delete-database($dbname as xs:string)
{
try
{
  let $config := admin:get-configuration()
  let $database-id := admin:database-get-id($config,$dbname)
  let $_ :=   admin:save-configuration-without-restart(
            admin:database-delete($config, $database-id)
        )
  return  
    fn:concat("Database Deleted ",$dbname)
   
}
catch($ex)
{
       fn:concat("Could not delete database ",$dbname," ",$ex//ex:format-string)
}
};

declare function teardown:delete-forest($forestname as xs:string)
{
 try
   {
   let $config := admin:get-configuration()
   let $forest-id := xdmp:forest($forestname)
   let $_ := admin:save-configuration-without-restart(
        admin:forest-delete($config,$forest-id,fn:true())
      )
      return
        fn:concat("Forest has been deleted ", $forestname)
    }
    catch($ex)
    {
        fn:concat("Could not delete forest ",$forestname," ",$ex//ex:format-string)
    }
};

declare function teardown:delete-user($username as xs:string)
{
  try
  {
      let $xx :=  sec:remove-user($username)
      return
        fn:concat("User Removed: ",$username)
  
  }
  catch($ex)
  {
      fn:concat("Could not delete user ",$username, $ex//ex:format-string)
  }
};

declare function teardown:delete-role($rolename as xs:string)
{
    try
    {
       let $stmt := 
       '
       import module namespace sec="http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy";
       declare variable $rolename as xs:string external;
       sec:remove-role($rolename)
       '
       let $eval := xdmp:eval($stmt,(xs:QName("rolename"),$rolename))
       return
         fn:concat("Role Removed ",$rolename)
    }
    catch($ex)
    {
      fn:concat("Could not delete Role ",$rolename,$ex//ex:format-string) 
    }
};

(:~
 : Teardown function will wipe all configuration elements
 : The order of the teardown is as follows
 :  App-servers
 :  Assignments
 :  Databases
 :  Forests
 :  Users
 :  Roles
~:)
declare function teardown:do-teardown($config as element(configuration))
{
   let $http-servers := $config/gr:http-servers/gr:http-server
   let $xdbc-servers := $config/gr:xdbc-servers/gr:xdbc-server
   let $databases    := $config/db:databases/db:database
   let $users        := $config/sc:users/sc:user
   let $roles        := $config/sc:roles/sc:role
   return
     (
       for $s in ($http-servers,$xdbc-servers)
       return
          teardown:delete-appserver($s)
       ,
       (:
       <database>
        <database-name>semantics-data</database-name>
        <forests>
        <forest-id name="semantics-data"/>
        </forests>
       :)
       for $d in $databases
       let $dbname :=  fn:string($d/db:database-name)
       let $assignments := 
            for $f in $d/db:forests/db:forest-id
            return 
            (
               teardown:unassign-forest($dbname,fn:data($f/@name)),
               teardown:delete-forest(fn:data($f/@name))
            )
       return
         (
           $assignments,
           teardown:delete-database($dbname)
         )
      ,
       for $u in $users
       return teardown:delete-user($u/sc:user-name)
      ,for $r in $roles
       return teardown:delete-role($r/sc:role-name)
   )     
};
