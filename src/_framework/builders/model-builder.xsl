<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
 xmlns:xs="http://www.w3.org/2001/XMLSchema" 
 exclude-result-prefixes="xs" version="2.0"
 xmlns:domain="http://www.xquerrail-framework.com/domain"
 xmlns:builder="http://www.xquerrail-framework.com/builder"
 xmlns:search="http://marklogic.com/appservices/search">

 <xsl:output  media-type="text" include-content-type="no" indent="yes" omit-xml-declaration="yes" exclude-result-prefixes="builder domain search"/>
 
 <xsl:template match="/" mode="model">
  <xsl:apply-templates mode="model"/>  
 </xsl:template>
 
 <xsl:template match="/domain:domain" mode="model">
  <xsl:apply-templates mode="model"/>  
 </xsl:template>
 
<xsl:template match="domain:model" mode="model">
 <xsl:variable name="model-description" select="@description"/>
 <xsl:variable name="model-author" select="@author"/>
 <xsl:variable name="model-version" select="@version"/>
 <xsl:message>Creating Model: <xsl:value-of select="@name"/> at <xsl:value-of select="builder:model-location(.)"/></xsl:message> 
 <xsl:result-document href="../../{$app-name}/model/{@name}{$model-suffix}" exclude-result-prefixes="#all">xquery version "1.0-ml";
(:~
 : Model : <xsl:value-of select="@name"/> 
 :         <xsl:value-of select="$model-description"/>
 : @author <xsl:value-of select="$model-author"/>
 : @version <xsl:value-of select="$model-version"/>  
 : Requires Models:
<xsl:for-each select="domain:import-model"> :  <xsl:value-of select="./@name"/>,</xsl:for-each>
 :)

module namespace model = "<xsl:value-of select="builder:model-module-uri(.)"/>";

(:Default Imports:)
import module namespace search = "http://marklogic.com/appservices/search" at 
"/MarkLogic/appservices/search/search.xqy";

import module namespace util = "http://www.condenast.com/dam/2.0/lib/util" at
"/lib/utils.xqy";

declare default element namespace "<xsl:value-of select="/domain:domain/domain:content-namespace/@namespace-uri"/>";

declare default collation "http://marklogic.com/collation/codepoint";

<xsl:apply-templates select="*" mode="model-header"/>
<xsl:apply-templates select="." mode="model-header"/>

(:Options Definition:)
declare option xdmp:mapping "false";
declare variable $collation := "http://marklogic.com/collation/codepoint";

(:Required Functions:)
declare function model:create-id() {
     fn:string(xdmp:random())
};

