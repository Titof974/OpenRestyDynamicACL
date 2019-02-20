 
local C, R, U, D, O, H = "POST", "GET", "PUT", "DELETE", "OPTION", "HEAD"
local DynamicACL = {}
local cjson = require "cjson"
DynamicACL.__index = DynamicACL

function DynamicACL:initACLS()
	local dacl = ngx.shared.dacl
	if dacl:get("json") == nil then
		DynamicACL:setACLS({
			{
				["user"] = ".*",
				["permission"] = {},
				["url"] = "/.*",
				["filters"] = {}
			},
			{
				["user"] = "boby",
				["permission"] = {C},
				["url"] = "/boby",
				["filters"] = {}
			}
		})
	end
end


function DynamicACL:getACLS()
	local dacl = ngx.shared.dacl
	return cjson.decode(dacl:get("json"))
end

function DynamicACL:setACLS(acls)
	local dacl = ngx.shared.dacl
	dacl:set("json", cjson.encode(acls))
end

function DynamicACL:setACLSJson(acls)
	local dacl = ngx.shared.dacl
	dacl:set("json", acls)
end

function DynamicACL:getACLSJson()
	local dacl = ngx.shared.dacl
	return dacl:get("json")
end

function DynamicACL:getURI()
	return ngx.unescape_uri(ngx.var.request_uri);
end

function DynamicACL:getMethod()
	return ngx.req.get_method();
end

function DynamicACL:getTokenHeader()
	local user = ngx.req.get_headers()["user"];
	return user == nil and "" or user
end

function DynamicACL:hasPermission(acl)
	for key, value in pairs(acl["permission"]) do
		if value == DynamicACL:getMethod() then
			return true;
		end
	end
	return false
end

function DynamicACL:hasACLS(user, url)
	local acls = {}
	for key, value in pairs(DynamicACL:getACLS()) do
		if string.match(url, "^" .. value["url"] .. "$") ~= nil and string.match(user, "^" .. value["user"] .. "$") ~= nil then
			table.insert(acls, value);
		end
	end
	return acls
end

function DynamicACL:verify()
	local acls = DynamicACL:hasACLS(DynamicACL:getTokenHeader(), DynamicACL:getURI());
	for key, value in pairs(acls) do
		if DynamicACL:hasPermission(value) then
			return true
		end
	end
	return false
end

function DynamicACL:getWebUI()
	if DynamicACL:getURI() == "/>/dacl/"  then
		if DynamicACL:getMethod() == "GET" then
			ngx.header['Content-Type'] = "application/json";
			ngx.say(DynamicACL:getACLSJson());
			ngx.exit(ngx.HTTP_OK);
		elseif DynamicACL:getMethod() == "POST" then
			ngx.req.read_body()
			ngx.header['Content-Type'] = "application/json";
			DynamicACL:setACLSJson(ngx.req.get_body_data())
			ngx.say(DynamicACL:getACLSJson());
			ngx.exit(ngx.HTTP_OK);
		end
	end
end

return DynamicACL