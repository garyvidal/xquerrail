<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" 
 exclude-result-prefixes="xs" version="2.0"
 xmlns:domain="http://www.xquerrail-framework.com/domain"
 xmlns:search="http://marklogic.com/appservices/search"
 xmlns:util="http://www.xquerrail-framework.com/lib/utilities">
 
<xsl:output media-type="text" include-content-type="no" indent="yes" omit-xml-declaration="yes" exclude-result-prefixes="#all"/>

<xsl:param name="package"/>
<xsl:variable name="app-name" select="/domain:domain/domain:name"/>
<xsl:variable name="app-namespace" select="/domain:domain/domain:namespace"/>
<xsl:variable name="controller-author" select="/domain:domain/domain:author"/>
<xsl:variable name="controller-description" select="/domain:domain/domain:description"/>
<xsl:variable name="controller-version" select="/domain:domain/domain:version"/>
<xsl:include href="main-builder.xsl"/>
 
<xsl:template match="/">
  <xsl:message>Generating Package: <xsl:value-of select="domain:domain/domain:name"/></xsl:message>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="domain:domain">
   <xsl:apply-templates select="domain:controller"/> 
</xsl:template>
 
<xsl:template match="domain:controller">
<!-- <xsl:result-document href="{$package}/controllers/{./domain:name}:controller.xqy">-->
 <xsl:result-document href="../../../{$app-name}/controllers/{./@name}.xqy">(:@AUTO-GENERATED@:)
xquery version "1.0-ml";
(:~
 : Controller :  <xsl:value-of select="@name"/> 
 :               <xsl:value-of select="$controller-description"/>
 : @author   <xsl:value-of select="$controller-author"/>
 : @version  <xsl:value-of select="$controller-version"/>  
~:)

module namespace controller = "<xsl:value-of select="$app-namespace"/>/controller/<xsl:value-of select="@name"/>";

import module namespace response =  "http://www.xquerrail-framework.com/response"
   at "../../_framework/response.xqy";
   
import module namespace request =  "http://www.xquerrail-framework.com/request"
   at "../../_framework/request.xqy";

(:Default Imports:)
declare namespace search = "http://marklogic.com/appservices/search";
<xsl:apply-templates select="*" mode="controller-header"/>
<xsl:apply-templates select="." mode="controller-header"/>

(:Options Definition:)
declare option xdmp:mapping "false";

declare variable $collation := "http://marklogic.com/collation/codepoint";

 <!-- Controller Required Functions --> 
(:Controller Required Functions:)
 <xsl:call-template name="name-template">
  <xsl:with-param name="controller" select="."/>
 </xsl:call-template>
 
 <xsl:call-template name="main-template">
  <xsl:with-param name="controller" select="."/>
 </xsl:call-template>
 
 <xsl:call-template name="info-template">
  <xsl:with-param name="controller" select="."/>
 </xsl:call-template>
 
<!-- Controller Web Templates -->
(:Controller HTML Functions:)
 <xsl:call-template name="index-template">
  <xsl:with-param name="controller" select="."/>
 </xsl:call-template>
 
 <xsl:call-template name="show-template">
  <xsl:with-param name="controller" select="."/>
 </xsl:call-template>
 
 <xsl:call-template name="new-template">
  <xsl:with-param name="controller" select="."/>
 </xsl:call-template>
 
 <xsl:call-template name="edit-template">
  <xsl:with-param name="controller" select="."/>
 </xsl:call-template>
 
 <xsl:call-template name="remove-template">
  <xsl:with-param name="controller" select="."/>
 </xsl:call-template>
 
 <xsl:call-template name="find-template">
  <xsl:with-param name="controller" select="."/>
 </xsl:call-template>
 
 <xsl:call-template name="list-template">
  <xsl:with-param name="controller" select="."/>
 </xsl:call-template>
 
 <!-- Restful Service Templates -->
 <xsl:call-template name="create-template">
  <xsl:with-param name="controller" select="."/>
 </xsl:call-template>
 
 <xsl:call-template name="update-template">
  <xsl:with-param name="controller" select="."/>
 </xsl:call-template>
 
 <xsl:call-template name="get-template">
  <xsl:with-param name="controller" select="."/>
 </xsl:call-template>
 
 <xsl:call-template name="delete-template">
  <xsl:with-param name="controller" select="."/>
 </xsl:call-template>
 
 <xsl:call-template name="search-template">
  <xsl:with-param name="controller" select="."/>
 </xsl:call-template>
 
<!--End Controller Generation-->
</xsl:result-document>
</xsl:template>
<!--
 Define all your Body Function Templates
-->
<xsl:template match="domain:controller" mode="controller-body">

<xsl:apply-templates select="*" mode="controller-body"/>
<!--End Builder Template-->
</xsl:template>


<!-- Controller Required Templates -->

<xsl:template name="name-template">
   <xsl:param name="controller" select="."/>