declare function model:get-uri($elem){
<xsl:choose>
<xsl:when test="@persistence ='single'">    fn:concat("/<xsl:value-of select="./@name"/>/",fn:generate-id($elem),".xml")</xsl:when>
<xsl:otherwise>    fn:concat(<xsl:value-of select="builder:model-get-uri(.)"/>,fn:generate-id($elem),".xml"
     )</xsl:otherwise>
</xsl:choose>
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

 <xsl:call-template name="model-validate-template">
  <xsl:with-param name="model" select="."/>
 </xsl:call-template>
 
 <xsl:call-template name="model-create-template">
  <xsl:with-param name="model" select="."/>
 </xsl:call-template>
 <xsl:call-template name="model-get-template">
  <xsl:with-param name="model" select="."/>
 </xsl:call-template>
 <xsl:call-template name="model-update-template" >
 <xsl:with-param name="model" select="."/>
 </xsl:call-template>
 <xsl:call-template name="model-delete-template">
  <xsl:with-param name="model" select="."/>
 </xsl:call-template>
 <xsl:call-template name="model-list-template">
  <xsl:with-param name="model" select="."/>
 </xsl:call-template>
 <xsl:call-template name="model-find-template">
  <xsl:with-param name="model" select="."/>
 </xsl:call-template>
 <xsl:call-template name="model-search-template">
  <xsl:with-param name="model" select="."/>
 </xsl:call-template>
 <xsl:call-template name="model-build-relationships">
  <xsl:with-param name="model" select="."/>
 </xsl:call-template>
 <xsl:call-template name="model-has-many">
  <xsl:with-param name="model" select="."/>
 </xsl:call-template>
</xsl:template>
<!--Search Options--> 
<xsl:template match="domain:model" mode="model-header">
(:~
 : Model Definition 
 :)
declare variable $model as element() := 
<xsl:copy-of select="."/>
;
(:~
 : Search Options Configuration
 :)
declare variable $model:search-options := 
  <xsl:call-template name="model-search-options">
   <xsl:with-param name="model" select="."/>
  </xsl:call-template>
;
</xsl:template>

<!--Declare namespaces-->
<xsl:template match="domain:required-namespace" mode="model-header">
declare namespace <xsl:value-of select="@prefix"/> = "<xsl:value-of select="@uri"/>";
</xsl:template>
 
<!--
   Import Statement Builder
-->
<xsl:template match="domain:import-model" mode="model-header">
import module namespace <xsl:value-of select="@name"/> = "<xsl:value-of select="concat($model-namespace,'/',@name)"/>"
    at "<xsl:value-of select="$model-location"/><xsl:value-of select="@name"/>-model.xqy";
</xsl:template>


<!--
  Return Option List
-->
<xsl:template match="domain:optionlist" mode="model-body">
(:~
 : Returns a list of <xsl:value-of select="@name" />
 : @return  element(<xsl:value-of select="@name"/>)*   
 :)    
declare function model:list-<xsl:value-of select="@name"/>() as element(<xsl:value-of select="@name"/>)* 
{
<xsl:element name="{@name}" namespace="">
  <xsl:for-each select="domain:option">
     <xsl:element name="{../@child-element}" namespace="">
      <xsl:copy-of select="./(@*|text())"/>
     </xsl:element>
  </xsl:for-each>
</xsl:element> 
}; 
</xsl:template>

<!--
  Model Update Template
--> 
<xsl:template name="model-update-template">
 <xsl:param name="model"/>
(:~
 : Update Operation <xsl:value-of select="$model/@name"/>
 :
 :<xsl:value-of select="builder:model-create-comments($model)"/>
 :) 
declare function model:update(<xsl:value-of select="builder:model-update-params($model)"/>
) as element(<xsl:value-of select="$model/@name"/>) 
{ 
   let $current := model:get($uuid)
   let $update := 
       <xsl:element name="{$model/@name}">
           {$current/uuid }<xsl:for-each select="$model//(domain:element|domain:attribute)">
  <xsl:choose>
   <xsl:when test="./@reference"><xsl:text>&#xA;           </xsl:text> <xsl:element name="{./@name}">{$<xsl:value-of select="@name"/>}</xsl:element></xsl:when>
   <xsl:otherwise><xsl:text>&#xA;            </xsl:text> <xsl:element name="{./@name}">{$<xsl:value-of select="./@name"/>}</xsl:element></xsl:otherwise>
  </xsl:choose>
  </xsl:for-each>
<xsl:text>&#xA;       </xsl:text>
         </xsl:element>
  return
  ( if($current) 
    then xdmp:node-replace($current,$update)
    else <xsl:copy-of select="builder:update-insert-statement($model)" exclude-result-prefixes="#all"/>,$update
  )
};
</xsl:template>

<!--Create Template-->
<xsl:template name="model-create-template" >
  <xsl:param name="model"/>
(:~
 : Create <xsl:value-of select="$model/@name"/>
 :<xsl:value-of select="builder:model-update-comments($model)"/>
 :) 
declare function model:create(<xsl:value-of select="builder:model-create-params($model)"/>  
  ) {
  let $current := model:get($<xsl:value-of select="builder:get-primary-field-id($model)"/>)
  let $update := 
     <xsl:element name="{$model/@name}">
        { util:generate-guid-element() }<xsl:for-each select="$model//(domain:element|domain:attribute)">
    <xsl:choose>
     <xsl:when test="./@reference"><xsl:text>&#xA;      </xsl:text><xsl:element name="{./@name}">{$<xsl:value-of select="@name"/>}</xsl:element></xsl:when>
     <xsl:otherwise><xsl:text>&#xA;        </xsl:text><xsl:element name="{./@name}">{$<xsl:value-of select="./@name"/>}</xsl:element></xsl:otherwise>
    </xsl:choose>
   </xsl:for-each>
   <xsl:text>&#xA;     </xsl:text></xsl:element>
  return
  ( if($current) 
  then fn:error(xs:QName("DOCUMENT-EXISTS"),fn:concat("The document already exists. Duplicate ID: ", $<xsl:value-of select="builder:get-primary-field-id($model)"/>))
  else <xsl:copy-of select="builder:update-insert-statement($model)" exclude-result-prefixes="#all"/>,$update
  )
};
</xsl:template>
 
 <!--Delete Template-->
 <xsl:template name="model-delete-template">
 <xsl:param name="model" as="element()"/>
(:~
 :  Deletes a <xsl:value-of select="$model/@name"/>
 :  @param $<xsl:value-of select="builder:get-primary-field-id($model)"/> - Id of document delete
 :  @return xs:boolean denoted whether delete occurred
 :)  
declare function model:delete($<xsl:value-of select="builder:get-primary-field-id($model)"/> as xs:string
) as xs:boolean
{
  let $current := model:get($<xsl:value-of select="builder:get-primary-field-id($model)"/>)
  return
    try {(
      xdmp:node-delete($current),
      fn:true()
     )} catch($ex) {
      fn:false()  
    }
};
</xsl:template>
 
 <!--Get Template-->
 <xsl:template name="model-get-template">
 <xsl:param name="model" as="element(domain:model)"/>
 <xsl:variable name="primary-datatype" select="builder:get-primary-field-datatype($model)"/>
 <xsl:variable name="persistence-constraint">
   <xsl:choose>
    <xsl:when test="$model/@persistence eq 'document'">cts:document-query("<xsl:value-of select="$model/domain:document"/>")</xsl:when>
    <xsl:otherwise>cts:directory-query("<xsl:value-of select="$model/domain:directory"/>","infinity")</xsl:otherwise>
   </xsl:choose>
</xsl:variable>
  
(:~
 :  Retrieves a <xsl:value-of select="$model/@name"/> by id
 :  @param $<xsl:value-of select="builder:get-primary-field-id($model)"/>
~:) 
declare function model:get($<xsl:value-of select="builder:get-primary-field-id($model)"/> as <xsl:value-of select="builder:get-primary-field-datatype($model)"/>
) as element(<xsl:value-of select="$model/@name"/>)? {
    cts:search(<xsl:value-of select="builder:search-path($model)"/>,
        cts:and-query((
        cts:or-query(( cts:element-range-query(xs:QName("uuid"),"=",$<xsl:value-of select="builder:get-primary-field-id($model)"/>),
                       cts:element-value-query(xs:QName("<xsl:value-of select="builder:get-primary-field-id($model)"/>"),$<xsl:value-of select="builder:get-primary-field-id($model)"/>))),
            <xsl:value-of select="$persistence-constraint"/>
        )), ("filtered")
    )
};
</xsl:template>
 
 <!--
  List Operation
 -->
 <xsl:template name="model-list-template">
  <xsl:param name="model" as="element(domain:model)"/>
(:~
: Returns a list of <xsl:value-of select="$model/@name" />
: @return  element(<xsl:value-of select="$model/@name"/>)*   
:)    
declare function model:list() 
as element(list)? 
{
  let $list  := <xsl:value-of select="builder:model-list-path($model)"/>
  let $count := 
  <xsl:choose><xsl:when test="@persistence eq 'single'">fn:count($list/<xsl:value-of select="$model/@name"/>)</xsl:when>
  <xsl:otherwise>fn:count($list)</xsl:otherwise>
  </xsl:choose> 
  return 
     <list>{
     $list/@*,
     <currentpage>1</currentpage>,
     <totalpages>1</totalpages>,
     <totalrecords>{$count}</totalrecords>,
     <xsl:choose> 
      <xsl:when test="$model/not(@persistence = 'single')">
       <xsl:element name="{$model/@name}s">{$list}</xsl:element>
      </xsl:when>
      <xsl:otherwise>$list</xsl:otherwise>
     </xsl:choose>
     }</list>
}; 
</xsl:template>

 <!--
  Find Template - Quick way to find paginated assets
 -->
 <xsl:template name="model-find-template">
  <xsl:param name="model" as="element(domain:model)"/>
(:~
 : Find a record of <xsl:value-of select="$model/@name" />
 : @return  element(<xsl:value-of select="$model/@name"/>)*   
 :)    
declare function model:find(
  $query as xs:string,
  $page as xs:integer,
  $size as xs:integer
) as element(<xsl:value-of select="@name"/>s)? 
{
   let $start    := (($page - 1) * $size) + 1
   let $end      := $page * $size 
   let $search   := cts:search(<xsl:value-of select="builder:search-path($model)"/>,$query)[$start to $end]
   let $estimate := xdmp:estimate(cts:search(<xsl:value-of select="builder:search-path($model)"/>,$query))
   return 
       <xsl:element name="results" namespace="{/domain:domain/domain:namespace}">
         <xsl:attribute name="count">{$estimate}</xsl:attribute>
         <xsl:text>{$search}</xsl:text>
       </xsl:element>
}; 
 </xsl:template>
 
 <!--Search Template-->
 <xsl:template name="model-search-template">
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
   $sort-order as xs:string,
   $start as xs:integer,
   $end as xs:integer
) as element(search:response)
{ 
   let $sort-key := 
      if($sort and $sort-order = ("ascending","descending"))
      then fn:concat($sort,"-",$sort-order)
      else fn:concat($sort)
   let $final := fn:concat($query," ",$sort-key)
   return
     search:search($final,$model:search-options,$start,$end)
};
 </xsl:template>
 
 <!--Builds search:options-->
 <xsl:template name="model-search-options">
  <xsl:param name="model" as="element(domain:model)"/>
  <xsl:variable name="properties" select="$model//(domain:element|domain:attribute)[domain:navigation/@searchable=true()]"/>
  <xsl:variable name="search-constraints">
      <xsl:for-each select="$properties">
       <xsl:variable name="nav" select="$model/domain:navigation"/>
       <search:constraint name="{@name}"  xsl:exclude-result-prefixes="#all" xsl:inherit-namespaces="no">
           <search:additional-constraint><xsl:choose>
            <xsl:when test='$model/domain:directory'>cts:directory-query("<xsl:value-of select="$model/domain:directory"/>")</xsl:when>
            <xsl:when test="$model/domain:document">cts:document-query("<xsl:value-of select="$model/domain:document"/>")</xsl:when> 
            </xsl:choose>
           </search:additional-constraint>
           <search:element name="{./@name}" 
             namespace="http://marklogic.com/appservices/search" 
             xsl:exclude-result-prefixes="#all">
              <xsl:if test="$nav/@facetable">
               <xsl:attribute name="facet" select="true()"/>
              </xsl:if>  
              <xsl:choose>
                 <xsl:when test="local-name(.) ='element'">
                  <search:element name="{./@name}" ns="{$app-namespace}"  xsl:exclude-result-prefixes="#all" xsl:inherit-namespaces="no"/>
                 </xsl:when>
                 <xsl:when test="local-name(.) = 'attribute'">
                  <search:element name="{./parent::*/@name}" ns="{$app-namespace}"  xsl:exclude-result-prefixes="#all" xsl:inherit-namespaces="no"/>
                  <search:attribute name="{./@name}" ns=""  xsl:exclude-result-prefixes="#all" xsl:inherit-namespaces="no"/>
                 </xsl:when>
              </xsl:choose>  
           </search:element>
         </search:constraint>
      </xsl:for-each>
  </xsl:variable>
  <xsl:variable name="sort-options">
   <!--Sorting Constraints-->
   <xsl:for-each select="$properties">
    <search:state name="{./@name}"  xsl:exclude-result-prefixes="#all" xsl:inherit-namespaces="no">
        <search:sort-order direction="ascending" type="{@type}"  xsl:exclude-result-prefixes="#all" xsl:inherit-namespaces="no">{$collation}
            <search:element ns="{$content-namespace}" name="{@name}"  xsl:exclude-result-prefixes="#all" xsl:inherit-namespaces="no"/>
        </search:sort-order>
        <search:sort-order>
             <search:score/>
        </search:sort-order>
    </search:state>
    <search:state name="{@name}-descending"  xsl:exclude-result-prefixes="#all" xsl:inherit-namespaces="no">
     <search:sort-order direction="descending" type="{@type}">{$collation}
          <search:element ns="{$content-namespace}" name="{@name}"  xsl:exclude-result-prefixes="#all" xsl:inherit-namespaces="no"/>
     </search:sort-order>
     <search:sort-order>
          <search:score  xsl:exclude-result-prefixes="#all" xsl:inherit-namespaces="no"/>
     </search:sort-order>
    </search:state>
    <search:state name="{@name}-ascending"  xsl:exclude-result-prefixes="#all" xsl:inherit-namespaces="no">
         <search:sort-order direction="ascending" type="{@type}"  xsl:exclude-result-prefixes="#all" xsl:inherit-namespaces="no">
              <search:element ns="{$app-namespace}" name="{@name}"  xsl:exclude-result-prefixes="#all" xsl:inherit-namespaces="no"/>
         </search:sort-order>
         <search:sort-order>
              <search:score  xsl:exclude-result-prefixes="#all" xsl:inherit-namespaces="no"/>
         </search:sort-order>
    </search:state>
   </xsl:for-each>
  </xsl:variable>
  <search:options xsl:exclude-result-prefixes="#all" xsl:inherit-namespaces="no">
   <xsl:copy-of select="$search-constraints" xml:space="preserve"/><xsl:text>&#xA;</xsl:text>
   <search:operator name="sort">
   <xsl:copy-of select="$sort-options"/>
   </search:operator>
  </search:options>
 </xsl:template>

