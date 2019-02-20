DynamicACL = require "DynamicAcl";

DynamicACL:getWebUI();
if not (DynamicACL:verify()) then
	ngx.exit(ngx.HTTP_UNAUTHORIZED);
end