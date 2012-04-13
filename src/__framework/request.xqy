xquery version "1.0-ml";

(:~
 : This request controls all serialization of request map 
 : - All HTTP request elements in a single map:map type.
~:)
module namespace request = "http://www.xquerrail-framework.com/request";

import module namespace json = "http://marklogic.com/json"  at "/lib/json.xqy";
import module namespace config = "http://www.xquerrail-framework.com/config" 
  at "/_framework/config.xqy";

declare option xdmp:mapping "false";

declare variable $BODY              := "request:body";
declare variable $BODY-XML          := "request:body-xml";
declare variable $BODY-TEXT         := "request:body-text";
declare variable $BODY-BINARY       := "request:body-binary";
declare variable $METHOD            := "request:method";
declare variable $CONTENT-TYPE      := "request:content-type";
declare variable $BODY-TYPE         := "request:body-type";
declare variable $PROTOCOL          := "request:protocol";
declare variable $USERNAME          := "request:username";
declare variable $USERID            := "request:userid";
declare variable $PATH              := "request:path";
declare variable $URL               := "request:url";
declare variable $CONTEXT           := "request:context";
declare variable $APPLICATION       := "request:application";
declare variable $CONTROLLER        := "request:controller";
declare variable $ACTION            := "request:action";
declare variable $FORMAT            := "request:format";
declare variable $ROUTE             := "request:route";
declare variable $VIEW              := "request:view";
declare variable $PARTIAL           := "request:partial";
declare variable $HEADER-PREFIX     := "request:header::";
declare variable $PARAM-PREFIX      := "request:field::";
declare variable $REDIRECT          := "request:redirect";

declare variable $PARAM-CONTENT-TYPE-PREFIX := "request:field-content-type::";
declare variable $PARAM-FILENAME-PREFIX   := "request:field-filename::";

(:~Global Request Variable ~:)
declare private variable $request as map:map := map:map();

(:~
 : Decodes a binary request into s string
~:)
declare function request:hex-decode($hexBin as xs:hexBinary) as xs:string {
    request:hex-decode($hexBin, fn:floor(fn:string-length(fn:string($hexBin)) div 2))
};

declare function request:hex-decode($hexBin as xs:hexBinary, $length as xs:integer) as xs:string {
    let $string := fn:substring(fn:string($hexBin),1,$length * 2)
    let $bytes as xs:integer* :=
        for $pos in 1 to fn:string-length($string)
        let $half-byte := fn:substring($string, $pos, 1)
        let $next-half-byte := fn:substring($string, $pos + 1, 1)
        where ($pos mod 2) = 1
        return
            xdmp:hex-to-integer(fn:concat($half-byte, $next-half-byte))

    return
        fn:codepoints-to-string($bytes)
};

(:~
 : Returns the map:map of the request
~:)
declare function request:request()
{
  $request
};
declare function request:join($params as map:map)
{
   let $_ := xdmp:set($request, $request + ($request - $params) )
   return $request
};
(:~
 :  Wraps the http response into a map:map
 :  Accessing the map can be used the following keys
 :  map:get($response, "field:xxx")
 :  Accessors:
 :      request:header::xxxx
 :      request:field::xxxx
 :      request:body
~:)
declare function request:initialize($_request as map:map) {
  xdmp:set($request:request, $request:request + $_request)
};

