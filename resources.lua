local log = require('logger.lua')

local resources = []

local _methods  = ['initialize', 'finalize', 'find', 'fuzzyfind', 'rload', 'register', 'bind']
local _rtypes   = ['graphics', 'table', 'bibliography']
local _srcdir = "src/"

local function configure(res)
	res.types = _rtypes
	log.debug("Available resource types:", res.types)
	for t in _ryped do
		dofile(_srcdir .. t .. ".lua")
		--texsprint(\input{_specs .. t .. ".sty")
	end
end

local function wrapper(fooname, tlist)
	return (function(t,n) return tlist[t][fooname](n) end)
end

resources.initialize = function(stage)
	log.debug("Initializing at the stage", stage)
	configure(resources)
	for t in resources.types do
		t.initialize(stage)
	end
end

resources.finalize = function()
	log.debug("Finalizing at the stage", stage)
	for t in resources.types do
		t.finalize(stage)
	end
end

for foo in _methods do
	resources[foo] = log.call.debug(wrapper(foo, resources.types))
end

return resources
