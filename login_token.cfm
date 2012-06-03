<!--- This code sample shows how to make the auth_info API call using CFML --->

<!--- Enter your API key here --->
<cfset variables.apikey = "">

<!--- Step 1) Extract the token from your environment --->
<cfset variables.token = form.token>

<!---
Step 2) Now that we have the token, we need to make the api call to auth_info.
auth_info expects an HTTP Post with the following paramters:
--->

<cfhttp url="https://rpxnow.com/api/v2/auth_info">
	<cfhttpparam name="token" value="#variables.token#" type="URL">
	<cfhttpparam name="apiKey" value="#variables.apikey#" type="URL">
</cfhttp>

<!--- If status code is 200 --->
<cfif cfhttp.responseheader.status_code EQ "200">

	<!--- Step 3) read the json response --->
	<cfset variables.auth_info_json = Deserializejson(cfhttp.filecontent)>
	
	<!--- Set default variables which might be in the response (depending on the provider) --->
	<cfparam name="variables.auth_info_json.profile.displayName" default="" />
	<cfparam name="variables.auth_info_json.profile.email" default="" />
	<cfparam name="variables.auth_info_json.profile.photo" default="" />
	
	<!--- 	Step 4) use the response to sign the user in --->
	<cfif variables.auth_info_json.stat EQ "OK">
	    <!---
		'identifier' is the unique idenfifier that you use to sign the user in to your site
		--->
	    <cfset variables.identifier = variables.auth_info_json.profile.identifier>
	    <!---
		get fields
		--->
		<cfset variables.displayName = variables.auth_info_json.profile.displayName>
	    <cfset variables.email = variables.auth_info_json.profile.email>
	    <cfset variables.profile_pic_url = variables.auth_info_json.profile.photo>
		<cfset variables.providerName = variables.auth_info_json.profile.providerName>
		<cfset variables.preferredUsername = variables.auth_info_json.profile.preferredUsername>
	   	<!---
		actually sign the user in. this implementation depends highly on your platform, and is up to you.
		--->
	    <!--- <cfinvoke component="" method=""></cfinvoke> --->
	    
	    <!--- Simply dump variables --->
	    <cfdump var="#variables#">
	
	<!--- Error with Authentication --->
	<cfelse>
	    <h1>Error with the authentication</h1>
	    <cfdump var="#variables.auth_info_json.err.msg#">
	</cfif>

<!--- There is an error with the http response --->
<cfelse>
	<h1>Error with the HTTP Response</h1>
	<cfdump var="#cfhttp#">
</cfif>