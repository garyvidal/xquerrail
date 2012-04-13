(:
 : Copyright 2011 - Gary Vidal
 :
 : Licensed     under the Apache License, Version 2.0 (the "License");
 : you may not use this file except in compliance with the License.
 : You may obtain a copy of the License at
 :
 :    http://www.apache.org/licenses/LICENSE-2.0
 :
 : Unless required by applicable law or agreed to in writing, software
 : distributed under the License is distributed on an "AS IS" BASIS,
 : WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 : See the License for the specific language governing permissions and
 : limitations under the License.
 :)



<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
 xmlns:xs="http://www.w3.org/2001/XMLSchema" 
 exclude-result-prefixes="xs" version="2.0"
 xmlns:domain="http://marklogic.com/xqor/domain"
 xmlns:search="http://marklogic.com/appservices/search"
 xmlns:util="http://marklogic.com/xqor/utilities">
<xsl:output media-type="text" include-content-type="no" indent="yes" omit-xml-declaration="yes" exclude-result-prefixes="#all"/>
<xsl:include href="./main-builder.xsl"/>

<xsl:variable name="app-namespace" select="/domain:model/@ns"/>

 <xsl:template match="/">
  <xsl:apply-templates select="domain:model"/>
</xsl:template>

<xsl:template match="domain:model">
 <xsl:result-document href="../../application/controller/{./@name}-controller.xqy">
xquery version "1.0-ml";
(:@AUTO-GENERATED@:)
(:~
: Controller : <xsl:value-of select="@name"/>
: Requires Models:
<xsl:for-each select="domain:import-model"> :    <xsl:value-of select="./@name"/>,
</xsl:for-each>
~:)

module namespace controller = "<xsl:value-of select="$controller-namespace"/><xsl:value-of select="@name"/>;


(:Default Imports:)
import module request = "http://marklogic.com/xqor/request"
    at "/system/request.xqy";
import module view = "http://marklogic.com/xqor/view"
    at "/system/view.xqy";    
import module model = "<xsl:value-of select="$model-namespace"/><xsl:value-of select="@name"/>"
     at "<xsl:value-of select="util:model-uri(.)"/>;

<xsl:apply-templates select="*" mode="model-header"/>
<xsl:apply-templates select="." mode="model-header"/>
     
(:Model Operations:)
<xsl:apply-templates select="." mode="model-body"/> 
  
 </xsl:result-document>
</xsl:template>
<!--
 Body Function Templates
-->
<xsl:template match="domain:model" mode="model-body">
 <xsl:apply-templates select="*" mode="model-body"/>
 
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
</xsl:template>

<xsl:template match="domain:model" mode="model-header">
</xsl:template>
    
<xsl:template match="domain:namespace" mode="model-header">
declare namespace <xsl:value-of select="@prefix"/> = "<xsl:value-of select="@uri"/>";
</xsl:template>
 <!--
    Import Statement Builder
 -->
<xsl:template match="domain:import-model" mode="model-header">
import module namespace <xsl:value-of select="@name"/> = "<xsl:value-of select="concat($model-namespace,@name)"/>"
    at "<xsl:value-of select="$model-location"/><xsl:value-of select="@name"/>-model.xqy";
</xsl:template>

<xsl:template match="domain:optionlist" mode="model-body">
(:~
 : Returns a list of <xsl:value-of select="@name" />
 : @return  element(<xsl:value-of select="@name"/>)*   
~:)    
declare function controller:list-<xsl:value-of select="@name"/>() as element(<xsl:value-of select="@name"/>)* 
{
   model:list-<xsl:value-of select="@name"/>()
}; 
</xsl:template>
 
<xsl:template name="update-template">
 <xsl:param name="model"/>
(:~
 : Update Operation <xsl:value-of select="$model/@name"/>
 :
 :<xsl:value-of select="util:create-comments($model)"/>
~:) 
declare function controller:update()
{ 
  <xsl:value-of select="util:request-update-params($model)"/>
  let $data := model:update(<xsl:value-of select="util:model-update-params($model)"/>)
  return 
    xqor:view($request,$data)
};
</xsl:template>

<xsl:template name="create-template" xml:space="true">
  <xsl:param name="model"/>
(:~
 : Create Action for <xsl:value-of select="$model/@name"/>
 :<xsl:value-of select="util:update-comments($model)"/>
~:) 
declare function controller:create(
)
{
<xsl:value-of select="util:request-create-params($model)"/>
  let $data := model:create(
<xsl:value-of select="util:model-create-params($model)"/>
  )
  return 
    xqor:view("view-<xsl:value-of select="$model/@name"/>",
        (xs:QName("REQUEST"), $request,
         xs:QName("DATA"), $data
        )
    )   
};
</xsl:template>
 
 <!--Delete Template-->
 <xsl:template name="delete-template">
 <xsl:param name="model" as="element()"/>
