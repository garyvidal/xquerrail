/**
 * Parser function for XQuery code.
 * structure based on the parsesparql.js
 *
 * @Author
 * Patrick Wied
 * http://www.patrick-wied.at
 *
 * @Version
 * 2010-09-25
 *
 * @Functionality
 * 	-	highlighting xquery functions, datatypes and keywords
 * 	-	highlighting xquery variables
 *  -	highlighting xml
 *  -	highlighting strings ("/') just in xquery context (not in xml) 
 *  -	highlighting xml attribute values (in literals)
 *  -	highlighting xquery code in xml attributes
 *  -	highlighting user defined functions
 *
 * * @Buglist
 *	#1 (fixed)	keywordmatching regex should match functions without a leading whitespace
 *					e.g:	avg(doc( <- matches avg but not doc OR {$b/price/text()} <- doesnt match text()
 *	#2 (fixed)	proper indentation after non-keywords
 *					-> no random indentation (done)
 *					-> take last indentation width for new line if keyword match occurs
 *	#3 (fixed)	lexicals within xml code should not be highlighted, xquery highlighting in xml just if xquery wrapped in { }
 *				-> own state function + break if { 
 *	#4 (fixed)	element names which are eq to keyword names should not be highlighted
 *	#5 (fixed)	xml attributes should be allowed
 *	#6 (fixed)	xml after xml starting tags should not be recognized as words <- only setState inWord if following char != "<"
 *	#7 (fixed)	after xml opening tag a linebreak doesn't work correct
 *	#8 (fixed)		xquery syntax in xml attributes should be highlighted
 *	#9 (fixed)	when typing xml random cursor behaviour starts.. seriously.. wtf!xmltotalcrash -.- reason: \space match temporary took out attributes
 *  #10(fixed)	after a line break xml doesnt show up correctly
 *  #11			if the xquery context gets closed the custom indentation gets lost
 *
 *
 * @Thanks to
 * -	Marklogic Community for the bounty hunting article, I enjoyed the work
 * 		http://developer.marklogic.com/
 * -	Mozilla Developer Group for providing this useful regexp summary
 * 		https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/RegExp#Special_characters_in_regular_expressions
 *
 * @ChangeLog
 * 2010-09-17 02.00PM	beta version with some regex and non proper indentation bugs 
 * 2010-09-18 00:45AM	fixed bug #1 - approach on bug #3 (xml state)
 * 2010-09-18 06:15AM	fixed bug #3: used an regex check for open xml tags -> content of xml tags are words, otherwise default highlighting
 * 2010-09-21 07:00AM	fixed bug #5: xml state approach -> if regex matches " -> set literal state (extended inLiteral: fromState for switching back to a state)
 * 						fixed bug #7: confusion, the bug does not exist anymore, I really did not do anything for fixing it o_O
 * 2010-09-24 12:00AM	fixed bug #2: passed last indentation value to the indentXQuery function (if the pattern context type matches -> take the last line indent)
 * 2010-09-24 15:00PM	fixed bug #8: included lastState variable for changing back to inAttribute state
 * 						fixed bug #9: jump over spaces in xml state
 * 2010-09-27 08:00AM	fixed bug #4: check if lastContent equals content and content eq the defined keyword (specific)
 * 						
 */
