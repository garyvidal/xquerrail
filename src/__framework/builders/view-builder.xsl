<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" 
exclude-result-prefixes="xs" version="2.0"
xmlns:domain="http://www.xquerrail-framework.com/domain"
xmlns:search="http://marklogic.com/appservices/search"
xmlns:builder="http://www.xquerrail-framework.com/builder">

<xsl:output media-type="text" include-content-type="no" indent="yes" omit-xml-declaration="yes" exclude-result-prefixes="#all"/>

<xsl:template match="/" mode="view">
<xsl:message>Generating Package Views: <xsl:value-of select="domain:domain/domain:name"/></xsl:message>
<xsl:apply-templates select="/domain:domain/domain:controller" mode="view"/>
</xsl:template>
 
<xsl:template match="domain:controller" mode="view">
<xsl:message>Creating Controller View:<xsl:value-of select="./@name"/></xsl:message>
<xsl:variable name="model-name" select="@model"/>
<xsl:variable name="model" select="/domain:domain/domain:model[@name eq $model-name]"/>

<!-- Restful JSON Service Templates -->
<!-- 
<xsl:call-template name="info-template">
<xsl:with-param name="model" select="."/>
</xsl:call-template>


<xsl:call-template name="json-create-template">
<xsl:with-param name="model" select="."/>
</xsl:call-template>

<xsl:call-template name="json-update-template">
<xsl:with-param name="model" select="."/>
</xsl:call-template>

<xsl:call-template name="json-get-template">
<xsl:with-param name="model" select="."/>
</xsl:call-template>

<xsl:call-template name="json-delete-template">
<xsl:with-param name="model" select="."/>
</xsl:call-template>

<xsl:call-template name="json-search-template">
<xsl:with-param name="model" select="."/>
</xsl:call-template>
--> 

<!-- Web View Web Templates -->
<xsl:call-template name="html-index-template">
<xsl:with-param name="model" select="$model"/>
<xsl:with-param name="controller" select="."/>
</xsl:call-template>

<xsl:call-template name="html-show-template">
 <xsl:with-param name="model" select="$model"/>
 <xsl:with-param name="controller" select="."/>
</xsl:call-template>

<xsl:call-template name="html-new-template">
 <xsl:with-param name="model" select="$model"/>
 <xsl:with-param name="controller" select="."/>
</xsl:call-template>

 <xsl:call-template name="html-edit-template">
  <xsl:with-param name="model" select="$model"/>
  <xsl:with-param name="controller" select="."/>
</xsl:call-template>

<xsl:call-template name="html-remove-template">
 <xsl:with-param name="model" select="$model"/>
 <xsl:with-param name="controller" select="."/>
</xsl:call-template>
 
 <xsl:call-template name="html-save-template">
  <xsl:with-param name="model" select="$model"/>
  <xsl:with-param name="controller" select="."/>
 </xsl:call-template>

<xsl:call-template name="html-find-template">
 <xsl:with-param name="model" select="$model"/>
 <xsl:with-param name="controller" select="."/>
</xsl:call-template>

<xsl:call-template name="html-list-template">
 <xsl:with-param name="model" select="$model"/>
 <xsl:with-param name="controller" select="."/>
</xsl:call-template>
 
<!--End Generation-->
</xsl:template>

<!--Base Header for all HTML Views-->
<xsl:template name="base-html-header">
xquery version "1.0-ml";
declare default element namespace "http://www.w3.org/1999/xhtml";
import module namespace response = "http://www.xquerrail-framework.com/response" at "/_framework/response.xqy";
declare option xdmp:output "indent-untyped=yes";
declare variable $response as map:map external;
let $init := response:initialize($response)
return
</xsl:template>

<!--REST Service Builder Templates -->
<!--Get Template-->
<xsl:template name="json-get-template">
<xsl:param name="controller"/>
<xsl:param name="model"/>
</xsl:template>

<!--Create Template-->
<xsl:template name="json-create-template" xml:space="true">

</xsl:template>
<!--JSON Update Template-->
<xsl:template name="json-update-template">
</xsl:template>

