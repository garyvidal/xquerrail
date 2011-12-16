<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
 xmlns:xs="http://www.w3.org/2001/XMLSchema" 
 exclude-result-prefixes="xs" version="2.0"
 xmlns:domain="http://www.xquerrail-framework.com/domain"
 xmlns:search="http://marklogic.com/appservices/search"
 xmlns:util="http://www.xquerrail-framework.com/lib/utilities">
<xsl:output media-type="text" include-content-type="no" indent="yes" omit-xml-declaration="yes" exclude-result-prefixes="#all"/>
<xsl:include href="./main-builder.xsl"/>

<xsl:variable name="app-name" select="/domain:domain/domain:name"/>
<xsl:variable name="content-namespace" select="/domain:domain/domain:content-namespace"/>
<xsl:variable name="content-prefix" select="/domain:domain/domain:content-namespace/@prefix"/>
<xsl:variable name="app-namespace" select="/domain:domain/domain:application-namespace"/>
<xsl:variable name="author" select="/domain:domain/domain:author"/>
<xsl:variable name="description" select="/domain:domain/domain:description"/>
<xsl:variable name="version" select="/domain:domain/domain:version"/>
 
<xsl:template match="/">
 <xsl:apply-templates select="//domain:model"/>
</xsl:template>
 

<xsl:template match="domain:model">
 <xsl:variable name="model-version" select="/domain:model/domain:version"/>
 <xsl:message>Creating Model: <xsl:value-of select="@name"/></xsl:message>
<xsl:result-document href="../../../{$app-name}/model/{@name}-model.xqy">(:@AUTO-GENERATED@:)
xquery version "1.0-ml";
(:~
: Model : <xsl:value-of select="@name"/> 
:         <xsl:value-of select="@description"/>
: @author  <xsl:value-of select="(@author,$author)[position() eq 1]"/>
: @version <xsl:value-of select="$version"/>  
: Requires Models:
<xsl:for-each select="domain:import-model"> : <xsl:value-of select="./@name"/>,
</xsl:for-each>
~:)

module namespace model = "<xsl:value-of select="$app-namespace"/>/<xsl:value-of select="@name"/>";

(:Default Content Namespace:)
declare namespace <xsl:value-of select="$content-prefix"/> = "<xsl:value-of select="$content-namespace"/>";

(:Default Imports:)
import module namespace search = "http://marklogic.com/appservices/search"
  at "/MarkLogic/appservices/search/search.xqy";
 
(:Options Definition:)
declare option xdmp:mapping "false";

<xsl:apply-templates select="*" mode="model-header"/>
<xsl:apply-templates select="." mode="model-header"/>
(:Set Default Collection:)
declare variable $collation := "http://marklogic.com/collation/codepoint";

declare function model:create-id()
{
   xdmp:random()
};

declare function model:get-uri($project) as xs:string
{
let $id := $project/id
return 
fn:concat("/<xsl:value-of select="@name"/>/<xsl:value-of select="@name"/>-",$id,".xml")
};
declare function model:get-permissions() as element(xdmp:permissions)?
{
()
};
declare function model:get-collections()
{
"urn:<xsl:value-of select="@name"/>"
};
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
declare variable $model:model as element(model:model) := 
<xsl:copy-of select="."/>
;
(:~
 : Search Options Configuration
~:)
declare variable $model:search-options as element(search:options) := 
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
import module namespace <xsl:value-of select="@name"/> = "<xsl:value-of select="concat($app-namespace,'/',@name)"/>"
    at "<xsl:value-of select="$model-location"/><xsl:value-of select="@name"/>.xqy";
</xsl:template>

<xsl:template match="domain:optionlist" mode="model-body">
(:~
 : Returns a list of <xsl:value-of select="@name" />
 : @return  element(<xsl:value-of select="@name"/>)*   
~:)    
declare function model:list-<xsl:value-of select="@name"/>() as element(<xsl:value-of select="@name"/>)* 
{
<xsl:variable name="child-name" select="@child-element"/>
<xsl:element name="{@name}">
<xsl:for-each select="domain:option"> 
<xsl:element name="{$child-name}">
 <xsl:attribute name="key">
   <xsl:choose>
      <xsl:when test="@key">
         <xsl:value-of select="@key"/>
      </xsl:when>
    <xsl:otherwise>
         <xsl:value-of select="text()"/>
    </xsl:otherwise>
   </xsl:choose>
 </xsl:attribute>
 <xsl:value-of select="node()" exclude-result-prefixes="#all"/>
</xsl:element>
</xsl:for-each>
</xsl:element> 
}; 
</xsl:template>
 
