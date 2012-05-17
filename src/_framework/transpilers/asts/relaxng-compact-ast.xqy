xquery version "1.0-ml";
(:~
 : Parser Visitor for relax-ng-compact
~:)    
module namespace visitor = "relax-ng-compact-visitor";

import module namespace p = "relax-ng-compact"  at "/_framework/parsers/relax-ng-compact.xqy";

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
        case element(literal) return visitor:visit-literal($node)
    case element(identifierOrKeyword) return visitor:visit-identifierOrKeyword($node)
    case element(documentations) return visitor:visit-documentations($node)
    case element(prefixedName) return visitor:visit-prefixedName($node)
    case element(anyElementName) return visitor:visit-anyElementName($node)
    case element(nestedAnnotationElement) return visitor:visit-nestedAnnotationElement($node)
    case element(anyAttributeName) return visitor:visit-anyAttributeName($node)
    case element(annotationAttributesContent) return visitor:visit-annotationAttributesContent($node)
    case element(foreignElementNameNotKeyword) return visitor:visit-foreignElementNameNotKeyword($node)
    case element(annotationElementNotKeyword) return visitor:visit-annotationElementNotKeyword($node)
    case element(foreignElementName) return visitor:visit-foreignElementName($node)
    case element(annotationElement) return visitor:visit-annotationElement($node)
    case element(foreignAttributeName) return visitor:visit-foreignAttributeName($node)
    case element(annotations) return visitor:visit-annotations($node)
    case element(followAnnotations) return visitor:visit-followAnnotations($node)
    case element(simpleNameClass) return visitor:visit-simpleNameClass($node)
    case element(exceptNameClass) return visitor:visit-exceptNameClass($node)
    case element(leadAnnotatedSimpleNameClass) return visitor:visit-leadAnnotatedSimpleNameClass($node)
    case element(annotatedSimpleNameClass) return visitor:visit-annotatedSimpleNameClass($node)
    case element(leadAnnotatedExceptNameClass) return visitor:visit-leadAnnotatedExceptNameClass($node)
    case element(annotatedExceptNameClass) return visitor:visit-annotatedExceptNameClass($node)
    case element(innerNameClass) return visitor:visit-innerNameClass($node)
    case element(nameClass) return visitor:visit-nameClass($node)
    case element(param) return visitor:visit-param($node)
    case element(optParams) return visitor:visit-optParams($node)
    case element(datatypeValue) return visitor:visit-datatypeValue($node)
    case element(datatypeName) return visitor:visit-datatypeName($node)
    case element(ref) return visitor:visit-ref($node)
    case element(dataExcept) return visitor:visit-dataExcept($node)
    case element(primary) return visitor:visit-primary($node)
    case element(leadAnnotatedPrimary) return visitor:visit-leadAnnotatedPrimary($node)
    case element(leadAnnotatedDataExcept) return visitor:visit-leadAnnotatedDataExcept($node)
    case element(annotatedDataExcept) return visitor:visit-annotatedDataExcept($node)
    case element(annotatedPrimary) return visitor:visit-annotatedPrimary($node)
    case element(innerParticle) return visitor:visit-innerParticle($node)
    case element(innerPattern) return visitor:visit-innerPattern($node)
    case element(pattern) return visitor:visit-pattern($node)
    case element(includeDiv) return visitor:visit-includeDiv($node)
    case element(div) return visitor:visit-div($node)
    case element(includeComponent) return visitor:visit-includeComponent($node)
    case element(annotatedIncludeComponent) return visitor:visit-annotatedIncludeComponent($node)
    case element(includeMember) return visitor:visit-includeMember($node)
    case element(includeBody) return visitor:visit-includeBody($node)
    case element(optIncludeBody) return visitor:visit-optIncludeBody($node)
    case element(optInherit) return visitor:visit-optInherit($node)
    case element(anyURILiteral) return visitor:visit-anyURILiteral($node)
    case element(include) return visitor:visit-include($node)
    case element(assignOp) return visitor:visit-assignOp($node)
    case element(define) return visitor:visit-define($node)
    case element(start) return visitor:visit-start($node)
    case element(component) return visitor:visit-component($node)
    case element(annotatedComponent) return visitor:visit-annotatedComponent($node)
    case element(member) return visitor:visit-member($node)
    case element(grammar) return visitor:visit-grammar($node)
    case element(topLevelBody) return visitor:visit-topLevelBody($node)
    case element(namespaceURILiteral) return visitor:visit-namespaceURILiteral($node)
    case element(datatypePrefix) return visitor:visit-datatypePrefix($node)
    case element(namespacePrefix) return visitor:visit-namespacePrefix($node)
    case element(decl) return visitor:visit-decl($node)
    case element(topLevel) return visitor:visit-topLevel($node)
    default return fn:error(xs:QName("UNKNOWN-VISITOR"),"Unknown")
};  


