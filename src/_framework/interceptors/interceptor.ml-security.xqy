xquery version "1.0-ml";

module namespace ml-security = "http://www.xquerrail-framework.com/interceptor";

import module namespace interceptor = "http://www.xquerrail-framework.com/interceptor" at "/_framework/interceptor.xqy";
import module namespace request = "http://www.xquerrail-framework.com/request" at "/_framework/request.xqy";
import module namespace config  = "http://www.xquerrail-framework.com/config"  at "/_framework/config.xqy";

   
declare function ml-security:name()
{
  xs:QName("interceptor:ml-security")
};

declare function ml-security:get-roles()
{
   xdmp:eval('
   import module namespace sec = "http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy";
   sec:get-role-names(xdmp:get-current-roles())
   ',(),
   
     <options xmlns="xdmp:eval">
        <database>{xdmp:security-database()}</database>
     </options> 
   )
};

declare function ml-security:implements() as xs:QName*
{   
   (
     xs:QName("interceptor:after-request")
   )
};

declare function ml-security:after-request(
   $configuration as element()
)
{
     let $context := interceptor:get-context()
     let $scope   := interceptor:get-matching-scopes($configuration)[1]
     let $roles   := ml-security:get-roles()
     return
       if($scope//config:allow-role = $roles or
          fn:not($scope//config:deny-role  = $roles))
       then ( 
          xdmp:log(("Not-Redirecting::",xdmp:get-current-user(), $context,$scope))
       )
       else (
          request:set-redirect($configuration/config:login-url/@url),
          xdmp:log(("Redirecting::",request:redirect(),$context,$scope))
       )
};
