xquery version "1.0-ml";
declare option xdmp:mapping "false";
xdmp:set-session-field("employer", ""),
xdmp:set-session-field("emp-id", ""),
xdmp:redirect-response("/default.xqy")