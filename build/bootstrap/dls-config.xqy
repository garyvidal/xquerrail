xquery version "1.0-ml";

(: setup the retention policy for dls :)
import module namespace dls="http://marklogic.com/xdmp/dls" at "/MarkLogic/dls.xqy";

try {
dls:retention-rule-insert(
  dls:retention-rule("All Versions Retention Rule",
                     "Retain all versions of all documents",
                     (), (),
                     "Locate all of the documents",
                     cts:and-query(()) ) )
}
catch($ex) {
  "DLS is already configured on this database. Doing nothing."
}