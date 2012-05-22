<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" 
    xmlns:g="http://www.w3.org/2001/03/XPath/grammar"
    version="2.0">
  <xsl:output method="text"/>
  <xsl:variable name="productions" select="reverse(//processing-instruction('TOKENS')//preceding::g:production)"/>
  <xsl:variable name="baseName" select="substring-before(substring-after(base-uri(.),'grammars/'),'.xml')"/>
    
<xsl:template match="/">xquery version "1.0-ml";
(:~
 : Parser Visitor for <xsl:value-of select="$baseName"/>
~:)    
module namespace visitor = "<xsl:value-of select="$baseName"/>-visitor";

import module namespace p = "<xsl:value-of select='$baseName'/>"  at "/_framework/parsers/<xsl:value-of select="$baseName"/>.xqy";

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
    <xsl:apply-templates select="$productions"/>    default return fn:error(xs:QName("UNKNOWN-VISITOR"),"Unknown")
};  

<xsl:apply-templates select="$productions" mode='function'/>
</xsl:template>
<!--Matches a production to build typeswitch statement-->    
<xsl:template match="g:production">    case element(<xsl:value-of select="@name"/>) return visitor:visit-<xsl:value-of select="@name"/>($node)&#xA;</xsl:template>
    
    
<xsl:template match="g:production" mode="function">
(:~
 : Provides a visitor for <xsl:value-of select="@name"/> parsed node
~:)
declare function visitor:visit-<xsl:value-of select="@name"/>(
    $node as element(<xsl:value-of select="@name"/>)
) as item() {
     if(visitor:has-function("<xsl:value-of select="@name"/>"))
     then visitor:call("<xsl:value-of select="@name"/>",$node)
     else $node
};
</xsl:template>    </xsl:stylesheet>
