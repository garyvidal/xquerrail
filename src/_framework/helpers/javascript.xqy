 xquery version "1.0-ml";

module namespace js = "http://www.xquerrail-framework.com/helper/javascript";

declare option xdmp:mapping "false";


declare function js:null()
{
   "null"
};

declare function js:boolean($value)
{
   if($value castable as xs:boolean)
   then fn:string($value cast as xs:boolean)
   else js:null()
};

declare function js:isNumeric($value)
{
      $value castable as xs:integer or
      $value castable as xs:long or 
      $value castable as xs:int or 
      $value castable as xs:short or
      $value castable as xs:unsignedLong or
      $value castable as xs:unsignedInt or
      $value castable as xs:decimal or
      $value castable as xs:double or
      $value castable as xs:float 
};
declare function js:isBoolean($value)
{
  $value castable as xs:boolean 
};
declare function js:isDate($value)
{
  $value castable as xs:dateTime or
  $value castable as xs:date or
  $value castable as xs:time
};
declare function js:number($value)
{
   if(js:isNumeric($value))
   then fn:string($value)
   else "isNaN"
};

declare function js:string(
$value as xs:string?
)
{
  if(fn:exists($value)) 
  then
   fn:concat('"',
   js:stringify($value),
   '"')
  else js:null()
};
declare function date($value as item())
{
  fn:concat("new Date('",$value,"')")
};
declare function js:object(
$value as item()*
)
{
   fn:concat(
     "{&#xA;",
     if(fn:count($value) gt 1) 
     then fn:string-join($value,",&#xA;")
     else $value
     ,
     "&#xA;}"
   )
};

declare function js:named-object(
   $name as xs:string,
   $value as item()*
) as xs:string
{
  fn:concat(
      '"', $name,""": {",
      fn:string-join($value,","),
      "}"
  )
};
declare function js:named-array(
   $name as xs:string,
   $value as item()*
) as xs:string
{
  fn:concat(
      '"',$name,""": [",
      fn:string-join($value,",&#xA;"),
      "]"
  )
};

declare function js:array($items as item()*)
{
   fn:concat("[",
      fn:string-join(
      for $i in $items
      return
        if(js:isNumeric($i) or isBoolean($i)) 
        then fn:string($i)
        else $i
       ,","),"]"
   )
};

declare function js:pair(
   $key as xs:string, 
   $value as item()*) 
{
   fn:concat('"',$key,""": ",
   if(fn:count($value) gt 1) 
   then js:array($value)
   else if(isNumeric($value)) then js:number($value)
   else if(isBoolean($value)) then js:boolean($value)
   else if(isDate($value)) then js:date($value)
   else if(fn:matches($value,"^('|&quot;).*('|&quot;)$")) 
   then $value
   else js:string($value)
   )
};

(:==============================================================
 :Helper Functions
 :==============================================================
 :)
declare function js:stringify($value as xs:string)
{
   fn:replace(fn:replace($value,"\r","\\r"),"\n","\\n")
};
declare function js:jsify($value as item())
{
   $value
};

declare function js:bind-event(
  $id as xs:string,
  $event-name as xs:string,
  $function as xs:string)
{ 
   ()
};
declare function js:variable(
 $varname as xs:string,
 $statement as xs:string 
){
  fn:concat("var ",$varname," = ", $statement, ";")
};
declare function js:function(
   $params as xs:string,
   $body)
{
   fn:string(<script>function ({$params}){{
    { $body }
   }}
   </script>)
};

(:Shortcut functions for tight code:)

(:~
 : JS Object Shortcut
~:)
declare function js:o(
$value as item()*
){
  js:object($value)
};

(:Named Object:)
declare function js:no(
$name as xs:string,
$value as item()*
){
   js:named-object($name,$value)
};
declare function js:na(
$name as xs:string,
$value as item()*
){
   js:named-array($name,$value)
};
(:Number shortcut:)
declare function js:n($value as item())
{
   js:number($value) 
};

(:String  Shortcut:)
declare function js:s(
$value as item()
){
   js:string($value)
};
(:Boolean:)
declare function js:b($value as item())
{
   js:boolean($value)
};
(:DateTime Helper:)
declare function js:dt($value as item())
{
   ()
};
(:Array Short Notation:)
declare function js:a($values as item()*)
{
   js:array($values)
};

declare function js:p($name,$value as item()*)
{
  js:pair($name,$value)
};