(:~
 : Provides a visitor for literal parsed node
~:)
declare function visitor:visit-literal(
    $node as element(literal)
) as item() {
     if(visitor:has-function("literal"))
     then visitor:call("literal",$node)
     else $node
};

(:~
 : Provides a visitor for identifierOrKeyword parsed node
~:)
declare function visitor:visit-identifierOrKeyword(
    $node as element(identifierOrKeyword)
) as item() {
     if(visitor:has-function("identifierOrKeyword"))
     then visitor:call("identifierOrKeyword",$node)
     else $node
};

(:~
 : Provides a visitor for documentations parsed node
~:)
declare function visitor:visit-documentations(
    $node as element(documentations)
) as item() {
     if(visitor:has-function("documentations"))
     then visitor:call("documentations",$node)
     else $node
};

(:~
 : Provides a visitor for prefixedName parsed node
~:)
declare function visitor:visit-prefixedName(
    $node as element(prefixedName)
) as item() {
     if(visitor:has-function("prefixedName"))
     then visitor:call("prefixedName",$node)
     else $node
};

(:~
 : Provides a visitor for anyElementName parsed node
~:)
declare function visitor:visit-anyElementName(
    $node as element(anyElementName)
) as item() {
     if(visitor:has-function("anyElementName"))
     then visitor:call("anyElementName",$node)
     else $node
};

(:~
 : Provides a visitor for nestedAnnotationElement parsed node
~:)
declare function visitor:visit-nestedAnnotationElement(
    $node as element(nestedAnnotationElement)
) as item() {
     if(visitor:has-function("nestedAnnotationElement"))
     then visitor:call("nestedAnnotationElement",$node)
     else $node
};

(:~
 : Provides a visitor for anyAttributeName parsed node
~:)
declare function visitor:visit-anyAttributeName(
    $node as element(anyAttributeName)
) as item() {
     if(visitor:has-function("anyAttributeName"))
     then visitor:call("anyAttributeName",$node)
     else $node
};

(:~
 : Provides a visitor for annotationAttributesContent parsed node
~:)
declare function visitor:visit-annotationAttributesContent(
    $node as element(annotationAttributesContent)
) as item() {
     if(visitor:has-function("annotationAttributesContent"))
     then visitor:call("annotationAttributesContent",$node)
     else $node
};

(:~
 : Provides a visitor for foreignElementNameNotKeyword parsed node
~:)
declare function visitor:visit-foreignElementNameNotKeyword(
    $node as element(foreignElementNameNotKeyword)
) as item() {
     if(visitor:has-function("foreignElementNameNotKeyword"))
     then visitor:call("foreignElementNameNotKeyword",$node)
     else $node
};

(:~
 : Provides a visitor for annotationElementNotKeyword parsed node
~:)
declare function visitor:visit-annotationElementNotKeyword(
    $node as element(annotationElementNotKeyword)
) as item() {
     if(visitor:has-function("annotationElementNotKeyword"))
     then visitor:call("annotationElementNotKeyword",$node)
     else $node
};

(:~
 : Provides a visitor for foreignElementName parsed node
~:)
declare function visitor:visit-foreignElementName(
    $node as element(foreignElementName)
) as item() {
     if(visitor:has-function("foreignElementName"))
     then visitor:call("foreignElementName",$node)
     else $node
};

(:~
 : Provides a visitor for annotationElement parsed node
~:)
declare function visitor:visit-annotationElement(
    $node as element(annotationElement)
) as item() {
     if(visitor:has-function("annotationElement"))
     then visitor:call("annotationElement",$node)
     else $node
};

(:~
 : Provides a visitor for foreignAttributeName parsed node
~:)
declare function visitor:visit-foreignAttributeName(
    $node as element(foreignAttributeName)
) as item() {
     if(visitor:has-function("foreignAttributeName"))
     then visitor:call("foreignAttributeName",$node)
     else $node
};