<xsl:template name="update-template">
 <xsl:param name="model"/>
(:~
 : Update Operation <xsl:value-of select="$model/@name"/>
 :
 :<xsl:value-of select="util:model-create-comments($model)"/>
~:) 
declare function model:update(<xsl:value-of select="util:model-update-params($model)"/>
) as element(model:<xsl:value-of select="$model/@name"/>) 
{ 
   let $current := model:get($<xsl:value-of select="util:get-primary-id($model)"/> )
   let $update := 
     <xsl:element name="{$model/@name}" namespace="{$content-namespace}" >
      <xsl:text>&#xA;        </xsl:text><xsl:element name="created" namespace="{$content-namespace}">{$current/<xsl:value-of select="$content-prefix"/>:created}</xsl:element>
      <xsl:text>&#xA;        </xsl:text><xsl:element name="created-user" namespace="{$content-namespace}">{$current/<xsl:value-of select="$content-prefix"/>:creator}</xsl:element>
      <xsl:text>&#xA;        </xsl:text><xsl:element name="modified" namespace="{$content-namespace}">{fn:current-dateTime()}</xsl:element>
      <xsl:text>&#xA;        </xsl:text><xsl:element name="modified-by" namespace="{$content-namespace}">{xdmp:get-current-user()}</xsl:element>
       <xsl:for-each select="$model/(domain:element|domain:attribute)">
       <xsl:choose>
        <xsl:when test="./@ref"><xsl:text>&#xA;        </xsl:text>{$<xsl:value-of select="@name"/>}</xsl:when>
        <xsl:otherwise><xsl:text>&#xA;        </xsl:text><xsl:element name="{./@name}" namespace="{$content-namespace}">{$<xsl:value-of select="./@name"/>}</xsl:element></xsl:otherwise>
       </xsl:choose>
       </xsl:for-each>
     <xsl:text>&#xA;      </xsl:text></xsl:element>
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
 :<xsl:value-of select="util:model-update-comments($model)"/>
~:) 
declare function model:create(
  <xsl:value-of select="util:model-create-params($model)"/>  
  ){
  let $identifier := model:create-id()
  let $create := 
<xsl:element name="{$model/@name}" namespace="{$model/@ns}">
    <xsl:element name="creator">{xdmp:get-current-user()}</xsl:element>
    <xsl:element name="created">{fn:current-dateTime()}</xsl:element>
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
  (:let $validate := model:validate($create):)
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
   $id as xs:string
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
$id as xs:string
) as element(<xsl:value-of select="$model/@name"/>)?
{
   /<xsl:value-of select="$model/@name"/>[<xsl:value-of select="$content-prefix"/>:identifier = $id]
};
 </xsl:template>
 
 <xsl:template name="search-template">
  <xsl:param name="model"/>
(:~
 : Provide search interface for <xsl:value-of select="$model/@name"/>
 : @param $query - Search query 
 : @param $sort  - Sorting Key to sort results by
 : @param $start - Starting Index Record
 : @param $end   - Ending Record to fetch
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
     search:search($final,$model:search-options,$start,$end)
};
 </xsl:template>
 <!--Builds search:options-->
 <xsl:template name="search-options">
  <xsl:param name="model" as="element(domain:model)"/>
  <xsl:variable name="fields" select="$model//(domain:element|domain:attribute)[domain:navigation]"/>
  <xsl:variable name="search-constraints">
      <xsl:for-each select="$fields">
       <xsl:variable name="navigation" select="./domain:navigation"/>
       <xsl:if test="$navigation/@searchable = ('word','value','range')">
       <search:constraint name="{@name}">
           <xsl:element name="search:{$navigation/@searchable}" 
             namespace="http://marklogic.com/appservices/search" exclude-result-prefixes="#all">
              <xsl:if test="$navigation/@facetable">
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
       </xsl:if>
      </xsl:for-each>
  </xsl:variable>
  <xsl:variable name="sort-options">
   <!--Sorting Constraints-->
   <xsl:for-each select="$fields">
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
 
 
 <!--Global Chomper-->
<xsl:template match="*" mode="model-body"/>
<xsl:template match="*" mode="model-header"/>
</xsl:stylesheet>