<!-- This will build the relationships for the current model -->
 <xsl:template name="model-build-relationships">
  <xsl:param name="model" as="element(domain:model)" />
  <xsl:variable name="primaryId" select="builder:get-primary-field-id($model)" />
  <xsl:variable name="primaryIdName" select="$primaryId/@name"/>
(:~ 
: This function will create a sequence of nodes that represent each
: model for inlining in other relationships. 
: @param $ids a sequence of ids for models to be extracted
: @return a sequence of <xsl:value-of select="$model/@name"/>
:)
declare function model:build-relationships-to-self($ids as xs:string*) 
as element(<xsl:value-of select="$model/@name"/>)*
{
    for $id in $ids
    let $model := model:get($id)
    return
        <xsl:element name="{$model/@name}">
         <xsl:attribute name="{$primaryId}">{ $model/@<xsl:value-of select="$primaryId"/> }</xsl:attribute>
           <xsl:text>{ $model/name/text() }</xsl:text>
        </xsl:element>
};
 </xsl:template>
 
 <!-- This will build the has many relationship for the current model -->
 <xsl:template name="model-has-many">
 	<xsl:param name="model" as="element(domain:model)" />
 	<xsl:variable name="hasMany" select="$model/domain:hasMany" />
 	<xsl:choose>
 		<xsl:when test="exists($hasMany)">
 		 <xsl:for-each select="$hasMany">
      <xsl:variable name="this" select="." />
  		  <xsl:variable name="hasManyModel" select="/domain:domain/domain:model[@name =  $this/@type]" />
      <xsl:variable name="primaryId" select="builder:get-primary-field-id($hasManyModel)" />
      <xsl:variable name="primaryIdName" select="$primaryId/@name"/>
