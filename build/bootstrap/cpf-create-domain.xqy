xquery version "1.0-ml";

import module namespace dom = "http://marklogic.com/cpf/domains" 
    at "/MarkLogic/cpf/domains.xqy";
import module namespace p="http://marklogic.com/cpf/pipelines"
    at "/MarkLogic/cpf/pipelines.xqy";

declare variable $domain-name as xs:string external;
declare variable $pipeline-names as xs:string external;
declare variable $scope as xs:string external;

declare variable $MODULES-DATABASE as xs:string external;

try {
	let $pipeline-names := (fn:tokenize($pipeline-names, ","), "Status Change Handling")
	
	let $pipeline-ids := fn:data(p:get($pipeline-names)/p:pipeline-id)

	let $scope := dom:domain-scope("directory", $scope, "infinity")
	let $eval-context := dom:evaluation-context(xdmp:database($MODULES-DATABASE), "/")
	let $domain := try { fn:data(dom:get($domain-name)/dom:domain-id) } catch ($e) { () }
	return
		if ($domain) then
			let $pipes := dom:set-pipelines($domain-name, $pipeline-ids)
			let $scope := dom:set-domain-scope($domain-name, $scope)
			let $context := dom:set-evaluation-context($domain-name, $eval-context)
			return
				("- Updated domain", $domain)
		else
			let $create := dom:create($domain-name, "", $scope, $eval-context, $pipeline-ids, ())
			return
				("- Created domain", $create)
} catch ($e) {
	"- CPF create domain failed: ",
	fn:string($e//*:format-string),
	xdmp:log($e)
}
