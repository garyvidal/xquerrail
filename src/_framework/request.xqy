xquery version "1.0-ml";

(:~
 : This request controls all serialization of request map 
 : - All HTTP request elements 
 : are returned in a single map object.
 : @author : Gary Vidal
~:)
module namespace request = "http://www.xquerrail-framework.com/request";

import module namespace json = "http://marklogic.com/json"  at "/application/lib/json.xqy";

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
declare variable $CONTROLLER        := "request:controller";
declare variable $ACTION            := "request:action";
declare variable $FORMAT            := "request:format";
declare variable $ROUTE             := "request:route";
declare variable $VIEW              := "request:view";
declare variable $HEADER-PREFIX     := "request:header::";
declare variable $PARAM-PREFIX      := "request:field::";
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
declare function request:request()
{
  $request
};

(:~
 :  Wraps the http response into a map:map
 :  Accessing the map can be used the following keys
 :  map:get($response, "rest:field:xxx")
 :  Accessors:
 :      request:header::xxxx
 :      request:field::xxxx
 :      request:body
~:)
declare function request:initialize($_request) {
 xdmp:set($request:request, $_request) (:NO-OP just keeps an empty map:)
};

(:~
 : 
~:)
declare function request:parse($parameters) as map:map {
   let $request := map:map()
   let $headers :=            
        for $i in xdmp:get-request-header-names()
        return
            for $j in xdmp:get-request-header($i)
            return
               map:put($request, fn:concat($HEADER-PREFIX,$i),$j)
   let $rests := 
      ( 
        map:put($request,$CONTROLLER,xdmp:get-request-field("_controller","default")),
        map:put($request,$ACTION,xdmp:get-request-field("_action","main")),
        map:put($request,$VIEW,xdmp:get-request-field("_view","default")),
        map:put($request,$URL, xdmp:get-request-field("_url","")) 
      )
   let $fields := 
         for $i in xdmp:get-request-field-names()[fn:not(. = ("_controller","_action","_view","_context","_format","_url","_route"))]
         let $fieldname := fn:concat($PARAM-PREFIX,$i)
         let $filename := xdmp:get-request-field-filename($i)
         let $content-type := xdmp:get-request-field-content-type($i)
         return
            for $j in xdmp:get-request-field($i)
            let $filename-key := fn:concat($PARAM-FILENAME-PREFIX,$i)
            return 
                (
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
                     map:put($request,fn:concat($PARAM-CONTENT-TYPE-PREFIX),$content-type)
                  ) 
                else  ()   
              )
   
   let $rest := (
      map:put($request, $METHOD,xdmp:get-request-method()),
      map:put($request, $PATH,xdmp:get-request-path()),
      map:put($request, $URL,xdmp:get-request-url()),
      map:put($request, $PROTOCOL,xdmp:get-request-protocol()),
      map:put($request, $USERNAME,xdmp:get-request-username()),
      map:put($request, $USERID,xdmp:get-request-user())
   ) 
   let $accept-types := xdmp:uri-format(xdmp:get-request-header("Content-Type"))   
   let $_ := map:put($request, $BODY,xdmp:get-request-body($accept-types))
   return $request
};

(:~
 : 
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
 : Selects the file format of the reqeust
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
 : Returns the method for a given request
 : the method returns the http verb such as POST,GET,DELETE
 : etc.
~:)
declare function request:method() {
    map:get($request,$METHOD)
};
(:~
 : 
~:)
declare function request:path() {
    map:get($request,$PATH)
};
(:~
 : 
~:)
declare function request:protocol($request as map:map) {
    map:get($request,$PROTOCOL)
};
(:~
 : Returns the body element of an http:request
~:)
declare function request:body() {
    map:get($request,$BODY)
};
(:~
 : 
~:)
declare function request:body-type($request as map:map){
    map:get($request,$BODY-TYPE)
};
(:~
 :  Returns the list of params
~:)
declare function request:params() {
    let $new-map := map:map()
    let $_ := 
        for $key in map:keys($request)[fn:starts-with(.,$PARAM-PREFIX)]
        return 
            map:put($new-map,fn:substring-after($PARAM-PREFIX,$key),map:get($request,$key))
    return
        $new-map
};
(:~
 :
~:)
declare function request:param-names()
{
    for $key in map:keys($request)[fn:starts-with(.,$PARAM-PREFIX)]
    return fn:substring-after($key, $PARAM-PREFIX)
};
(:~
 : 
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
 : 
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
 :
~:)
declare function request:param-filename($request as map:map,$name as xs:string) {
    map:get($request,fn:concat($PARAM-FILENAME-PREFIX,$name))
};
(:~
 :
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
 : 
~:)
declare function request:get-header($name as xs:string) {
   let $key-name := fn:concat($HEADER-PREFIX,$name)
   return 
     map:get($request,$key-name)
};

(:~
 : 
~:)
declare function request:get-header($name as xs:string,$default as xs:anyAtomicType) {
  if(request:get-header($request,$name))
  then request:get-header($request,$name)
  else $default
};

(:Common Request Header PARAM wrapper:)
declare function request:locale()
{
  map:get($request,fn:concat($HEADER-PREFIX,"Accept-Language"))
};
(:~
 :
~:)
declare function request:content-length()
{ 
  ()
};
(:~
 :
~:)
declare function request:user-agent()
{
  map:get($request,fn:concat($HEADER-PREFIX,"User-Agent"))
};

(:~
 :
~:)
declare function request:referer()
{
  map:get($request,fn:concat($HEADER-PREFIX,"Referer"))  
};

(:~
 :
~:)
declare function request:encoding()
{
    map:get($request,fn:concat($HEADER-PREFIX,"Accept-Encoding"))  
};

declare function request:connection()
{
    map:get($request,fn:concat($HEADER-PREFIX,"Connection"))  
};

declare function request:authorization()
{
    map:get($request,fn:concat($HEADER-PREFIX,"Authorization"))  
};

declare function request:cookies()
{
    map:get($request,fn:concat($HEADER-PREFIX,"Cookie"))     
};
declare function request:cookie($name)
{
   request:cookies()
};
(:~
 :
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
