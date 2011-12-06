<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
 xmlns:xs="http://www.w3.org/2001/XMLSchema" 
 exclude-result-prefixes="xs" version="2.0"
 xmlns:domain="http://marklogic.com/xqor/domain"
 xmlns:search="http://marklogic.com/appservices/search"
 xmlns:util="http://marklogic.com/xqor/utilities">
<xsl:output media-type="text" include-content-type="no" indent="yes" omit-xml-declaration="yes" exclude-result-prefixes="#all"/>
<xsl:include href="./main-builder.xsl"/>

<xsl:variable name="app-namespace" select="/domain:model/domain:namespace"/>
<xsl:variable name="model-author" select="/domain:model/domain:author"/>
<xsl:variable name="model-description" select="/domain:model/domain:description"/>
<xsl:variable name="model-version" select="/domain:model/domain:version"/>

 <xsl:template match="/">
  <xsl:message>Creating Model <xsl:value-of select="domain:model/@name"/></xsl:message>
  <xsl:apply-templates select="domain:model"/>
  <xsl:message>Created Model <xsl:value-of select="domain:model/@name"/> at <xsl:value-of select="util:model-uri(domain:model)"/>
  </xsl:message>
</xsl:template>

<xsl:template match="domain:model">
 
 <xsl:result-document href="../../application/model/{./@name}-model.xqy">
xquery version "1.0-ml";
(:@AUTO-GENERATED@:)
(:~
: Model : <xsl:value-of select="@name"/> 
:         <xsl:value-of select="$model-description"/>
: @author <xsl:value-of select="$model-author"/>
: @version <xsl:value-of select="$model-version"/>  
: Requires Models:
<xsl:for-each select="domain:import-model"> :    <xsl:value-of select="./@name"/>,
</xsl:for-each>
~:)

module namespace model = "<xsl:value-of select="$model-namespace"/><xsl:value-of select="@name"/>;

(:Default Imports:)
import module namespace search = "http://marklogic.com/appservices/search";
<xsl:apply-templates select="*" mode="model-header"/>
<xsl:apply-templates select="." mode="model-header"/>

(:Options Definition:)
declare option xdmp:mapping "false";

declare variable $collation := "http://marklogic.com/collation/codepoint";

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
(:~
 : Model Definition 
~:)
declare variable $domain:model as element(domain:model) := 
<xsl:copy-of select="."/>
;
(:~
 : Search Options Configuration
~:)
declare variable $search:options := 
  <xsl:call-template name="search-options">
   <xsl:with-param name="model" select="."/>
  </xsl:call-template>
;
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
declare function model:list-<xsl:value-of select="@name"/>() as element(<xsl:value-of select="@name"/>)* 
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
 :<xsl:value-of select="util:create-comments($model)"/>
~:) 
declare function model:update(
 <xsl:value-of select="util:update-params($model)"/>
) as element(model:<xsl:value-of select="$model/@name"/>) 
{ 
   let $current := model:get($<xsl:value-of select="util:get-primary-id($model)"/>)
   let $update := 
     <xsl:element name="{$model/@name}" namespace="{$model/@ns}">
       <xsl:attribute name="created">{$current/@created}</xsl:attribute>
       <xsl:attribute name="created-user">{$current/@created-user}</xsl:attribute>
       <xsl:attribute name="modified">{fn:current-dateTime()}</xsl:attribute>
       <xsl:attribute name="modified-by">{xdmp:get-current-user()}</xsl:attribute>
       <xsl:for-each select="$model/(domain:element|domain:attribute)">
       <xsl:choose>
        <xsl:when test="./@ref"><xsl:text>&#xA;      </xsl:text>{$<xsl:value-of select="@name"/>}</xsl:when>
        <xsl:otherwise><xsl:text>&#xA;      </xsl:text><xsl:element name="{./@name}" namespace="{$model/@ns}">{$<xsl:value-of select="./@name"/>}</xsl:element></xsl:otherwise>
       </xsl:choose>
       </xsl:for-each>
     <xsl:text>&#xA;</xsl:text></xsl:element>
  return
  (
    xdmp:node-replace($current,$update),
    $update
  )
};
</xsl:template>

<xsl:template name="create-template" xml:space="true">
  <xsl:param name="model"/>