(:~
 : Provides a visitor for annotations parsed node
~:)
declare function visitor:visit-annotations(
    $node as element(annotations)
) as item() {
     if(visitor:has-function("annotations"))
     then visitor:call("annotations",$node)
     else $node
};

(:~
 : Provides a visitor for followAnnotations parsed node
~:)
declare function visitor:visit-followAnnotations(
    $node as element(followAnnotations)
) as item() {
     if(visitor:has-function("followAnnotations"))
     then visitor:call("followAnnotations",$node)
     else $node
};

(:~
 : Provides a visitor for simpleNameClass parsed node
~:)
declare function visitor:visit-simpleNameClass(
    $node as element(simpleNameClass)
) as item() {
     if(visitor:has-function("simpleNameClass"))
     then visitor:call("simpleNameClass",$node)
     else $node
};

(:~
 : Provides a visitor for exceptNameClass parsed node
~:)
declare function visitor:visit-exceptNameClass(
    $node as element(exceptNameClass)
) as item() {
     if(visitor:has-function("exceptNameClass"))
     then visitor:call("exceptNameClass",$node)
     else $node
};

(:~
 : Provides a visitor for leadAnnotatedSimpleNameClass parsed node
~:)
declare function visitor:visit-leadAnnotatedSimpleNameClass(
    $node as element(leadAnnotatedSimpleNameClass)
) as item() {
     if(visitor:has-function("leadAnnotatedSimpleNameClass"))
     then visitor:call("leadAnnotatedSimpleNameClass",$node)
     else $node
};

(:~
 : Provides a visitor for annotatedSimpleNameClass parsed node
~:)
declare function visitor:visit-annotatedSimpleNameClass(
    $node as element(annotatedSimpleNameClass)
) as item() {
     if(visitor:has-function("annotatedSimpleNameClass"))
     then visitor:call("annotatedSimpleNameClass",$node)
     else $node
};

(:~
 : Provides a visitor for leadAnnotatedExceptNameClass parsed node
~:)
declare function visitor:visit-leadAnnotatedExceptNameClass(
    $node as element(leadAnnotatedExceptNameClass)
) as item() {
     if(visitor:has-function("leadAnnotatedExceptNameClass"))
     then visitor:call("leadAnnotatedExceptNameClass",$node)
     else $node
};

(:~
 : Provides a visitor for annotatedExceptNameClass parsed node
~:)
declare function visitor:visit-annotatedExceptNameClass(
    $node as element(annotatedExceptNameClass)
) as item() {
     if(visitor:has-function("annotatedExceptNameClass"))
     then visitor:call("annotatedExceptNameClass",$node)
     else $node
};

(:~
 : Provides a visitor for innerNameClass parsed node
~:)
declare function visitor:visit-innerNameClass(
    $node as element(innerNameClass)
) as item() {
     if(visitor:has-function("innerNameClass"))
     then visitor:call("innerNameClass",$node)
     else $node
};

(:~
 : Provides a visitor for nameClass parsed node
~:)
declare function visitor:visit-nameClass(
    $node as element(nameClass)
) as item() {
     if(visitor:has-function("nameClass"))
     then visitor:call("nameClass",$node)
     else $node
};

(:~
 : Provides a visitor for param parsed node
~:)
declare function visitor:visit-param(
    $node as element(param)
) as item() {
     if(visitor:has-function("param"))
     then visitor:call("param",$node)
     else $node
};

(:~
 : Provides a visitor for optParams parsed node
~:)
declare function visitor:visit-optParams(
    $node as element(optParams)
) as item() {
     if(visitor:has-function("optParams"))
     then visitor:call("optParams",$node)
     else $node
};

(:~
 : Provides a visitor for datatypeValue parsed node
~:)
declare function visitor:visit-datatypeValue(
    $node as element(datatypeValue)
) as item() {
     if(visitor:has-function("datatypeValue"))
     then visitor:call("datatypeValue",$node)
     else $node
};

(:~
 : Provides a visitor for datatypeName parsed node
~:)
declare function visitor:visit-datatypeName(
    $node as element(datatypeName)
) as item() {
     if(visitor:has-function("datatypeName"))
     then visitor:call("datatypeName",$node)
     else $node
};

(:~
 : Provides a visitor for ref parsed node
~:)
declare function visitor:visit-ref(
    $node as element(ref)
) as item() {
     if(visitor:has-function("ref"))
     then visitor:call("ref",$node)
     else $node
};

