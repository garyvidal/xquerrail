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



(:@AUTO-GENERATED@:)
xquery version "1.0-ml";
(:~
: Model : project 
:         A project in a content validation framework
: @author  Gary Vidal
: @version 1.0  
: Requires Models:

~:)

module namespace model = "http://marklogic.com/ps/content-validation/project";

(:Default Content Namespace:)
declare namespace cvf = "http://marklogic.com/ps/content-validation";

(:Default Imports:)
import module namespace search = "http://marklogic.com/appservices/search"
  at "/MarkLogic/appservices/search/search.xqy";
 
(:Options Definition:)
declare option xdmp:mapping "false";


(:~
 : Model Definition 
~:)
declare variable $model:model as element(model:model) := 
<model xmlns="http://www.xquerrail-framework.com/domain" name="project"
       description="A project in a content validation framework">        
        <required-namespace prefix="dc" namespace-uri="http://purl.org/dc/elements/1.1"/>
        <required-namespace prefix="dcterms" namespace-uri="http://purl.org/dc/terms/"/>
   <!--        <import-model name="vendor"/>
        <import-model name="user"/>
        <import-model name="schema"/>
        <import-model name="schematron"/>
-->
        <element name="identifier" identity="true" description="Default ID Value for document"
            type="xs:ID">
            <navigation searchable="value" facetable="false" sortable="true"/>
            <constraint required="true"/>
        </element>
        <element name="name" type="xs:string">
            <navigation searchable="value" sortable="true"/>
            <constraint minLength="1" maxLength="9" required="true"/>
        </element>
        <element name="isbn" type="xs:string">
            <navigation searchable="value" sortable="true"/>
            <constraint required="true" minLength="9" maxLength="9"/>
        </element>
        <element name="edition" type="xs:string">
            <navigation searchable="value" sortable="true"/>
        </element>
        <element name="author" type="xs:string">
            <navigation searchable="value" sortable="true"/>
        </element>
        <element name="vendor-ref" type="element()" ref="vendor:reference">
            <navigation facetable="true" sortable="true"/>
        </element>
        <element name="schema-ref" type="element()" ref="schema:reference">
            <navigation facetable="true" sortable="true"/>
        </element>
        <element name="status" type="xs:string" required="true" default="Created">
            <constraint inList="project-status" match=""/>
            <navigation searchable="range" facetable="true" sortable="true"/>
        </element>
        <sequence name="notify">
            <reference name="user-ref" type="xs:string" model="user:reference"/>
        </sequence>
        <sequence name="schematrons">
            <reference name="schematron-ref" type="reference:schematron"
                 model="model:schematron:reference">
                <constraint required="true"/>
            </reference>
        </sequence>
        <children>
            <child model="job" delete="cascade" update="cascade"/>
        </children>
        <optionlist name="project-status" child-element="status" type="xs:string">
            <option>Created</option>
            <option>Closed</option>
            <option>Pending</option>
        </optionlist>
    </model>