(:~
 : Create <xsl:value-of select="$model/@name"/>
 :<xsl:value-of select="util:update-comments($model)"/>
~:) 
declare function model:create(
  <xsl:value-of select="util:create-params($model)"/>  
  ){
  let $id := model:create-id()
  let $create := 
   <xsl:element name="{$model/@name}" namespace="{$model/@ns}">
    <xsl:attribute name="created">{$current/@created}</xsl:attribute>
    <xsl:attribute name="created-user">{$current/@created-user}</xsl:attribute>
    <xsl:for-each select="$model/(domain:element|domain:attribute|domain:group)">
     <xsl:choose>
      <xsl:when test=". instance of element(domain:element)">
       <xsl:element name="{./@name}" namespace="{$model/@ns}">{$<xsl:value-of select="./@name"/>}</xsl:element>
      </xsl:when>
      <xsl:when test=". instance of element(domain:group)">
      <xsl:element name="{./@name}" namespace="{$model/@ns}">{$<xsl:value-of select="./@name"/>}</xsl:element> 
      </xsl:when>
      <xsl:when test=". instance of element(domain:attribute)">
        attribute <xsl:value-of select="./@name"/>{$<xsl:value-of select="./@name"/>}
      </xsl:when>
     </xsl:choose>
   </xsl:for-each>
  </xsl:element>
 
  let $validate := model:validate($create)
  return
  (
    xdmp:document-insert(
       model:get-uri($create),
       $create,
       model:get-permissions(),
       model:get-collections()
     ),
     $create
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
declare function model:delete(
$id as xs:long
) as xs:boolean
{
  let $current := model:get($id)
  return
    try {
     (
      xdmp:document-delete($current),
      fn:true()
     )
    } catch($ex) {
      fn:false()  
    }
};
 </xsl:template>
 
 <!--Get Template-->
 <xsl:template name="get-template">
 <xsl:param name="model" as="element(domain:model)"/>
(:~
 :  Retrieves a <xsl:value-of select="$model/@name"/> by id
~:) 
declare function model:get(
$id as xs:long
) as element(<xsl:value-of select="$model/@name"/>)
{
   cts:search(/<xsl:value-of select="$model/@name"/>,
      cts:element-range-query(xs:QName("<xsl:value-of select="$model/@name"/>),"=",$id)
   )
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
declare function model:search(
$query as xs:string,
$sort as xs:string,
$start as xs:integer,
$end as xs:integer
) as element(search:response)
{
   let $final := fn:concat($query," ",$sort)
   return
     cts:search($final,$search:options,$start,$end)
};
 </xsl:template>
 <!--Builds search:options-->
 <xsl:template name="search-options">
  <xsl:param name="model" as="element(domain:model)"/>
  <xsl:variable name="properties" select="$model//(domain:element|domain:attribute)[@searchable]"/>
  <xsl:variable name="search-constraints">
      <xsl:for-each select="$properties">
       <search:constraint name="{@name}">
           <xsl:element name="search:{@searchable}" 
             namespace="http://marklogic.com/appservices/search" 
             exclude-result-prefixes="#all">
              <xsl:if test="@facetable">
               <xsl:attribute name="facet" select="true()"/>
              </xsl:if>  
              <xsl:choose>
                 <xsl:when test="local-name(.) ='element'">
                  <search:element name="{./@name}" ns="{$app-namespace}"/>
                 </xsl:when>
                 <xsl:when test="local-name(.) = 'attribute'">
                  <search:element name="{./parent::*/@name}" ns="{$app-namespace}"/>
                  <search:attribute name="{./@name}" ns=""/>
                 </xsl:when>
              </xsl:choose>  
           </xsl:element>
         </search:constraint>
      </xsl:for-each>
  </xsl:variable>
  <xsl:variable name="sort-options">
   <!--Sorting Constraints-->
   <xsl:for-each select="$properties">
    <search:state name="{./@name}">
     <search:sort-order direction="ascending" type="{@type}">
      {$collation}
      <search:element ns="{$app-namespace}" name="{@name}"/>
     </search:sort-order>
     <search:sort-order>
      <search:score/>
     </search:sort-order>
    </search:state>
    <search:state name="{@name}-descending">
     <search:sort-order direction="descending" type="{@type}">
      {$collation}
      <search:element ns="" name="{@name}"/>
     </search:sort-order>
     <search:sort-order>
      <search:score/>
     </search:sort-order>
    </search:state>
    <search:state name="{@name}-ascending">
     <search:sort-order direction="ascending" type="{@type}">
      <search:element ns="{$app-namespace}" name="{@name}"/>
     </search:sort-order>
     <search:sort-order>
      <search:score/>
     </search:sort-order>
    </search:state>
   </xsl:for-each>
  </xsl:variable>
  <search:options>
   <xsl:copy-of select="$search-constraints" xml:space="preserve"/><xsl:text>&#xA;</xsl:text>
   <search:operator name="sort">
   <xsl:copy-of select="$sort-options"/>
   </search:operator>
  </search:options>
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
<xsl:template match="*" mode="model-body"/>
<xsl:template match="*" mode="model-header"/>
</xsl:stylesheet>
