(:
 : Copyright 2011 - Gary Vidal
 :
 : Licensed     under the Apache License, Version 2.0 (the "License");
 : you may not use this file except in compliance with the License.
 : You may obtain a copy of the License at
 :
 :    http://www.apache.org/licenses/LICENSE-2.0
 :
 : Unless required by applicable law or agreed to in writing, software
 : distributed under the License is distributed on an "AS IS" BASIS,
 : WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 : See the License for the specific language governing permissions and
 : limitations under the License.
 :)



xquery version "1.0-ml";

module namespace lib = "http://marklogic.com/ps/lib/security";
(:~
 : Security Function Wrapper for user administration
 : @author <a href="gary.vidal@marklogic.com">Gary Vidal</a>
~:)
(:
import module namespace sec = "http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy";
:)
declare variable $EDITOR-ROLE as xs:string := "validator-editor";
declare variable $ADMIN-ROLE as xs:string := "validator-admin";
declare variable $USER-ROLE as xs:string  :="validator-user";


declare variable $ADMIN-PERMISSIONS as element(sec:permission)*  := 
(
    xdmp:permission("validator-admin", "read"),
    xdmp:permission("validator-admin", "update"),
    xdmp:permission("validator-admin", "insert"),
    xdmp:permission("validator-admin", "execute")
    
);

declare variable $EDITOR-PERMISSIONS as element(sec:permission)* :=
  (
    xdmp:permission("validator-editor", "read"),
    xdmp:permission("validator-editor", "update"),
    xdmp:permission("validator-editor", "insert"),
    xdmp:permission("validator-editor", "execute")
  )
;

declare variable $USER-PERMISSIONS as element(sec:permission)*   :=
(    
    xdmp:permission("validator-user", "read"),
    xdmp:permission("validator-user", "update"),
    xdmp:permission("validator-user", "insert"),
    xdmp:permission("validator-user", "execute")
)
;
declare variable $EMAIL-REGEX := 
   "[A-Za-z0-9_]+([-+.'][A-Za-z0-9_]+)*@[A-Za-z0-9_]+([-.][A-Za-z0-9_]+)*\.[A-Za-z0-9_]+([-.][A-Za-z0-9_]+)*";
(:~
 :  Creates a user 
~:)
declare function lib:create-user(
    $username as xs:string,
    $password as xs:string,
    $type as xs:string
)
{
    let $role := 
        if($type eq "admin") then $ADMIN-ROLE 
        else if($type eq "editor") then $EDITOR-ROLE
        else if($type eq "user") then $USER-ROLE 
        else fn:error(xs:QName("ROLETYPE-NOT-DEFINED"),
               fn:concat("No Roles are associated with type: ",$type)
             )
    let $description := 
        if($type eq "admin") then "Validator Admin Role"
        else if($type eq "editor") then "Validator Editor Role"
        else if($type eq "user") then "Validator User Role"
        else "nobody"
         
    let $perms := 
        if($type eq "admin") then $ADMIN-PERMISSIONS
        else if($type eq "editor") then $EDITOR-PERMISSIONS
        else if($type eq "user") then   $USER-PERMISSIONS  
        else  fn:error(xs:QName("ROLETYPE-NOT-DEFINED"),
               fn:concat("No Roles are associated with type: ",$type)
             )
    let $description := fn:concat("Validator User Type:",$type)  
    let $stmt := 
        'import module namespace sec = "http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy";
         declare variable $username as xs:string external;
         declare variable $password as xs:string external;
         declare variable $description as xs:string external;
         declare variable $roles as xs:string external;
         declare variable $permissions as element(perms) external;
         sec:create-user($username,$description,$password,$roles,$permissions/sec:permission,())
         '
    return 
    xdmp:eval($stmt,
       (
        xs:QName("username"),$username,
        xs:QName("description"),$description,
        xs:QName("password"),$password,
        xs:QName("roles"), $role,
        xs:QName("permissions"), <perms>{$perms}</perms>
       ),
        <options xmlns="xdmp:eval">
            <database>{xdmp:security-database()}</database>
        </options>     
        )
};
(:~
 : Validates email against regex pattern $EMAIL-REGEX
~:)
declare function lib:validate-email(
$email as xs:string
) as xs:boolean
{
   fn:matches($email,$EMAIL-REGEX,"ix")
};

(:~
 : Deletes a user from the Security database
 : @param $username - Name of the user to delete
~:)
declare function lib:delete-user($username as xs:string)
{
   let $stmt := 
   'import module namespace sec = "http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy";
         declare variable $username as xs:string external;
         sec:remove-user($username)
   '
    return 
    xdmp:eval($stmt,
       (
        xs:QName("username"),$username),
        <options xmlns="xdmp:eval">
            <database>{xdmp:security-database()}</database>
        </options>     
        )   
};
(:~
 : Changes Password of user
 : @param $username - name of user in Security database
 : @param $password - password to change user for
~:)
declare function lib:change-password(
    $username as xs:string,
    $password as xs:string
)
{
   let $stmt := 
   'import module namespace sec = "http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy";
    declare variable $username as xs:string external;
    declare variable $password as xs:string external;
    sec:user-set-password($username,$password)
   '
   return
    xdmp:eval($stmt, 
        (
        xs:QName("username"),$username,
        xs:QName("password"),$password
        )
    ,<options xmlns="xdmp:eval">
       <database>{xdmp:security-database()}</database>
     </options>
    )
};