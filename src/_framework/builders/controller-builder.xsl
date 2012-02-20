<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" 
 exclude-result-prefixes="xs" version="2.0"
 xmlns:domain="http://www.xquerrail-framework.com/domain"
 xmlns:search="http://marklogic.com/appservices/search"
 xmlns:builder="http://www.xquerrail-framework.com/builder">
 
<xsl:output media-type="text" include-content-type="no" indent="yes" omit-xml-declaration="yes" exclude-result-prefixes="#all"/>
<!--<xsl:include href="main-builder.xsl"/>-->
 
<xsl:template match="/" mode="controller">
  <xsl:apply-templates mode="controller"/>
</xsl:template>

<xsl:template match="domain:domain" mode="controller">
   <xsl:apply-templates select="domain:controller" mode="controller"/> 
</xsl:template>
 
<xsl:template match="domain:controller" mode="controller">
 <xsl:variable name="controller-description" select="@description"/>
 <xsl:variable name="controller-author" select="@author"/>
 <xsl:variable name="controller-version" select="@version"/>
 <xsl:variable name="controller" select="."/>
 <xsl:variable name="model" select="//domain:model[@name eq $controller/@model]"/>
 
 <xsl:message>Creating Controller: <xsl:value-of select="@name"/></xsl:message>
 <xsl:result-document href="../../{$app-name}/controller/{./@name}-controller.xqy" exclude-result-prefixes="#all"><xsl:value-of select="$AUTO-GENERATE"/>
xquery version "1.0-ml";
(:~
 : Controller :  <xsl:value-of select="@name"/> 
 :               <xsl:value-of select="$controller-description"/>
 : @author   <xsl:value-of select="$controller-author"/>
 : @version  <xsl:value-of select="$controller-version"/>  
~:)

module namespace controller = "<xsl:value-of select="$app-namespace"/>/controller/<xsl:value-of select="@name"/>";



(:Global Import Module:)
import module namespace request =  "http://www.xquerrail-framework.com/request"
   at "../../_framework/request.xqy";
   
import module namespace response =  "http://www.xquerrail-framework.com/response"
   at "../../_framework/response.xqy";   

import module namespace model = "<xsl:value-of select="builder:model-module-uri($model)"/>"
  at "<xsl:value-of select="builder:model-location($model)"/>";
  
declare default collation "http://marklogic.com/collation/codepoint";
  
(:Default Imports:)
declare namespace search = "http://marklogic.com/appservices/search";
<xsl:apply-templates select="*" mode="controller-header"/>
<xsl:apply-templates select="." mode="controller-header"/>

(:Global Option:)
declare option xdmp:mapping "false";
declare variable $collation := "http://marklogic.com/collation/codepoint";

declare function controller:initialize($request)
{(
   request:initialize($request),
   response:initialize(map:map(),$request),
   response:set-partial(request:partial())
)};

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

  <!-- Restful Service Templates -->
  <xsl:choose>
   <xsl:when test="exists($model)">  
    <xsl:value-of select="builder:controller-create-template($model)"/>
    <xsl:value-of select="builder:controller-get-template($model)"/>
    <xsl:value-of select="builder:controller-update-template($model)"/>
    <xsl:value-of select="builder:controller-delete-template($model)"/>
    <xsl:value-of select="builder:controller-search-template($model)"/>
    <xsl:value-of select="builder:controller-get-has-many($model)"/>
   </xsl:when>
   <xsl:otherwise>
    <xsl:message terminate="yes">Cannot find model <xsl:value-of select="$controller/@model"/></xsl:message>
   </xsl:otherwise>
  </xsl:choose>
  
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
  
  <xsl:call-template name="save-template">
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
 
   <!--
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
 --> 
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
declare function controller:main()
{
   if(request:format() eq "xml") 
   then (
      response:set-controller(controller:name()),
      response:set-format(request:format()),
      response:set-template("main"),
      response:set-view("info"),
      response:flush()
   ) else (
     controller:index()  
   )
};
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
{(
   controller:list()[0],
   response:set-template("main"),
   response:set-view("index"),
   response:flush()
)};
</xsl:template>