(:~
: This function will create the  <xsl:value-of select="$this/@name"/> related 
: to this <xsl:value-of select="$model/@name"/> then insert it into the doucment
: @param $currentId is the id of the <xsl:value-of select="$model/@name"/>.
: @param $ids the ids of content you want to build the relationship too.
:)
declare function model:create-<xsl:value-of select="$this/@name" />($currentId as xs:string,$ids as xs:string*)
as empty-sequence()
{
    let $current := model:get($currentId)	  
   	let $node :=   
   		   <xsl:element name="{$this/@name}">{
   		     <xsl:value-of select="$this/@type"/>:build-relationships-to-self($ids)
   		   }</xsl:element>
    return 
        xdmp:node-insert-child($current,$node)
};

(:~
: This function will return the  <xsl:value-of select="$this/@name"/> related to this <xsl:value-of select="$model/@name"/>
: @param $currentId is the id of the <xsl:value-of select="$model/@name"/> .
: @return <xsl:value-of select="$this/@name"/> related to this <xsl:value-of select="$model/@name"/>
:)
declare function model:get-<xsl:value-of select="$this/@name" />($currentId as xs:string)
as element(<xsl:value-of select="$this/@name"/>) 
{
    let $current := model:get($currentId)	  
    return 
        $current/<xsl:value-of select="$this/@name" />
};