(:~
 : Provides a visitor for dataExcept parsed node
~:)
declare function visitor:visit-dataExcept(
    $node as element(dataExcept)
) as item() {
     if(visitor:has-function("dataExcept"))
     then visitor:call("dataExcept",$node)
     else $node
};

(:~
 : Provides a visitor for primary parsed node
~:)
declare function visitor:visit-primary(
    $node as element(primary)
) as item() {
     if(visitor:has-function("primary"))
     then visitor:call("primary",$node)
     else $node
};

(:~
 : Provides a visitor for leadAnnotatedPrimary parsed node
~:)
declare function visitor:visit-leadAnnotatedPrimary(
    $node as element(leadAnnotatedPrimary)
) as item() {
     if(visitor:has-function("leadAnnotatedPrimary"))
     then visitor:call("leadAnnotatedPrimary",$node)
     else $node
};

(:~
 : Provides a visitor for leadAnnotatedDataExcept parsed node
~:)
declare function visitor:visit-leadAnnotatedDataExcept(
    $node as element(leadAnnotatedDataExcept)
) as item() {
     if(visitor:has-function("leadAnnotatedDataExcept"))
     then visitor:call("leadAnnotatedDataExcept",$node)
     else $node
};

(:~
 : Provides a visitor for annotatedDataExcept parsed node
~:)
declare function visitor:visit-annotatedDataExcept(
    $node as element(annotatedDataExcept)
) as item() {
     if(visitor:has-function("annotatedDataExcept"))
     then visitor:call("annotatedDataExcept",$node)
     else $node
};

(:~
 : Provides a visitor for annotatedPrimary parsed node
~:)
declare function visitor:visit-annotatedPrimary(
    $node as element(annotatedPrimary)
) as item() {
     if(visitor:has-function("annotatedPrimary"))
     then visitor:call("annotatedPrimary",$node)
     else $node
};

(:~
 : Provides a visitor for innerParticle parsed node
~:)
declare function visitor:visit-innerParticle(
    $node as element(innerParticle)
) as item() {
     if(visitor:has-function("innerParticle"))
     then visitor:call("innerParticle",$node)
     else $node
};

(:~
 : Provides a visitor for innerPattern parsed node
~:)
declare function visitor:visit-innerPattern(
    $node as element(innerPattern)
) as item() {
     if(visitor:has-function("innerPattern"))
     then visitor:call("innerPattern",$node)
     else $node
};

(:~
 : Provides a visitor for pattern parsed node
~:)
declare function visitor:visit-pattern(
    $node as element(pattern)
) as item() {
     if(visitor:has-function("pattern"))
     then visitor:call("pattern",$node)
     else $node
};

(:~
 : Provides a visitor for includeDiv parsed node
~:)
declare function visitor:visit-includeDiv(
    $node as element(includeDiv)
) as item() {
     if(visitor:has-function("includeDiv"))
     then visitor:call("includeDiv",$node)
     else $node
};

(:~
 : Provides a visitor for div parsed node
~:)
declare function visitor:visit-div(
    $node as element(div)
) as item() {
     if(visitor:has-function("div"))
     then visitor:call("div",$node)
     else $node
};

(:~
 : Provides a visitor for includeComponent parsed node
~:)
declare function visitor:visit-includeComponent(
    $node as element(includeComponent)
) as item() {
     if(visitor:has-function("includeComponent"))
     then visitor:call("includeComponent",$node)
     else $node
};

(:~
 : Provides a visitor for annotatedIncludeComponent parsed node
~:)
declare function visitor:visit-annotatedIncludeComponent(
    $node as element(annotatedIncludeComponent)
) as item() {
     if(visitor:has-function("annotatedIncludeComponent"))
     then visitor:call("annotatedIncludeComponent",$node)
     else $node
};

(:~
 : Provides a visitor for includeMember parsed node
~:)
declare function visitor:visit-includeMember(
    $node as element(includeMember)
) as item() {
     if(visitor:has-function("includeMember"))
     then visitor:call("includeMember",$node)
     else $node
};

(:~
 : Provides a visitor for includeBody parsed node
~:)
declare function visitor:visit-includeBody(
    $node as element(includeBody)
) as item() {
     if(visitor:has-function("includeBody"))
     then visitor:call("includeBody",$node)
     else $node
};