<xsl:template name="show-template">
  <xsl:param name="controller" select="."/>
 (:~ Show a record ~:) 
 
declare function controller:show()
{
 (   <xsl:apply-templates select="$controller/dependencies"/>
    response:set-body(controller:get()),
    response:set-template("main"),
    response:set-view("show"),  
    response:flush()
 )     
};   
</xsl:template>

<xsl:template name="new-template">
  <xsl:param name="controller" select="."/>
declare function controller:new()
{(  <xsl:apply-templates select="$controller/dependencies"/>
    response:set-template("main"),
    response:set-view("new"),  
    response:flush()
)}; 
</xsl:template>

<xsl:template name="edit-template">
  <xsl:param name="controller" select="."/>
  <xsl:variable name="model" select="/domain:domain/domain:model[@name eq $controller/@model]"/> 
declare function controller:edit()
{(
    response:set-body(controller:get()),<xsl:value-of select="builder:controller-dependencies($model)"/>
    response:set-template("main"),
    response:set-view("edit"),  
    response:flush()
)};
</xsl:template>

<xsl:template name="save-template" >
  <xsl:param name="controller" select="."/>
(:~
 :  Saves a controller
~:)
declare function controller:save()
{
   let $uuid := request:param("uuid")
   let $update := 
       try {
         if ($uuid and $uuid ne "") 
         then controller:update()
         else controller:create()
   } catch($exception) {
         xdmp:rethrow()
       }
   return
   if(response:has-error()) 
   then (
     response:flash("error_message","Could not save"),
     response:flush()
   ) else (
      response:set-body($update),<xsl:apply-templates select="$controller/dependencies"/>
      response:set-template("main"),
      response:set-format("html"),
      response:set-view("save"),  
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
     controller:delete( )
  } catch($exception) {
    response:set-error("404",$exception) 
  }
  return
  if(response:has-error()) then (
     response:flash("error_message","Could not Delete"),
     response:flush()
   ) else ( 
    response:flash("status",fn:string($delete)), 
    response:redirect(controller:name(),"remove")
  )
};
</xsl:template>  
<xsl:template name="list-template">
   <xsl:param name="controller" select="."/>
(:~
 : Returns a list of records
~:)
declare function controller:list()
{
    model:list()
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
    model:find(
      request:param("query","*"),
      request:param("page",1),
      request:param("size",20)
    )
  } catch($exception) {
    response:set-error("404",$exception) 
  }
  return
	  if(response:error()) then (
	     response:flash("error_message",response:error()//*:format-string),
	     response:flush()
	   ) else ( 
	    response:set-template("main"),
	    response:set-view("find"),
	    response:set-body($find),
	    response:flush()
	  )
};
</xsl:template>  
 
<!--REST Service Builder Templates -->

<xsl:template match="domain:namespace" mode="controller-header">
declare namespace <xsl:value-of select="@prefix"/> = "<xsl:value-of select="@uri"/>";
</xsl:template>

<!--Option List Template-->
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
 
<!--Utility Functions--> 
<xsl:function name="builder:controller-create-template">
<xsl:param name="controller"/>
(:~
 : Create <xsl:value-of select="$controller/@name"/>
~:) 
declare function controller:create() {
  model:create(<xsl:value-of select="builder:controller-create-params($controller)"/>)
};
</xsl:function>
 
 <!--Get Template-->
 <xsl:function name="builder:controller-get-template">
  <xsl:param name="model"/>
  <xsl:variable name="identity" select="$model/(domain:element|domain:attribute)[@identity eq 'true']"/>
(:~
 :  Retrieves a <xsl:value-of select="$model/@name"/>
~:) 
declare function controller:get()
{
   model:get((request:param("uuid"), request:param("<xsl:value-of select="$identity/@name"/>"))[1])
};
 </xsl:function>
 
 <xsl:function name="builder:controller-get-has-many">
  <xsl:param name="model"/>
  <xsl:variable name="hasMany" select="$model/domain:hasMany" /> 
  <xsl:variable name="identity" select="$model/(domain:element|domain:attribute)[@identity eq 'true']"/>
  
  <xsl:choose>
   <xsl:when test="exists($hasMany)">
    <xsl:for-each select="$hasMany">
     <xsl:variable name="this" select="." />
     <xsl:variable name="hasManyModel" select="/domain:domain/domain:model[@name =  $this/@type]" />
     <xsl:variable name="primaryId" select="builder:get-primary-field-id($hasManyModel)" />
     <xsl:variable name="primaryIdName" select="$primaryId/@name"/>