(:~
 :  Parses the map pulling all the required information from http request 
~:)
declare function request:parse($parameters) as map:map {
   
   (:Insert all custom headers:)
   let $headers :=            
        for $i in xdmp:get-request-header-names()
        return
            for $j in xdmp:get-request-header($i)
            return
               map:put($request, fn:concat($HEADER-PREFIX,$i),$j)
   (:Map All common request information:)
   let $rests := 
      ( 
        map:put($request, $APPLICATION,xdmp:get-request-field("_application","application")),
        map:put($request, $CONTROLLER, xdmp:get-request-field("_controller","default")),
        map:put($request, $ACTION,     xdmp:get-request-field("_action","main")),
        map:put($request, $FORMAT,     xdmp:get-request-field("_format","xml")),
        map:put($request, $VIEW,       xdmp:get-request-field("_view","default")),
        map:put($request, $URL,        xdmp:get-request-field("_url","")),
        map:put($request, $ROUTE,      xdmp:get-request-field("_route","")),
        map:put($request, $PARTIAL,    xdmp:get-request-field("_partial","false")),
        map:put($request, $METHOD,     xdmp:get-request-method()),
        map:put($request, $PATH,       xdmp:get-request-path()),
        map:put($request, $URL,        xdmp:get-request-url()),
        map:put($request, $PROTOCOL,   xdmp:get-request-protocol()),
        map:put($request, $USERNAME,   xdmp:get-request-username()),
        map:put($request, $USERID,     xdmp:get-request-user())
      )
   let $fields := 
         for $i in xdmp:get-request-field-names()[fn:not(. = ("_controller","_action","_view","_context","_format","_url","_route","_partial"))]
         let $fieldname := fn:concat($PARAM-PREFIX,$i)
         let $filename := xdmp:get-request-field-filename($i)
         let $content-type := xdmp:get-request-field-content-type($i)
         return
            (:Load All Request Fields:)
            for $j in xdmp:get-request-field($i)
            let $filename-key := fn:concat($PARAM-FILENAME-PREFIX,$i)
            let $x := 
                 if(fn:matches($j,"^(\{|\[)*(\}|\])$","mix")) 
                 then 
                     let $jsonMap := xdmp:from-json(fn:replace($j,"(&#13;|&#10;)","")) 
                     return request:convert-json-map($jsonMap)
                 else $j
            return (
                    if(map:get($request,$fieldname)) then
                    (
                         map:put($request,$fieldname,
                            (map:get($request,$fieldname),$j)
                         )
                    )
                    else     
                       map:put($request, $fieldname,$j)
                ,(:Write out the filename info:) 
                if($filename) then
                (
                   map:put($request,fn:concat($PARAM-FILENAME-PREFIX,$i),$filename),
                   map:put($request,fn:concat($PARAM-CONTENT-TYPE-PREFIX,$i),$content-type)
                ) 
                else  ()   
            )
 
        let $_content-type := fn:normalize-space(fn:tokenize(xdmp:get-request-header("Content-Type"), ";")[1])
        let $accept-types := xdmp:uri-format($_content-type)
        let $_ := xdmp:log($_content-type)
        let $_ := 
             if ($_content-type = "application/json" or fn:contains($_content-type,"application/json"))  
             then map:put($request, $BODY, json:jsonToXML( xdmp:quote(xdmp:get-request-body()/node()) ))
             else  map:put($request, $BODY, xdmp:get-request-body($accept-types))
        let $_ := map:put($request,"foo","foo")
   return $request
};

(:~
 : Get the application from the request
~:)
declare function request:application(){
  map:get($request,$APPLICATION)
};

(:~
 :  Gets the controller from the request
~:)
declare function request:controller() {
    map:get($request,$CONTROLLER)
};

(:~
 :  Gets that action Parameters of the request
~:)
declare function request:action() {
    map:get($request,$ACTION)
};

(:~
 : Selects the file format of the requestt
~:)
declare function request:format() {
   map:get($request,$FORMAT)
};

(:~
 : Gets the route selected for the request
~:)
declare function request:route() {
   map:get($request,$ROUTE)
};

(:~
 : Gets the view selected for the request
~:)
declare function request:view() {
   map:get($request,$VIEW)
};

(:~
 : Returns the method for a given request
 : the method returns the http verb such as POST,GET,DELETE
 : etc.
~:)
declare function request:method() {
    map:get($request,$METHOD)
};

(:~
 :  Get the original Path of the request
~:)
declare function request:path() {
    map:get($request,$PATH)
};

(:~
 :  Get the protocal of the request
~:)
declare function request:protocol() {
    map:get($request,$PROTOCOL)
};

(:~
 : Returns the body element of an http:request. Use the request:body-type() 
 : function to determine the underlying datatype
~:)
declare function request:body() {
    map:get($request,$BODY)
};

(:~
 :  Returns the body type of the given request such as (xml, binary, text) 
~:)
declare function request:body-type(){
    map:get($request,$BODY-TYPE)
};

(:~
 : Returns if a request is a partial request common in ajax calls
~:)
declare function request:partial(){
  let $is-partial := map:get($request,$PARTIAL)
  return
    if($is-partial) then
      if($is-partial eq "true") 
      then fn:true()
      else fn:false()
    else 
      fn:false()
};

(:~
 :  Returns the list of parameters of just parameters in a map
~:)
declare function request:params()  as map:map{
    let $new-map := map:map()
    let $_ := 
        (
            for $key in map:keys($request)[fn:starts-with(.,$PARAM-PREFIX)]
            return 
                map:put($new-map,fn:substring-after($key,$PARAM-PREFIX
                ),map:get($request,$key)),
            (:Add param with format $key:filename key:content-type:) 
            for $key in map:keys($request)[fn:starts-with(.,$PARAM-FILENAME-PREFIX)]
            return map:put($new-map, fn:concat(fn:substring-after($key,$PARAM-FILENAME-PREFIX),"::filename"),map:get($request,$key))
            ,
            for $key in map:keys($request)[fn:starts-with(.,$PARAM-CONTENT-TYPE-PREFIX)]
            return map:put($new-map, fn:concat(fn:substring-after($key,$PARAM-CONTENT-TYPE-PREFIX),"::content-type"),map:get($request,$key))
        )    
    return
        $new-map
};

