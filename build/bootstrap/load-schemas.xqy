xquery version "1.0-ml";

(: loads all the required schemas into the schemas db :)

declare function local:insert-schema($uri as xs:string, $schema) {
  let $runme :=
    'declare variable $uri as xs:string external;
     declare variable $schema external;
     xdmp:document-insert($uri, $schema)'
  return
    xdmp:eval($runme, (xs:QName("uri"), $uri, xs:QName("schema"), $schema),
              <options xmlns="xdmp:eval">
                <database>{xdmp:database("Schemas")}</database>
              </options>)
};

local:insert-schema("/dc.xsd",
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema"
           xmlns="http://purl.org/dc/elements/1.1/"
           targetNamespace="http://purl.org/dc/elements/1.1/"
           elementFormDefault="qualified"
           attributeFormDefault="unqualified">

  <xs:annotation>
    <xs:documentation xml:lang="en">
      DCMES 1.1 XML Schema
      XML Schema for http://purl.org/dc/elements/1.1/ namespace

      Created 2008-02-11

      Created by 

      Tim Cole (t-cole3@uiuc.edu)
      Tom Habing (thabing@uiuc.edu)
      Jane Hunter (jane@dstc.edu.au)
      Pete Johnston (p.johnston@ukoln.ac.uk),
      Carl Lagoze (lagoze@cs.cornell.edu)

      This schema declares XML elements for the 15 DC elements from the
      http://purl.org/dc/elements/1.1/ namespace.

      It defines a complexType SimpleLiteral which permits mixed content 
      and makes the xml:lang attribute available. It disallows child elements by
      use of minOcccurs/maxOccurs.

      However, this complexType does permit the derivation of other complexTypes
      which would permit child elements.

      All elements are declared as substitutable for the abstract element any, 
      which means that the default type for all elements is dc:SimpleLiteral.

    </xs:documentation>

  </xs:annotation>


  <xs:import namespace="http://www.w3.org/XML/1998/namespace"
             schemaLocation="xml.xsd">
  </xs:import>

  <xs:complexType name="SimpleLiteral">
        <xs:annotation>
        <xs:documentation xml:lang="en">
            This is the default type for all of the DC elements.
            It permits text content only with optional
            xml:lang attribute.
            Text is allowed because mixed="true", but sub-elements
            are disallowed because minOccurs="0" and maxOccurs="0" 
            are on the xs:any tag.

    	    This complexType allows for restriction or extension permitting
            child elements.
    	</xs:documentation>
  	</xs:annotation>

   <xs:complexContent mixed="true">
    <xs:restriction base="xs:anyType">
     <xs:sequence>
      <xs:any processContents="lax" minOccurs="0" maxOccurs="0"/>
     </xs:sequence>
     <xs:attribute ref="xml:lang" use="optional"/>
    </xs:restriction>
   </xs:complexContent>
  </xs:complexType>

  <xs:element name="any" type="SimpleLiteral" abstract="true"/>

  <xs:element name="title" substitutionGroup="any"/>
  <xs:element name="creator" substitutionGroup="any"/>
  <xs:element name="subject" substitutionGroup="any"/>
  <xs:element name="description" substitutionGroup="any"/>
  <xs:element name="publisher" substitutionGroup="any"/>
  <xs:element name="contributor" substitutionGroup="any"/>
  <xs:element name="date" substitutionGroup="any"/>
  <xs:element name="type" substitutionGroup="any"/>
  <xs:element name="format" substitutionGroup="any"/>
  <xs:element name="identifier" substitutionGroup="any"/>
  <xs:element name="source" substitutionGroup="any"/>
  <xs:element name="language" substitutionGroup="any"/>
  <xs:element name="relation" substitutionGroup="any"/>
  <xs:element name="coverage" substitutionGroup="any"/>
  <xs:element name="rights" substitutionGroup="any"/>

  <xs:group name="elementsGroup">
  	<xs:annotation>
    	<xs:documentation xml:lang="en">
    	    This group is included as a convenience for schema authors
            who need to refer to all the elements in the 
            http://purl.org/dc/elements/1.1/ namespace.
    	</xs:documentation>
  	</xs:annotation>

  <xs:sequence>
    <xs:choice minOccurs="0" maxOccurs="unbounded">
      <xs:element ref="any"/>
    </xs:choice>
    </xs:sequence>
  </xs:group>

  <xs:complexType name="elementContainer">
  	<xs:annotation>
    	<xs:documentation xml:lang="en">
    		This complexType is included as a convenience for schema authors who need to define a root
    		or container element for all of the DC elements.
    	</xs:documentation>
  	</xs:annotation>

    <xs:choice>
      <xs:group ref="elementsGroup"/>
    </xs:choice>
  </xs:complexType>


</xs:schema>),


