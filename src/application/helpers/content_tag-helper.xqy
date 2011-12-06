(:
  Helpers are similar to Tags but allow dynamic function invocation
  to support building set of useful functions
:)
xquery version "1.0-ml";

module namespace helper = "http://www.xquerrail-framework.com/helper";

declare default element namespace "http://www.w3.org/1999/xhtml";

declare private function helper:parse-attributes(
  $string as xs:string
) as attribute()*
{
  let $tokenize := fn:tokenize("=")
  for $t at $pos in (1 to fn:ceiling(fn:count($tokenize) div 2))
  return
   attribute {fn:QName("",fn:normalize-space($tokenize[$pos]))}
   {
      $tokenize[$pos + 1]
   }
};

declare function helper:content_tag(
$type as xs:string,
$attributes as xs:string
)
{
  element {xs:QName($type)}
  {
    helper:tokenize-attributes($attributes)
  }  
};

declare function helper:content_tag(
 $type as xs:string,
 $value,
 $attributes as xs:string
){
  element {xs:QName($type)}
  {
    helper:tokenize-attributes($attributes),
    $value
  }    
};