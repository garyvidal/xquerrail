<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
 xmlns:xs="http://www.w3.org/2001/XMLSchema" 
 exclude-result-prefixes="xs" version="2.0"
 xmlns:domain="http://www.xquerrail-framework.com/domain"
 xmlns:search="http://marklogic.com/appservices/search"
 xmlns:builder="http://www.xquerrail-framework.com/builder">
 
<!--Include Main Builders-->
 <xsl:include href="model-builder.xsl"/>
 <xsl:include href="controller-builder.xsl"/>
 <xsl:include href="view-builder.xsl"/>

 <xsl:param name="identity-model" select="'guid'"/>
 <xsl:param name="generate" />
 <xsl:variable name="AUTO-GENERATE" select='
  if($generate eq "true") 
  then "(:@AUTO-GENERATED@:)"
  else ()'/>

 <xsl:output method="xml" media-type="text" include-content-type="no" indent="yes" omit-xml-declaration="yes" exclude-result-prefixes="domain search builder"/>
 
 <xsl:variable name="controller-prefix" select="'controller/'" />
 <xsl:variable name="model-prefix" select="'model/'"/>
 <xsl:variable name="view-prefix" select="'view/'"/>
 
 <xsl:variable name="controller-suffix" select="'-controller.xqy'"/>
 <xsl:variable name="model-suffix" select="'-model.xqy'"/>
 <xsl:variable name="view-suffix" select="'.xqy'"/>
  
 <xsl:variable name="app-name" select="/domain:domain/domain:name"/>
 <xsl:variable name="app-namespace" select="/domain:domain/domain:application-namespace"/>
 <xsl:variable name="app-author" select="/domain:domain/domain:author"/>
 <xsl:variable name="app-description" select="/domain:domain/domain:description"/>
 <xsl:variable name="app-version" select="/domain:domain/domain:version"/>
 <xsl:variable name="app-location" select="concat('/',$app-name)"/>
 <xsl:variable name="app-path" select="concat('../',$app-name)"/> 
 
 <xsl:variable name="content-namespace" select="/domain:domain/domain:content-namespace/@namespace-uri"/>
 
 <xsl:variable name="model-namespace" select="concat($app-namespace,'/','model')"/>
 <xsl:variable name="controller-namespace" select="concat($app-namespace,'/','controller')"/>
 <xsl:variable name="view-namespace" select="concat($app-namespace,'/','view')"/>
 
 <xsl:variable name="controller-location" select="concat($app-location,'/',$controller-prefix)"/>
 <xsl:variable name="model-location" select="concat($app-location,'/',$model-prefix)"/>
 <xsl:variable name="view-location" select="concat($app-location,'/',$view-prefix)"/>

<xsl:template match="/">
  <xsl:message>Scaffolding Application Domain : <xsl:value-of select="$app-name"/></xsl:message>
  <xsl:apply-templates select="." mode="model"/>
  <xsl:apply-templates select="." mode="controller"/>
  <xsl:apply-templates select="." mode="view"/>
</xsl:template>

 <!--Utility Function Library-->
 <xsl:function name="builder:model-location">
   <xsl:param name="model" as="element(domain:model)"/>
   <xsl:value-of select="concat($model-location,$model/@name,$model-suffix)"/>
 </xsl:function>

 <xsl:function name="builder:model-module-uri">
  <xsl:param name="model" as="element(domain:model)"/>
  <xsl:value-of select="concat($model-namespace,'/',$model/@name)"/>
 </xsl:function>
 
 <xsl:function name="builder:controller-location">
  <xsl:param name="model" as="element(domain:model)"/>
  <xsl:value-of select="concat($model-location,$model/@name,$controller-suffix)"/>
 </xsl:function>
 
<xsl:function name="builder:controller-module-uri">
   <xsl:param name="model" as="element(domain:model)"/>
   <xsl:value-of select="concat($model-location,$model/@name,$controller-suffix)"/>