local:insert-schema("/dcmimetype.xsd",
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema"
           xmlns="http://purl.org/dc/dcmitype/"
           targetNamespace="http://purl.org/dc/dcmitype/"
           elementFormDefault="qualified"
           attributeFormDefault="unqualified">

  <xs:annotation>
    <xs:documentation xml:lang="en">
      DCMI Type Vocabulary XML Schema
      XML Schema for http://purl.org/dc/dcmitype/ namespace

      Created 2008-02-11

      Created by 

      Tim Cole (t-cole3@uiuc.edu)
      Tom Habing (thabing@uiuc.edu)
      Jane Hunter (jane@dstc.edu.au)
      Pete Johnston (p.johnston@ukoln.ac.uk),
      Carl Lagoze (lagoze@cs.cornell.edu)

      This schema defines a simpleType which enumerates
      the allowable values for the DCMI Type Vocabulary.
    </xs:documentation>

 
  </xs:annotation>


  <xs:simpleType name="DCMIType">
     <xs:union>
        <xs:simpleType>
           <xs:restriction base="xs:Name">
		<xs:enumeration value="Collection"/>
		<xs:enumeration value="Dataset"/>
		<xs:enumeration value="Event"/>
		<xs:enumeration value="Image"/>
		<xs:enumeration value="MovingImage"/>
		<xs:enumeration value="StillImage"/>
		<xs:enumeration value="InteractiveResource"/>
		<xs:enumeration value="Service"/>
		<xs:enumeration value="Software"/>
		<xs:enumeration value="Sound"/>
		<xs:enumeration value="Text"/>
		<xs:enumeration value="PhysicalObject"/>
            </xs:restriction>
        </xs:simpleType> 
     </xs:union>
  </xs:simpleType>

</xs:schema>),