(:~
 : Returns a list parameter names from request as sequence of string values
~:)
declare function request:param-names()
{
    for $key in map:keys($request)[fn:starts-with(.,$PARAM-PREFIX)]
    return fn:substring-after($key, $PARAM-PREFIX)
};

(:~
 :  Gets a parameter value by name
~:)
declare function request:param($name as xs:string) {
   let $key-name := fn:concat($PARAM-PREFIX,$name)
   return 
    map:get($request,$key-name)
};

(:~
 : Retrieves a field if it is available and returns.
 : If field does not exist returns default.
~:)
declare function request:param($name as xs:string,$default as item()*) {
  let $field := request:param($request,$name) 
  return
    if($field) 
    then $field
    else $default
};
(:~
 : Returns a parameter casted as the type you specify.
 : Use the generic type of the asset to resolve as the underlying type
~:)
declare function request:param-as(
    $name as xs:string,
    $type as xs:string,
    $default as item()
) as item()*
{
    let $value := request:param($name,$default)
    return 
      if($type eq "xs:integer" and $value castable as xs:integer) 
      then $value cast as xs:integer
      else if($type eq "xs:unsignedInteger" and $value castable as xs:unsignedInt) 
      then $value cast as xs:unsignedInt
      else if($type eq "xs:long" and $value castable as xs:long) 
      then $value cast as xs:long
      else if($type eq "xs:unsignedLong" and $value castable as xs:unsignedLong) 
      then $value cast as xs:unsignedLong
      else if($type eq "xs:decimal" and $value castable as xs:decimal)
      then $value cast as xs:decimal
      else if($type eq "xs:float" and $value castable as xs:float) 
      then $value cast as xs:float
      else if($type eq "xs:double" and $value castable as xs:double)
      then $value cast as xs:double
      else if($type eq "xs:boolean" and $value castable as xs:boolean)
      then $value cast as xs:boolean
      else if($type eq "xs:string" and $value castable as xs:string)
      then $value cast as xs:string
      else if($type eq "element" and $value instance of element())
      then $value
      else fn:error(xs:QName("PARAM-EXCEPTION"),"Parameter Type is not supported",($type,$name))
};
(:~
 :  Returns the parameters of the request as a map
~:)
declare function request:params-as-map()
{
   let $new-map := map:map()
   let $fields := request:params()
   let $insert := 
        for $field in map:keys($fields)
        let $value := map:get($fields,$field)
        return 
          map:put($new-map,fn:substring-after($value,$PARAM-PREFIX),$value)
  return
    $new-map
};

(:~
 :  Returns the filename for the param
~:)
declare function request:param-filename($name as xs:string) {
    map:get($request,fn:concat($PARAM-FILENAME-PREFIX,$name))
};
(:~
 :  Returns the associated content-type for the given param
 :  In cases where the request has multipart/mime data on the form
 :  you can extract the type based request from client
~:)
declare function request:param-content-type(
$request as map:map,
$field as xs:string
)
{
   map:get($request,fn:concat($PARAM-CONTENT-TYPE-PREFIX,$field))
};

(:~
 : Gets a all response header object
~:)
declare function request:get-headers() {
    let $new-map := map:map()
    let $_ := 
        for $key in map:keys($request)[fn:starts-with(.,"request:header::")]
        return 
            map:put($new-map,fn:substring-after($key,$HEADER-PREFIX),map:get($request,$key))
    return
        $new-map
};

(:~
 : Gets a specific header parameter by name 
 :  @param $name - Name of the header parameter (ie. Content-Length)
~:)
declare function request:get-header($name as xs:string) {
   let $key-name := fn:concat($HEADER-PREFIX,$name)
   return 
     map:get($request,$key-name)
};

(:~
 :  Gets a specific header parameter by name and its default value if not present
 :  @param $name - Name of the header parameter (ie. Content-Length)
 :  @param $defualt - Default value if header parameter is not present.
~:)
declare function request:get-header($name as xs:string,$default as xs:anyAtomicType) {
  if(request:get-header($request,$name))
  then request:get-header($request,$name)
  else $default
};

(:Common HTTP Request Header PARAMs wrapper:)