(:~
: This function will create the  <xsl:value-of select="$this/@name"/> related to this <xsl:value-of select="$model/@name"/>
:)
declare function controller:create-<xsl:value-of select="$this/@name" />()
as empty-sequence()
{
    let $currentId := request:param("<xsl:value-of select="$identity/@name"/>")
    let $ids := request:param("<xsl:value-of select="$primaryId"/>")
    return
        model:create-<xsl:value-of select="$this/@name"/>($currentId,$ids)
};
     
(:~
 : This function will return the  <xsl:value-of select="$this/@name"/> related to this <xsl:value-of select="$model/@name"/>
 : @return <xsl:value-of select="$this/@name"/> related to this <xsl:value-of select="$model/@name"/>
 :)
declare function controller:get-<xsl:value-of select="$this/@name" />()
as element(<xsl:value-of select="$this/@name"/>) 
{
    model:get-<xsl:value-of select="$this/@name"/>(request:param("<xsl:value-of select="$identity/@name"/>"))
};

(:~
 : This function will create the  <xsl:value-of select="$this/@name"/> related to this <xsl:value-of select="$model/@name"/>
 :)
declare function controller:update-<xsl:value-of select="$this/@name" />()
as empty-sequence()
{
    let $currentId := request:param("<xsl:value-of select="$identity/@name"/>")
    let $ids := request:param("<xsl:value-of select="$primaryId"/>")
    return
       model:update-<xsl:value-of select="$this/@name"/>($currentId,$ids)
};

(:~
: This function will delete all <xsl:value-of select="$this/@name"/> related to this <xsl:value-of select="$model/@name"/>
:)
declare function controller:delete-<xsl:value-of select="$this/@name" />()
as element(<xsl:value-of select="$this/@name"/>) 
{
    model:delete-<xsl:value-of select="$this/@name"/>(request:param("<xsl:value-of select="$identity/@name"/>"))
};
    </xsl:for-each>
   </xsl:when>
  </xsl:choose>
 </xsl:function>
 
 <!--update template-->
 <xsl:function name="builder:controller-update-template">
 <xsl:param name="controller"/>
(:~
 : Update Operation <xsl:value-of select="$controller/@name"/>
 :) 
declare function controller:update()
{
  model:update(<xsl:value-of select="builder:controller-update-params($controller)"/>
  )
};
 </xsl:function>
 <!--Delete Template-->
 <xsl:function name="builder:controller-delete-template">
 <xsl:param name="controller" as="element()"/>
(:~
 :  Deletes a <xsl:value-of select="$controller/@name"/>
~:)  
declare function controller:delete()
{
    model:delete(request:param("uuid"))
};
 </xsl:function>
 
<!--Search Template-->
 <xsl:function name="builder:controller-search-template">
  <xsl:param name="controller"/>
