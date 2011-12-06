<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
 xmlns:xs="http://www.w3.org/2001/XMLSchema" 
 exclude-result-prefixes="xs" version="2.0"
 xmlns:domain="http://www.xquerrail.com/domain"
 xmlns:search="http://marklogic.com/appservices/search">

 <xsl:param name="bundle" />
 <xsl:param name="namespace"/>
 <xsl:param name="domain"/>

 <xsl:variable name="base-namespace" select="concat($namespace,'/',$bundle,'/')"/>
 <xsl:variable name="model-namespace" select="concat($base-namespace,'model')"/>
 <xsl:variable name="controller-namespace" select="concat($base-namespace,'controller')"/>
 <xsl:variable name="view-namespace" select="concat($base-namespace,'view')"/>
 
 <xsl:variable name="application-location" select="concat($bundle,'/')"/>
 <xsl:variable name="controller-location" select="concat($application-location,'controller/')"/>
 <xsl:variable name="model-location" select="concat($application-location,'model/')"/>
 <xsl:variable name="view-location" select="concat($application-location,'view/')"/>
 
 <xsl:function name="util:model-uri">
   <xsl:param name="model" as="element(domain:model)"/>
   <xsl:value-of select="concat($model-location,$model/@name,'-model.xqy')"/>
 </xsl:function>
 
 <xsl:function name="util:controller-uri">
  <xsl:param name="model" as="element(domain:model)"/>
  <xsl:value-of select="concat($model-location,$model/@name,'-controller.xqy')"/>
 </xsl:function> 
 
 <xsl:function name="util:view-uri">
  <xsl:param name="model" as="element(domain:model)"/>
  <xsl:value-of select="concat($model-location,$model/@name,'/')"/>
 </xsl:function>
 
 <xsl:function name="util:resolve-datatype">
  <xsl:param name="value" as="xs:string"/>
    <xsl:choose>
     <xsl:when test="$value = 'xs:string'">xs:string</xsl:when>
     <xsl:when test="$value = 'xs:integer'">xs:integer</xsl:when>
     <xsl:when test="$value = 'xs:long'">xs:long</xsl:when>
    </xsl:choose>
 </xsl:function>
</xsl:stylesheet>