(:~
: This function will replace the <xsl:value-of select="$this/@name"/> related 
: to this <xsl:value-of select="$model/@name"/> then replace the whole <xsl:value-of select="$this/@name"/> node
: @param $currentId is the id of the <xsl:value-of select="$model/@name"/>.
: @param $ids the ids of the content you want to build a relationship too.
:)
declare function model:update-<xsl:value-of select="$this/@name" />($currentId as xs:string,$ids as xs:string*)
as empty-sequence()
{
    let $current := model:get($currentId)/<xsl:value-of select="$this/@name" />	  
    let $node :=   
        <xsl:element name="{$this/@name}">{
         <xsl:value-of select="$this/@type"/>:build-relationships-to-self($ids)
         }</xsl:element>
    return 
        xdmp:node-replace($current,$node)
};

(:~
: This function will remove all <xsl:value-of select="$this/@name"/> related to this <xsl:value-of select="$model/@name"/>
: @param $currentId is the id of the <xsl:value-of select="$model/@name"/> .
:)
declare function model:delete-<xsl:value-of select="$this/@name" />($currentId as xs:string)
as element(<xsl:value-of select="$this/@name"/>) 
{
    let $current := model:get($currentId)	  
    return 
        xdmp:node-delete($current/<xsl:value-of select="$this/@name" />)
};
 			</xsl:for-each>
 		</xsl:when>
 	</xsl:choose>
 </xsl:template>
 <!--Validate Template-->
 <xsl:template name="model-validate-template">
  <xsl:param name="model"/>
