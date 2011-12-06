xquery version "1.0-ml";

import module namespace teardown = "http://marklogic.com/ps/teardown" at "lib-teardown.xqy";

declare namespace err="http://marklogic.com/xdmp/error";

declare function local:hex-decode($hexBin as xs:hexBinary) as xs:string {
    local:hex-decode($hexBin, floor(string-length(string($hexBin)) div 2))
};

declare function local:hex-decode($hexBin as xs:hexBinary, $length as xs:integer) as xs:string {
    let $string :=
        substring(
            string($hexBin),
            1,
            $length * 2
        )

    let $bytes as xs:integer* :=
        for $pos in 1 to string-length($string)
        let $half-byte := substring($string, $pos, 1)
        let $next-half-byte := substring($string, $pos + 1, 1)
        where ($pos mod 2) = 1
        return
            xdmp:hex-to-integer(concat($half-byte, $next-half-byte))

    return
        codepoints-to-string($bytes)
};

try {
    let $filename := try { xdmp:get-request-field-filename("config") } catch ($e) { $e }
    let $content-type := try { xdmp:get-request-field-content-type("config") } catch ($e) { $e }
    let $import-config := xdmp:get-request-field("config")
    let $import-config :=
        try {
            if ($import-config/self::binary()) then
                xdmp:unquote(local:hex-decode(data($import-config)))/*
            else
                xdmp:unquote($import-config)/*
        } catch ($e) { $e }

    return
        if (not($import-config/*)) then
            fn:concat("No config found: ", $filename, $content-type, $import-config, "..")
        else if ($import-config/self::err:error) then
            fn:concat("Failed to get config from request: ", $filename, $content-type, $import-config//err:format-string, "..")
        else
            teardown:do-teardown($import-config)
} catch ($e) {
    fn:concat("General failure tearing down config: ", string($e), "..")
}