;
(:~
 : Search Options Configuration
~:)
declare variable $model:search-options as element(search:options) := 
  <search:options xmlns:domain="http://www.xquerrail-framework.com/domain"
                xmlns:search="http://marklogic.com/appservices/search"
                xmlns:util="http://www.xquerrail-framework.com/lib/utilities">
   <search:constraint name="identifier">
      <search:value facet="true">
         <search:element name="identifier" ns="http://marklogic.com/ps/content-validation"/>
      </search:value>
   </search:constraint>
   <search:constraint name="name">
      <search:value>
         <search:element name="name" ns="http://marklogic.com/ps/content-validation"/>
      </search:value>
   </search:constraint>
   <search:constraint name="isbn">
      <search:value>
         <search:element name="isbn" ns="http://marklogic.com/ps/content-validation"/>
      </search:value>
   </search:constraint>
   <search:constraint name="edition">
      <search:value>
         <search:element name="edition" ns="http://marklogic.com/ps/content-validation"/>
      </search:value>
   </search:constraint>
   <search:constraint name="author">
      <search:value>
         <search:element name="author" ns="http://marklogic.com/ps/content-validation"/>
      </search:value>
   </search:constraint>
   <search:constraint name="status">
      <search:range facet="true">
         <search:element name="status" ns="http://marklogic.com/ps/content-validation"/>
      </search:range>
   </search:constraint>
   <search:operator name="sort">
      <search:state name="identifier">
         <search:sort-order direction="ascending" type="xs:ID">
      {$collation}
      <search:element ns="http://marklogic.com/ps/content-validation" name="identifier"/>
         </search:sort-order>
         <search:sort-order>
            <search:score/>
         </search:sort-order>
      </search:state>
      <search:state name="identifier-descending">
         <search:sort-order direction="descending" type="xs:ID">
      {$collation}
      <search:element ns="" name="identifier"/>
         </search:sort-order>
         <search:sort-order>
            <search:score/>
         </search:sort-order>
      </search:state>
      <search:state name="identifier-ascending">
         <search:sort-order direction="ascending" type="xs:ID">
            <search:element ns="http://marklogic.com/ps/content-validation" name="identifier"/>
         </search:sort-order>
         <search:sort-order>
            <search:score/>
         </search:sort-order>
      </search:state>
      <search:state name="name">
         <search:sort-order direction="ascending" type="xs:string">
      {$collation}
      <search:element ns="http://marklogic.com/ps/content-validation" name="name"/>
         </search:sort-order>
         <search:sort-order>
            <search:score/>
         </search:sort-order>
      </search:state>
      <search:state name="name-descending">
         <search:sort-order direction="descending" type="xs:string">
      {$collation}
      <search:element ns="" name="name"/>
         </search:sort-order>
         <search:sort-order>
            <search:score/>
         </search:sort-order>
      </search:state>
      <search:state name="name-ascending">
         <search:sort-order direction="ascending" type="xs:string">
            <search:element ns="http://marklogic.com/ps/content-validation" name="name"/>
         </search:sort-order>
         <search:sort-order>
            <search:score/>
         </search:sort-order>
      </search:state>
      <search:state name="isbn">
         <search:sort-order direction="ascending" type="xs:string">
      {$collation}
      <search:element ns="http://marklogic.com/ps/content-validation" name="isbn"/>
         </search:sort-order>
         <search:sort-order>
            <search:score/>
         </search:sort-order>
      </search:state>
      <search:state name="isbn-descending">
         <search:sort-order direction="descending" type="xs:string">
      {$collation}
      <search:element ns="" name="isbn"/>
         </search:sort-order>
         <search:sort-order>
            <search:score/>
         </search:sort-order>
      </search:state>
      <search:state name="isbn-ascending">
         <search:sort-order direction="ascending" type="xs:string">
            <search:element ns="http://marklogic.com/ps/content-validation" name="isbn"/>
         </search:sort-order>
         <search:sort-order>
            <search:score/>
         </search:sort-order>
      </search:state>
      <search:state name="edition">
         <search:sort-order direction="ascending" type="xs:string">
      {$collation}
      <search:element ns="http://marklogic.com/ps/content-validation" name="edition"/>
         </search:sort-order>
         <search:sort-order>
            <search:score/>
         </search:sort-order>
      </search:state>
      <search:state name="edition-descending">
         <search:sort-order direction="descending" type="xs:string">
      {$collation}
      <search:element ns="" name="edition"/>
         </search:sort-order>
         <search:sort-order>
            <search:score/>
         </search:sort-order>
      </search:state>
      <search:state name="edition-ascending">
         <search:sort-order direction="ascending" type="xs:string">
            <search:element ns="http://marklogic.com/ps/content-validation" name="edition"/>
         </search:sort-order>
         <search:sort-order>
            <search:score/>
         </search:sort-order>
      </search:state>
      <search:state name="author">
         <search:sort-order direction="ascending" type="xs:string">
      {$collation}
      <search:element ns="http://marklogic.com/ps/content-validation" name="author"/>
         </search:sort-order>
         <search:sort-order>
            <search:score/>
         </search:sort-order>
      </search:state>
      <search:state name="author-descending">
         <search:sort-order direction="descending" type="xs:string">
      {$collation}
      <search:element ns="" name="author"/>
         </search:sort-order>
         <search:sort-order>
            <search:score/>
         </search:sort-order>
      </search:state>
      <search:state name="author-ascending">
         <search:sort-order direction="ascending" type="xs:string">
            <search:element ns="http://marklogic.com/ps/content-validation" name="author"/>
         </search:sort-order>
         <search:sort-order>
            <search:score/>
         </search:sort-order>
      </search:state>
      <search:state name="vendor-ref">
         <search:sort-order direction="ascending" type="element()">
      {$collation}
      <search:element ns="http://marklogic.com/ps/content-validation" name="vendor-ref"/>
         </search:sort-order>
         <search:sort-order>
            <search:score/>
         </search:sort-order>
      </search:state>
      <search:state name="vendor-ref-descending">
         <search:sort-order direction="descending" type="element()">
      {$collation}
      <search:element ns="" name="vendor-ref"/>
         </search:sort-order>
         <search:sort-order>
            <search:score/>
         </search:sort-order>
      </search:state>
      <search:state name="vendor-ref-ascending">
         <search:sort-order direction="ascending" type="element()">
            <search:element ns="http://marklogic.com/ps/content-validation" name="vendor-ref"/>
         </search:sort-order>
         <search:sort-order>
            <search:score/>
         </search:sort-order>
      </search:state>
      <search:state name="schema-ref">
         <search:sort-order direction="ascending" type="element()">
      {$collation}
      <search:element ns="http://marklogic.com/ps/content-validation" name="schema-ref"/>
         </search:sort-order>
         <search:sort-order>
            <search:score/>
         </search:sort-order>
      </search:state>
      <search:state name="schema-ref-descending">
         <search:sort-order direction="descending" type="element()">
      {$collation}
      <search:element ns="" name="schema-ref"/>
         </search:sort-order>
         <search:sort-order>
            <search:score/>
         </search:sort-order>
      </search:state>
      <search:state name="schema-ref-ascending">
         <search:sort-order direction="ascending" type="element()">
            <search:element ns="http://marklogic.com/ps/content-validation" name="schema-ref"/>
         </search:sort-order>
         <search:sort-order>
            <search:score/>
         </search:sort-order>
      </search:state>
      <search:state name="status">
         <search:sort-order direction="ascending" type="xs:string">
      {$collation}
      <search:element ns="http://marklogic.com/ps/content-validation" name="status"/>
         </search:sort-order>
         <search:sort-order>
            <search:score/>
         </search:sort-order>
      </search:state>
      <search:state name="status-descending">
         <search:sort-order direction="descending" type="xs:string">
      {$collation}
      <search:element ns="" name="status"/>
         </search:sort-order>
         <search:sort-order>
            <search:score/>
         </search:sort-order>
      </search:state>
      <search:state name="status-ascending">
         <search:sort-order direction="ascending" type="xs:string">
            <search:element ns="http://marklogic.com/ps/content-validation" name="status"/>
         </search:sort-order>
         <search:sort-order>
            <search:score/>
         </search:sort-order>
      </search:state>
   </search:operator>
