xquery version "1.0-ml";
(:~
 : Domain Operations and functions for accessing domain configuration
 :
~:)
module namespace domain = "http://www.xquerrail-framework.com/domain";


import module namespace config = "http://www.xquerrail-framework.com/config"
    at "/_framework/config.xqy";
(:~
 : Returns the XDM/ML datatype of a XQuerrail datatype.
 : @param $field - Domain Field such as domain:element|domain:container|domain:attribute
~:)
declare function domain:resolve-datatype($field)
{
   let $data-type := element{$field/@type}{$field}
   return 
     typeswitch($data-type)
     case element(uuid) return "xs:string"
     case element(grid) return "element()"
     case element(identity) return "xs:ID"
     case element(create-timestamp) return "xs:dateTime"
     case element(create-user) return "xs:string"
     case element(modify-timestamp) return "xs:dateTime"
     case element(modify-user) return "xs:string"
     case element(binary) return "binary()"
     case element(schema-element) return "schema-element()"
     case element(query) return "cts:query"
     case element(point) return "cts:point"
     case element(string) return "xs:string"
     case element(integer) return "xs:integer"
     case element(int) return "xs:integer"
     case element(long) return "xs:long"
     case element(double) return "xs:double"
     case element(decimal) return "xs:decimal"
     case element(float) return "xs:float"
     case element(boolean) return "xs:boolean"
     case element(anyURI) return "xs:anyURI"
     case element(dateTime) return "xs:dateTime"
     case element(date) return "xs:date"
     case element(duration) return "xs:duration"
     case element(dayTime) return "xs:dayTimeDuration"
     case element(yearMonth) return "xs:yearMonthDuration"
     case element(monthDay) return "xs:monthDayDuration"
     case element(reference) return "element()"
     default return fn:error(xs:QName("UNRESOLVED-DATATYPE"),$field)
};

(:~
 : Returns a list of controllers defined for a given domain
 : @param $application-name - Name of the application to retrieve the controllers
~:)
declare function domain:get-controllers(
   $application-name as xs:string
) as element(domain:controller)* 
{
    let $domain := config:get-domain($application-name)
    return 
       if($domain) 
       then $domain/domain:controller
       else fn:error(xs:QName("get-controller-error"),"Cannot get Controllers")       
};

(:~
 : Gets the definition of a controller from the domain configuration
 : @param $application-name - Name of the application
 : @param $controller-name - Name of the controller 
~:)
declare function domain:get-controller(
   $application-name as xs:string,
   $controller-name as xs:string
) as element(domain:controller)? 
{
    let $domain := config:get-domain($application-name)
    return 
        $domain/domain:controller[@name eq $controller-name]  
};

(:~
 : Returns the model defined by a given controller
 : @param $application-name - Name of the application
 : @param $controller-name - Name of the controller 
 : @return Model assigned by controller
~:)
declare function domain:get-controller-model(
    $application-name as xs:string, 
    $controller-name as xs:string
) as element(domain:model)?
{
     let $domain := config:get-domain($application-name)
     let $controller := domain:get-controller($application-name,$controller-name)
     let $model := $domain/domain:model[@name eq $controller/@model]
     return 
        $model
};

(:~
 : Returns a model from an application domain
 : @param $application-name - Name of the application
 : @param $controller-name - Name of the controller 
~:)
declare function domain:get-domain-model(
    $application-name as xs:string,
    $domain-name as xs:string
)  as element()?
{
  let $path := config:get-application($application-name)/config:domain/@resource
  let $domain := xdmp:invoke($path)  
  return
    $domain/domain:model[@name = $domain-name]
};

(:~
 : Returns a model from the application domain.  Deprecated use full function to get appropriate model
 : @param $controller-name - Name of the controller 
~:)
declare function domain:get-domain-model(
    $model-name as xs:string
)  as element()?
{
  let $path := config:get-application("application")/config:domain/@resource
  let $domain := xdmp:invoke($path)  
  return
    $domain/domain:model[@name = $model-name]
};

