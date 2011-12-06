xquery version "1.0-ml";

declare default function namespace "http://www.w3.org/2005/xpath-functions";

declare namespace xdmp="http://marklogic.com/xdmp";
declare namespace prop = "http://marklogic.com/xdmp/property";
declare namespace pce="http://pcenamespace";

declare option xdmp:mapping "false";

declare variable $ALLOW-UPDATING as xs:boolean := false();

declare variable $doc-uri as xs:string? := xdmp:get-request-field("doc-uri");
declare variable $dir-uri as xs:string := xdmp:get-request-field("dir-uri", if ($doc-uri) then local:get-parentdir($doc-uri) else "/");
declare variable $action as xs:string? := lower-case(xdmp:get-request-field("action"));
declare variable $message as item()* := xdmp:value(xdmp:get-request-field("message", '()'));
declare variable $elapsed-time as item()* := xdmp:get-request-field("elapsed-time");

declare function local:quoteSequence($args as item()*) as xs:string {
    concat(
        "(",
        string-join(
            for $arg in $args
            return
                if ($arg instance of xs:string) then
                    concat("'", $arg, "'")
                else
                    xdmp:quote($arg),
            
            ", "
        ),
        ")"
    )
};

declare function local:get-copy-filename($doc-uri as xs:string, $copy-count as xs:integer) as xs:string {
    let $doc-name := local:get-name($doc-uri)
    let $doc-dir := local:get-parentdir($doc-uri)
    let $copy-uri := concat($doc-dir, "Copy", if ($copy-count = 1) then "" else concat(" (", $copy-count, ")")," of ", $doc-name)
    return
        if (doc-available($copy-uri)) then
            local:get-copy-filename($doc-uri, $copy-count + 1)
        else
            $copy-uri
};