(:~
 : Provide search interface for <xsl:value-of select="$controller/@name"/>
 : @param $query - Search query 
 : @param $sort -  Sorting Key to sort results by
 : @param $start 
~:)
declare function controller:search()
{
    model:search(
        request:param("query") cast as xs:string,
        request:param("sort") cast as xs:string,
        request:param("sort-order") cast as xs:string,
        request:param("page",1) cast as xs:integer,
        request:param("size",10) cast as xs:integer
   )
};
 </xsl:function>

 <!--
  ============================================================
  Controller Update Functions
  ============================================================
 -->
 
 <!--Gets the primary id of the controller-->
 <xsl:function name="builder:controller-get-primary-id">
  <xsl:param name="controller" as="element(domain:controller)"/>
  <xsl:value-of select="$controller/*[@identity]/@name"/>
 </xsl:function>
 
 <!--Resolves the Type for the given controller element/attribute-->
 <xsl:function name="builder:controller-resolve-type">
  <xsl:param name="controller-node"/>
  <xsl:choose>
   <xsl:when test="starts-with($controller-node/@type, 'xs:')"> as <xsl:value-of select="$controller-node/@type"/></xsl:when>
   <xsl:otherwise> as <xsl:value-of select="local-name($controller-node)"/>(<xsl:value-of select="tokenize($controller-node/@type,':')[2]"/>)</xsl:otherwise>   
  </xsl:choose>
 </xsl:function>
 
 <!--Update Comment Template-->    
 <xsl:function name="builder:controller-update-comments">
  <xsl:param name="controller" as="element(domain:controller)"/>
  <xsl:for-each select="$controller//(domain:element|domain:attribute)[not(@identity)]"> 
   <xsl:variable name="description" select="if(./@description) then ./@description else ./@name"/>
   : @param <xsl:value-of select="./@name"/> - <xsl:value-of select="$description"/>    
  </xsl:for-each>
 </xsl:function>   
 
 <!--Update Parameter Template-->    
 <xsl:function name="builder:controller-update-params">
  <xsl:param name="model" as="element(domain:model)"/>
  <xsl:variable name="id-elem" select="$model//(domain:element|domain:attribute)[@identity eq 'true']"/>
  request:param("uuid") cast as xs:string?,
  <xsl:choose>
   <xsl:when test='exists($id-elem)'>
   request:param("<xsl:value-of select="$id-elem/@name"/>") <xsl:value-of select="builder:cast-as-datatype($id-elem)"/>,</xsl:when>
   <xsl:otherwise><xsl:message><xsl:value-of select="$model/@name"/> does not have a id field</xsl:message></xsl:otherwise>
  </xsl:choose>
  <xsl:for-each select="$model//(domain:element|domain:attribute)[not(@identity = true())]"> 
   request:param("<xsl:value-of select="./@name"/>") <xsl:value-of select="builder:cast-as-datatype(.)"/><xsl:if test="position() ne last()">,</xsl:if></xsl:for-each>
 </xsl:function> 
 
 <!--Create Parameter Template-->    
 <xsl:function name="builder:controller-create-params">
  <xsl:param name="model" as="element(domain:model)"/>
  <xsl:for-each select="$model//(domain:element|domain:attribute)"> 
  request:param("<xsl:value-of select="./@name"/>") <xsl:value-of select="builder:cast-as-datatype(.)"/><xsl:if test="position() ne last()">,</xsl:if></xsl:for-each>
 </xsl:function> 
 
 <!--Create Comment Template-->    
 <xsl:function name="builder:controller-create-comments">
  <xsl:param name="controller" as="element(domain:controller)"/>
  <xsl:for-each select="$controller//(domain:element|domain:attribute)"> 
   <xsl:variable name="description" select="if(./@description) then ./@description else ./@name"/>
   : @param $<xsl:value-of select="./@name"/> - <xsl:value-of select="$description"/>    
  </xsl:for-each>
 </xsl:function>  
 <!--Resolve any Controller dependencies for rendering UI -->
 <xsl:function name="builder:controller-dependencies">
    <xsl:param name="model"/>
    <xsl:variable name="dependencies">
    <xsl:choose>
     <xsl:when test="$model//domain:constraint[exists(@inList)] or $model/(domain:hasMany|domain:isChildOf|domain:isParentOf|domain:isRelatedTo)"
     ><xsl:if test="$model//domain:constraint[@inList]"><xsl:for-each select="$model//domain:constraint[@inList]"
      >response:set-data("<xsl:value-of select="../@name"/>",model:list-<xsl:value-of select="@inList"/>()),
      </xsl:for-each> 
     </xsl:if>
      
     </xsl:when>
     <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="$dependencies"/>
 </xsl:function>
 <!--Global Chomper-->
<xsl:template match="*" mode="controller-body"/>
<xsl:template match="*" mode="controller-header"/>
</xsl:stylesheet>