declare function controller:name() {
"<xsl:value-of select="$controller/@name"/>"
}; 
</xsl:template>

<xsl:template name="main-template">
 <xsl:param name="controller" select="."/>
declare function controller:main($request)
{
   if(request:format() eq "xml") 
   then (
      response:format(request:format()),
      response:template("main"),
      response:view("info"),
      response:flush()
   ) else (
     controller:index()  
   )
);
</xsl:template>

<xsl:template name="info-template">
   <xsl:param name="controller" select="."/>
  declare function controller:info() { 
  <info>
    
  
  </info>
};
</xsl:template>

<!-- Web Builder Templates -->
<xsl:template name="index-template">
   <xsl:param name="controller" select="."/>
(:~
 : Default Index Page 
~:)
declare function controller:index()
{
  response:template("main"),
  response:view("index"),
  response:data(controller:list(request:request())),
  response:flush()
};
</xsl:template>

<xsl:template name="show-template">
  <xsl:param name="controller" select="."/>
 (:~ Show a record ~:) 
 
declare function controller:index()
{
   let $get := controller:show()
   return
   (
        response:data("context",$update),
        <xsl:apply-templates select="$controller/dependencies"/>,
        response:template("main"),
        response:view("new"),  
        response:flush()
    )     
};   
</xsl:template>
<!--New Template-->
<xsl:template name="new-template">
  <xsl:param name="controller" select="."/>
declare function controller:new()
{
	   let $create := controller:create()
	   return
	   (
	      response:data("context",$create),
	      <xsl:apply-templates select="$controller/dependencies"/>,
	      response:template("main"),
	      response:view("new"),  
	      response:flush()
	   )  
}; 
</xsl:template>


<xsl:template name="edit-template">
  <xsl:param name="controller" select="."/>
  declare function controller:edit()
  {
     let $update := controller:get(request:params())
     return
     (
        response:data("context",$update),
        <xsl:apply-templates select="$controller/dependencies"/>,
        response:template("main"),
        response:view("edit"),  
        response:flush()
     )
  };

</xsl:template>

<xsl:template name="save-template">
  <xsl:param name="controller" select="."/>
(:~
 :  Saves a controller
 :
~:)
declare function controller:save()
{
   let $update := 
       try {
         controller:update()
       } catch($exception) {
         response:error("404"),$exception)
       }
   return
   if(response:has-error()) 
   then (
     response:flash("error_message","Could not save"),
     response:flush()
   ) else (
      response:data("context",$update),
      <xsl:apply-templates select="$controller/dependencies"/>,
      response:template("main"),
      response:redirect("show"),  
      response:flush()
   )
};
</xsl:template>

<xsl:template name="remove-template">
   <xsl:param name="controller" select="."/>
declare function controller:remove()
{
  let $delete := 
  try { 
     controller:delete(request:params())
  } catch($exception) {
    response:error("404",$exception) 
  }
  return
  if(response:has-error()) then (
     response:flash("error_message","Could not Delete"),
     response:flush()
   ) else ( 
      response:flash("status",fn:status($delete)), 
      response:redirect(controller:url(controller:name(),"index"))
      response:flush()
  )
};
</xsl:template>  
<xsl:template name="list-template">
   <xsl:param name="controller" select="."/>
