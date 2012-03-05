xquery version "1.0-ml";

module namespace js = "http://www.xquerrail-framework.com/helper/javascript";

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

declare function js:number($value)
{
   if($value castable as xs:integer or
      $value castable as xs:long or 
      $value castable as xs:int or 
      $value castable as xs:short or
      $value castable as xs:unsignedLong or
      $value castable as xs:unsignedInt or
      $value castable as xs:decimal or
      $value castable as xs:double or
      $value castable as xs:float 
   )
   then fn:string($value)
   else js:null()
};

declare function js:string($value as xs:string)
{
   fn:concat('"',
   js:stringify($value),
   '"')
};

declare function js:object($value as item())
{
   fn:concat("{",
     js:stringify($value),
   "}")
};

declare function js:named-object(
   $name as xs:string,
   $value as item()
) as xs:string
{
  fn:concat(
      "{",
      $name,
      js:object($value),
      "}"
  )
};

declare function js:array($items as item()*)
{
   fn:concat("[",$items,"]")
};

declare function js:pair(
   $key as xs:string, 
   $value as item()*) 
{
   fn:concat($key," : ",$value)
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
declare function js:o($value){
  js:object($value)
};

(:Named Object:)
declare function js:no(
$name as xs:string,
$value as item()
){
   js:named-object($name,$value)
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

declare function js:p($name,$value)
{
  js:pair($name,$value)
};