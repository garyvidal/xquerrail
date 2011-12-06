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
<!--<xsl:include href="main-builder.xsl"/>-->
 
<xsl:template name="base-view-header">
xquery version "1.0-ml";
declare default function namespace "http://www.w3.org/2005/xpath-functions";
declare default element namespace "http://www.w3.org/1999/xhtml";
declare variable $response as map:map external;
declare variable $request  as map:map external;
declare variable $context  as map:map external;
</xsl:template> 
<xsl:template match="/">
  <xsl:message>Generating Package Views: <xsl:value-of select="domain:domain/domain:name"/></xsl:message>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="domain:domain">
   <xsl:apply-templates select="domain:controller"/> 
</xsl:template>
 
<xsl:template match="domain:controller">
 <xsl:call-template name="name-template">
  <xsl:with-param name="model" select="."/>
 </xsl:call-template>
 
 <xsl:call-template name="main-template">
  <xsl:with-param name="model" select="."/>
 </xsl:call-template>
 
 <xsl:call-template name="info-template">
  <xsl:with-param name="model" select="."/>
 </xsl:call-template>
 
<!-- Web View Web Templates -->
(:Controller HTML Functions:)
 <xsl:call-template name="index-template">
  <xsl:with-param name="model" select="."/>
 </xsl:call-template>
 
  <xsl:call-template name="show-template">
  <xsl:with-param name="model" select="."/>
  </xsl:call-template>
  <xsl:result-document href="../../{$app-name}/views/{$model:name}:show:html.xqy">(:@GENERATED@:)
     <xsl:call-template name="base-view-header"/>
      <xsl:
  </xsl:result-document>
 </xsl:call-template>
 
 <xsl:call-template name="new-template">
  <xsl:with-param name="model" select="."/>
 </xsl:call-template>
 
 <xsl:call-template name="edit-template">
  <xsl:with-param name="model" select="."/>
 </xsl:call-template>
 
 <xsl:call-template name="remove-template">
  <xsl:with-param name="model" select="."/>
 </xsl:call-template>
 
 <xsl:call-template name="find-template">
  <xsl:with-param name="model" select="."/>
 </xsl:call-template>
 
 <xsl:call-template name="list-template">
  <xsl:with-param name="model" select="."/>
 </xsl:call-template>
 
 <!-- Restful Service Templates -->
 <xsl:call-template name="create-template">
  <xsl:with-param name="model" select="."/>
 </xsl:call-template>
 
 <xsl:call-template name="update-template">
  <xsl:with-param name="model" select="."/>
 </xsl:call-template>
 
 <xsl:call-template name="get-template">
  <xsl:with-param name="model" select="."/>
 </xsl:call-template>
 
 <xsl:call-template name="delete-template">
  <xsl:with-param name="model" select="."/>
 </xsl:call-template>
 
 <xsl:call-template name="search-template">
  <xsl:with-param name="model" select="."/>
 </xsl:call-template>
<!--End Generation-->
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
   <xsl:param name="model" select="."/>
declare function controller:name() {
"<xsl:value-of select="$model/@name"/>"

}; 
</xsl:template>

<xsl:template name="main-template">
  <xsl:param name="model" select="."/>
  xquery version "1.0-ml";
  declare default element namespace "http://www.w3.org/1999/xhtml";
</xsl:template>

<xsl:template name="info-template">
   <xsl:param name="model" select="."/>
};
</xsl:template>

<!-- Web Builder Templates -->
<xsl:template name="index-template">
   <xsl:param name="model" select="."/>
(:~
 : Default Index Page 
~:)
declare function controller:index()
{
  response:template("main"),
  response:view("index"),
  response:data(model:list(request:request())),
  response:flush()
};
</xsl:template>

<xsl:template name="show-template">
  <xsl:param name="model" select="."/>
 (:~ Show a record ~:) 
 
declare function controller:index()
{
   let $get := model:show()
   return
   (
        response:data("context",$update),
        <xsl:apply-templates select="$model/dependencies"/>
        response:template("main"),
        response:view("new"),  
        response:flush()
    )     
};   
</xsl:template>

<xsl:template name="new-template">
  <xsl:param name="model" select="."/>
declare function controller:new()
{
	   let $update := model:create()
	   return
	   (
	      response:data("context",$update),
	      <xsl:apply-templates select="$model/dependencies"/>
	      response:template("main"),
	      response:view("new"),  
	      response:flush()
	   )  
}; 
</xsl:template>


<xsl:template name="edit-template">
  <xsl:param name="model" select="."/>
declare function model:edit()
{
   let $update := model:get(request:params())
   return
   (
      response:data("context",$update),
      <xsl:apply-templates select="$model/dependencies"/>
      response:template("main"),
      response:view("update"),  
      response:flush()
   )
};

</xsl:template>

<xsl:template name="save-template">
  <xsl:param name="model" select="."/>
(:~
 :  Saves a controller
 :
~:)
declare function controller:save()
{
   let $update := 
       try {
         model:update(request:params())
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
      <xsl:apply-templates select="$model/dependencies"/>
      response:template("main"),
      response:redirect("show"),  
      response:flush()
   )
};
</xsl:template>

<xsl:template name="remove-template">
   <xsl:param name="model" select="."/>
