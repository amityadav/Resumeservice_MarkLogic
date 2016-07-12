xquery version "1.0-ml";
declare default function namespace "http://www.w3.org/2005/xpath-functions";

import module namespace glib = "http://amityadav.name/common-lib" at "../lib/common-lib.xqy";
import module namespace clib = "http://amityadav.name/candidate-lib" at "../lib/candidate-lib.xqy";



if ((clib:is-login()))
then
  xdmp:redirect-response("default.xqy")
else



  let $login := xdmp:get-request-field("login")
  let $password	:= xdmp:get-request-field("password")
  let $re-password := xdmp:get-request-field("re-password")
  let $email := xdmp:get-request-field("email")
  return

  if ($login = "") then 
    <span>
      <div class="error">Provide an username</div>
      { clib:register-candidate() }
    </span>
  else if (normalize-space($login) = "") then
    <span>
      <div class="error">Provide an username</div>
      { clib:register-candidate() }
    </span>
  else if (normalize-space($password) = "") then
    <span>
      <div class="error">Provide a password</div>
      { clib:register-candidate() }
    </span>
  else if ($password != $re-password) then
    <span>
      <div class="error">The two password and re-password are not same</div>
      { clib:register-candidate() }
    </span>
  else if (normalize-space($email) = "") then
    <span>
      <div class="error">Provide an email</div>
      { clib:register-candidate() }
    </span>
  else

  let $add-candidate := clib:add-candidate(normalize-space($login), normalize-space($password), normalize-space($email))
  return

  <span>
    <div class="action-explain">
      {
		xdmp:set-session-field("message", "You have been successfully registered to the system"),
		xdmp:redirect-response("/default.xqy") 
	  }
	  
    </div>
  </span>
