xquery version "1.0-ml";
import module namespace glib = "http://amityadav.name/common-lib" at "../lib/common-lib.xqy";
import module namespace clib = "http://amityadav.name/candidate-lib" at "../lib/candidate-lib.xqy";
declare namespace cd="http://amityadav.name/candidates";
declare option xdmp:mapping "false";

(:Check if the user is logged in:)
if (fn:not(clib:is-login())) then
	(:Redirect to the login page:)
	xdmp:redirect-response("/default.xqy") 		
else 
	(:Update the candiate profile:)

	let $candidate-node := clib:get-candidate-details(xdmp:get-session-field("user-id"))
	return

	if (fn:empty($candidate-node)) then
		(
			xdmp:set-session-field("message", "Error updating the record!!!"),
			xdmp:redirect-response("/candidate/profile") 
		)
	else
		let $status := clib:update-candidate-node($candidate-node, xdmp:get-request-field("f_name"), xdmp:get-session-field("user-id"), xdmp:get-request-field("l_name"), xdmp:get-request-field("resume_title"), xdmp:get-request-field("skills"), xdmp:get-request-field("experience"), xdmp:get-request-field("summary"), xdmp:get-request-field("email"))
		return

		xdmp:redirect-response("/candidate/profile") 