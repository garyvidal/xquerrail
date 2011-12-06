xquery version "1.0-ml";

import module namespace p="http://marklogic.com/cpf/pipelines"
    at "/MarkLogic/cpf/pipelines.xqy";

declare variable $PIPELINE-DIRECTORY as xs:string external;
declare variable $MODULES-DATABASE as xs:string external;
try {
	let $pipelines := (
		"validator-pipeline.xml"
	)
	let $inserts := (
		(: copied from Admin/database-cpf-admin-go.xqy :)
		xdmp:load("Installer/cpf/domains.css", "/cpf/domains.css"), 
		xdmp:load("Installer/cpf/pipelines.css", "/cpf/pipelines.css"), 

		p:insert(xdmp:document-get("Installer/cpf/status-pipeline.xml")),

		for $pipeline in $pipelines
		let $runme := 'declare variable $uri as xs:string external;
					   fn:doc($uri)'
		let $doc := xdmp:eval($runme,
							  (xs:QName("uri"), fn:concat($PIPELINE-DIRECTORY, $pipeline)),
							  <options xmlns="xdmp:eval">
								<database>{xdmp:database($MODULES-DATABASE)}</database>
							  </options>) 
		return p:insert($doc/*)
	)
	return
		"- Inserted pipelines"
} catch ($e) {
	"- CPF insert pipelines failed: ",
	fn:string($e//*:format-string),
	xdmp:log($e)
}