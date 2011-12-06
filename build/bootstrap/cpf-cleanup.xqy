xquery version "1.0-ml";

import module namespace dom = "http://marklogic.com/cpf/domains" 
    at "/MarkLogic/cpf/domains.xqy";
import module namespace p="http://marklogic.com/cpf/pipelines"
    at "/MarkLogic/cpf/pipelines.xqy";

try {
	let $config := try { dom:configuration-get() } catch ($e) {}
	return
		if ($config) then (
			for $x as xs:string in dom:domains( )/dom:domain-name
			return
			  dom:remove($x),
			  
			for $x as xs:string in p:pipelines( )/p:pipeline-name
			return
			  p:remove($x),
			  
			"- Removed existing domains and pipelines"
		) else (
			"- CPF not yet installed"
		)
} catch ($e) {
	"- CPF cleanup failed: ",
	fn:string($e//*:format-string),
	xdmp:log($e)
}