local:insert-schema("/dcterms.xsd",
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema"
           xmlns:dc="http://purl.org/dc/elements/1.1/"
           xmlns:dcmitype="http://purl.org/dc/dcmitype/"
           targetNamespace="http://purl.org/dc/terms/"
           xmlns="http://purl.org/dc/terms/"
           elementFormDefault="qualified"
           attributeFormDefault="unqualified">

  <xs:annotation>
    <xs:documentation xml:lang="en">
      DCterms XML Schema
      XML Schema for http://purl.org/dc/terms/ namespace
 
      Created 2008-02-11

      Created by 

      Tim Cole (t-cole3@uiuc.edu)
      Tom Habing (thabing@uiuc.edu)
      Jane Hunter (jane@dstc.edu.au)
      Pete Johnston (p.johnston@ukoln.ac.uk),
      Carl Lagoze (lagoze@cs.cornell.edu)

      This schema declares XML elements for the DC elements and
      DC element refinements from the http://purl.org/dc/terms/ namespace.
      
      It reuses the complexType dc:SimpleLiteral, imported from the dc.xsd
      schema, which permits simple element content, and makes the xml:lang
      attribute available.

      This complexType permits the derivation of other complexTypes
      which would permit child elements.

      XML elements corresponding to DC elements are declared as substitutable for the abstract element dc:any, and 
      XML elements corresponding to DC element refinements are defined as substitutable for the base elements 
      which they refine.

      This means that the default type for all XML elements (i.e. corresponding to all DC elements and 
      element refinements) is dc:SimpleLiteral.

      Encoding schemes are defined as complexTypes which are restrictions
      of the dc:SimpleLiteral complexType. These complexTypes restrict 
      values to an appropriates syntax or format using data typing,
      regular expressions, or enumerated lists.
  
      In order to specify one of these encodings an xsi:type attribute must 
      be used in the instance document.

      Also, note that one shortcoming of this approach is that any type can be 
      applied to any of the elements or refinements.  There is no convenient way
      to restrict types to specific elements using this approach.

      Changes in 2008-02-11 version:
      
      Add element declarations corresponding to 15 new dcterms URIs, and amend use of substitutionGroups.
      
      Add compexType definitions corresponding to ISO639-3, RFC4646.
      
    </xs:documentation>

  </xs:annotation>


  <xs:import namespace="http://www.w3.org/XML/1998/namespace"
             schemaLocation="xml.xsd">
  </xs:import>

   <xs:import namespace="http://purl.org/dc/elements/1.1/"
              schemaLocation="dc.xsd"/>

   <xs:import namespace="http://purl.org/dc/dcmitype/"
              schemaLocation="dcmitype.xsd"/>

   <xs:element name="title" substitutionGroup="dc:title"/>
   <xs:element name="creator" substitutionGroup="dc:creator"/>
   <xs:element name="subject" substitutionGroup="dc:subject"/>
   <xs:element name="description" substitutionGroup="dc:description"/>
   <xs:element name="publisher" substitutionGroup="dc:publisher"/>
   <xs:element name="contributor" substitutionGroup="dc:contributor"/>
   <xs:element name="date" substitutionGroup="dc:date"/>
   <xs:element name="type" substitutionGroup="dc:type"/>
   <xs:element name="format" substitutionGroup="dc:format"/>
   <xs:element name="identifier" substitutionGroup="dc:identifier"/>
   <xs:element name="source" substitutionGroup="dc:source"/>
   <xs:element name="language" substitutionGroup="dc:language"/>
   <xs:element name="relation" substitutionGroup="dc:relation"/>
   <xs:element name="coverage" substitutionGroup="dc:coverage"/>
   <xs:element name="rights" substitutionGroup="dc:rights"/>

   <xs:element name="alternative" substitutionGroup="title"/>

   <xs:element name="tableOfContents" substitutionGroup="description"/>
   <xs:element name="abstract" substitutionGroup="description"/>

   <xs:element name="created" substitutionGroup="date"/>
   <xs:element name="valid" substitutionGroup="date"/>
   <xs:element name="available" substitutionGroup="date"/>
   <xs:element name="issued" substitutionGroup="date"/>
   <xs:element name="modified" substitutionGroup="date"/>
   <xs:element name="dateAccepted" substitutionGroup="date"/>
   <xs:element name="dateCopyrighted" substitutionGroup="date"/>
   <xs:element name="dateSubmitted" substitutionGroup="date"/>

   <xs:element name="extent" substitutionGroup="format"/>
   <xs:element name="medium" substitutionGroup="format"/>

   <xs:element name="isVersionOf" substitutionGroup="relation"/>
   <xs:element name="hasVersion" substitutionGroup="relation"/>
   <xs:element name="isReplacedBy" substitutionGroup="relation"/>
   <xs:element name="replaces" substitutionGroup="relation"/>
   <xs:element name="isRequiredBy" substitutionGroup="relation"/>
   <xs:element name="requires" substitutionGroup="relation"/>
   <xs:element name="isPartOf" substitutionGroup="relation"/>
   <xs:element name="hasPart" substitutionGroup="relation"/>
   <xs:element name="isReferencedBy" substitutionGroup="relation"/>
   <xs:element name="references" substitutionGroup="relation"/>
   <xs:element name="isFormatOf" substitutionGroup="relation"/>
   <xs:element name="hasFormat" substitutionGroup="relation"/>
   <xs:element name="conformsTo" substitutionGroup="relation"/>

   <xs:element name="spatial" substitutionGroup="coverage"/>
   <xs:element name="temporal" substitutionGroup="coverage"/>

   <xs:element name="audience" substitutionGroup="dc:any"/>
   <xs:element name="accrualMethod" substitutionGroup="dc:any"/>
   <xs:element name="accrualPeriodicity" substitutionGroup="dc:any"/>
   <xs:element name="accrualPolicy" substitutionGroup="dc:any"/>
   <xs:element name="instructionalMethod" substitutionGroup="dc:any"/>
   <xs:element name="provenance" substitutionGroup="dc:any"/>
   <xs:element name="rightsHolder" substitutionGroup="dc:any"/>

   <xs:element name="mediator" substitutionGroup="audience"/>
   <xs:element name="educationLevel" substitutionGroup="audience"/>

   <xs:element name="accessRights" substitutionGroup="rights"/>
   <xs:element name="license" substitutionGroup="rights"/>

   <xs:element name="bibliographicCitation" substitutionGroup="identifier"/>

  <xs:complexType name="LCSH">
   <xs:simpleContent>
    <xs:restriction base="dc:SimpleLiteral">
        <xs:simpleType>
          <xs:restriction base="xs:string"/>
        </xs:simpleType>
        <xs:attribute ref="xml:lang" use="prohibited"/>
    </xs:restriction>
   </xs:simpleContent>
  </xs:complexType>

  <xs:complexType name="MESH">
   <xs:simpleContent>
    <xs:restriction base="dc:SimpleLiteral">
        <xs:simpleType>
          <xs:restriction base="xs:string"/>
        </xs:simpleType>
        <xs:attribute ref="xml:lang" use="prohibited"/>
    </xs:restriction>
   </xs:simpleContent>
  </xs:complexType>

  <xs:complexType name="DDC">
   <xs:simpleContent>
    <xs:restriction base="dc:SimpleLiteral">
        <xs:simpleType>
          <xs:restriction base="xs:string"/>
        </xs:simpleType>
        <xs:attribute ref="xml:lang" use="prohibited"/>
    </xs:restriction>
   </xs:simpleContent>
  </xs:complexType>

  <xs:complexType name="LCC">
   <xs:simpleContent>
    <xs:restriction base="dc:SimpleLiteral">
        <xs:simpleType>
          <xs:restriction base="xs:string"/>
        </xs:simpleType>
        <xs:attribute ref="xml:lang" use="prohibited"/>
    </xs:restriction>
   </xs:simpleContent>
  </xs:complexType>

  <xs:complexType name="UDC">
   <xs:simpleContent>
    <xs:restriction base="dc:SimpleLiteral">
        <xs:simpleType>
          <xs:restriction base="xs:string"/>
        </xs:simpleType>
        <xs:attribute ref="xml:lang" use="prohibited"/>
    </xs:restriction>
   </xs:simpleContent>
  </xs:complexType>

  <xs:complexType name="Period">
   <xs:simpleContent>
    <xs:restriction base="dc:SimpleLiteral">
        <xs:simpleType>
          <xs:restriction base="xs:string"/>
        </xs:simpleType>
        <xs:attribute ref="xml:lang" use="prohibited"/>
    </xs:restriction>
   </xs:simpleContent>
  </xs:complexType>

  <xs:complexType name="W3CDTF">
   <xs:simpleContent>
    <xs:restriction base="dc:SimpleLiteral">
        <xs:simpleType>
           <xs:union memberTypes="xs:gYear xs:gYearMonth xs:date xs:dateTime"/>
        </xs:simpleType>
        <xs:attribute ref="xml:lang" use="prohibited"/>
    </xs:restriction>
   </xs:simpleContent>
  </xs:complexType> 

  <xs:complexType name="DCMIType">
   <xs:simpleContent>
    <xs:restriction base="dc:SimpleLiteral">
        <xs:simpleType>
          <xs:restriction base="dcmitype:DCMIType"/>
        </xs:simpleType>
        <xs:attribute ref="xml:lang" use="prohibited"/>
    </xs:restriction>
   </xs:simpleContent>
  </xs:complexType>

  <xs:complexType name="IMT">
   <xs:simpleContent>
    <xs:restriction base="dc:SimpleLiteral">
        <xs:simpleType>
          <xs:restriction base="xs:string"/>
        </xs:simpleType>
        <xs:attribute ref="xml:lang" use="prohibited"/>
    </xs:restriction>
   </xs:simpleContent>
  </xs:complexType>

  <xs:complexType name="URI">
   <xs:simpleContent>
    <xs:restriction base="dc:SimpleLiteral">
        <xs:simpleType>
          <xs:restriction base="xs:anyURI"/>
        </xs:simpleType>
        <xs:attribute ref="xml:lang" use="prohibited"/>
    </xs:restriction>
   </xs:simpleContent>
  </xs:complexType> 

  <xs:complexType name="ISO639-2">
   <xs:simpleContent>
    <xs:restriction base="dc:SimpleLiteral">
        <xs:simpleType>
          <xs:restriction base="xs:string"/>
        </xs:simpleType>
        <xs:attribute ref="xml:lang" use="prohibited"/>
    </xs:restriction>
   </xs:simpleContent>
  </xs:complexType>

  <xs:complexType name="ISO639-3">
   <xs:simpleContent>
    <xs:restriction base="dc:SimpleLiteral">
        <xs:simpleType>
          <xs:restriction base="xs:string"/>
        </xs:simpleType>
        <xs:attribute ref="xml:lang" use="prohibited"/>
    </xs:restriction>
   </xs:simpleContent>
  </xs:complexType>

  <xs:complexType name="RFC1766">
   <xs:simpleContent>
    <xs:restriction base="dc:SimpleLiteral">
        <xs:simpleType>
          <xs:restriction base="xs:language"/>
        </xs:simpleType>
        <xs:attribute ref="xml:lang" use="prohibited"/>
    </xs:restriction>
   </xs:simpleContent>
  </xs:complexType>

  <xs:complexType name="RFC3066">
   <xs:simpleContent>
    <xs:restriction base="dc:SimpleLiteral">
        <xs:simpleType>
          <xs:restriction base="xs:language"/>
        </xs:simpleType>
        <xs:attribute ref="xml:lang" use="prohibited"/>
    </xs:restriction>
   </xs:simpleContent>
  </xs:complexType>

  <xs:complexType name="RFC4646">
   <xs:simpleContent>
    <xs:restriction base="dc:SimpleLiteral">
        <xs:simpleType>
          <xs:restriction base="xs:language"/>
        </xs:simpleType>
        <xs:attribute ref="xml:lang" use="prohibited"/>
    </xs:restriction>
   </xs:simpleContent>
  </xs:complexType>

  <xs:complexType name="Point">
   <xs:simpleContent>
    <xs:restriction base="dc:SimpleLiteral">
        <xs:simpleType>
          <xs:restriction base="xs:string"/>
        </xs:simpleType>
        <xs:attribute ref="xml:lang" use="prohibited"/>
    </xs:restriction>
   </xs:simpleContent>
  </xs:complexType>

  <xs:complexType name="ISO3166">
   <xs:simpleContent>
    <xs:restriction base="dc:SimpleLiteral">
        <xs:simpleType>
          <xs:restriction base="xs:string"/>
        </xs:simpleType>
        <xs:attribute ref="xml:lang" use="prohibited"/>
    </xs:restriction>
   </xs:simpleContent>
  </xs:complexType>

  <xs:complexType name="Box">
   <xs:simpleContent>
    <xs:restriction base="dc:SimpleLiteral">
        <xs:simpleType>
          <xs:restriction base="xs:string"/>
        </xs:simpleType>
        <xs:attribute ref="xml:lang" use="prohibited"/>
    </xs:restriction>
   </xs:simpleContent>
  </xs:complexType>

  <xs:complexType name="TGN">
   <xs:simpleContent>
    <xs:restriction base="dc:SimpleLiteral">
        <xs:simpleType>
          <xs:restriction base="xs:string"/>
        </xs:simpleType>
        <xs:attribute ref="xml:lang" use="prohibited"/>
    </xs:restriction>
   </xs:simpleContent>
  </xs:complexType>

  <xs:group name="elementsAndRefinementsGroup">
  	<xs:annotation>
    	<xs:documentation xml:lang="en">
    		This group is included as a convenience for schema authors
            who need to refer to all the DC elements and element refinements 
            in the http://purl.org/dc/elements/1.1/ and 
            http://purl.org/dc/terms namespaces. 
            N.B. Refinements available via substitution groups.
    	</xs:documentation>
  	</xs:annotation>

  <xs:sequence>
    <xs:choice minOccurs="0" maxOccurs="unbounded">
	<xs:element ref="dc:any" />
    </xs:choice>
  </xs:sequence>
  </xs:group>	

  <xs:complexType name="elementOrRefinementContainer">
  	<xs:annotation>
    	<xs:documentation xml:lang="en">
    		This is included as a convenience for schema authors who need to define a root
    		or container element for all of the DC elements and element refinements.
    	</xs:documentation>
  	</xs:annotation>

    <xs:choice>
      <xs:group ref="elementsAndRefinementsGroup"/>
    </xs:choice>
  </xs:complexType>


</xs:schema>),

