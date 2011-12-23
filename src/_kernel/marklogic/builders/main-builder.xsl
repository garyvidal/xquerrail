<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
 xmlns:xs="http://www.w3.org/2001/XMLSchema" 
 exclude-result-prefixes="xs" version="2.0"
 xmlns:domain="http://www.xquerrail-framework.com/domain"
 xmlns:search="http://marklogic.com/appservices/search"
 xmlns:util="http://www.xquerrail-framework.com/lib/utilities">

 <xsl:param name="bundle" />
 <xsl:param name="namespace"/>
 <xsl:param name="domain"/>
 
 <xsl:variable name="model-basepath">/models/</xsl:variable>
 <xsl:variable name="controller-basepath">/controllers/</xsl:variable>
 <xsl:variable name="view-basepath">/views/</xsl:variable>

 <xsl:variable name="base-namespace" select="concat($namespace,'/',$bundle,'/')"/>
 <xsl:variable name="model-namespace" select="concat($base-namespace,'model')"/>
 <xsl:variable name="controller-namespace" select="concat($base-namespace,'controller')"/>
 <xsl:variable name="view-namespace" select="concat($base-namespace,'view')"/>
 
 <xsl:variable name="application-location" select="concat($bundle,'/')"/>
 <xsl:variable name="controller-location" select="concat($application-location,'controller/')"/>
 <xsl:variable name="model-location" select="concat($application-location,'model/')"/>
 <xsl:variable name="view-location" select="concat($application-location,'view/')"/>
 <xsl:variable name="default-controller-actions">
    <action>list</action>
    <action>index</action> 
    <action>create</action>
    <action>get</action>
    <action>update</action>
    <action>delete</action>
    <action>search</action>
    <action>find</action>
    <action>default</action>
 </xsl:variable>

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
 
 <!--Gets the primary id of the model-->
 <xsl:function name="util:get-primary-id">
  <xsl:param name="model" as="element(domain:model)"/>
  <xsl:value-of select="$model/*[@identity]/@name"/>
 </xsl:function>
 
 <!--
  Resolves the Type for the given model element/attribute
 -->
 <xsl:function name="util:resolve-type">
  <xsl:param name="model-node"/>
  <xsl:choose>
   <xsl:when test="starts-with($model-node/@type, 'xs:')"> as <xsl:value-of select="$model-node/@type"/></xsl:when>
   <xsl:otherwise> as <xsl:value-of select="local-name($model-node)"/>(<xsl:value-of select="tokenize($model-node/@type,':')[2]"/>)</xsl:otherwise>   
  </xsl:choose>
 </xsl:function>
 <xsl:function name="util:model-update-call-params">
    <xsl:param name="model" as="element(domain:model)"/>
    <xsl:variable name="id-elem" select="$model/(domain:element|domain:attribute)[@identity = 'true']"/>
   request:param("<xsl:value-of select="$id-elem/@name"/>") as <xsl:value-of select="util:resolve-type($id-elem)"/>,<xsl:for-each select="$model//(domain:element|domain:attribute)[not(./@identity = 'true')]"> 
   request:param("<xsl:value-of select="@name"/>") cast <xsl:value-of select="util:resolve-type(.)"/><xsl:if test="position() ne last()">,</xsl:if></xsl:for-each>
 </xsl:function>
 <xsl:function name="util:model-create-call-params">
  <xsl:param name="model" as="element(domain:model)"/>
  <xsl:variable name="id-elem" select="$model/(domain:element|domain:attribute)[@identity = 'true']"/>
      <xsl:for-each select="$model//(domain:element|domain:attribute)[not(./@identity = 'true')]"> 
      request:param("<xsl:value-of select="@name"/>") cast <xsl:value-of select="util:resolve-type(.)"/><xsl:if test="position() ne last()">,</xsl:if>
  </xsl:for-each>
 </xsl:function> 
 
 <!--Update Parameter Template-->    
 <xsl:function name="util:model-update-params">
  <xsl:param name="model" as="element(domain:model)"/>
  <xsl:variable name="id-elem" select="$model/(domain:element|domain:attribute)[@identity = 'true']"/>
  $<xsl:value-of select="$id-elem/@name"/><xsl:value-of select="util:resolve-type($id-elem)"/>,<xsl:for-each select="$model//(domain:element|domain:attribute)[not(./@identity = 'true')]"> 
  $<xsl:value-of select="./@name"/> <xsl:value-of select="util:resolve-type(.)"/><xsl:if test="position() ne last()">,</xsl:if></xsl:for-each>
 </xsl:function> 
 
 <!--Create Parameter Template-->    
 <xsl:function name="util:model-create-params">
  <xsl:param name="model" as="element(domain:model)"/>
  <xsl:for-each select="$model//(domain:element|domain:attribute)[not(@identity = 'true')]"> 
   $<xsl:value-of select="./@name"/> <xsl:value-of select="util:resolve-type(.)"/><xsl:if test="position() ne last()">,</xsl:if></xsl:for-each>
 </xsl:function> 
 
 <!--Create Comment Template-->    
 <xsl:function name="util:model-create-comments">
  <xsl:param name="model" as="element(domain:model)"/>
  <xsl:for-each select="$model//(domain:element|domain:attribute)"> 
   <xsl:variable name="description" select="if(./@description) then ./@description else ./@name"/>
   : @param $<xsl:value-of select="./@name"/> - <xsl:value-of select="$description"/>    
  </xsl:for-each>
 </xsl:function>  
 
 <!--Update Comment Template-->    
 <xsl:function name="util:model-update-comments">
  <xsl:param name="model" as="element(domain:model)"/>
  <xsl:for-each select="$model//(domain:element|domain:attribute)[not(@id-field)]"> 
   <xsl:variable name="description" select="if(./@description) then ./@description else ./@name"/>
   : @param <xsl:value-of select="./@name"/> - <xsl:value-of select="$description"/>    
  </xsl:for-each>
 </xsl:function>  
 
</xsl:stylesheet>