<!--JSON Delete Template-->
<xsl:template name="json-delete-template">
<xsl:param name="model" as="element()"/>
</xsl:template>
<!--JSON Search Template--> 
<xsl:template name="json-search-template">
<xsl:param name="model"/>
</xsl:template>


<!--
Define all your Body Function Templates
-->
<xsl:template match="domain:view" mode="view-body">
<xsl:apply-templates select="*" mode="view-body"/>
<!--End Builder Template-->
</xsl:template>


<xsl:template name="html-main-template">
<xsl:param name="model" select="."/>
xquery version "1.0-ml";
declare default element namespace "http://www.w3.org/1999/xhtml";
declare option xdmp:output "indent=yes;indent-untyped=yes;indent-typed=yes";
</xsl:template>

<xsl:template name="html-info-template">
 <xsl:param name="model" as="element(domain:model)"/>
 <xsl:param name="controller" as="element(domain:controller)"/>
</xsl:template>

<!-- Web Builder Templates -->
<xsl:template name="html-index-template">
 <xsl:param name="model" as="element(domain:model)"/>
 <xsl:param name="controller" as="element(domain:controller)"/>
 <xsl:variable name="body">
     <div id="form-wrapper" xmlns="http://www.w3.org/1999/xhtml">
      <div class="inner-page-title ui-layout-north">
         <div class="toolbar">
          <h2><xsl:value-of select="($model/@label,$controller/@label,$controller/@name)[1]"/></h2>
          <div class="toolbar-items">
            <a class="toolbar-item toolbar-new">
             <xsl:attribute name="onclick">return createNew(this);</xsl:attribute>
             <xsl:attribute name="href">/<xsl:value-of select="$controller/@name"/>/new.html</xsl:attribute>
             New
            </a>
           <a class="toolbar-item toolbar-help">
              <xsl:attribute name="href">/help.html?id=<xsl:value-of select="$model/@name"/></xsl:attribute>
              Help
            </a>
          </div>
         </div>      
      </div>     
      <div class="list-box ui-layout-west">
       <table id="{$model/@name}_table" > </table>
       <div id="{normalize-space($model/@name)}_table_pager"></div>
      </div>       
      <div class="form-box panel ui-layout-center">
        <h3><xsl:value-of select="($model/@label,$controller/@label,$controller/@name)[1]"/></h3>
        <div id="form-content" class="pannelContent">
          <p>You may select an existing item in the table provided to 
           edit it or click new above to create a new entry.</p>
        </div>
      </div>
      
      <!--<br class="clearit"/>-->
      <script type="text/javascript">
         var gridId = "#<xsl:value-of select="$model/@name"/>_table";
         <xsl:value-of select="builder:get-list-gridmodel($controller,$model)"/>
      </script>
     </div>
 </xsl:variable>
 
 <xsl:call-template name="create-html-view-file">
    <xsl:with-param name="controller" select="$controller"/>
    <xsl:with-param name="model" select="$model"/>
    <xsl:with-param name="body" select="$body"/>
    <xsl:with-param name="view">index</xsl:with-param>
 </xsl:call-template>
</xsl:template>