</search:options>
;

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
fn:concat("/project/project-",$id,".xml")
};
declare function model:get-permissions() as element(xdmp:permissions)?
{
()
};
declare function model:get-collections()
{
"urn:project"
};
(:Model Operations:)

(:~
 : Returns a list of project-status
 : @return  element(project-status)*   
~:)    
declare function model:list-project-status() as element(project-status)* 
{
<project-status>
   <status key="Created">Created</status>
   <status key="Closed">Closed</status>
   <status key="Pending">Pending</status>
</project-status> 
}; 

(:~
 : Create project
 :
   : @param identifier - Default ID Value for document
   : @param name - name
   : @param isbn - isbn
   : @param edition - edition
   : @param author - author
   : @param vendor-ref - vendor-ref
   : @param schema-ref - schema-ref
   : @param status - status
~:) 
declare function model:create(
   
   $name as xs:string, 
   $isbn as xs:string, 
   $edition as xs:string, 
   $author as xs:string, 
   $vendor-ref as element(), 
   $schema-ref as element(), 
   $status as xs:string  
  ){
  let $identifier := model:create-id()
  let $create := 
<project>
   <creator>{xdmp:get-current-user()}</creator>
   <created>{fn:current-dateTime()}</created>
   <identifier>{$identifier}</identifier>
   <name>{$name}</name>
   <isbn>{$isbn}</isbn>
   <edition>{$edition}</edition>
   <author>{$author}</author>
   <vendor-ref>{$vendor-ref}</vendor-ref>
   <schema-ref>{$schema-ref}</schema-ref>
   <status>{$status}</status>
</project>
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

(:~
 : Update Operation project
 :
 :
   : @param $identifier - Default ID Value for document
   : @param $name - name
   : @param $isbn - isbn
   : @param $edition - edition
   : @param $author - author
   : @param $vendor-ref - vendor-ref
   : @param $schema-ref - schema-ref
   : @param $status - status
~:) 
declare function model:update(
  $identifier as xs:ID, 
  $name as xs:string, 
  $isbn as xs:string, 
  $edition as xs:string, 
  $author as xs:string, 
  $vendor-ref as element(), 
  $schema-ref as element(), 
  $status as xs:string
) as element(model:project) 
{ 
   let $current := model:get($identifier )
   let $update := 
     <project xmlns="http://marklogic.com/ps/content-validation">
        <created>{$current/cvf:created}</created>
        <created-user>{$current/cvf:creator}</created-user>
        <modified>{fn:current-dateTime()}</modified>
        <modified-by>{xdmp:get-current-user()}</modified-by>
        <identifier>{$identifier}</identifier>
        <name>{$name}</name>
        <isbn>{$isbn}</isbn>
        <edition>{$edition}</edition>
        <author>{$author}</author>
        {$vendor-ref}
        {$schema-ref}
        <status>{$status}</status>
      </project>
  return
  (
    xdmp:node-replace($current,$update),
    $update
  )
};

(:~
 :  Retrieves a project by id
~:) 
declare function model:get(
$id as xs:string
) as element(project)?
{
   /project[cvf:identifier = $id]
};
 
(:~
 :  Deletes a project
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
 
(:~
 : Provide search interface for project
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
 