declare function controller:remove()
{
  let $delete := 
  try { 
     controller:delete(request:params())
  } catch($exception) {
    response:error("404",$exception) 
  }
  return
  if(response:error()) then (
     response:flash("error_message","Could not Delete"),
     response:flush()
   ) else ( 
    response:flash("status",fn:status($delete)), 
    response:redirect(controller:url(controller:name(),"index"))
  )
};
</xsl:template>  
<xsl:template name="list-template">
   <xsl:param name="model" select="."/>
(:~
 : Returns a list of  records
~:)
declare function controller:find()
{
  let $find := 
  try { 
    model:find(request:params())
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
   <xsl:param name="model" select="."/>
(:~
 : Finds Records
~:)
declare function controller:find()
{
  let $find := 
  try { 
    model:find(request:params())
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
<xsl:template match="domain:model" mode="controller-header">
(:~
 : Controller Definition 
~:)
declare variable $domain:model as element(domain:model) := 
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
 <xsl:param name="model"/>
(:~
 : Update Operation <xsl:value-of select="$model/@name"/>
 :
~:) 
declare function model:update()
{
  ( 
	    response:body(model:update(request:request()))
	    response:flush()
  )
};
</xsl:template>

<xsl:template name="create-template" xml:space="true">
  <xsl:param name="model"/>
(:~
 : Create <xsl:value-of select="$model/@name"/>
~:) 
declare function controller:create() {
  let $create := model:create(request:params())
  return
  (
    response:body($create),
    response:flush()
  )
 };
</xsl:template>
 
 <!--Delete Template-->
 <xsl:template name="delete-template">
 <xsl:param name="model" as="element()"/>
(:~
 :  Deletes a <xsl:value-of select="$model/@name"/>
~:)  
declare function controller:delete()
{
      response:data("delete",model:delete(request:flush())),
      response:flush()
};
 </xsl:template>
 
 <!--Get Template-->
 <xsl:template name="get-template">
 <xsl:param name="model"/>
(:~
 :  Retrieves a <xsl:value-of select="$model/@name"/>
~:) 
declare function controller:get()
{
  response:body(model:get(request:request())),
  respone:flush();
};

 </xsl:template>
 
 <xsl:template name="search-template">
  <xsl:param name="model"/>
(:~
 : Provide search interface for <xsl:value-of select="$model/@name"/>
 : @param $query - Search query 
 : @param $sort - Sorting Key to sort results by
 : @param $start 
~:)
declare function controller:search()
{
  response:data("search_results",model)
};
 </xsl:template>
 <!--
  ============================================================
  XSL FUNCTIONS
  ============================================================
 -->
 
 <!--Gets the primary id of the controller-->
 <xsl:function name="util:get-primary-id">
   <xsl:param name="model" as="element(domain:model)"/>
   <xsl:value-of select="$model/*[@id-field]/@name"/>
 </xsl:function>
 
<!--
  Resolves the Type for the given model element/attribute
-->
 <xsl:function name="util:resolve-type">
  <xsl:param name="controller-node"/>
   <xsl:choose>
       <xsl:when test="starts-with($controller-node/@type, 'xs:')"> as <xsl:value-of select="$controller-node/@type"/></xsl:when>
    <xsl:otherwise> as <xsl:value-of select="local-name($controller-node)"/>(<xsl:value-of select="tokenize($controller-node/@type,':')[2]"/>)</xsl:otherwise>   
   </xsl:choose>
 </xsl:function>
 
 <!--Update Parameter Template-->    
<xsl:function name="util:update-params">
<xsl:param name="model" as="element(domain:model)"/>
<xsl:variable name="id-elem" select="$model/domain:element[@id-field eq 'true']"/>
  $<xsl:value-of select="$id-elem/@name"/> <xsl:value-of select="util:resolve-type($id-elem)"/>,
<xsl:for-each select="$model//(domain:element[not(@id-field = 'true')]|domain:attribute)"> 
  $<xsl:value-of select="./@name"/> <xsl:value-of select="util:resolve-type(.)"/><xsl:if test="position() ne last()">,</xsl:if></xsl:for-each>
</xsl:function> 
 
 <!--Create Parameter Template-->    
 <xsl:function name="util:create-params">
  <xsl:param name="model" as="element(domain:model)"/>
  <xsl:for-each select="$model//(domain:element|domain:attribute)[not(@id-field = 'true')]"> 
  $<xsl:value-of select="./@name"/> <xsl:value-of select="util:resolve-type(.)"/><xsl:if test="position() ne last()">,</xsl:if></xsl:for-each>
 </xsl:function> 

 <!--Create Comment Template-->    
 <xsl:function name="util:create-comments">
  <xsl:param name="model" as="element(domain:model)"/>
  <xsl:for-each select="$model//(domain:element|domain:attribute)"> 
   <xsl:variable name="description" select="if(./@description) then ./@description else ./@name"/>
 : @param $<xsl:value-of select="./@name"/> - <xsl:value-of select="$description"/>    
  </xsl:for-each>
 </xsl:function>  
 
 <!--Update Comment Template-->    
 <xsl:function name="util:update-comments">
  <xsl:param name="model" as="element(domain:model)"/>
  <xsl:for-each select="$model//(domain:element|domain:attribute)[not(@id-field)]"> 
   <xsl:variable name="description" select="if(./@description) then ./@description else ./@name"/>
 : @param <xsl:value-of select="./@name"/> - <xsl:value-of select="$description"/>    
  </xsl:for-each>
 </xsl:function>  
 
 <!--Global Chomper-->
<xsl:template match="*" mode="controller-body"/>
<xsl:template match="*" mode="controller-header"/>
</xsl:stylesheet>