(:~
 :  Function validates a document instance and returns if the document is valid
 :  We build a constraint rule 
 :)
 declare function model:validate($instance)
 { 
   let $validations :=  (
    <xsl:for-each select="$model//(domain:element|domain:attribute)">
       <xsl:variable name="constraints" select="domain:constraint"/>
     <xsl:if test="$constraints/@required eq 'true'">
      if($instance/<xsl:value-of select="@name"/> ne "" or fn:empty($instance/<xsl:value-of select="@name"/>)) 
      then fn:concat('<xsl:value-of select="@name"/> is required field') else (),</xsl:if>
     <xsl:if test="$constraints/@minLength and $constraints/@maxLength">
      if(fn:string-length($instance/<xsl:value-of select="@name"/>) ge <xsl:value-of select="$constraints/@minLength"/> and 
          fn:string-length($instance/<xsl:value-of select="@name"/>) le <xsl:value-of select="$constraints/@maxLength"/>) 
      then fn:concat("<xsl:value-of select="@name"/> length must be between <xsl:value-of select="$constraints/@minLength"/> and <xsl:value-of select="$constraints/@maxLength"/>") else (),
    </xsl:if>      
    </xsl:for-each>()
    
    )
  return 
    $validations
 };
 </xsl:template>
 <!--Update Parameter Template-->    
 <xsl:function name="builder:model-update-params">
  <xsl:param name="model" as="element(domain:model)"/>
   $uuid as xs:string,
  <xsl:for-each select="$model//(domain:element|domain:attribute)"
   > $<xsl:value-of select="./@name"/><xsl:value-of select="builder:resolve-datatype(.)"/> <xsl:value-of select="builder:resolve-as-type(.)"/><xsl:if test="position() ne last()">,
   </xsl:if>
  </xsl:for-each>
 </xsl:function> 

 <!--Create Parameter Template-->    
 <xsl:function name="builder:model-create-params">
  <xsl:param name="model" as="element(domain:model)"/>
  <xsl:for-each select="$model//(domain:element|domain:attribute)"> 
   $<xsl:value-of select="./@name"/> <xsl:value-of select="builder:resolve-as-type(.)"/><xsl:if test="position() ne last()">,</xsl:if></xsl:for-each>
 </xsl:function> 
 
 <!--Create Comment Template-->    
 <xsl:function name="builder:model-create-comments">
  <xsl:param name="model" as="element(domain:model)"/>
  <xsl:for-each select="$model//(domain:element|domain:attribute)"> 
   <xsl:variable name="description" select="if(./@description) then ./@description else ./@name"/>
   : @param $<xsl:value-of select="./@name"/> - <xsl:value-of select="$description"/>    
  </xsl:for-each>
 </xsl:function>  
 
 <!--Update Comment Template-->    
 <xsl:function name="builder:model-update-comments">
   <xsl:param name="model" as="element(domain:model)"/>
   <xsl:for-each select="$model//(domain:element|domain:attribute)"> 
    $<xsl:value-of select="./@name"/> <xsl:value-of select="builder:resolve-as-type(.)"/><xsl:if test="position() ne last()">,</xsl:if>
   </xsl:for-each> 
 </xsl:function>  
 
 <!--Search Path Function-->
 <xsl:function name="builder:search-path">
   <xsl:param name="model" as="element(domain:model)"/>