declare function local:do-action($dir-uri as xs:string?, $doc-uri as xs:string?, $action as xs:string) as item()* {
    if ($action = "doc-unlock") then (
        try {
            xdmp:lock-release($doc-uri),
            concat("Lock release on ", $doc-uri, " succesful.."),
            <br/>

        } catch ($e) {
            concat("Lock release on ", $doc-uri, " failed:"),
            <br/>,
            $e//*:format-string
        }
    
    ) else if ($action = "doc-lock") then (
        try {
            xdmp:lock-acquire($doc-uri),
            concat("Lock acquire on ", $doc-uri, " succesful.."),
            <br/>

        } catch ($e) {
            concat("Lock acquire on ", $doc-uri, " failed:"),
            <br/>,
            $e//*:format-string
        }
    
    ) else if ($action = "doc-delete") then (
        try {
            xdmp:document-delete($doc-uri),
            concat("Delete document ", $doc-uri, " succesful.."),
            <br/>

        } catch ($e) {
            concat("Delete document ", $doc-uri, " failed:"),
            <br/>,
            $e//*:format-string
        }
    
    ) else if ($action = "doc-copy") then (
        try {
            let $copy-uri := local:get-copy-filename($doc-uri, 1)
            return (
                xdmp:document-insert($copy-uri, doc($doc-uri), xdmp:document-get-permissions($doc-uri), xdmp:document-get-collections($doc-uri)),
                xdmp:document-set-properties($copy-uri, xdmp:document-properties($doc-uri)/*/*),
                concat("Copy document ", $doc-uri, " to ", $copy-uri, " succesful.."),
                <br/>
            )

        } catch ($e) {
            concat("Copy document ", $doc-uri, " failed:"),
            <br/>,
            $e//*:format-string
        }
    
    ) else if ($action = "dir-delete") then (
        try {
            <div>Are you sure you want to delete all of {count(xdmp:directory($dir-uri, 'infinity'))} documents?</div>,
            
            <ul>{
                for $doc at $pos in xdmp:directory($dir-uri, 'infinity')
                let $doc-uri := base-uri($doc)
                where $pos <= 5
                return
                    if ($pos = 5) then
                        <li>..</li>
                    else
                        <li>{$doc-uri}</li>
            }</ul>,
            
            <form action="?" method="post">
              <input type="hidden" name="dir-uri" value="{$dir-uri}"/>
              <input type="hidden" name="action" value="dir-delete-commit"/>
              <input type="submit" value="Commit"/>
            </form>

        } catch ($e) {
            concat("Delete directory ", $dir-uri, " failed:"),
            <br/>,
            $e//*:format-string
        }
    
    ) else if ($action = "dir-delete-commit") then (
        try {
            concat("Delete directory with ", count(xdmp:directory($dir-uri, 'infinity')), " documents succesful.."),
            <br/>,

            <ul>{
            for $doc at $pos in xdmp:directory($dir-uri, 'infinity')
            let $doc-uri := base-uri($doc)
            return (
                (:xdmp:document-delete($doc-uri),:)
                if ($pos < 5) then (
                    <li>{$doc-uri}</li>
                ) else if ($pos = 5) then (
                    <li>..</li>
                ) else ()
            )
            }</ul>,
            
            xdmp:directory-delete($dir-uri)

        } catch ($e) {
            concat("Delete directory ", $dir-uri, " failed:"),
            <br/>,
            $e//*:format-string
        }
    
    ) else if ($action = "create-all-dirs") then (
        try {
            "Created all virtual directories succesful..",
			<br/>,
			let $created-dirs := ()
            for $dir in cts:uris()
			let $dir :=
				if (ends-with($dir, "/")) then
					$dir
				else
					local:get-parentdir($dir)
			let $steps := fn:tokenize($dir, '/')
			where not($dir = $created-dirs)
			return
				for $pos in 1 to (fn:count($steps) - 1)
				let $dir := fn:concat(fn:string-join($steps[1 to $pos], '/'), '/')
				return
					if ($dir = $created-dirs) then
						()
					else if (xdmp:document-properties($dir)) then
						xdmp:set($created-dirs, ($created-dirs, $dir))
					else (
						xdmp:directory-create($dir),
						xdmp:set($created-dirs, ($created-dirs, $dir))
					)

        } catch ($e) {
            "Create all virtual directories failed:",
            <br/>,
            $e//*:format-string
        }
    
    ) else (
        concat("Unknown action ", $action)
    )
};

declare function local:is-rootdoc($uri as xs:string) as xs:boolean {
    if (matches($uri, '^[a-z]+://')) then (
        matches($uri, '^[a-z]+://[^/]*$')
    ) else (
        matches($uri, '^[^/]*$')
    )
};

declare function local:is-in-subdir($uri as xs:string) as xs:boolean {
    if (matches($uri, '^[a-z]+://')) then (
        matches($uri, '^[a-z]+://[^/]*/.*$')
    ) else (
        matches($uri, '^[^/]*/.*$')
    )
};

declare function local:get-rootdir($uri as xs:string) as xs:string {
    if (matches($uri, '^[a-z]+://')) then (
        replace($uri, '^([a-z]+://[^/]*/).*$', '$1')
    ) else (
        replace($uri, '^([^/]*/).*$', '$1')
    )
};

declare function local:has-subdir-after-base($uri as xs:string, $base-uri as xs:string) as xs:boolean {
    contains(substring-after($uri, $base-uri), '/')
};

declare function local:get-first-subdir-after-base($uri as xs:string, $base-uri as xs:string) as xs:string {
    concat($base-uri, substring-before(substring-after($uri, $base-uri), '/'), '/')
};

declare function local:get-name($uri as xs:string) as xs:string {
    (: also works for http:// like uri's :)
    if (matches($uri, '^.*/[^/]+/?$')) then (
        replace($uri, '^.*/([^/]+)/?$', '$1')
    ) else (
        $uri
    )
};

declare function local:get-parentdir($uri as xs:string) as xs:string {
    (: also works for http:// like uri's :)
    if (matches($uri, '^.*/[^/]+/?$')) then (
        replace($uri, '^(.*/)[^/]+/?$', '$1')
    ) else (
        ''
    )
};

declare function local:get-subdirs($dir-uri as xs:string) as xs:string* {
    if ($dir-uri) then (
        for $prop in xdmp:directory-properties($dir-uri, '1')
        where $prop/prop:properties/prop:directory
        return
            base-uri($prop)
    ) else (
        distinct-values(
            for $uri in cts:uris()
            where local:is-in-subdir($uri)
            return
                local:get-rootdir($uri)
        )
    )
};

declare function local:get-files($dir-uri as xs:string) as xs:string* {
    if ($dir-uri) then (
        for $doc in xdmp:directory($dir-uri)
        return
            base-uri($doc)
    ) else (
        for $doc in doc()
        let $doc-uri := base-uri($doc)
        where local:is-rootdoc($doc-uri)
        return
            $doc-uri
    )
};


if ($action and not($action = ('doc-info', 'correlations'))) then (

    xdmp:set-response-content-type("application/xml; charset=utf-8"),
    
    let $message := local:do-action($dir-uri, $doc-uri, $action)
    let $dir-uri := if ($action = ('dir-delete', 'dir-delete-commit')) then local:get-parentdir($dir-uri) else $dir-uri
    return
        xdmp:redirect-response(concat("?dir-uri=", encode-for-uri($dir-uri), "&amp;message=", encode-for-uri(local:quoteSequence($message)), "&amp;elapsed-time=", xdmp:elapsed-time()))

) else if ($doc-uri and doc-available($doc-uri)) then (

    if ($action = 'correlations') then (

		xdmp:set-response-content-type("text/html; charset=utf-8"),
		
		<html>
			<head>
				<title>Explore database - {$doc-uri}</title>
			</head>
			<body>
				<div>
					<b>{$doc-uri}:</b>
				</div>
				<li>
					<a href="?dir-uri={encode-for-uri(local:get-parentdir($doc-uri))}">..</a>
				</li>
				{
					let $correlations := distinct-values(/pce:correlation[pce:item = $doc-uri]/pce:item)
					return
						if ($correlations) then (
							for $subdoc-uri in $correlations
							where not($subdoc-uri = $doc-uri)
							order by $subdoc-uri
							return
								<li>
									<a href="exploreDatabase.xqy?doc-uri={encode-for-uri($subdoc-uri)}" target="_blank">{$subdoc-uri}</a>
									<font size="-2">
										{'&#160;&#160;&#160;'}
										<a href="exploreDatabase.xqy?doc-uri={encode-for-uri($subdoc-uri)}&amp;action=doc-info" target="_blank">[info]</a>
										{'&#160;|&#160;'}
										<a href="exploreDatabase.xqy?doc-uri={encode-for-uri($subdoc-uri)}&amp;action=correlations">[correlations]</a>
										{
											if ($ALLOW-UPDATING) then (
												'&#160;|&#160;',
												<a href="?doc-uri={encode-for-uri($subdoc-uri)}&amp;action=doc-copy">[copy]</a>,
												'&#160;|&#160;',
												<a href="?doc-uri={encode-for-uri($subdoc-uri)}&amp;action=doc-delete">[delete]</a>,
												if (xdmp:document-locks($subdoc-uri)) then (
													'&#160;|&#160;',
													<a href="?doc-uri={encode-for-uri($subdoc-uri)}&amp;action=doc-unlock">[unlock]</a>
												) else (
													'&#160;|&#160;',
													<a href="?doc-uri={encode-for-uri($subdoc-uri)}&amp;action=doc-lock">[lock]</a>
												)
											) else ()
										}
									</font>
								</li>
						) else (
							<li><i>(no correlations)</i></li>
						)
				}
				<p>{if ($elapsed-time) then $elapsed-time else xdmp:elapsed-time()}</p>
			</body>
		</html>

	) else if ($action = 'doc-info') then (

		xdmp:set-response-content-type("application/xml; charset=utf-8"),

		<document-info
			uri="{$doc-uri}"
			forest="{xdmp:forest-name(xdmp:document-forest($doc-uri))}"
			quality="{xdmp:document-get-quality($doc-uri)}"
			collections="{string-join(xdmp:document-get-collections($doc-uri), ', ')}"
		>{
			xdmp:document-properties($doc-uri),

			xdmp:document-locks($doc-uri),

			xdmp:document-get-permissions($doc-uri),
			
			/pce:correlation[pce:item = $doc-uri]

		}</document-info>

	) else (
		if (xdmp:uri-format($doc-uri) = 'binary') then (
			let $filename := local:get-name($doc-uri)
			let $content-disposition :=
				fn:concat("attachment; filename=", fn:encode-for-uri($filename))
			return (
				xdmp:add-response-header("Content-Disposition",$content-disposition),
				xdmp:add-response-header("ETag", fn:string(xdmp:random())),
				xdmp:set-response-content-type(xdmp:uri-content-type($doc-uri))
			)
		) else (
			xdmp:set-response-content-type(concat(xdmp:uri-content-type($doc-uri), "; charset=utf-8"))
		),

		doc($doc-uri)
	)

) else (

    xdmp:set-response-content-type("text/html; charset=utf-8"),
    
    <html>
        <head>
            <title>Explore database - {if ($doc-uri) then $doc-uri else if ($dir-uri) then $dir-uri else '(root)'}</title>
        </head>
        <body>{

            if ($message) then
                <div style="color:{if (contains(string-join($message, ''), 'succesful')) then 'green' else 'red'}">{$message}<br/></div>
            else (),
            
            <div>
				<b>{if ($doc-uri) then $doc-uri else if ($dir-uri) then $dir-uri else <i>(root)</i>}:</b>
				{
					if (not($doc-uri or $dir-uri)) then
						<font size="-2">
							{'&#160;&#160;&#160;'}
							<a href="?dir-uri={encode-for-uri($dir-uri)}&amp;action=create-all-dirs">[create all dirs]</a>
						</font>
					else ()
				}
			</div>,
            
            if ($dir-uri) then (
            	<li>
                    <a href="?dir-uri={encode-for-uri(local:get-parentdir($dir-uri))}">..</a>
            	</li>
            ) else (),
            
				let $subdirs := local:get-subdirs($dir-uri)
				let $files := local:get-files($dir-uri)
	            return (
					if ($subdirs) then (
						for $subdir-uri in $subdirs
						order by $subdir-uri
						return
							<li>
								<a href="?dir-uri={encode-for-uri($subdir-uri)}">{substring-after($subdir-uri, $dir-uri)}</a>
								<font size="-2">
									{'&#160;&#160;&#160;'}
									<a href="?dir-uri={encode-for-uri($subdir-uri)}&amp;action=dir-delete">[delete]</a>
								</font>
							</li>,

		                <br/>

					) else (),

					if ($files) then (
						for $subdoc-uri in $files
						order by $subdoc-uri
						return
							<li>
								<a href="exploreDatabase.xqy?doc-uri={encode-for-uri($subdoc-uri)}" target="_blank">{substring-after($subdoc-uri, $dir-uri)}</a>
								<font size="-2">
									{'&#160;&#160;&#160;'}
									<a href="exploreDatabase.xqy?doc-uri={encode-for-uri($subdoc-uri)}&amp;action=doc-info" target="_blank">[info]</a>
									{'&#160;|&#160;'}
									<a href="exploreDatabase.xqy?doc-uri={encode-for-uri($subdoc-uri)}&amp;action=correlations">[correlations]</a>
									{
										if ($ALLOW-UPDATING) then (
											'&#160;|&#160;',
											<a href="?doc-uri={encode-for-uri($subdoc-uri)}&amp;action=doc-copy">[copy]</a>,
											'&#160;|&#160;',
											<a href="?doc-uri={encode-for-uri($subdoc-uri)}&amp;action=doc-delete">[delete]</a>,
											if (xdmp:document-locks($subdoc-uri)) then (
												'&#160;|&#160;',
												<a href="?doc-uri={encode-for-uri($subdoc-uri)}&amp;action=doc-unlock">[unlock]</a>
											) else (
												'&#160;|&#160;',
												<a href="?doc-uri={encode-for-uri($subdoc-uri)}&amp;action=doc-lock">[lock]</a>
											)
										) else ()
									}
								</font>
							</li>

					) else if (not($subdirs)) then (
						<li><i>(empty)</i></li>
					) else ()
				)
        }
			<p>{if ($elapsed-time) then $elapsed-time else xdmp:elapsed-time()}</p>
		</body>
    </html>

)
