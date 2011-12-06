xquery version "1.0-ml";

import module namespace dom = "http://marklogic.com/cpf/domains" 
      at "/MarkLogic/cpf/domains.xqy";


declare variable $domain-name as xs:string external;
declare variable $domain-id as xs:unsignedLong external;
declare variable $MODULES-DATABASE as xs:string external;

try {
	let $eval-context := xdmp:eval(fn:concat('
		xquery version "1.0-ml";
		import module namespace dom = "http://marklogic.com/cpf/domains" at "/MarkLogic/cpf/domains.xqy";
		dom:evaluation-context(xdmp:database("', $MODULES-DATABASE, '"), "/")
	'))
	let $permissions := ()
	let $config := xdmp:eval('
		xquery version "1.0-ml";
		import module namespace dom = "http://marklogic.com/cpf/domains" at "/MarkLogic/cpf/domains.xqy";
		try { dom:configuration-get() } catch ($e) {}
	')
	return
		if ($config) then
			let $config := dom:configuration-set-restart-user(xdmp:get-current-user())
			let $config := dom:configuration-set-evaluation-context($eval-context)
			let $config := dom:configuration-set-default-domain($domain-id)
			let $config := dom:configuration-set-permissions($permissions)
			let $config := dom:configuration-set-conversion-enabled(fn:false())
			return "- Updated configuration"
		else
			let $config := xdmp:eval(
				'
					xquery version "1.0-ml";
					import module namespace dom = "http://marklogic.com/cpf/domains" at "/MarkLogic/cpf/domains.xqy";
					declare variable $eval-context as element() external;
					declare variable $domain-id as xs:unsignedLong external;
					declare variable $permissions as element() external;
					dom:configuration-create(xdmp:get-current-user(), $eval-context, $domain-id, $permissions/*)
				',
				(xs:QName("eval-context"), $eval-context,
				 xs:QName("domain-id"), $domain-id,
				 xs:QName("permissions"), <permissions>{$permissions}</permissions>
				)
			)
			let $option := xdmp:eval('
				xquery version "1.0-ml";
				import module namespace dom = "http://marklogic.com/cpf/domains" at "/MarkLogic/cpf/domains.xqy";
				dom:configuration-set-conversion-enabled(fn:false())
			')
			return "- Created configuration"
} catch ($e) {
	"- CPF create config failed: ",
	fn:string($e//*:format-string),
	xdmp:log($e)
}