(:~
 : Returns the given Accept-Language from the HTTP request
~:)
declare function request:locale()
{
  map:get($request,fn:concat($HEADER-PREFIX,"Accept-Language"))
};
(:~
 : Returns the Content-Length header param
~:)
declare function request:content-length()
{ 
   map:get($request,fn:concat($HEADER-PREFIX,"Content-Length"))
};
(:~
 : Returns the User-Agent header from a given request
~:)
declare function request:user-agent()
{
  map:get($request,fn:concat($HEADER-PREFIX,"User-Agent"))
};

(:~
 : Returns the Referer header from a given request
~:)
declare function request:referer()
{
  map:get($request,fn:concat($HEADER-PREFIX,"Referer"))  
};

(:~
 : Returns the Accept-Encoding header from a given request
~:)
declare function request:encoding()
{
    map:get($request,fn:concat($HEADER-PREFIX,"Accept-Encoding"))  
};

(:~
 : Returns the Connection header from a given request
~:)
declare function request:connection()
{
    map:get($request,fn:concat($HEADER-PREFIX,"Connection"))  
};
(:~
 : Returns the Authorization Header from the request
~:)
declare function request:authorization()
{
    map:get($request,fn:concat($HEADER-PREFIX,"Authorization"))  
};
(:~
 : Returns the Cookies from the request
~:)
declare function request:cookies()
{
    map:get($request,fn:concat($HEADER-PREFIX,"Cookie"))     
};

(:~
 : Returns the Cookies by name from the request
 : @param $name - name of cookie
~:)
declare function request:cookie($name)
{
   request:cookies()
};

declare function request:user()
{
   xdmp:get-current-user()
};
declare function request:anonymous-user()
{
  config:anonymous-user(request:application())
};
(:~
 :  Using JQGrid you can parse a query from field using simple language, parses from JSON into CTS Query
~:)
declare function request:build-query($params)
{
  let $filters := 
     if($params instance of element(item)) 
     then $params 
     else $params//item
  let $value-query := 
    for $item in $filters
    return
      if($item/op eq "eq") then
        cts:element-value-query(xs:QName($item/field),$item/data)
      else if($item/op eq "ne") then
        cts:not-query( cts:element-value-query(xs:QName($item/field),$item/data))
      else if($item/op eq "bw") then
         cts:element-word-query(xs:QName($item/field),fn:concat($item/data,"*"))
      else if($item/op eq "bn") then
         cts:not-query( cts:element-word-query(xs:QName($item/field),fn:concat($item/data,"*")))
      else if($item/op eq "ew") then
         cts:element-word-query(xs:QName($item/field),fn:concat("*",$item/data))
      else if($item/op eq "en") then
         cts:not-query( cts:element-word-query(xs:QName($item/field),fn:concat("*",$item/data)))
      else if($item/op eq "cn") then
         cts:element-word-query(xs:QName($item/field),fn:concat("*",$item/data,"*"))
      else if($item/op eq "nc") then
         cts:not-query( cts:element-word-query(xs:QName($item/field),fn:concat("*",$item/data,"*")))
       else if($item/op eq "nu") then
         cts:element-query(xs:QName($item/field),cts:and-query(()))
      else if($item/op eq "nn") then
         cts:element-query(xs:QName($item/field),cts:or-query(()))         
      else if($item/op eq "in") then
        cts:element-value-query(xs:QName($item/field),$item/data)
      else if($item/op eq "ni") then
        cts:not-query( cts:element-value-query(xs:QName($item/field),$item/data))
      else ()
  return
  if($params//groupOp eq "AND") then
    cts:and-query($value-query)
  else if($params//groupOp eq "OR") then
    cts:or-query($value-query)
  else $value-query
};

(:~
 : Returns the parse Query from JQGrid 
~:)
declare function request:parse-query()  
{
 let $filters  := 
  if(request:param("_search", "false") = "true") 
  then if(request:param("filters",())) 
       then json:jsonToXML(request:param($request,"filters"))
       else 
        <item>
           <field>{request:param($request,"searchField")}</field>
           <op>{request:param($request,"searchOper")}</op>
           <data>{request:param($request,"searchString")}</data>
        </item>
  else ()
  return
     request:build-query($filters)
};
(:~
 : Converts a JSON map into a request parameter
~:)
declare private function request:convert-json-map($map as map:map) {
    for $key in map:keys($map)
    let $val := map:get($map,$key)
    return
        element {$key} {
            if($val instance of map:map) then request:convert-json-map($val) else $val
        }

};
declare function request:set-redirect($uri)
{
   map:put($request,$REDIRECT,fn:data($uri))
};
declare function request:redirect()  as xs:string?
{
  map:get($request,$REDIRECT)
};