CodeMirror.defineMode("xquery",function() {
	// function for generating a regular expression by an array
	function wordRegexp(words) {
		return new RegExp("^(?:" + words.join	("|") + ")$", "i");
	}

	// generating keywords regex
	var keywords = wordRegexp(['xquery','where','version','variable','union','typeswitch','treat','to','then','text','stable','sortby','some','self','schema','satisfies','returns','return','ref','processing-instruction','preceding-sibling','preceding','precedes','parent','only','of','node','namespace','module','let','item','intersect','instance','in','import','if','function','for','follows','following-sibling','following','external','except','every','else','element','descending','descendant-or-self','descendant','define','default','declare','comment','child','cast','case','before','attribute','assert','ascending','as','ancestor-or-self','ancestor','after','or','and','eq','comment','schema-element','element','order','by','node','document-node', 'at']);
	// generating datatypes regex
	var datatypes = wordRegexp(['xs:yearMonthDuration','xs:unsignedLong','xs:time','xs:string','xs:short','xs:QName','xs:Name','xs:long','xs:integer','xs:int','xs:gYearMonth','xs:gYear','xs:gMonthDay','xs:gDay','xs:float','xs:duration','xs:double','xs:decimal','xs:dayTimeDuration','xs:dateTime','xs:date','xs:byte','xs:boolean','xs:anyURI','xf:yearMonthDuration']);
	// generating functions regex
	var functions = wordRegexp(['zero-or-one','years-from-duration','year-from-dateTime','year-from-date','upper-case','unordered','true','translate','trace','tokenize','timezone-from-time','timezone-from-dateTime','timezone-from-date','sum','subtract-dateTimes-yielding-yearMonthDuration','subtract-dateTimes-yielding-dayTimeDuration','substring-before','substring-after','substring','subsequence','string-to-codepoints','string-pad','string-length','string-join','string','static-base-uri','starts-with','seconds-from-time','seconds-from-duration','seconds-from-dateTime','round-half-to-even','round','root','reverse','resolve-uri','resolve-QName','replace','remove','QName','prefix-from-QName','position','one-or-more','number','not','normalize-unicode','normalize-space','node-name','node-kind','nilled','namespace-uri-from-QName','namespace-uri-for-prefix','namespace-uri','name','months-from-duration','month-from-dateTime','month-from-date','minutes-from-time','minutes-from-duration','minutes-from-dateTime','min','max','matches','lower-case','local-name-from-QName','local-name','last','lang','iri-to-uri','insert-before','index-of','in-scope-prefixes','implicit-timezone','idref','id','hours-from-time','hours-from-duration','hours-from-dateTime','floor','false','expanded-QName','exists','exactly-one','escape-uri','escape-html-uri','error','ends-with','encode-for-uri','empty','document-uri','doc-available','doc','distinct-values','distinct-nodes','default-collation','deep-equal','days-from-duration','day-from-dateTime','day-from-date','data','current-time','current-dateTime','current-date','count','contains','concat','compare','collection','codepoints-to-string','codepoint-equal','ceiling','boolean','base-uri','avg','adjust-time-to-timezone','adjust-dateTime-to-timezone','adjust-date-to-timezone','abs','xp:dereference','xinc:node-expand','xinc:link-references','xinc:link-expand','xhtml:restructure','xhtml:clean','xhtml:add-lists','xdmp:zip-manifest','xdmp:zip-get','xdmp:zip-create','xdmp:xquery-version','xdmp:word-convert','xdmp:with-namespaces','xdmp:version','xdmp:value','xdmp:user-roles','xdmp:user-last-login','xdmp:user','xdmp:url-encode','xdmp:url-decode','xdmp:uri-is-file','xdmp:uri-format','xdmp:uri-content-type','xdmp:unquote','xdmp:unpath','xdmp:triggers-database','xdmp:trace','xdmp:to-json','xdmp:tidy','xdmp:subbinary','xdmp:strftime','xdmp:spawn-in','xdmp:spawn','xdmp:sleep','xdmp:shutdown','xdmp:set-session-field','xdmp:set-response-encoding','xdmp:set-response-content-type','xdmp:set-response-code','xdmp:set-request-time-limit','xdmp:set','xdmp:servers','xdmp:server-status','xdmp:server-name','xdmp:server','xdmp:security-database','xdmp:security-assert','xdmp:schema-database','xdmp:save','xdmp:role-roles','xdmp:role','xdmp:rethrow','xdmp:restart','xdmp:request-timestamp','xdmp:request-status','xdmp:request-cancel','xdmp:request','xdmp:redirect-response','xdmp:random','xdmp:quote','xdmp:query-trace','xdmp:query-meters','xdmp:product-edition','xdmp:privilege-roles','xdmp:privilege','xdmp:pretty-print','xdmp:powerpoint-convert','xdmp:platform','xdmp:permission','xdmp:pdf-convert','xdmp:path','xdmp:octal-to-integer','xdmp:node-uri','xdmp:node-replace','xdmp:node-kind','xdmp:node-insert-child','xdmp:node-insert-before','xdmp:node-insert-after','xdmp:node-delete','xdmp:node-database','xdmp:mul64','xdmp:modules-root','xdmp:modules-database','xdmp:merging','xdmp:merge-cancel','xdmp:merge','xdmp:md5','xdmp:logout','xdmp:login','xdmp:log-level','xdmp:log','xdmp:lock-release','xdmp:lock-acquire','xdmp:load','xdmp:invoke-in','xdmp:invoke','xdmp:integer-to-octal','xdmp:integer-to-hex','xdmp:http-put','xdmp:http-post','xdmp:http-options','xdmp:http-head','xdmp:http-get','xdmp:http-delete','xdmp:hosts','xdmp:host-status','xdmp:host-name','xdmp:host','xdmp:hex-to-integer','xdmp:hash64','xdmp:hash32','xdmp:has-privilege','xdmp:groups','xdmp:group-serves','xdmp:group-servers','xdmp:group-name','xdmp:group-hosts','xdmp:group','xdmp:get-session-field-names','xdmp:get-session-field','xdmp:get-response-encoding','xdmp:get-response-code','xdmp:get-request-username','xdmp:get-request-user','xdmp:get-request-url','xdmp:get-request-protocol','xdmp:get-request-path','xdmp:get-request-method','xdmp:get-request-header-names','xdmp:get-request-header','xdmp:get-request-field-names','xdmp:get-request-field-filename','xdmp:get-request-field-content-type','xdmp:get-request-field','xdmp:get-request-client-certificate','xdmp:get-request-client-address','xdmp:get-request-body','xdmp:get-current-user','xdmp:get-current-roles','xdmp:get','xdmp:function-name','xdmp:function-module','xdmp:function','xdmp:from-json','xdmp:forests','xdmp:forest-status','xdmp:forest-restore','xdmp:forest-restart','xdmp:forest-name','xdmp:forest-delete','xdmp:forest-databases','xdmp:forest-counts','xdmp:forest-clear','xdmp:forest-backup','xdmp:forest','xdmp:filesystem-file','xdmp:filesystem-directory','xdmp:exists','xdmp:excel-convert','xdmp:eval-in','xdmp:eval','xdmp:estimate','xdmp:email','xdmp:element-content-type','xdmp:elapsed-time','xdmp:document-set-quality','xdmp:document-set-property','xdmp:document-set-properties','xdmp:document-set-permissions','xdmp:document-set-collections','xdmp:document-remove-properties','xdmp:document-remove-permissions','xdmp:document-remove-collections','xdmp:document-properties','xdmp:document-locks','xdmp:document-load','xdmp:document-insert','xdmp:document-get-quality','xdmp:document-get-properties','xdmp:document-get-permissions','xdmp:document-get-collections','xdmp:document-get','xdmp:document-forest','xdmp:document-delete','xdmp:document-add-properties','xdmp:document-add-permissions','xdmp:document-add-collections','xdmp:directory-properties','xdmp:directory-locks','xdmp:directory-delete','xdmp:directory-create','xdmp:directory','xdmp:diacritic-less','xdmp:describe','xdmp:default-permissions','xdmp:default-collections','xdmp:databases','xdmp:database-restore-validate','xdmp:database-restore-status','xdmp:database-restore-cancel','xdmp:database-restore','xdmp:database-name','xdmp:database-forests','xdmp:database-backup-validate','xdmp:database-backup-status','xdmp:database-backup-purge','xdmp:database-backup-cancel','xdmp:database-backup','xdmp:database','xdmp:collection-properties','xdmp:collection-locks','xdmp:collection-delete','xdmp:collation-canonical-uri','xdmp:castable-as','xdmp:can-grant-roles','xdmp:base64-encode','xdmp:base64-decode','xdmp:architecture','xdmp:apply','xdmp:amp-roles','xdmp:amp','xdmp:add64','xdmp:add-response-header','xdmp:access','trgr:trigger-set-recursive','trgr:trigger-set-permissions','trgr:trigger-set-name','trgr:trigger-set-module','trgr:trigger-set-event','trgr:trigger-set-description','trgr:trigger-remove-permissions','trgr:trigger-module','trgr:trigger-get-permissions','trgr:trigger-enable','trgr:trigger-disable','trgr:trigger-database-online-event','trgr:trigger-data-event','trgr:trigger-add-permissions','trgr:remove-trigger','trgr:property-content','trgr:pre-commit','trgr:post-commit','trgr:get-trigger-by-id','trgr:get-trigger','trgr:document-scope','trgr:document-content','trgr:directory-scope','trgr:create-trigger','trgr:collection-scope','trgr:any-property-content','thsr:set-entry','thsr:remove-term','thsr:remove-synonym','thsr:remove-entry','thsr:query-lookup','thsr:lookup','thsr:load','thsr:insert','thsr:expand','thsr:add-synonym','spell:suggest-detailed','spell:suggest','spell:remove-word','spell:make-dictionary','spell:load','spell:levenshtein-distance','spell:is-correct','spell:insert','spell:double-metaphone','spell:add-word','sec:users-collection','sec:user-set-roles','sec:user-set-password','sec:user-set-name','sec:user-set-description','sec:user-set-default-permissions','sec:user-set-default-collections','sec:user-remove-roles','sec:user-privileges','sec:user-get-roles','sec:user-get-description','sec:user-get-default-permissions','sec:user-get-default-collections','sec:user-doc-permissions','sec:user-doc-collections','sec:user-add-roles','sec:unprotect-collection','sec:uid-for-name','sec:set-realm','sec:security-version','sec:security-namespace','sec:security-installed','sec:security-collection','sec:roles-collection','sec:role-set-roles','sec:role-set-name','sec:role-set-description','sec:role-set-default-permissions','sec:role-set-default-collections','sec:role-remove-roles','sec:role-privileges','sec:role-get-roles','sec:role-get-description','sec:role-get-default-permissions','sec:role-get-default-collections','sec:role-doc-permissions','sec:role-doc-collections','sec:role-add-roles','sec:remove-user','sec:remove-role-from-users','sec:remove-role-from-role','sec:remove-role-from-privileges','sec:remove-role-from-amps','sec:remove-role','sec:remove-privilege','sec:remove-amp','sec:protect-collection','sec:privileges-collection','sec:privilege-set-roles','sec:privilege-set-name','sec:privilege-remove-roles','sec:privilege-get-roles','sec:privilege-add-roles','sec:priv-doc-permissions','sec:priv-doc-collections','sec:get-user-names','sec:get-unique-elem-id','sec:get-role-names','sec:get-role-ids','sec:get-privilege','sec:get-distinct-permissions','sec:get-collection','sec:get-amp','sec:create-user-with-role','sec:create-user','sec:create-role','sec:create-privilege','sec:create-amp','sec:collections-collection','sec:collection-set-permissions','sec:collection-remove-permissions','sec:collection-get-permissions','sec:collection-add-permissions','sec:check-admin','sec:amps-collection','sec:amp-set-roles','sec:amp-remove-roles','sec:amp-get-roles','sec:amp-doc-permissions','sec:amp-doc-collections','sec:amp-add-roles','search:unparse','search:suggest','search:snippet','search:search','search:resolve-nodes','search:resolve','search:remove-constraint','search:parse','search:get-default-options','search:estimate','search:check-options','prof:value','prof:reset','prof:report','prof:invoke','prof:eval','prof:enable','prof:disable','prof:allowed','ppt:clean','pki:template-set-request','pki:template-set-name','pki:template-set-key-type','pki:template-set-key-options','pki:template-set-description','pki:template-in-use','pki:template-get-version','pki:template-get-request','pki:template-get-name','pki:template-get-key-type','pki:template-get-key-options','pki:template-get-id','pki:template-get-description','pki:need-certificate','pki:is-temporary','pki:insert-trusted-certificates','pki:insert-template','pki:insert-signed-certificates','pki:insert-certificate-revocation-list','pki:get-trusted-certificate-ids','pki:get-template-ids','pki:get-template-certificate-authority','pki:get-template-by-name','pki:get-template','pki:get-pending-certificate-requests-xml','pki:get-pending-certificate-requests-pem','pki:get-pending-certificate-request','pki:get-certificates-for-template-xml','pki:get-certificates-for-template','pki:get-certificates','pki:get-certificate-xml','pki:get-certificate-pem','pki:get-certificate','pki:generate-temporary-certificate-if-necessary','pki:generate-temporary-certificate','pki:generate-template-certificate-authority','pki:generate-certificate-request','pki:delete-template','pki:delete-certificate','pki:create-template','pdf:make-toc','pdf:insert-toc-headers','pdf:get-toc','pdf:clean','p:status-transition','p:state-transition','p:remove','p:pipelines','p:insert','p:get-by-id','p:get','p:execute','p:create','p:condition','p:collection','p:action','ooxml:runs-merge','ooxml:package-uris','ooxml:package-parts-insert','ooxml:package-parts','msword:clean','mcgm:polygon','mcgm:point','mcgm:geospatial-query-from-elements','mcgm:geospatial-query','mcgm:circle','math:tanh','math:tan','math:sqrt','math:sinh','math:sin','math:pow','math:modf','math:log10','math:log','math:ldexp','math:frexp','math:fmod','math:floor','math:fabs','math:exp','math:cosh','math:cos','math:ceil','math:atan2','math:atan','math:asin','math:acos','map:put','map:map','map:keys','map:get','map:delete','map:count','map:clear','lnk:to','lnk:remove','lnk:insert','lnk:get','lnk:from','lnk:create','kml:polygon','kml:point','kml:interior-polygon','kml:geospatial-query-from-elements','kml:geospatial-query','kml:circle','kml:box','gml:polygon','gml:point','gml:interior-polygon','gml:geospatial-query-from-elements','gml:geospatial-query','gml:circle','gml:box','georss:point','georss:geospatial-query','georss:circle','geo:polygon','geo:point','geo:interior-polygon','geo:geospatial-query-from-elements','geo:geospatial-query','geo:circle','geo:box','fn:zero-or-one','fn:years-from-duration','fn:year-from-dateTime','fn:year-from-date','fn:upper-case','fn:unordered','fn:true','fn:translate','fn:trace','fn:tokenize','fn:timezone-from-time','fn:timezone-from-dateTime','fn:timezone-from-date','fn:sum','fn:subtract-dateTimes-yielding-yearMonthDuration','fn:subtract-dateTimes-yielding-dayTimeDuration','fn:substring-before','fn:substring-after','fn:substring','fn:subsequence','fn:string-to-codepoints','fn:string-pad','fn:string-length','fn:string-join','fn:string','fn:static-base-uri','fn:starts-with','fn:seconds-from-time','fn:seconds-from-duration','fn:seconds-from-dateTime','fn:round-half-to-even','fn:round','fn:root','fn:reverse','fn:resolve-uri','fn:resolve-QName','fn:replace','fn:remove','fn:QName','fn:prefix-from-QName','fn:position','fn:one-or-more','fn:number','fn:not','fn:normalize-unicode','fn:normalize-space','fn:node-name','fn:node-kind','fn:nilled','fn:namespace-uri-from-QName','fn:namespace-uri-for-prefix','fn:namespace-uri','fn:name','fn:months-from-duration','fn:month-from-dateTime','fn:month-from-date','fn:minutes-from-time','fn:minutes-from-duration','fn:minutes-from-dateTime','fn:min','fn:max','fn:matches','fn:lower-case','fn:local-name-from-QName','fn:local-name','fn:last','fn:lang','fn:iri-to-uri','fn:insert-before','fn:index-of','fn:in-scope-prefixes','fn:implicit-timezone','fn:idref','fn:id','fn:hours-from-time','fn:hours-from-duration','fn:hours-from-dateTime','fn:floor','fn:false','fn:expanded-QName','fn:exists','fn:exactly-one','fn:escape-uri','fn:escape-html-uri','fn:error','fn:ends-with','fn:encode-for-uri','fn:empty','fn:document-uri','fn:doc-available','fn:doc','fn:distinct-values','fn:distinct-nodes','fn:default-collation','fn:deep-equal','fn:days-from-duration','fn:day-from-dateTime','fn:day-from-date','fn:data','fn:current-time','fn:current-dateTime','fn:current-date','fn:count','fn:contains','fn:concat','fn:compare','fn:collection','fn:codepoints-to-string','fn:codepoint-equal','fn:ceiling','fn:boolean','fn:base-uri','fn:avg','fn:adjust-time-to-timezone','fn:adjust-dateTime-to-timezone','fn:adjust-date-to-timezone','fn:abs','feed:unsubscribe','feed:subscription','feed:subscribe','feed:request','feed:item','feed:description','excel:clean','entity:enrich','dom:set-pipelines','dom:set-permissions','dom:set-name','dom:set-evaluation-context','dom:set-domain-scope','dom:set-description','dom:remove-pipeline','dom:remove-permissions','dom:remove','dom:get','dom:evaluation-context','dom:domains','dom:domain-scope','dom:create','dom:configuration-set-restart-user','dom:configuration-set-permissions','dom:configuration-set-evaluation-context','dom:configuration-set-default-domain','dom:configuration-get','dom:configuration-create','dom:collection','dom:add-pipeline','dom:add-permissions','dls:retention-rules','dls:retention-rule-remove','dls:retention-rule-insert','dls:retention-rule','dls:purge','dls:node-expand','dls:link-references','dls:link-expand','dls:documents-query','dls:document-versions-query','dls:document-version-uri','dls:document-version-query','dls:document-version-delete','dls:document-version-as-of','dls:document-version','dls:document-update','dls:document-unmanage','dls:document-set-quality','dls:document-set-property','dls:document-set-properties','dls:document-set-permissions','dls:document-set-collections','dls:document-retention-rules','dls:document-remove-properties','dls:document-remove-permissions','dls:document-remove-collections','dls:document-purge','dls:document-manage','dls:document-is-managed','dls:document-insert-and-manage','dls:document-include-query','dls:document-history','dls:document-get-permissions','dls:document-extract-part','dls:document-delete','dls:document-checkout-status','dls:document-checkout','dls:document-checkin','dls:document-add-properties','dls:document-add-permissions','dls:document-add-collections','dls:break-checkout','dls:author-query','dls:as-of-query','dbk:convert','dbg:wait','dbg:value','dbg:stopped','dbg:stop','dbg:step','dbg:status','dbg:stack','dbg:out','dbg:next','dbg:line','dbg:invoke','dbg:function','dbg:finish','dbg:expr','dbg:eval','dbg:disconnect','dbg:detach','dbg:continue','dbg:connect','dbg:clear','dbg:breakpoints','dbg:break','dbg:attached','dbg:attach','cvt:save-converted-documents','cvt:part-uri','cvt:destination-uri','cvt:basepath','cvt:basename','cts:words','cts:word-query-weight','cts:word-query-text','cts:word-query-options','cts:word-query','cts:word-match','cts:walk','cts:uris','cts:uri-match','cts:train','cts:tokenize','cts:thresholds','cts:stem','cts:similar-query-weight','cts:similar-query-nodes','cts:similar-query','cts:shortest-distance','cts:search','cts:score','cts:reverse-query-weight','cts:reverse-query-nodes','cts:reverse-query','cts:remainder','cts:registered-query-weight','cts:registered-query-options','cts:registered-query-ids','cts:registered-query','cts:register','cts:query','cts:quality','cts:properties-query-query','cts:properties-query','cts:polygon-vertices','cts:polygon','cts:point-longitude','cts:point-latitude','cts:point','cts:or-query-queries','cts:or-query','cts:not-query-weight','cts:not-query-query','cts:not-query','cts:near-query-weight','cts:near-query-queries','cts:near-query-options','cts:near-query-distance','cts:near-query','cts:highlight','cts:geospatial-co-occurrences','cts:frequency','cts:fitness','cts:field-words','cts:field-word-query-weight','cts:field-word-query-text','cts:field-word-query-options','cts:field-word-query-field-name','cts:field-word-query','cts:field-word-match','cts:entity-highlight','cts:element-words','cts:element-word-query-weight','cts:element-word-query-text','cts:element-word-query-options','cts:element-word-query-element-name','cts:element-word-query','cts:element-word-match','cts:element-values','cts:element-value-ranges','cts:element-value-query-weight','cts:element-value-query-text','cts:element-value-query-options','cts:element-value-query-element-name','cts:element-value-query','cts:element-value-match','cts:element-value-geospatial-co-occurrences','cts:element-value-co-occurrences','cts:element-range-query-weight','cts:element-range-query-value','cts:element-range-query-options','cts:element-range-query-operator','cts:element-range-query-element-name','cts:element-range-query','cts:element-query-query','cts:element-query-element-name','cts:element-query','cts:element-pair-geospatial-values','cts:element-pair-geospatial-value-match','cts:element-pair-geospatial-query-weight','cts:element-pair-geospatial-query-region','cts:element-pair-geospatial-query-options','cts:element-pair-geospatial-query-longitude-name','cts:element-pair-geospatial-query-latitude-name','cts:element-pair-geospatial-query-element-name','cts:element-pair-geospatial-query','cts:element-pair-geospatial-boxes','cts:element-geospatial-values','cts:element-geospatial-value-match','cts:element-geospatial-query-weight','cts:element-geospatial-query-region','cts:element-geospatial-query-options','cts:element-geospatial-query-element-name','cts:element-geospatial-query','cts:element-geospatial-boxes','cts:element-child-geospatial-values','cts:element-child-geospatial-value-match','cts:element-child-geospatial-query-weight','cts:element-child-geospatial-query-region','cts:element-child-geospatial-query-options','cts:element-child-geospatial-query-element-name','cts:element-child-geospatial-query-child-name','cts:element-child-geospatial-query','cts:element-child-geospatial-boxes','cts:element-attribute-words','cts:element-attribute-word-query-weight','cts:element-attribute-word-query-text','cts:element-attribute-word-query-options','cts:element-attribute-word-query-element-name','cts:element-attribute-word-query-attribute-name','cts:element-attribute-word-query','cts:element-attribute-word-match','cts:element-attribute-values','cts:element-attribute-value-ranges','cts:element-attribute-value-query-weight','cts:element-attribute-value-query-text','cts:element-attribute-value-query-options','cts:element-attribute-value-query-element-name','cts:element-attribute-value-query-attribute-name','cts:element-attribute-value-query','cts:element-attribute-value-match','cts:element-attribute-value-geospatial-co-occurrences','cts:element-attribute-value-co-occurrences','cts:element-attribute-range-query-weight','cts:element-attribute-range-query-value','cts:element-attribute-range-query-options','cts:element-attribute-range-query-operator','cts:element-attribute-range-query-element-name','cts:element-attribute-range-query-attribute-name','cts:element-attribute-range-query','cts:element-attribute-pair-geospatial-values','cts:element-attribute-pair-geospatial-value-match','cts:element-attribute-pair-geospatial-query-weight','cts:element-attribute-pair-geospatial-query-region','cts:element-attribute-pair-geospatial-query-options','cts:element-attribute-pair-geospatial-query-longitude-name','cts:element-attribute-pair-geospatial-query-latitude-name','cts:element-attribute-pair-geospatial-query-element-name','cts:element-attribute-pair-geospatial-query','cts:element-attribute-pair-geospatial-boxes','cts:document-query-uris','cts:document-query','cts:distance','cts:directory-query-uris','cts:directory-query-depth','cts:directory-query','cts:destination','cts:deregister','cts:contains','cts:confidence','cts:collections','cts:collection-query-uris','cts:collection-query','cts:collection-match','cts:classify','cts:circle-radius','cts:circle-center','cts:circle','cts:box-west','cts:box-south','cts:box-north','cts:box-east','cts:box','cts:bearing','cts:arc-intersection','cts:and-query-queries','cts:and-query-options','cts:and-query','cts:and-not-query-positive-query','cts:and-not-query-negative-query','cts:and-not-query','css:get','css:convert','cpf:success','cpf:failure','cpf:document-set-state','cpf:document-set-processing-status','cpf:document-set-last-updated','cpf:document-set-error','cpf:document-get-state','cpf:document-get-processing-status','cpf:document-get-last-updated','cpf:document-get-error','cpf:check-transition','alert:spawn-matching-actions','alert:rule-user-id-query','alert:rule-set-user-id','alert:rule-set-query','alert:rule-set-options','alert:rule-set-name','alert:rule-set-description','alert:rule-set-action','alert:rule-remove','alert:rule-name-query','alert:rule-insert','alert:rule-id-query','alert:rule-get-user-id','alert:rule-get-query','alert:rule-get-options','alert:rule-get-name','alert:rule-get-id','alert:rule-get-description','alert:rule-get-action','alert:rule-action-query','alert:remove-triggers','alert:make-rule','alert:make-log-action','alert:make-config','alert:make-action','alert:invoke-matching-actions','alert:get-my-rules','alert:get-all-rules','alert:get-actions','alert:find-matching-rules','alert:create-triggers','alert:config-set-uri','alert:config-set-trigger-ids','alert:config-set-options','alert:config-set-name','alert:config-set-description','alert:config-set-cpf-domain-names','alert:config-set-cpf-domain-ids','alert:config-insert','alert:config-get-uri','alert:config-get-trigger-ids','alert:config-get-options','alert:config-get-name','alert:config-get-id','alert:config-get-description','alert:config-get-cpf-domain-names','alert:config-get-cpf-domain-ids','alert:config-get','alert:config-delete','alert:action-set-options','alert:action-set-name','alert:action-set-module-root','alert:action-set-module-db','alert:action-set-module','alert:action-set-description','alert:action-remove','alert:action-insert','alert:action-get-options','alert:action-get-name','alert:action-get-module-root','alert:action-get-module-db','alert:action-get-module','alert:action-get-description','admin:xdbc-server-create','admin:webdav-server-create','admin:taskserver-set-threads','admin:taskserver-set-queue-size','admin:taskserver-set-profile-allow','admin:taskserver-set-pre-commit-trigger-limit','admin:taskserver-set-pre-commit-trigger-depth','admin:taskserver-set-post-commit-trigger-depth','admin:taskserver-set-max-time-limit','admin:taskserver-set-log-errors','admin:taskserver-set-default-time-limit','admin:taskserver-set-debug-threads','admin:taskserver-set-debug-allow','admin:taskserver-get-threads','admin:taskserver-get-queue-size','admin:taskserver-get-profile-allow','admin:taskserver-get-pre-commit-trigger-limit','admin:taskserver-get-pre-commit-trigger-depth','admin:taskserver-get-post-commit-trigger-depth','admin:taskserver-get-name','admin:taskserver-get-max-time-limit','admin:taskserver-get-log-errors','admin:taskserver-get-default-time-limit','admin:taskserver-get-debug-threads','admin:taskserver-get-debug-allow','admin:save-configuration-without-restart','admin:save-configuration','admin:restart-hosts','admin:mimetypes-get','admin:mimetypes-delete','admin:mimetypes-add','admin:mimetype','admin:http-server-create','admin:host-set-port','admin:host-set-name','admin:host-set-group','admin:host-get-port','admin:host-get-name','admin:host-get-id','admin:host-get-group','admin:group-weekly-scheduled-task','admin:group-trace-event','admin:group-set-xdqp-timeout','admin:group-set-xdqp-ssl-enabled','admin:group-set-xdqp-ssl-ciphers','admin:group-set-xdqp-ssl-allow-tls','admin:group-set-xdqp-ssl-allow-sslv3','admin:group-set-trace-events-activated','admin:group-set-system-log-level','admin:group-set-smtp-timeout','admin:group-set-smtp-relay','admin:group-set-rotate-log-files','admin:group-set-rotate-audit-files','admin:group-set-retry-timeout','admin:group-set-name','admin:group-set-list-cache-size','admin:group-set-list-cache-partitions','admin:group-set-keep-log-files','admin:group-set-keep-audit-files','admin:group-set-http-user-agent','admin:group-set-http-timeout','admin:group-set-host-timeout','admin:group-set-host-initial-timeout','admin:group-set-file-log-level','admin:group-set-failover-enable','admin:group-set-expanded-tree-cache-size','admin:group-set-expanded-tree-cache-partitions','admin:group-set-compressed-tree-read-size','admin:group-set-compressed-tree-cache-size','admin:group-set-compressed-tree-cache-partitions','admin:group-set-audit-user-restriction','admin:group-set-audit-uri-restriction','admin:group-set-audit-role-restriction','admin:group-set-audit-outcome-restriction','admin:group-set-audit-enabled','admin:group-schema','admin:group-one-time-scheduled-task','admin:group-namespace','admin:group-monthly-scheduled-task','admin:group-minutely-scheduled-task','admin:group-hourly-scheduled-task','admin:group-get-xdqp-timeout','admin:group-get-xdqp-ssl-enabled','admin:group-get-xdqp-ssl-ciphers','admin:group-get-xdqp-ssl-allow-tls','admin:group-get-xdqp-ssl-allow-sslv3','admin:group-get-xdbcserver-ids','admin:group-get-webdavserver-ids','admin:group-get-trace-events-activated','admin:group-get-trace-events','admin:group-get-taskserver-id','admin:group-get-system-log-level','admin:group-get-smtp-timeout','admin:group-get-smtp-relay','admin:group-get-schemas','admin:group-get-scheduled-tasks','admin:group-get-rotate-log-files','admin:group-get-rotate-audit-files','admin:group-get-retry-timeout','admin:group-get-namespaces','admin:group-get-name','admin:group-get-list-cache-size','admin:group-get-list-cache-partitions','admin:group-get-keep-log-files','admin:group-get-keep-audit-files','admin:group-get-id','admin:group-get-httpserver-ids','admin:group-get-http-user-agent','admin:group-get-http-timeout','admin:group-get-host-timeout','admin:group-get-host-initial-timeout','admin:group-get-host-ids','admin:group-get-file-log-level','admin:group-get-failover-enable','admin:group-get-expanded-tree-cache-size','admin:group-get-expanded-tree-cache-partitions','admin:group-get-compressed-tree-read-size','admin:group-get-compressed-tree-cache-size','admin:group-get-compressed-tree-cache-partitions','admin:group-get-audit-outcome-restriction','admin:group-get-audit-included-users','admin:group-get-audit-included-uris','admin:group-get-audit-included-roles','admin:group-get-audit-excluded-users','admin:group-get-audit-excluded-uris','admin:group-get-audit-excluded-roles','admin:group-get-audit-event-type-enabled','admin:group-get-audit-enabled','admin:group-get-appserver-ids','admin:group-enable-audit-event-type','admin:group-disable-audit-event-type','admin:group-delete-trace-event','admin:group-delete-schema','admin:group-delete-scheduled-task','admin:group-delete-namespace','admin:group-delete','admin:group-daily-scheduled-task','admin:group-create','admin:group-copy','admin:group-add-trace-event','admin:group-add-schema','admin:group-add-scheduled-task','admin:group-add-namespace','admin:get-host-ids','admin:get-group-ids','admin:get-forest-ids','admin:get-database-ids','admin:get-configuration','admin:get-appserver-ids','admin:forest-weekly-backup','admin:forest-set-updates-allowed','admin:forest-set-host','admin:forest-set-failover-enable','admin:forest-set-enabled','admin:forest-one-time-backup','admin:forest-monthly-backup','admin:forest-minutely-backup','admin:forest-hourly-backup','admin:forest-get-updates-allowed','admin:forest-get-name','admin:forest-get-id','admin:forest-get-host','admin:forest-get-failover-hosts','admin:forest-get-failover-enable','admin:forest-get-enabled','admin:forest-get-data-directory','admin:forest-get-backups','admin:forest-delete-failover-host','admin:forest-delete-backup','admin:forest-delete','admin:forest-daily-backup','admin:forest-create','admin:forest-copy','admin:forest-add-failover-host','admin:forest-add-backup','admin:database-word-lexicon','admin:database-weekly-backup','admin:database-set-word-searches','admin:database-set-word-query-word-searches','admin:database-set-word-query-two-character-searches','admin:database-set-word-query-trailing-wildcard-word-positions','admin:database-set-word-query-trailing-wildcard-searches','admin:database-set-word-query-three-character-word-positions','admin:database-set-word-query-three-character-searches','admin:database-set-word-query-stemmed-searches','admin:database-set-word-query-one-character-searches','admin:database-set-word-query-include-document-root','admin:database-set-word-query-fast-phrase-searches','admin:database-set-word-query-fast-diacritic-sensitive-searches','admin:database-set-word-query-fast-case-sensitive-searches','admin:database-set-word-positions','admin:database-set-uri-lexicon','admin:database-set-two-character-searches','admin:database-set-triggers-database','admin:database-set-trailing-wildcard-word-positions','admin:database-set-trailing-wildcard-searches','admin:database-set-three-character-word-positions','admin:database-set-three-character-searches','admin:database-set-tf-normalization','admin:database-set-stemmed-searches','admin:database-set-security-database','admin:database-set-schema-database','admin:database-set-reindexer-timestamp','admin:database-set-reindexer-throttle','admin:database-set-reindexer-enable','admin:database-set-preload-mapped-data','admin:database-set-preallocate-journals','admin:database-set-positions-list-max-size','admin:database-set-one-character-searches','admin:database-set-name','admin:database-set-merge-timestamp','admin:database-set-merge-priority','admin:database-set-merge-min-size','admin:database-set-merge-min-ratio','admin:database-set-merge-max-size','admin:database-set-merge-enable','admin:database-set-maintain-last-modified','admin:database-set-maintain-directory-last-modified','admin:database-set-language','admin:database-set-journal-size','admin:database-set-inherit-quality','admin:database-set-inherit-permissions','admin:database-set-inherit-collections','admin:database-set-index-detection','admin:database-set-in-memory-tree-size','admin:database-set-in-memory-reverse-index-size','admin:database-set-in-memory-range-index-size','admin:database-set-in-memory-list-size','admin:database-set-in-memory-limit','admin:database-set-format-compatibility','admin:database-set-field-word-searches','admin:database-set-field-two-character-searches','admin:database-set-field-trailing-wildcard-word-positions','admin:database-set-field-trailing-wildcard-searches','admin:database-set-field-three-character-word-positions','admin:database-set-field-three-character-searches','admin:database-set-field-stemmed-searches','admin:database-set-field-one-character-searches','admin:database-set-field-name','admin:database-set-field-include-document-root','admin:database-set-field-fast-phrase-searches','admin:database-set-field-fast-diacritic-sensitive-searches','admin:database-set-field-fast-case-sensitive-searches','admin:database-set-fast-reverse-searches','admin:database-set-fast-phrase-searches','admin:database-set-fast-element-word-searches','admin:database-set-fast-element-trailing-wildcard-searches','admin:database-set-fast-element-phrase-searches','admin:database-set-fast-element-character-searches','admin:database-set-fast-diacritic-sensitive-searches','admin:database-set-fast-case-sensitive-searches','admin:database-set-expunge-locks','admin:database-set-enabled','admin:database-set-element-word-positions','admin:database-set-element-value-positions','admin:database-set-directory-creation','admin:database-set-collection-lexicon','admin:database-set-attribute-value-positions','admin:database-recurring-merge-blackout','admin:database-range-element-index','admin:database-range-element-attribute-index','admin:database-phrase-through','admin:database-phrase-around','admin:database-one-time-merge-blackout','admin:database-one-time-backup','admin:database-monthly-backup','admin:database-minutely-backup','admin:database-included-element','admin:database-hourly-backup','admin:database-get-word-searches','admin:database-get-word-query-word-searches','admin:database-get-word-query-two-character-searches','admin:database-get-word-query-trailing-wildcard-word-positions','admin:database-get-word-query-trailing-wildcard-searches','admin:database-get-word-query-three-character-word-positions','admin:database-get-word-query-three-character-searches','admin:database-get-word-query-stemmed-searches','admin:database-get-word-query-one-character-searches','admin:database-get-word-query-included-elements','admin:database-get-word-query-include-document-root','admin:database-get-word-query-fast-phrase-searches','admin:database-get-word-query-fast-diacritic-sensitive-searches','admin:database-get-word-query-fast-case-sensitive-searches','admin:database-get-word-query-excluded-elements','admin:database-get-word-positions','admin:database-get-word-lexicons','admin:database-get-uri-lexicon','admin:database-get-two-character-searches','admin:database-get-triggers-database','admin:database-get-trailing-wildcard-word-positions','admin:database-get-trailing-wildcard-searches','admin:database-get-three-character-word-positions','admin:database-get-three-character-searches','admin:database-get-tf-normalization','admin:database-get-stemmed-searches','admin:database-get-security-database','admin:database-get-schema-database','admin:database-get-reindexer-timestamp','admin:database-get-reindexer-throttle','admin:database-get-reindexer-enable','admin:database-get-range-element-indexes','admin:database-get-range-element-attribute-indexes','admin:database-get-preload-mapped-data','admin:database-get-preallocate-journals','admin:database-get-positions-list-max-size','admin:database-get-phrase-throughs','admin:database-get-phrase-arounds','admin:database-get-one-character-searches','admin:database-get-name','admin:database-get-merge-timestamp','admin:database-get-merge-priority','admin:database-get-merge-min-size','admin:database-get-merge-min-ratio','admin:database-get-merge-max-size','admin:database-get-merge-enable','admin:database-get-merge-blackouts','admin:database-get-maintain-last-modified','admin:database-get-maintain-directory-last-modified','admin:database-get-language','admin:database-get-journal-size','admin:database-get-inherit-quality','admin:database-get-inherit-permissions','admin:database-get-inherit-collections','admin:database-get-index-detection','admin:database-get-in-memory-tree-size','admin:database-get-in-memory-reverse-index-size','admin:database-get-in-memory-range-index-size','admin:database-get-in-memory-list-size','admin:database-get-in-memory-limit','admin:database-get-id','admin:database-get-geospatial-element-pair-indexes','admin:database-get-geospatial-element-indexes','admin:database-get-geospatial-element-child-indexes','admin:database-get-geospatial-element-attribute-pair-indexes','admin:database-get-fragment-roots','admin:database-get-fragment-parents','admin:database-get-format-compatibility','admin:database-get-fields','admin:database-get-field-word-searches','admin:database-get-field-word-lexicons','admin:database-get-field-two-character-searches','admin:database-get-field-trailing-wildcard-word-positions','admin:database-get-field-trailing-wildcard-searches','admin:database-get-field-three-character-word-positions','admin:database-get-field-three-character-searches','admin:database-get-field-stemmed-searches','admin:database-get-field-one-character-searches','admin:database-get-field-included-elements','admin:database-get-field-include-document-root','admin:database-get-field-fast-phrase-searches','admin:database-get-field-fast-diacritic-sensitive-searches','admin:database-get-field-fast-case-sensitive-searches','admin:database-get-field-excluded-elements','admin:database-get-field','admin:database-get-fast-reverse-searches','admin:database-get-fast-phrase-searches','admin:database-get-fast-element-word-searches','admin:database-get-fast-element-trailing-wildcard-searches','admin:database-get-fast-element-phrase-searches','admin:database-get-fast-element-character-searches','admin:database-get-fast-diacritic-sensitive-searches','admin:database-get-fast-case-sensitive-searches','admin:database-get-expunge-locks','admin:database-get-enabled','admin:database-get-element-word-query-throughs','admin:database-get-element-word-positions','admin:database-get-element-word-lexicons','admin:database-get-element-value-positions','admin:database-get-element-attribute-word-lexicons','admin:database-get-directory-creation','admin:database-get-collection-lexicon','admin:database-get-backups','admin:database-get-attribute-value-positions','admin:database-get-attached-forests','admin:database-geospatial-element-pair-index','admin:database-geospatial-element-index','admin:database-geospatial-element-child-index','admin:database-geospatial-element-attribute-pair-index','admin:database-fragment-root','admin:database-fragment-parent','admin:database-field','admin:database-excluded-element','admin:database-element-word-query-through','admin:database-element-word-lexicon','admin:database-element-attribute-word-lexicon','admin:database-detach-forest','admin:database-delete-word-query-included-element','admin:database-delete-word-query-excluded-element','admin:database-delete-word-lexicon','admin:database-delete-range-element-index','admin:database-delete-range-element-attribute-index','admin:database-delete-phrase-through','admin:database-delete-phrase-around','admin:database-delete-merge-blackout','admin:database-delete-geospatial-element-pair-index','admin:database-delete-geospatial-element-index','admin:database-delete-geospatial-element-child-index','admin:database-delete-geospatial-element-attribute-pair-index','admin:database-delete-fragment-root','admin:database-delete-fragment-parent','admin:database-delete-field-word-lexicon','admin:database-delete-field-included-element','admin:database-delete-field-excluded-element','admin:database-delete-field','admin:database-delete-element-word-query-through','admin:database-delete-element-word-lexicon','admin:database-delete-element-attribute-word-lexicon','admin:database-delete-backup','admin:database-delete','admin:database-daily-backup','admin:database-create','admin:database-copy','admin:database-attach-forest','admin:database-add-word-query-included-element','admin:database-add-word-query-excluded-element','admin:database-add-word-lexicon','admin:database-add-range-element-index','admin:database-add-range-element-attribute-index','admin:database-add-phrase-through','admin:database-add-phrase-around','admin:database-add-merge-blackout','admin:database-add-geospatial-element-pair-index','admin:database-add-geospatial-element-index','admin:database-add-geospatial-element-child-index','admin:database-add-geospatial-element-attribute-pair-index','admin:database-add-fragment-root','admin:database-add-fragment-parent','admin:database-add-field-word-lexicon','admin:database-add-field-included-element','admin:database-add-field-excluded-element','admin:database-add-field','admin:database-add-element-word-query-through','admin:database-add-element-word-lexicon','admin:database-add-element-attribute-word-lexicon','admin:database-add-backup','admin:appserver-set-url-rewriter','admin:appserver-set-threads','admin:appserver-set-static-expires','admin:appserver-set-ssl-hostname','admin:appserver-set-ssl-client-certificate-authorities','admin:appserver-set-ssl-ciphers','admin:appserver-set-ssl-certificate-template','admin:appserver-set-ssl-allow-tls','admin:appserver-set-ssl-allow-sslv3','admin:appserver-set-session-timeout','admin:appserver-set-root','admin:appserver-set-request-timeout','admin:appserver-set-profile-allow','admin:appserver-set-privilege','admin:appserver-set-pre-commit-trigger-limit','admin:appserver-set-pre-commit-trigger-depth','admin:appserver-set-port','admin:appserver-set-output-sgml-character-entities','admin:appserver-set-output-encoding','admin:appserver-set-name','admin:appserver-set-modules-database','admin:appserver-set-max-time-limit','admin:appserver-set-log-errors','admin:appserver-set-last-login','admin:appserver-set-keep-alive-timeout','admin:appserver-set-error-handler','admin:appserver-set-enabled','admin:appserver-set-display-last-login','admin:appserver-set-default-xquery-version','admin:appserver-set-default-user','admin:appserver-set-default-time-limit','admin:appserver-set-debug-allow','admin:appserver-set-database','admin:appserver-set-concurrent-request-limit','admin:appserver-set-compute-content-length','admin:appserver-set-collation','admin:appserver-set-backlog','admin:appserver-set-authentication','admin:appserver-set-address','admin:appserver-recurring-request-blackout','admin:appserver-one-time-request-blackout','admin:appserver-get-url-rewriter','admin:appserver-get-type','admin:appserver-get-threads','admin:appserver-get-static-expires','admin:appserver-get-ssl-hostname','admin:appserver-get-ssl-client-certificate-authorities','admin:appserver-get-ssl-ciphers','admin:appserver-get-ssl-certificate-template','admin:appserver-get-ssl-allow-tls','admin:appserver-get-ssl-allow-sslv3','admin:appserver-get-session-timeout','admin:appserver-get-schemas','admin:appserver-get-root','admin:appserver-get-request-timeout','admin:appserver-get-request-blackouts','admin:appserver-get-profile-allow','admin:appserver-get-privilege','admin:appserver-get-pre-commit-trigger-limit','admin:appserver-get-pre-commit-trigger-depth','admin:appserver-get-port','admin:appserver-get-output-sgml-character-entities','admin:appserver-get-output-encoding','admin:appserver-get-namespaces','admin:appserver-get-name','admin:appserver-get-modules-database','admin:appserver-get-max-time-limit','admin:appserver-get-log-errors','admin:appserver-get-last-login','admin:appserver-get-keep-alive-timeout','admin:appserver-get-id','admin:appserver-get-host-ids','admin:appserver-get-group-id','admin:appserver-get-error-handler','admin:appserver-get-enabled','admin:appserver-get-display-last-login','admin:appserver-get-default-xquery-version','admin:appserver-get-default-user','admin:appserver-get-default-time-limit','admin:appserver-get-debug-allow','admin:appserver-get-database','admin:appserver-get-concurrent-request-limit','admin:appserver-get-compute-content-length','admin:appserver-get-collation','admin:appserver-get-backlog','admin:appserver-get-authentication','admin:appserver-get-address','admin:appserver-delete-schema','admin:appserver-delete-request-blackout','admin:appserver-delete-namespace','admin:appserver-delete','admin:appserver-copy','admin:appserver-add-schema','admin:appserver-add-request-blackout','admin:appserver-add-namespace']);

	var separators = /[;\/,\(]/;
	// user defined functions
	var declaredFunctions = [];
	var decFus;
	/**
	 * xquery tokenizing function
	 * 
	 * @return
	 * 	returns a tokenizer function call which returns the tokens
	 */
	var tokenizeXQuery = (function(){
		// lastState stores a state function call for returning to a last state from inLiteral
		var lastState;
		
		/**
		 * normal state function contains the basic keyword identifying structure. 
		 * if all conditions fail the token type gets identified as xq-word
		 * 
		 * @return
		 * 	returns a detected token type or sets special states
		 */
		function normal(source, setState) {
			// get the character
			var ch = source.next();
			// if the current character is a $
			if (ch == "$") {
				// call next as long as the regex matches (alphanumeric chars, digit chars, minus and underscore matches)
				source.nextWhileMatches(/[\w\d-_]/);
				// -> the type of the matches is a variable
				return "xq-var";
			}
			else if (ch == "<" && !source.matches(/[\s\u00a0=]/)) {
				setState(inXml);
				return null;
			}
			else if (ch == "\"" || ch == "'") { // if the character initiates a string
				// set the inLiteral state function, the starting character eq the ending character
				setState(inLiteral(ch, normal, false));
				return null;
			}
			else if (ch == "(" && source.equals(":")) {	// if the character initiates a comment
				// set the inComment state function 
				setState(inComment); 
				return null;
			}
			// match @attributes
			else if (ch == "@"){
				// call next as long as the regex matches (alphanumeric chars, digit chars, minus and underscore matches)
				source.nextWhileMatches(/[\w\d-_]/);
				// -> the type of the matches is an attribute
				return "xq-attr";
			}
			else if( separators.test(ch)){
				// important because tokens should not contain separators
				return "xq-word";	
			}else if(lastState && ch == "}"){
				// if the lastState variable is set -> inLiteral stored a state function -> set the stored state function
				setState(lastState);
				lastState=null;
				return "xq-word";
			}// if its not a variable, xml code, string or comment, start the keyword regex matching
			else {
				// match the current word (including minus and : because the function names or datatypes will need them)
				source.nextWhileMatches(/[_\w\d:-]/);
				// load the word
				var word = source.get(), type;
	
				// match the big regex we defined at the top, if the test function returns true, set the specific type
				if(keywords.test(word)){
					type = "xq-keyword";
				}else if (datatypes.test(word)){
					type = "xq-datatype";
				}else if(decFus && decFus.test(word)){
					type = "xq-function";
				}else if (functions.test(word)){
					type = "xq-function";
				}else{
					// if there was no match, type is xq-word
					type = "xq-word";
				}
				return {style: type, content: word};
			}
		}
		
		/**
		 * in comment state function. comments are getting detected in the normal function
		 * if the inComment state function is passed to setState the following text will be identified as xq-comment
		 * ":)" closes the comment and changes the state back to normal
		 */
		function inComment(source, setState) {
			// maybeEnd contains the status of the second last comment character
			// maybeEnd has to be true to break the comment state and get back to the normal state
			var maybeEnd = false;
			while (!source.endOfLine()) {
				var ch = source.next();
				if (maybeEnd && ch == ")") {
					setState(normal);
					break;
				}
				maybeEnd = (ch == ":");
			}
			return "xq-comment";
		}

		/**
		 * in literal state function. set from normal or xml state
		 * 
		 * 
		 * @param quote
		 * @param fromState
		 * @param ini
		 */
		function inLiteral(quote, fromState, ini) {
			return function(source, setState) {
				// escaped activates if the char is a backslash
				var escaped = false, 
				// we dont want to switch the state before the text ends
				start = true;
				while (!source.endOfLine()) {
					var ch = source.next();
					if( ini && source.equals("{")){
						lastState=inLiteral(quote, fromState, false);
						setState(normal);
						break;
					}else if (ch == quote && !escaped && (!start||!ini)) {
						setState(fromState);
						break;
					}
					escaped = !escaped && ch == "\\";
					// we are over the starting char
					start = false;
				}
				return "xq-literal";
			  };
		}

		/**
		 * in xml state function
		 * 
		 * 
		 * @param source	default params
		 * @param setState	default params
		 */
		function inXml(source, setState){
			source.nextWhileMatches(/[^\s\u00a0"'>]/);
			var str = source.get();
			// if the char equals ">"
			if(source.equals("\"") || source.equals("'")){
				setState(inLiteral((source.equals("'")?"'":"\""), inXml, true));
			}else if (source.equals(">")){ 
				source.next();
				// if it was a xml opening tag and the next character is not a "<" -> the content is a word -> inWord state
				// -> inWord state switches to normal state if { is typed
				// if it was a xml closing tag -> normal state should be used 
				// if not \n -> because after a line break text should be normal highlighted  && !source.equals("\n")
				if(!(/<\/.*/.test(str)) && !source.equals("<")){
					setState(inWord);
				}else{
					setState(normal);
				}
				// bug fix #9 - no random xml syntax behaviour anymore
			}else if(source.equals(" ")){
				source.next();
			}
			//return "xq-xml"; 
			return {style: "xq-xml", content: str};
		}
		/**
		 * inWord state function. -> just normal text but is able to switch state to normal or xml 
		 */
		function inWord(source, setState){

			while(!source.endOfLine()){
				var ch = source.next();
				// if the ch is a "{" or source initiated xml syntax -> set the normal state
				// for detecting xquery keywords,literals or xml
				if(ch == "{" || source.equals("<")){
					setState(normal);
					break;
				// if xml syntax is detected (following a linebreak)
				// @bugfix #10
				}else if(ch == "<"){
					// we set the state to xml
					setState(inXml);
					// and return the xq-xml type because we want the "<" colored in xml color
					return "xq-xml";
				}
			}
			return "xq-word";
		}
		
		return function(source, startState) {
			return tokenizer(source, startState || normal);
		};
	})();
	
	/**
	 * function indenting xquery code
	 */
	function indentXQuery(context, indent){
	    return function(nextChars) {
			var firstChar = nextChars && nextChars.charAt(0);
			
			// switch to the last context with type pattern
			if (/[\}]/.test(firstChar))
				while (context && context.type == "pattern") context = context.prev;
			
			// if the first character matches the } -> closing is active
			var closing = context && firstChar == matching[context.type];
			
			if (!context){
				return 0;
			}else if (context.type == "pattern"){
				// just take the last line indentation if the context.type matches "pattern"
				return indent;
			}else if (context.align){
				return context.col - (closing ? context.width : 0);
			}else{
				return context.indent + (closing ? 0 : indentUnit);	
			}
			
		}
	}
	/**
	 * function for parsing xquery code
	 */
	function parseXQuery(source){
		// get the tokens from source by tokenize function
		var tokens = tokenizeXQuery(source);
		
		var context = null, indent = 0, col = 0;
		function pushContext(type, width) {
		  context = {prev: context, indent: indent, col: col, type: type, width: width};
		}
		function popContext() {
		  context = context.prev;
		}
		var lv = 0,lastContent;
		// the MochiKit iterator object
		var iter = {
		  next: function() {
			var token = tokens.next(), type = token.style, content = token.content, width = token.value.length;
			// on linebreak
			if (content == "\n") {
				// call the indentXQuery function -> passing indent for last line indentation
			  token.indentation = indentXQuery(context, indent);
			  // call by value -> we can reset the indentation
			  indent = col = 0;
			  if (context && context.align == null) context.align = false;
			}
			else if (type == "whitespace" && col == 0) {
			  indent = width;
			}
			else if (type != "xq-comment" && context && context.align == null) {
			  context.align = true;
			}
			if (content != "\n") col += width; 
			
			// this fixes the keyword highlighting currently specified on element element and attribute attribute
			// are there more such cases?
			if(content == lastContent && (content == "element" || content == "attribute")){
				token.style = "xq-word";
			}else if(type != "whitespace"){
				lastContent = content;
			}
			// dynamically extend user defined functions
			if(lv==2){
				token.style = "xq-function";
				declaredFunctions.push(content);
				decFus = wordRegexp(declaredFunctions);
				lv = 0;
			}else{
				if(content == "declare" || content == "function"){
					lv++;
				}else if(type != "whitespace"){
					lv = 0;
				}
			}
			
			// check for content indentation case and execute pop or pushContext
			if (/[\{]/.test(content)) {
			  pushContext(content, width);
			}
			else if (/[\}]/.test(content)) {
				// switch to the previous context as long as the current context type is pattern
				while (context && context.type == "pattern")
					popContext();
				  if (context && content == matching[context.type])
					popContext();
			}
			else if ((type == "xq-keyword") && context && /[\{]/.test(context.type)) {
				pushContext("pattern", width);
			}

			return token;
		  },

		  copy: function() {
			var _context = context, _indent = indent, _col = col, _tokenState = tokens.state;
			return function(source) {
			  tokens = tokenizeXQuery(source, _tokenState);
			  context = _context;
			  indent = _indent;
			  col = _col;
			  return iter;
			};
		  }
		};
		return iter;
	}
	return {make: parseXQuery, electricChars: "}"};
});
CodeMirror.defineMIME("application/xquery", "xquery");