local:insert-schema("/lesson-frame.xsd",
<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:pce="http://pcenamespace" targetNamespace="http://pcenamespace" elementFormDefault="qualified" attributeFormDefault="unqualified">
	<xsd:import namespace="http://purl.org/dc/elements/1.1/" schemaLocation="dc.xsd"/>
	<xsd:import namespace="http://purl.org/dc/terms/" schemaLocation="dcterms.xsd"/>
	<xsd:simpleType name="non-empty-string">
		<xsd:restriction base="xsd:string">
			<xsd:minLength value="1"/>
		</xsd:restriction>
	</xsd:simpleType>
	<xsd:complexType name="LFStandardType">
		<xsd:sequence>
			<xsd:element ref="dc:identifier"/>
			<xsd:element name="std_statement_id" type="xsd:string"/>
			<xsd:element name="std_statement" type="xsd:string"/>
			<xsd:element name="std_statement_guiding_material" type="xsd:string"/>
			<xsd:element name="std_statement_notes" type="xsd:string"/>
			<xsd:element name="US_states" type="xsd:string"/>
			<xsd:element name="standard_association" type="xsd:string"/>
			<xsd:element ref="dc:relation"/>
		</xsd:sequence>
	</xsd:complexType>
	<xsd:complexType name="LFStandardsType">
		<xsd:sequence>
			<xsd:element name="standard" type="pce:LFStandardType" minOccurs="0" maxOccurs="unbounded"/>
		</xsd:sequence>
	</xsd:complexType>
	<xsd:complexType name="LFPartialStandardType">
		<xsd:sequence>
			<xsd:element ref="dc:identifier"/>
			<xsd:element name="partialstd_statement_id" type="xsd:string"/>
			<!--Kashif: added the tag to indicate the covered and not covered portions of a standard-->
			<!--<xsd:element name="PartialStandardText" type="pce:LFPartialStandardText" maxOccurs="unbounded"/>-->
			<xsd:choice maxOccurs="unbounded">
				<xsd:element name="partialstd_statement" type="xsd:string" minOccurs="0"/>
				<xsd:element name="std_statement_not_covered" type="xsd:string" minOccurs="0"/>
			</xsd:choice>
			<xsd:element name="partialstd_statement_guiding_material" type="xsd:string"/>
			<xsd:element name="US_states" type="xsd:string"/>	
			<xsd:element name="partialstd_statement_notes" type="xsd:string"/>
			<xsd:element ref="dc:relation"/>
		</xsd:sequence>
	</xsd:complexType>
	<!--
	<xsd:complexType name="LFPartialStandardText">
		<xsd:choice maxOccurs="unbounded">
			<xsd:element name="partialstd_statement" type="xsd:string" minOccurs="0"/>
			<xsd:element name="std_statement_not_covered" type="xsd:string" minOccurs="0"/>
		</xsd:choice>
	</xsd:complexType>
    -->
	<xsd:complexType name="LFPartialStandardsType">
		<xsd:sequence>
			<xsd:element name="partialStandard" type="pce:LFPartialStandardType" minOccurs="0" maxOccurs="unbounded"/>
		</xsd:sequence>
	</xsd:complexType>
	<xsd:complexType name="LFICType">
		<xsd:sequence>
			<xsd:element ref="dc:identifier"/>
			<xsd:element name="IC_source" type="xsd:string"/>
			<xsd:element name="IC_status" type="xsd:string" nillable="false"/>
			<xsd:element ref="dc:relation"/>
		</xsd:sequence>
	</xsd:complexType>
	<xsd:complexType name="LFICsType">
		<xsd:sequence>
			<xsd:element name="IC" type="pce:LFICType" minOccurs="0" maxOccurs="unbounded"/>
		</xsd:sequence>
	</xsd:complexType>
	<xsd:complexType name="LFIFType">
		<xsd:sequence>
			<xsd:element ref="dc:identifier"/>
			<xsd:element name="IF_source" type="xsd:string"/>
			<xsd:element ref="dc:relation"/>
		</xsd:sequence>
	</xsd:complexType>
	<xsd:complexType name="LFIFsType">
		<xsd:sequence>
			<xsd:element name="IF" type="pce:LFIFType" minOccurs="0" maxOccurs="unbounded"/>
		</xsd:sequence>
	</xsd:complexType>
	<xsd:complexType name="LFIntermediaryStatementType">
		<xsd:sequence>
			<xsd:element ref="dc:identifier"/>
			<xsd:element ref="dc:relation"/>
		</xsd:sequence>
	</xsd:complexType>
	<xsd:complexType name="LFIntermediaryStatementsType">
		<xsd:sequence>
			<xsd:element name="intermediaryStatement" type="pce:LFIntermediaryStatementType" minOccurs="0" maxOccurs="unbounded"/>
		</xsd:sequence>
	</xsd:complexType>
	<xsd:complexType name="LFObjectiveType">
		<xsd:sequence>
			<xsd:element name="objectiveDesc" type="xsd:string" nillable="false"/>
			<xsd:element ref="dc:relation"/>
		</xsd:sequence>
	</xsd:complexType>
	<xsd:complexType name="LFObjectivesType">
		<xsd:sequence>
			<xsd:element name="objective" type="pce:LFObjectiveType" minOccurs="0" maxOccurs="unbounded"/>
		</xsd:sequence>
	</xsd:complexType>
	<xsd:complexType name="contentType">
		<xsd:sequence>
			<xsd:element name="topic" type="xsd:string" nillable="false"/>
			<xsd:element name="topic_learning_goals" type="xsd:string" nillable="false" minOccurs="0" maxOccurs="unbounded"/>
			<xsd:element name="topic_supporting_concepts" type="xsd:string" nillable="false" minOccurs="0" maxOccurs="unbounded"/>
		</xsd:sequence>
	</xsd:complexType>
	<xsd:complexType name="synthesisType">
		<xsd:sequence>
			<xsd:element name="synthesis_topic" type="xsd:string" nillable="false" minOccurs="0" maxOccurs="unbounded"/>
			<xsd:element name="synthesis_learning_goals" type="xsd:string" nillable="false" minOccurs="0" maxOccurs="unbounded"/>
		</xsd:sequence>
	</xsd:complexType>
	<!--Kashif: made the change to accomodate the the Content and Synthesis-->
	<xsd:complexType name="LFLearningGoalsType">
		<xsd:sequence>
			<xsd:element name="learningGoalsContent" type="pce:contentType" minOccurs="0" maxOccurs="unbounded"/>
			<xsd:element name="learningGoalsSynthesis" type="pce:synthesisType" minOccurs="0" maxOccurs="unbounded"/>
			<xsd:element ref="dc:relation"/>
		</xsd:sequence>
	</xsd:complexType>
	<xsd:complexType name="desendentsType">
		<xsd:sequence>
			<xsd:element name="desendent" type="xsd:string" maxOccurs="unbounded"/>
		</xsd:sequence>
	</xsd:complexType>
	<xsd:complexType name="vocabularyTermsType">
		<xsd:sequence>
			<!--Kashif: this will store the highlighted terms-->
			<xsd:element name="highlightedVocab" type="xsd:string" maxOccurs="unbounded"/>
			<xsd:element name="otherTerms" type="xsd:string" maxOccurs="unbounded"/>
		</xsd:sequence>
	</xsd:complexType>
	<xsd:complexType name="prereqVocTermsType">
		<xsd:sequence>
			<xsd:element name="prerequisiteVocabularyTerm" type="xsd:string" maxOccurs="unbounded"/>
		</xsd:sequence>
	</xsd:complexType>
	<xsd:complexType name="prerequisiteTopicsType">
		<xsd:sequence>
			<xsd:element name="prerequisiteTopic" type="xsd:string" maxOccurs="unbounded"/>
		</xsd:sequence>
	</xsd:complexType>
	<xsd:complexType name="prereqLesnFrameType">
		<xsd:sequence>
			<xsd:element ref="dc:identifier"/>
			<xsd:element name="prereq_lesnframe_desc" type="xsd:string"/>
		</xsd:sequence>
	</xsd:complexType>
	<xsd:complexType name="prereqLesnFramesType">
		<xsd:sequence>
			<xsd:element name="prereq_lesn_frame" type="pce:prereqLesnFrameType" minOccurs="0" maxOccurs="unbounded"/>
			<xsd:element name="prereq_lesn_id" type="xsd:string" minOccurs="0" maxOccurs="unbounded"/>
		</xsd:sequence>
	</xsd:complexType>
	<xsd:complexType name="programType">
		<xsd:sequence>
			<xsd:element name="program" type="xsd:string"/>
			<xsd:element name="IC" type="pce:LFICType" minOccurs="0" maxOccurs="unbounded"/>
		</xsd:sequence>
	</xsd:complexType>
	<xsd:complexType name="subjectKeywordsType">
		<xsd:sequence>
			<xsd:element name="keyword" type="xsd:string" minOccurs="0" maxOccurs="unbounded"/>
		</xsd:sequence>
	</xsd:complexType>
	<xsd:complexType name="LessonFrameType">
		<xsd:sequence>
			<xsd:element ref="dc:title"/>
			<xsd:element ref="dc:language"/>
			<xsd:element ref="dc:creator"/>
			<xsd:element name="modifiedBy" type="xsd:string" minOccurs="0"/>
			<xsd:element name="loName" type="pce:non-empty-string"/>
			<xsd:element name="accessRights" type="xsd:string" minOccurs="0"/>
			<xsd:element name="standards" type="pce:LFStandardsType" minOccurs="0" maxOccurs="1"/>
			<xsd:element name="partialStandards" type="pce:LFPartialStandardsType" minOccurs="0" maxOccurs="1"/>
			<xsd:element name="intermediaryStatements" type="pce:LFIntermediaryStatementsType" minOccurs="0" maxOccurs="1"/>
			<xsd:element name="objectives" type="pce:LFObjectivesType" minOccurs="0" maxOccurs="1"/>
			<xsd:element name="learningGoals" type="pce:LFLearningGoalsType" minOccurs="0" maxOccurs="1"/>
			<xsd:element name="editornotes" type="xsd:string" minOccurs="0"/>
			<xsd:element name="vocabulary_terms" type="pce:vocabularyTermsType" minOccurs="0"/>
			<xsd:element name="ancestors" type="xsd:string" minOccurs="0"/>
			<xsd:element name="descendents" type="pce:desendentsType" minOccurs="0" maxOccurs="unbounded"/>
			<xsd:element name="need_review_std_change" type="xsd:boolean" minOccurs="0"/>
			<xsd:element name="ICs" type="pce:LFICsType" minOccurs="0" maxOccurs="unbounded"/>
			<xsd:element name="IFs" type="pce:LFIFsType" minOccurs="0" maxOccurs="unbounded"/>
			<xsd:element name="prereq_voc_terms" type="pce:prereqVocTermsType" minOccurs="0"/>
			<xsd:element name="prereq_topics" type="pce:prerequisiteTopicsType" minOccurs="0" maxOccurs="unbounded"/>
			<xsd:element name="subject_Keywords" type="pce:subjectKeywordsType" minOccurs="0" maxOccurs="unbounded"/>
			<xsd:element name="prereq_skills_knowledge" type="xsd:string" minOccurs="0" maxOccurs="unbounded"/>
			<xsd:element name="programs" type="xsd:string" minOccurs="0" maxOccurs="unbounded"/>
			<xsd:element name="prereq_lesn_frames" type="pce:prereqLesnFramesType" minOccurs="0"/>
			<!--<xsd:element name="synthesisNotes" type="pce:synthesisType" minOccurs="0"/>-->
			<xsd:element name="inquiry_skill" type="xsd:string" minOccurs="0" maxOccurs="unbounded"/>
			<xsd:element name="grade" type="xsd:string"/>
			<xsd:element name="discipline" type="xsd:string"/>
			<xsd:element name="restrictions" type="xsd:string" minOccurs="0"/>
			<xsd:element name="specification_status" type="xsd:string" minOccurs="0"/>
			<xsd:element name="complete_status" type="xsd:string"/>
			<xsd:element name="approval_status" type="xsd:string" minOccurs="0"/>
			<xsd:element name="objecttype" type="xsd:string"/>
			<!--Kahsif: this dc:identifier will store the unique id of the lesson frame.-->
			<xsd:element ref="dc:identifier"/>
			<xsd:element ref="dcterms:created" minOccurs="0"/>
			<xsd:element ref="dcterms:modified" minOccurs="0"/>
			<xsd:element ref="dcterms:dateAccepted" minOccurs="0"/>
			<xsd:element ref="dcterms:dateSubmitted" minOccurs="0"/>
			<!--Srini: this dcterms:modifiedStdDate will store the date LF was modified due to a standard change.-->
			<!--Kashif: modified the "modified_StdDate" because previous one was not validating-->
			<xsd:element name="modified_StdDate" type="xsd:date" minOccurs="0"/>
			<xsd:element name="version" type="xsd:string"/>
		</xsd:sequence>
	</xsd:complexType>
	<xsd:element name="LessonFrame" type="pce:LessonFrameType"/>
</xsd:schema>)