<xsl:choose>
    <xsl:when test="$model/@persistence = 'document' and not($model/domain:document) and ($model/@parent ne '')"
     >fn:doc("<xsl:value-of select="$model/domain:document"/>")/<xsl:value-of select="$model/@name"/>
    </xsl:when>
   <xsl:when test="$model/@persistence = 'document' and not($model/domain:document) and ($model/@parent = '' or empty($model/@parent))"
    >fn:doc("/ <xsl:value-of select="$model/@name"/>s.xml")/<xsl:value-of select="$model/@name"/>s/<xsl:value-of select="$model/@name"/>
   </xsl:when>
   <xsl:when test="$model/@persistence = 'document' and exists($model/domain:document) and ($model/@parent = '' or empty($model/@parent))"
    >fn:doc("<xsl:value-of select="$model/domain:document"/>")/<xsl:value-of select="$model/@name"/>s/<xsl:value-of select="$model/@name"/>
   </xsl:when>
   <xsl:otherwise>/<xsl:value-of select="$model/@name"/></xsl:otherwise>
</xsl:choose>
 </xsl:function>
 <!--Create/Update Statement-->
 <xsl:function name="builder:update-insert-statement">
  <xsl:param name="model" as="element(domain:model)"/>
  <xsl:variable name="uripath">
   <xsl:choose>
    <xsl:when test="$model/@persistence eq 'document'"><xsl:value-of select="$model/domain:document"/></xsl:when>
    <xsl:otherwise><xsl:value-of select="$model/domain:directory"/></xsl:otherwise>
   </xsl:choose>
  </xsl:variable>
  
  <xsl:variable name="update-path">
  <xsl:choose>
   <xsl:when test="$model/@persistence = 'document' and not($model/domain:document) and ($model/@parent ne '')">fn:doc("<xsl:value-of select="$uripath"/>")/<xsl:value-of select="$model/@name"/></xsl:when>
   <xsl:when test="$model/@persistence = 'document' and not($model/domain:document) and ($model/@parent = '' or empty($model/@parent))">fn:doc("<xsl:value-of select="$model/@name"/>s.xml")/<xsl:value-of select="$model/@name"/>s</xsl:when>
   <xsl:when test="$model/@persistence = 'document' and exists($model/domain:document) and ($model/@parent = '' or empty($model/@parent))">fn:doc("<xsl:value-of select="$uripath"/>")/<xsl:value-of select="$model/@name"/>s</xsl:when>
   <xsl:when test="$model/@persistence = 'document' and exists($model/domain:directory) and $model/@parent ne ''">
    fn:doc("<xsl:value-of select="$uripath"/>")/<xsl:value-of select="$model/@parent"/>
   </xsl:when>
   <xsl:when test="exists($model/directory)">/<xsl:value-of select="$model/@name"/></xsl:when>
   <xsl:otherwise>/<xsl:value-of select="$uripath"/>/<xsl:value-of select="$model/@name"/></xsl:otherwise>
  </xsl:choose>
  </xsl:variable>
  <xsl:variable name="new-path">
   <xsl:choose>
    <xsl:when test="$model/@persistence = 'document' and not($uripath) and ($model/@parent ne '')">"<xsl:value-of select="$uripath"/>"</xsl:when>
    <xsl:when test="$model/@persistence = 'document' and not($uripath) and ($model/@parent = '' or empty($model/@parent))">"<xsl:value-of select="$model/@name"/>s.xml"</xsl:when>
    <xsl:when test="$model/@persistence = 'document' and exists($uripath) and ($model/@parent = '' or empty($model/@parent))">"<xsl:value-of select="$uripath"/>"</xsl:when>
    <xsl:when test="$model/@persistence = 'document' and exists($uripath) and $model/@parent ne ''"> 
     "<xsl:value-of select="$uripath"/>"
    </xsl:when>
    <xsl:when test="exists($uripath)">/<xsl:value-of select="$model/@name"/></xsl:when>
    <xsl:otherwise>/<xsl:value-of select="$uripath"/>/<xsl:value-of select="$model/@name"/></xsl:otherwise>
   </xsl:choose>
  </xsl:variable>
  <xsl:choose>
   <xsl:when test="$model/@persistence eq 'document'">
    if(<xsl:value-of select="$update-path"/>) 
    then xdmp:node-insert-child(<xsl:value-of select="$update-path"/>,$update)
    else xdmp:document-insert(
       <xsl:value-of select="$new-path"/>,
       <xsl:element name="{$model/@name}s">{$update}</xsl:element>,
       xdmp:default-permissions(),
       xdmp:default-collections()
    )
   </xsl:when>
   <xsl:otherwise>
    xdmp:document-insert(model:get-uri($update),
      $update,
      xdmp:default-permissions(),
      xdmp:default-collections()
    )
   </xsl:otherwise>
  </xsl:choose> 
 </xsl:function>
 <!--Get the URI Path for the give document-->
 <!--Retus-->
 <xsl:function name="builder:model-get-uri">
  <xsl:param name="model" as="element(domain:model)"/>  
  <xsl:choose>
   <xsl:when test="$model/@persistence = 'document' and $model/domain:document">
    fn:doc("<xsl:value-of select="$model/domain:document"/>")</xsl:when>
   <xsl:when test="$model/@persistence eq 'directory' and $model/domain:directory">
    "<xsl:value-of select="$model/domain:directory"/>/"</xsl:when>
   <xsl:otherwise>
    "/<xsl:value-of select="$model/@name"/>s/<xsl:value-of select="$model/@name"/>"</xsl:otherwise>
  </xsl:choose>
 </xsl:function> 
 
 <xsl:function name="builder:model-list-path">
  <xsl:param name="model" as="element(domain:model)"/>  
  <xsl:choose>
   <xsl:when test="$model/@persistence eq 'document' and $model/domain:document">
    fn:doc("<xsl:value-of select="$model/domain:document"/>")/<xsl:value-of select="$model/@name"/>s</xsl:when>
   <xsl:when test="$model/@persistence ne 'document' and $model/domain:document">
    <xsl:value-of select="$model/domain:path"/></xsl:when>
   <xsl:otherwise>
    /<xsl:value-of select="$model/@name"/></xsl:otherwise>
  </xsl:choose>
 </xsl:function> 
 <!--Global Chomper-->
 <xsl:template match="*" mode="model-body"/>
 <xsl:template match="*" mode="model-header"/>
 <xsl:template match="*" mode="model"/> 
</xsl:stylesheet>