</xsl:function>
 
 <xsl:function name="builder:view-location">
  <xsl:param name="model" as="element(domain:model)"/>
  <xsl:value-of select="concat($view-location,$model/@name,'/')"/>
 </xsl:function>
 
 <xsl:function name="builder:resolve-datatype">
  <xsl:param name="value" as="xs:string?"/>
    <xsl:choose>
     <xsl:when test="$value = 'uuid'">xs:string</xsl:when>
     <xsl:when test="$value = 'identity'">xs:ID</xsl:when>
     <xsl:when test="$value = 'create-timestamp'">xs:dateTime</xsl:when>
     <xsl:when test="$value = 'create-user'">xs:string</xsl:when>
     <xsl:when test="$value = 'update-timestamp'">xs:dateTime</xsl:when>
     <xsl:when test="$value = 'update-user'">xs:string</xsl:when>
     <xsl:when test="$value = 'attachment'">binary()</xsl:when>
     <!--Special Types-->
     <xsl:when test="$value = 'binary'">binary()</xsl:when>
     <xsl:when test="$value = 'schema-element'">schema-element()</xsl:when>
     <xsl:when test="$value = 'query'">cts:query</xsl:when>
     <xsl:when test="$value = 'point'">cts:point</xsl:when>
     <!--Primitives-->
     <xsl:when test="$value = 'string'">xs:string</xsl:when> 
     <xsl:when test="$value = 'integer'">xs:integer</xsl:when>
     <xsl:when test="$value = 'long'">xs:long</xsl:when>
     <xsl:when test="$value = 'double'">xs:double</xsl:when>
     <xsl:when test="$value = 'decimal'">xs:decimal</xsl:when>
     <xsl:when test="$value = 'float'">xs:float</xsl:when>
     <xsl:when test="$value = 'boolean'">xs:boolean</xsl:when>
     <xsl:when test="$value = 'anyURI'">xs:anyURI</xsl:when>
     <!--Dates and Durations-->
     <xsl:when test="$value = 'dateTime'">xs:dateTime</xsl:when>
     <xsl:when test="$value = 'date'">xs:date</xsl:when>
     <xsl:when test="$value = 'time'">xs:time</xsl:when>
     <xsl:when test="$value = 'duration'">xs:duration</xsl:when>
     <xsl:when test="$value = 'dayTime'">xs:dayTimeDuration</xsl:when>
     <xsl:when test="$value = 'yearMonth'">xs:yearMonthDuration</xsl:when>
     <xsl:when test="$value = 'monthDay'">xs:monthDayDuration</xsl:when>
     <xsl:otherwise><xsl:message>No Datatype Resolved[<xsl:value-of select="$value"/>]</xsl:message></xsl:otherwise>  
    </xsl:choose>
 </xsl:function>
 
 <!--
  Resolves the Type for the given model element/attribute
 -->
 <xsl:function name="builder:resolve-as-type">
  <xsl:param name="model-node"/>
  <xsl:variable name="type" select="builder:resolve-datatype($model-node/@type)"/>
  <xsl:variable name="nillable" select="$model-node/domain:constraint/@nillable eq 'true'" />
  <xsl:variable name="nillable-arity">
   <xsl:choose>
    <xsl:when test="$nillable">?</xsl:when>
    <xsl:otherwise></xsl:otherwise>
   </xsl:choose>
  </xsl:variable>
  <xsl:choose>
   <xsl:when test="starts-with($type, 'xs:')"> as <xsl:value-of select="$type"/><xsl:value-of select="$nillable-arity"/></xsl:when>
   <xsl:otherwise> as <xsl:value-of select="local-name($model-node)"/>(<xsl:value-of select="tokenize($model-node/@type,':')[2]"/>)<xsl:value-of select="$nillable-arity"/></xsl:otherwise>   
  </xsl:choose>
 </xsl:function>  
 <!--
  Resolves the Type for the given model element/attribute
 -->
 <xsl:function name="builder:cast-as-datatype">
  <xsl:param name="model-node"/>
  <xsl:variable name="type" select="builder:resolve-datatype($model-node/@type)"/>
  <xsl:variable name="nillable" select="$model-node/domain:constraint/@nillable eq 'true'" />
  <xsl:variable name="nillable-arity">
   <xsl:choose>
    <xsl:when test="$nillable">?</xsl:when>
    <xsl:otherwise></xsl:otherwise>
   </xsl:choose>
  </xsl:variable>
  <xsl:choose>
   <xsl:when test="starts-with($type, 'xs:')"> cast as <xsl:value-of select="$type"/><xsl:value-of select="$nillable-arity"/></xsl:when>
   <xsl:when test="$type = ('schema-element','reference')"/>
   <xsl:otherwise> cast as <xsl:value-of select="local-name($model-node)"/>(<xsl:value-of select="tokenize($model-node/@type,':')[2]"/>)<xsl:value-of select="$nillable-arity"/></xsl:otherwise>   
  </xsl:choose>
 </xsl:function> 
 

 <!--
  =================================================
  Model Utility Functions
  =================================================
 -->

 <!--Gets the primary id of the model-->
 <xsl:function name="builder:get-primary-field-id">
  <xsl:param name="model" as="element(domain:model)"/>
  <xsl:value-of select="$model/*[@identity]/@name"/>
 </xsl:function>
 
<!--Gets the primary field of the model-->
<xsl:function name="builder:get-primary-field">
   <xsl:param name="model" as="element(domain:model)"/>
   <xsl:copy-of select="$model/(domain:element|domain:attribute)[@identity]"/>
</xsl:function>

<!--Gets the primary field of the model-->
<xsl:function name="builder:get-primary-field-datatype">
 <xsl:param name="model" as="element(domain:model)"/>
 <xsl:value-of select="builder:resolve-datatype(builder:get-primary-field($model)/@type)"/>
</xsl:function>

</xsl:stylesheet>