<xsl:template name="html-show-template">
 <xsl:param name="model" as="element(domain:model)"/>
 <xsl:param name="controller" as="element(domain:controller)"/>
 <xsl:variable name="id-field" select="$model//(domain:element|domain:attribute)[@id-field = 'true']"/>
 <xsl:variable name="body">
  <div id="show-wrapper">
   <div class="inner-page-title">
    <h2>Show <xsl:value-of select="($model/@label,$controller/@label,$controller/@name)[1]"/></h2>
   </div>
   <div class="show-box">
    <form name="form_{$model/@name}" method="get" action="/{$controller/@name}/edit.html"> 
     <ul>
      <xsl:for-each select="$model//(domain:element|domain:attribute)">
       <xsl:variable name="type" select="./@type"></xsl:variable>
      <li>
       <label class="show-only label"><xsl:value-of select="(@label,@name)[1]"/>:</label>
       <span class="show-only field ">{fn:data(response:body()/*:<xsl:value-of select="@name"/>)}{" "}</span><br/>
      </li>
      </xsl:for-each>
      <li class="buttons">
       <button class="ui-state-default ui-button" type="submit">Edit</button>
      </li>
     </ul>
    </form>
    <h2>XML Format</h2>
    <div style="width:400px">
    <pre>{
     xdmp:quote(response:body())
     }</pre>
     </div>
   </div>
   <div class="clearfix"></div>
  </div>
 </xsl:variable>
 
 <xsl:call-template name="create-html-view-file">
  <xsl:with-param name="controller" select="$controller"/>
  <xsl:with-param name="model" select="$model"/>
  <xsl:with-param name="body" select="$body"/>
  <xsl:with-param name="view">show</xsl:with-param>
 </xsl:call-template>
</xsl:template>

<xsl:template name="html-new-template">
 <xsl:param name="model" as="element(domain:model)"/>
 <xsl:param name="controller" as="element(domain:controller)"/>
 <xsl:variable name="body">
  <div id="form-wrapper">
   <div class="inner-page-title">
    <h2>Create New <span class="formLabel"><xsl:value-of select="($model/@label,$controller/@label,$controller/@name)[1]"/></span></h2>
   </div>
   <div class="content-box">
    <form id="form_{$model/@name}" name="form_{$model/@name}" method="post" action="/{$controller/@name}/save.html" onsubmit="return validateSave('form_{$model/@name}','{$model/@name}_table');">
     <ul class="editPanel">
      <xsl:for-each select="$model//(domain:element|domain:attribute)">
       <xsl:variable name="type" select="./@type"></xsl:variable>
       <li>
        <label class="desc"><xsl:value-of select="(@label,@name)[1]"/>:</label>
         <xsl:choose>
          <xsl:when test="$type = 'string'">
           <input class="field text small" name="{./@name}" type="text" value="" />  
          </xsl:when>
          <xsl:when test="$type = 'boolean'">
           <input class="field checkbox small" name="{./@name}" type="checkbox" value="true" />  
          </xsl:when>
          <xsl:when test="$type = 'date'">
           <input class="field date small" name="{./@name}" type="text" value="" />  
          </xsl:when>
          <xsl:when test="$type = 'dateTime'">
           <input class="field datetime small" name="{./@name}" type="text" value="" />  
          </xsl:when>
          <xsl:when test="$type = 'integer'">
           <input class="field number small" name="{./@name}" type="text" value="" />  
          </xsl:when>
          <xsl:otherwise>
           Unresolved domain type:
           <input class="field text small" style="border:1px solid red;" name="{./@name}" type="text" value="" />  
          </xsl:otherwise>
         </xsl:choose>
       </li>
      </xsl:for-each>
      <li class="buttons">
        <a class="cnp-button" href="#" onclick="return validateSave('form_{$model/@name}','{$model/@name}_table');">Create</a>
      </li>
     </ul>
    </form>
   </div>
   <div class="clearfix"></div>
  </div>
 </xsl:variable>
 <xsl:call-template name="create-html-view-file">
  <xsl:with-param name="controller" select="$controller"/>
  <xsl:with-param name="model" select="$model"/>
  <xsl:with-param name="body" select="$body"/>
  <xsl:with-param name="view">new</xsl:with-param>
 </xsl:call-template>
</xsl:template>

<xsl:template name="html-edit-template">
 <xsl:param name="model" as="element(domain:model)"/>
 <xsl:param name="controller" as="element(domain:controller)"/>
 <xsl:variable name="body">
  <div id="form-wrapper" xmlns="http://www.w3.org/1999/xhtml">
   <div class="inner-page-title">
    <h2>Edit <span class="formLabel"><xsl:value-of select="($model/@label,$controller/@label,$controller/@name)[1]"/></span></h2>
   </div>
   <div class="content-box">
    <form id="form_{$model/@name}" name="form_{$model/@name}" method="post" action="/{$controller/@name}/save.html" onsubmit="return validateSave('form_{$model/@name}','{$model/@name}_table');"> 
     <input type="hidden" name="uuid" value="{{response:body()/*:uuid}}" />
     <ul class="editPanel">
      <xsl:for-each select="$model//(domain:element|domain:attribute)">
       <xsl:variable name="type" select="./@type"></xsl:variable>
       <li>
        <label class="desc" for="{./@name}"><xsl:value-of select="(@label,@name)[1]"/> : </label>
        <xsl:copy-of select="builder:form-field(.)"/>
       </li>
      </xsl:for-each>
      <li class="buttons">
       <a class="cnp-button" href="#" onclick="return validateSave('form_{$model/@name}','{$model/@name}_table');">Save</a>
       {     
       if(response:body()/*:uuid) then      
       <a href="/{$controller/@name}/remove.html?uuid={{response:body()/*:uuid}}" class="cnp-button">
       <xsl:attribute name="onclick">
        return validateDelete(this,'<xsl:value-of select="normalize-space($model/@name)"/>_table');
       </xsl:attribute>
        Remove</a>
       else ()
       }  
      </li>
     </ul>
    </form>
   </div>
   <div class="clearfix"></div>
  </div>
 </xsl:variable>
 <xsl:call-template name="create-html-view-file">
  <xsl:with-param name="controller" select="$controller"/>
  <xsl:with-param name="model" select="$model"/>
  <xsl:with-param name="body" select="$body"/>
  <xsl:with-param name="view">edit</xsl:with-param>
 </xsl:call-template>
</xsl:template>
 
<xsl:template name="html-save-template">
 <xsl:param name="model" as="element(domain:model)"/>
 <xsl:param name="controller" as="element(domain:controller)"/>
 <xsl:variable name="body">
  <p>The item has been saved.</p>
 </xsl:variable>
 <xsl:call-template name="create-html-view-file">
  <xsl:with-param name="controller" select="$controller"/>
  <xsl:with-param name="model" select="$model"/>
  <xsl:with-param name="body" select="$body"/>
  <xsl:with-param name="view">save</xsl:with-param>
 </xsl:call-template>
</xsl:template>

<xsl:template name="html-remove-template">
 <xsl:param name="model" as="element(domain:model)"/>
 <xsl:param name="controller" as="element(domain:controller)"/>
 <xsl:variable name="body">
    <p>The item has been removed</p>
 </xsl:variable>
<xsl:call-template name="create-html-view-file">
  <xsl:with-param name="controller" select="$controller"/>
  <xsl:with-param name="model" select="$model"/>
  <xsl:with-param name="body" select="$body"/>
  <xsl:with-param name="view">remove</xsl:with-param>
 </xsl:call-template>
</xsl:template>
 
<xsl:template name="html-list-template">
 <xsl:param name="model" as="element(domain:model)"/>
 <xsl:param name="controller" as="element(domain:controller)"/>
</xsl:template>

<xsl:template name="html-find-template">
 <xsl:param name="model" as="element(domain:model)"/>
 <xsl:param name="controller" as="element(domain:controller)"/>
</xsl:template>   

 <xsl:template name="create-html-view-file">
  <xsl:param name="controller"/>
  <xsl:param name="model"/>
  <xsl:param name="body"/>
  <xsl:param name="view"/>
  <xsl:result-document href="../../{$app-name}/views/{$controller/@name}/{$controller/@name}.{$view}.html.xqy" exclude-result-prefixes="#all">(:@GENERATED@:)<xsl:call-template name="base-html-header"/>
   <xsl:copy-of select="$body" exclude-result-prefixes="#all" copy-namespaces="no"></xsl:copy-of>
  </xsl:result-document>
 </xsl:template>

 <!--
  ============================================================
  Javascript HELPER FUNCTIONS
  ============================================================
 -->
 <!--Javascript Grid Generator Functions-->
<xsl:function name="builder:get-list-gridmodel">
<xsl:param name="controller" as="element(domain:controller)"/>
<xsl:param name="model" as="element(domain:model)"/>
<xsl:variable name="paginate" select="$model/domain:navigation/@paginate eq 'true'"/>
<xsl:variable name="paginate-settings">
 <xsl:choose>
    <xsl:when test="$paginate eq true()">rowNum:50,
     loadonce: false,
     pgbuttons: true,
    </xsl:when>
    <xsl:otherwise>loadonce:false,
     rowNum:9999999,
     pgbuttons: false,
    </xsl:otherwise>
</xsl:choose>
 </xsl:variable> 
 <xsl:variable name="sort-settings">
  <xsl:choose>
   <xsl:when test="$model/domain:navigation[@sortable eq 'true']">
    sortname: '<xsl:value-of select="builder:get-primary-field-id($model)"/>',
    sortorder: 'desc',   
   </xsl:when>
   <xsl:otherwise>loadonce:false,
    rowNum:9999999,
    pgbuttons: false,
   </xsl:otherwise>
  </xsl:choose>
</xsl:variable>
var gridModel = {{
     url: '/<xsl:value-of select="builder:get-controller-uri($controller,$model,'list')"/>/list.xml',
     pager: jQuery('#<xsl:value-of select="normalize-space($model/@name)"/>_table_pager'),
     datatype: "xml",
     colModel:[<xsl:value-of select="builder:get-grid-columns($controller,$model)"/>],
     <xsl:value-of select="$paginate-settings"/>
     <xsl:value-of select="$sort-settings"/>
     //Grid Text
     emptyrecords: "No <xsl:value-of select="$model/@name"/>'s Found",
     loadtext: "Loading <xsl:value-of select="$model/@name"/>'s",
     gridview: true,
     viewrecords :true,
     rownumbers:true,
     width: '500',
     height: '500',
     multiselect: false,
     xmlReader : xmlListReaderSettings('<xsl:value-of select="$model/@name"/>s','<xsl:value-of select="$model/@name"/>'),
     onSelectRow: function(id){{ 
       if(id){{ 
         editForm('<xsl:value-of select="$controller/@name"/>',id,true);
       }} 
     }}
}};

/*initialize your grid model*/
$(document).ready(function(){{
   initListGrid("#<xsl:value-of select="normalize-space($model/@name)"/>_table",gridModel)
}});
</xsl:function>
<xsl:function name="builder:form-field">
  <xsl:param name="field" />
  <xsl:variable name="datatype" select="$field/@type"/>
  <xsl:variable name="id" select="generate-id($field)"/>
  <xsl:variable name="ref" select="$field/@ref"/>
  <xsl:variable name="constraints" select="$field/domain:constraint"/>
  <xsl:variable name="ui" select="$field/domain:ui"/>
  <xsl:variable name="inList" select="$constraints/@inList"/>
  <xsl:variable name="value">{response:body()//*:<xsl:value-of select="$field/@name"/>}</xsl:variable>
  <xsl:choose>
    <xsl:when test="$inList ne '' and exists($inList)"
     ><xsl:copy-of select="builder:text-field(generate-id($field),$field/@name,'field text','select',$value)"/></xsl:when>
   <xsl:when test="$datatype eq 'boolean'">
    <xsl:copy-of select="builder:text-field(generate-id($field),$field/@name,'field checkbox','checkbox',$value)"/>
   </xsl:when>
   <xsl:otherwise>
    <xsl:copy-of select="builder:text-field(generate-id($field),$field/@name,'field text','input',$value)"/>
   </xsl:otherwise>
  </xsl:choose>
 
</xsl:function>
 
<xsl:function name="builder:text-field">
  <xsl:param name="id"/>
  <xsl:param name="name"/>
  <xsl:param name="class"/>
  <xsl:param name="type"/>
  <xsl:param name="value"/>
  <xsl:choose>
     <xsl:when test="$type eq 'input'">
         <xsl:element name="input" namespace="http://www.w3.org/1999/xhtml">
          <xsl:attribute name="id" select="$id"/>
          <xsl:attribute name="name" select="$name"/>
          <xsl:attribute name="class" select="$class"/>
          <xsl:attribute name="value" select="$value"></xsl:attribute>
         </xsl:element>
     </xsl:when>
     <xsl:when test="$type eq 'select'">
      <xsl:element name="select" namespace="http://www.w3.org/1999/xhtml">
       <xsl:attribute name="id" select="$id"/>
       <xsl:attribute name="name" select="$name"/>
       <xsl:attribute name="class" select="$class"/>
       {for $opt in response:data("status")//*:option
        return
          <option>
          {if($opt/@value eq <xsl:value-of select="$value"/>)
           then attribute selected {"selected"}
           else ()
          }{$opt/text()}          
          </option>
       }
      </xsl:element>
     </xsl:when>   
    <xsl:when test="$type eq 'checkbox'">
      <xsl:element name="input" namespace="http://www.w3.org/1999/xhtml">
        <xsl:attribute name="id" select="$id"/>
        <xsl:attribute name="name" select="$name" />
        <xsl:attribute name="class" select="$class"/>
        <xsl:attribute name="value" select="$value"></xsl:attribute>
        <xsl:attribute name="type">checkbox</xsl:attribute>
          {
           if(response:body()/*:<xsl:value-of select="$name"/> = 'true') 
           then attribute checked {"checked"}
           else () 
          }         
      </xsl:element>
    </xsl:when>
  </xsl:choose>
</xsl:function> 
<xsl:function name="builder:get-controller-uri">
<xsl:param name="controller" as="element(domain:controller)"/>
<xsl:param name="model" as="element(domain:model)"/>
<xsl:param name="action" as="xs:string"/> 
<xsl:value-of select="($controller/@name,concat($controller/@model,'s'))[1]"></xsl:value-of> 
</xsl:function>
 
<xsl:function name="builder:get-grid-colnames">
<xsl:param name="controller" as="element(domain:controller)"/>
<xsl:param name="model" as="element(domain:model)"/>
 <xsl:for-each select="$model/(domain:element|domain:attribute)">'<xsl:value-of select="@name"/>'<xsl:if test="position() ne last()">,</xsl:if></xsl:for-each>
</xsl:function>

<xsl:function name="builder:get-grid-columns">
<xsl:param name="controller" as="element(domain:controller)"/>
<xsl:param name="model" as="element(domain:model)"/>
 {{ name:'uuid', label:'UUID', index:'uuid',hidden:true}},
 <xsl:for-each select='$model/(domain:element|domain:attribute)'>
  {{ name:'<xsl:value-of select="./@name"/>', label:'<xsl:value-of select="(./@label,./@name)[1]"/>', index:'<xsl:value-of select="./@name"/>', xmlmap:'<xsl:value-of select="./@name"/>', 
     jsonmap:'<xsl:value-of select="./@name"/>', dataType:'<xsl:value-of select="builder:grid-type(.)"/>', resizable: true, sortable: true,  width:'80'}}<xsl:if test="position() ne last()">,</xsl:if>
 </xsl:for-each>
</xsl:function>
<xsl:function name="builder:grid-type">
  <xsl:param name="node" as="node()"/>
   <xsl:choose>
       <xsl:when test="$node/@type eq 'string'">string</xsl:when>
       <xsl:when test="$node/@type eq 'long'">long</xsl:when>
       <xsl:when test="$node/@type eq 'integer'">integer</xsl:when>
       <xsl:when test="$node/@type eq 'decimal'">decimal</xsl:when>
       <xsl:when test="$node/@type eq 'float'">float</xsl:when>
       <xsl:when test="$node/@type eq 'boolean'">boolean</xsl:when>
       <xsl:when test="$node/@type eq 'normalizedString'">textarea</xsl:when>
       <xsl:when test="$node/@type eq 'date'">date</xsl:when>
       <xsl:when test="$node/@type eq 'dateTime'">dateTime</xsl:when>
       <xsl:when test="$node/@type eq 'time'">time</xsl:when>
       <xsl:when test="$node/@type eq 'duration'">duration</xsl:when>
       <xsl:when test="$node/@type eq 'dayTime'">integer</xsl:when>
       <xsl:when test="$node/@type eq 'yearMonth'">integer</xsl:when>
       <xsl:when test="$node/@type eq 'monthDay'">integer</xsl:when>
   </xsl:choose>
</xsl:function>
<!--Global Chomper--> 
<xsl:template match="*" mode="view-body"/>
<xsl:template match="*" mode="view-header"/>
<xsl:template match="*" mode="view"/>
</xsl:stylesheet>
