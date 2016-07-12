let $url := xdmp:get-request-url()

let $url := fn:replace($url, "^/candidate$", "/candidate/candidate-home.xqy")
let $url := fn:replace($url, "^/candidate/register$", "/candidate/register_candidate.xqy")
let $url := fn:replace($url, "^/candidate/logout$", "/candidate/logout.xqy")
let $url := fn:replace($url, "^/candidate/profile/([0-9]+)$", "/candidate/view_profile.xqy?cid=$1")
let $url := fn:replace($url, "^/candidate/profile$", "/candidate/view_profile.xqy")
let $url := fn:replace($url, "^/candidate/edit$", "/candidate/edit_profile.xqy")
let $url := fn:replace($url, "^/candidate/update$", "/candidate/update_profile.xqy")
let $url := fn:replace($url, "^/candidate/jobs$", "/candidate/candidate_jobs.xqy")

let $url := fn:replace($url, "^/employer/logout$", "/employer/logout.xqy")
let $url := fn:replace($url, "^/employer/new$", "/employer/register_employer.xqy")
let $url := fn:replace($url, "^/employer/dashboard$", "/employer/dashboard.xqy")
let $url := fn:replace($url, "^/employer/profile$", "/employer/view_profile.xqy")
let $url := fn:replace($url, "^/employer/edit$", "/employer/edit_profile.xqy")
let $url := fn:replace($url, "^/employer/update$", "/employer/update_profile.xqy")

let $url := fn:replace($url, "^/employer/jobs$", "/employer/jobs.xqy")
let $url := fn:replace($url, "^/employer/job/([0-9]+)$", "/employer/view_job.xqy?jid=$1")
let $url := fn:replace($url, "^/employer/job/edit$", "/employer/edit_job.xqy")
let $url := fn:replace($url, "^/employer/job/edit/([0-9]+)$", "/employer/edit_job.xqy?jid=$1")
let $url := fn:replace($url, "^/employer/job/create$", "/employer/create_job.xqy")

let $url := fn:replace($url, "^/privacy$", "/privacy.xqy")
return $url