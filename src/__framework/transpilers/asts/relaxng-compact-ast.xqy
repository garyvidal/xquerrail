xquery version "1.0-ml";

module namespace ast = "http://www.xquerrail-framework.com/ast/relaxng-compact";

declare function p:build-ast($node as node())
{
    typeswitch($node)
      case element(topLevel) return p:build-topLevel($node)
      case element(decl) return p:build-decl($node)
      case element(topLevelBody) return p:build-topLevelBody($node)
      case element(grammar) return p:build-grammar($node)
      case element(member) return p:build-member($node)
      case element(annotatedComponent) return p:build-annotatedComponent($node)
      case element(annotations) return p:build-annotations($node)
      case element(documentations) return p:build-documentations($node)
      case element(documentation) return p:build-documentation($node)
      case element(define) return p:build-define($node)
      case element(pattern) return p:build-pattern($node)
      default return ()        
 
};
declare function p:build-annotatedComponent($node as element(annotatedComponent))
{
   
};
declare function p:build-member($node as element(member))
{

};
declare function p:build-grammar($node as element(grammar))
{
   ()
};
declare function p:build-topLevelBody($node as element(topLevelBody))
{
   () 
};
declare function p:build-decl($node as element(decl)
{
  ()
};
declare function p:build-topLevel($node as element(topLevel)
{
  ()
};
declare function p:ast($s as xs:string) as item()*
{
   let $parse := p:parse($s)
   return
      p:build-ast($parse)
};