(:~
 : Returns a list of  records
~:)
declare function controller:find()
{
  let $find := 
  try { 
    controller:find(request:params())
  } catch($exception) {
    response:error("404",$exception) 
  }
  return
	  if(response:error()) then (
	     response:flash("error_message",response:error()//*:format-string),
	     response:flush()
	   ) else ( 
	    response:controller(controller:name()),
	    response:template("main"),
	    response:view("list"),
	    response:data("context",$find)
	    response:flush()
	  )
};
</xsl:template>

 <xsl:template name="find-template">
   <xsl:param name="controller" select="."/>
(:~
 : Finds Records
~:)
declare function controller:find()
{
  let $find := 
  try { 
    controller:search()
  } catch($exception) {
    response:error("404",$exception) 
  }
  return
	  if(response:error()) then (
	     response:flash("error_message",response:error()//*:format-string),
	     response:flush()
	   ) else ( 
	    response:controller(controller:name()),
	    response:template("main"),
	    response:view("find"),
	    response:data("context",$find)
	    response:flush()
	  )
};
</xsl:template>  
 
<!--REST Service Builder Templates -->
<xsl:template match="domain:controller" mode="controller-header">
(:~
 : Controller Definition 
~:)
declare variable $domain:controller as element(domain:controller) := 
<xsl:copy-of select="."/>
;
(:~
 : Search Options Configuration
~:)

</xsl:template>

<xsl:template match="domain:namespace" mode="controller-header">
declare namespace <xsl:value-of select="@prefix"/> = "<xsl:value-of select="@uri"/>";
</xsl:template>


<xsl:template match="domain:optionlist" mode="controller-body">
(:~
 : Returns a list of <xsl:value-of select="@name" />
~:)    
declare function controller:<xsl:value-of select="@name"/>() as map:map 
{
<xsl:element name="{@name}">
<xsl:copy-of select="node()" exclude-result-prefixes="#all" copy-namespaces="no" />
</xsl:element> 
}; 
</xsl:template>
 
<xsl:template name="update-template">
 <xsl:param name="controller"/>
(:~
 : Update Operation <xsl:value-of select="$controller/@name"/>
~:) 
declare function controller:update()
{
      model:update(<xsl:value-of select="util:model-call-update-params"/>)
};
</xsl:template>

<xsl:template name="create-template" xml:space="true">
  <xsl:param name="controller"/>
(:~
 : Create <xsl:value-of select="$controller/@name"/>
~:) 
declare function controller:create() {
   model:create(
      <xsl:value-of select="util:model-create-call-params($controller)"/>
   )  
};
</xsl:template>
 
 <!--Delete Template-->
 <xsl:template name="delete-template">
 <xsl:param name="controller" as="element()"/>
(:~
 :  Deletes a <xsl:value-of select="$controller/@name"/>
~:)  
declare function controller:delete()
{
     model:delete(
        request:param("id")
     )
};
 </xsl:template>
 
 <!--Get Template-->
 <xsl:template name="get-template">
 <xsl:param name="controller"/>
(:~
 :  Retrieves a <xsl:value-of select="$controller/@name"/>
~:) 
declare function controller:get()
{
    model:get(
        request:param("id")
    ) 
};
 </xsl:template>
 
 <xsl:template name="search-template">
  <xsl:param name="controller"/>
(:~
 : Provide search interface for <xsl:value-of select="$controller/@name"/>
 : @param $query - Search query 
 : @param $sort - Sorting Key to sort results by
 : @param $start 
~:)
declare function controller:search()
{
   model:search(
     request:param("query"),
     request:param("start"),
     request:param("page"),
     request:param("sort")
   )
};
 </xsl:template>
 <!--
  ============================================================
  XSL FUNCTIONS
  ============================================================
 -->
 
<!--
  Resolves the Type for the given controller element/attribute
-->
 <xsl:function name="util:cast-data-param">
  <xsl:param name="controller-node"/>
   <xsl:choose>
       <xsl:when test="starts-with($controller-node/@type, 'xs:')"> cast as <xsl:value-of select="$controller-node/@type"/></xsl:when>
    <xsl:otherwise> cast as <xsl:value-of select="local-name($controller-node)"/>(<xsl:value-of select="tokenize($controller-node/@type,':')[2]"/>)</xsl:otherwise>   
   </xsl:choose>
 </xsl:function>
 
 <!--Update Parameter Template-->    
<xsl:function name="util:controller-update-params">
<xsl:param name="controller" as="element(domain:controller)"/>
<xsl:variable name="id-elem" select="$controller/domain:element[@id-field eq 'true']"/>
  $<xsl:value-of select="$id-elem/@name"/> <xsl:value-of select="util:resolve-type($id-elem)"/>,
<xsl:for-each select="$controller//(domain:element[not(@id-field = 'true')]|domain:attribute)"> 
  $<xsl:value-of select="./@name"/> <xsl:value-of select="util:resolve-type(.)"/><xsl:if test="position() ne last()">,</xsl:if></xsl:for-each>
</xsl:function> 
 
 <!--Create Parameter Template-->    
 <xsl:function name="util:controller-create-params">
  <xsl:param name="controller" as="element(domain:controller)"/>
  <xsl:for-each select="$controller//(domain:element|domain:attribute)[not(@id-field = 'true')]"> 
  $<xsl:value-of select="./@name"/> <xsl:value-of select="util:resolve-type(.)"/><xsl:if test="position() ne last()">,</xsl:if></xsl:for-each>
 </xsl:function> 

 <!--Create Comment Template-->    
 <xsl:function name="util:controller-create-comments">
  <xsl:param name="controller" as="element(domain:controller)"/>
  <xsl:for-each select="$controller//(domain:element|domain:attribute)"> 
   <xsl:variable name="description" select="if(./@description) then ./@description else ./@name"/>
 : @param $<xsl:value-of select="./@name"/> - <xsl:value-of select="$description"/>    
  </xsl:for-each>
 </xsl:function>  
 
 <!--Update Comment Template-->    
 <xsl:function name="util:controller-update-comments">
  <xsl:param name="controller" as="element(domain:controller)"/>
  <xsl:for-each select="$controller//(domain:element|domain:attribute)[not(@id-field)]"> 
   <xsl:variable name="description" select="if(./@description) then ./@description else ./@name"/>
 : @param <xsl:value-of select="./@name"/> - <xsl:value-of select="$description"/>    
  </xsl:for-each>
 </xsl:function>  
 
 <!--Global Chomper-->
<xsl:template match="*" mode="controller-body"/>
<xsl:template match="*" mode="controller-header"/>
</xsl:stylesheet>