(:~
 :  Deletes a <xsl:value-of select="$model/@name"/>
 :  @param id - Id of document delete
 :  @return xs:boolean denoted whether delete occurred
~:)  
declare function controller:delete()
{ 
   let $id as xs:long := request:get-field("id")
   let $data := model:delete($id)
   return 
     xqor:view("view-<xsl:value-of select="$model/@name"/>",
        (
           xs:QName("REQUEST"), $request,
           xs:QName("DATA"), $data,
           xs:QName("MESSAGE"),$message
        )
     )   
};
 </xsl:template>
 
 <!--Get Template-->
 <xsl:template name="get-template">
 <xsl:param name="model" as="element(domain:model)"/>
(:~
 :  Retrieves a <xsl:value-of select="$model/@name"/> by id
~:) 
declare function controller:get() 
{
  let $id as xs:long := xs:long(request:get-field("id"))
  let $data := model:get($id)
  return
    xqor:view($request,$data)
};
 </xsl:template>
 
 <xsl:template name="search-template">
  <xsl:param name="model"/>
declare function controller:search() 
{
  let $query := request:get-field("query","*")
  let $sort  := request:get-field("sort","")
  let $start as xs:integer := request:get-field-integer("start",1)
  let $end   as xs:integer := request:get-field-integer("end",100)
  let $data := model:search($query,$sort,$start,$end)
  return
     xqor:view($request,$data)
};
 </xsl:template>
 <!--
  ============================================================
  XSL FUNCTIONS
  ============================================================
 -->
 
 <!--Gets the primary id of the model-->
 <xsl:function name="util:get-primary-id">
   <xsl:param name="model" as="element(domain:model)"/>
   <xsl:value-of select="$model/*[@id-field]/@name"/>
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
 
 <!--Update Parameter Template-->    
    <!--Create Parameter Template-->    
<xsl:function name="util:request-create-params">
    <xsl:param name="model" as="element(domain:model)"/>
    <xsl:for-each select="$model//(domain:element|domain:attribute)[not(@id-field = 'true')]"> 
  let $<xsl:value-of select="./@name"/> := request:get-field("<xsl:value-of select="./@name"/>")</xsl:for-each>
</xsl:function> 
    
<xsl:function name="util:request-update-params">
<xsl:param name="model" as="element(domain:model)"/>
<xsl:variable name="id-elem" select="$model/domain:element[@id-field eq 'true']"/>
  let $<xsl:value-of select="$id-elem/@name"/> := request:get-field("<xsl:value-of select="$id-elem/@name"/>")
<xsl:for-each select="$model//(domain:element[not(@id-field = 'true')]|domain:attribute)"> 
  let $<xsl:value-of select="./@name"/> := request:get-field("<xsl:value-of select="@name"/>")</xsl:for-each>
</xsl:function>     

<xsl:function name="util:model-update-params">
<xsl:param name="model" as="element(domain:model)"/>
<xsl:variable name="id-elem" select="$model/domain:element[@id-field eq 'true']"/>
  $<xsl:value-of select="$id-elem/@name"/>,
<xsl:for-each select="$model//(domain:element[not(@id-field = 'true')]|domain:attribute)"> 
  $<xsl:value-of select="./@name"/><xsl:if test="position() ne last()">,</xsl:if></xsl:for-each>
</xsl:function> 

 <!--Create Parameter Template-->    
 <xsl:function name="util:model-create-params">
  <xsl:param name="model" as="element(domain:model)"/>
  <xsl:for-each select="$model//(domain:element|domain:attribute)[not(@id-field = 'true')]"> 
   $<xsl:value-of select="./@name"/><xsl:if test="position() ne last()">,</xsl:if></xsl:for-each>
 </xsl:function> 

 <!--Create Comment Template-->    
 <xsl:function name="util:create-comments">
  <xsl:param name="model" as="element(domain:model)"/>
  <xsl:for-each select="$model//(domain:element|domain:attribute)"> 
 : @param <xsl:value-of select="./@name"/> - <xsl:value-of select="./@name"/>    
  </xsl:for-each>
 </xsl:function>  
 
 <!--Update Comment Template-->    
 <xsl:function name="util:update-comments">
  <xsl:param name="model" as="element(domain:model)"/>
  <xsl:for-each select="$model//(domain:element|domain:attribute)[not(@id-field)]"> 
 : @param <xsl:value-of select="./@name"/> - <xsl:value-of select="./@name"/>    
  </xsl:for-each>
 </xsl:function>  
 
 <!--Global Chomper-->
<xsl:template match="*" mode="model-body"/>
<xsl:template match="*" mode="model-header"/>
</xsl:stylesheet>