(:~
 : Provides a visitor for optIncludeBody parsed node
~:)
declare function visitor:visit-optIncludeBody(
    $node as element(optIncludeBody)
) as item() {
     if(visitor:has-function("optIncludeBody"))
     then visitor:call("optIncludeBody",$node)
     else $node
};

(:~
 : Provides a visitor for optInherit parsed node
~:)
declare function visitor:visit-optInherit(
    $node as element(optInherit)
) as item() {
     if(visitor:has-function("optInherit"))
     then visitor:call("optInherit",$node)
     else $node
};

(:~
 : Provides a visitor for anyURILiteral parsed node
~:)
declare function visitor:visit-anyURILiteral(
    $node as element(anyURILiteral)
) as item() {
     if(visitor:has-function("anyURILiteral"))
     then visitor:call("anyURILiteral",$node)
     else $node
};

(:~
 : Provides a visitor for include parsed node
~:)
declare function visitor:visit-include(
    $node as element(include)
) as item() {
     if(visitor:has-function("include"))
     then visitor:call("include",$node)
     else $node
};

(:~
 : Provides a visitor for assignOp parsed node
~:)
declare function visitor:visit-assignOp(
    $node as element(assignOp)
) as item() {
     if(visitor:has-function("assignOp"))
     then visitor:call("assignOp",$node)
     else $node
};

(:~
 : Provides a visitor for define parsed node
~:)
declare function visitor:visit-define(
    $node as element(define)
) as item() {
     if(visitor:has-function("define"))
     then visitor:call("define",$node)
     else $node
};

(:~
 : Provides a visitor for start parsed node
~:)
declare function visitor:visit-start(
    $node as element(start)
) as item() {
     if(visitor:has-function("start"))
     then visitor:call("start",$node)
     else $node
};

(:~
 : Provides a visitor for component parsed node
~:)
declare function visitor:visit-component(
    $node as element(component)
) as item() {
     if(visitor:has-function("component"))
     then visitor:call("component",$node)
     else $node
};

(:~
 : Provides a visitor for annotatedComponent parsed node
~:)
declare function visitor:visit-annotatedComponent(
    $node as element(annotatedComponent)
) as item() {
     if(visitor:has-function("annotatedComponent"))
     then visitor:call("annotatedComponent",$node)
     else $node
};

(:~
 : Provides a visitor for member parsed node
~:)
declare function visitor:visit-member(
    $node as element(member)
) as item() {
     if(visitor:has-function("member"))
     then visitor:call("member",$node)
     else $node
};

(:~
 : Provides a visitor for grammar parsed node
~:)
declare function visitor:visit-grammar(
    $node as element(grammar)
) as item() {
     if(visitor:has-function("grammar"))
     then visitor:call("grammar",$node)
     else $node
};

(:~
 : Provides a visitor for topLevelBody parsed node
~:)
declare function visitor:visit-topLevelBody(
    $node as element(topLevelBody)
) as item() {
     if(visitor:has-function("topLevelBody"))
     then visitor:call("topLevelBody",$node)
     else $node
};

(:~
 : Provides a visitor for namespaceURILiteral parsed node
~:)
declare function visitor:visit-namespaceURILiteral(
    $node as element(namespaceURILiteral)
) as item() {
     if(visitor:has-function("namespaceURILiteral"))
     then visitor:call("namespaceURILiteral",$node)
     else $node
};

(:~
 : Provides a visitor for datatypePrefix parsed node
~:)
declare function visitor:visit-datatypePrefix(
    $node as element(datatypePrefix)
) as item() {
     if(visitor:has-function("datatypePrefix"))
     then visitor:call("datatypePrefix",$node)
     else $node
};

(:~
 : Provides a visitor for namespacePrefix parsed node
~:)
declare function visitor:visit-namespacePrefix(
    $node as element(namespacePrefix)
) as item() {
     if(visitor:has-function("namespacePrefix"))
     then visitor:call("namespacePrefix",$node)
     else $node
};

(:~
 : Provides a visitor for decl parsed node
~:)
declare function visitor:visit-decl(
    $node as element(decl)
) as item() {
     if(visitor:has-function("decl"))
     then visitor:call("decl",$node)
     else $node
};

(:~
 : Provides a visitor for topLevel parsed node
~:)
declare function visitor:visit-topLevel(
    $node as element(topLevel)
) as item() {
     if(visitor:has-function("topLevel"))
     then visitor:call("topLevel",$node)
     else $node
};
