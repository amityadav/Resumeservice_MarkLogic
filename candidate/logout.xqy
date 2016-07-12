xquery version "1.0-ml";
declare option xdmp:mapping "false";
xdmp:set-session-field("candidate", ""),
xdmp:set-session-field("user-id", ""),
xdmp:redirect-response("/default.xqy")