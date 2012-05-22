xquery version "1.0-ml";
(:~
 : Parser Visitor for CSS3Selectors
~:)    
module namespace visitor = "CSS3Selectors-visitor";

import module namespace p = "CSS3Selectors"  at "/_framework/parsers/CSS3Selectors.xqy";

(:~
 : Map of all overriding visitor functions
~:)
declare variable $visitor-functions := map:map();

(:~
 : Registers your visitor functions with base map
~:)
declare function register-visitors(
  $functions as xdmp:function()*
) as empty-sequence() {
  for $f in $functions
  return 
      map:put($visitor-functions,xdmp:function-name($function),$function)
};

(:~
 : Checks wether visitor exists in $visitor-functions
 : @param $name
 : @return xs:boolean
~:)
declare function has-visitor(
  $name as xs:string 
) as xs:boolean {
  fn:exists(map:get($visitor-functions,$name))
};

(:~
 : Calls visitor function based on name passing node.
~:)
declare function visitor:call(
  $visitor-name as xs:string,
  $node as node()
) {
   let $function := map:get($visitor-functions,$visitor-name)
   return
     xdmp:apply($function,$node)
};

(:~
 : Main Typeswitch Processor 
~:)
declare function visitor:visit($node as node()) {
    typeswitch ($node)
        case element(negation_arg) return visitor:visit-negation_arg($node)
    case element(negation) return visitor:visit-negation($node)
    case element(expression) return visitor:visit-expression($node)
    case element(functional_pseudo) return visitor:visit-functional_pseudo($node)
    case element(pseudo) return visitor:visit-pseudo($node)
    case element(attrib) return visitor:visit-attrib($node)
    case element(class) return visitor:visit-class($node)
    case element(universal) return visitor:visit-universal($node)
    case element(element_name) return visitor:visit-element_name($node)
    case element(namespace_prefix) return visitor:visit-namespace_prefix($node)
    case element(type_selector) return visitor:visit-type_selector($node)
    case element(simple_selector_sequence) return visitor:visit-simple_selector_sequence($node)
    case element(combinator) return visitor:visit-combinator($node)
    case element(selector) return visitor:visit-selector($node)
    case element(selectors_group) return visitor:visit-selectors_group($node)
    default return fn:error(xs:QName("UNKNOWN-VISITOR"),"Unknown")
};  


(:~
 : Provides a visitor for negation_arg parsed node
~:)
declare function visitor:visit-negation_arg(
    $node as element(negation_arg)
) as item() {
     if(visitor:has-function("negation_arg"))
     then visitor:call("negation_arg",$node)
     else $node
};

(:~
 : Provides a visitor for negation parsed node
~:)
declare function visitor:visit-negation(
    $node as element(negation)
) as item() {
     if(visitor:has-function("negation"))
     then visitor:call("negation",$node)
     else $node
};

(:~
 : Provides a visitor for expression parsed node
~:)
declare function visitor:visit-expression(
    $node as element(expression)
) as item() {
     if(visitor:has-function("expression"))
     then visitor:call("expression",$node)
     else $node
};

(:~
 : Provides a visitor for functional_pseudo parsed node
~:)
declare function visitor:visit-functional_pseudo(
    $node as element(functional_pseudo)
) as item() {
     if(visitor:has-function("functional_pseudo"))
     then visitor:call("functional_pseudo",$node)
     else $node
};

(:~
 : Provides a visitor for pseudo parsed node
~:)
declare function visitor:visit-pseudo(
    $node as element(pseudo)
) as item() {
     if(visitor:has-function("pseudo"))
     then visitor:call("pseudo",$node)
     else $node
};

(:~
 : Provides a visitor for attrib parsed node
~:)
declare function visitor:visit-attrib(
    $node as element(attrib)
) as item() {
     if(visitor:has-function("attrib"))
     then visitor:call("attrib",$node)
     else $node
};

(:~
 : Provides a visitor for class parsed node
~:)
declare function visitor:visit-class(
    $node as element(class)
) as item() {
     if(visitor:has-function("class"))
     then visitor:call("class",$node)
     else $node
};

(:~
 : Provides a visitor for universal parsed node
~:)
declare function visitor:visit-universal(
    $node as element(universal)
) as item() {
     if(visitor:has-function("universal"))
     then visitor:call("universal",$node)
     else $node
};

(:~
 : Provides a visitor for element_name parsed node
~:)
declare function visitor:visit-element_name(
    $node as element(element_name)
) as item() {
     if(visitor:has-function("element_name"))
     then visitor:call("element_name",$node)
     else $node
};

(:~
 : Provides a visitor for namespace_prefix parsed node
~:)
declare function visitor:visit-namespace_prefix(
    $node as element(namespace_prefix)
) as item() {
     if(visitor:has-function("namespace_prefix"))
     then visitor:call("namespace_prefix",$node)
     else $node
};

(:~
 : Provides a visitor for type_selector parsed node
~:)
declare function visitor:visit-type_selector(
    $node as element(type_selector)
) as item() {
     if(visitor:has-function("type_selector"))
     then visitor:call("type_selector",$node)
     else $node
};

(:~
 : Provides a visitor for simple_selector_sequence parsed node
~:)
declare function visitor:visit-simple_selector_sequence(
    $node as element(simple_selector_sequence)
) as item() {
     if(visitor:has-function("simple_selector_sequence"))
     then visitor:call("simple_selector_sequence",$node)
     else $node
};

(:~
 : Provides a visitor for combinator parsed node
~:)
declare function visitor:visit-combinator(
    $node as element(combinator)
) as item() {
     if(visitor:has-function("combinator"))
     then visitor:call("combinator",$node)
     else $node
};

(:~
 : Provides a visitor for selector parsed node
~:)
declare function visitor:visit-selector(
    $node as element(selector)
) as item() {
     if(visitor:has-function("selector"))
     then visitor:call("selector",$node)
     else $node
};

(:~
 : Provides a visitor for selectors_group parsed node
~:)
declare function visitor:visit-selectors_group(
    $node as element(selectors_group)
) as item() {
     if(visitor:has-function("selectors_group"))
     then visitor:call("selectors_group",$node)
     else $node
};

