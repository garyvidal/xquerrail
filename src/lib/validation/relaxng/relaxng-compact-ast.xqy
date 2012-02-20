xquery version "1.0-ml";

module namespace ast = "httast://www.xquerrail-framework.com/ast/relaxng-compact";

declare function ast:build-ast($node as node())
{
    typeswitch($node)
      case element(topLevel) return ast:build-topLevel($node)
      case element(decl) return ast:build-decl($node)
      case element(topLevelBody) return ast:build-topLevelBody($node)
      case element(grammar) return ast:build-grammar($node)
      case element(member) return ast:build-member($node)
      case element(annotatedComponent) return ast:build-annotatedComponent($node)
      case element(annotations) return ast:build-annotations($node)
      case element(documentations) return ast:build-documentations($node)
      case element(documentation) return ast:build-documentation($node)
      case element(define) return ast:build-define($node)
      case element(pattern) return ast:build-pattern($node)
      default return ()        
 
};
declare function ast:build-annotatedComponent($node as element(annotatedComponent))
{
   
};
declare function ast:build-member($node as element(member))
{

};
declare function ast:build-grammar($node as element(grammar))
{
   ()
};
declare function ast:build-topLevelBody($node as element(topLevelBody))
{
   () 
};
declare function ast:build-decl($node as element(decl)
{
  ()
};
declare function ast:build-topLevel($node as element(topLevel)
{
  
};
declare function ast:ast($s as xs:string) as item()*
{
   let $parse := ast:parse($s)
   return
      ast:build-ast($parse)
};