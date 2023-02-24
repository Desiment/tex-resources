local log    = dofile("logger.lua")
local config = dofile("config.lua")

local resources = {}


resources.initialize = function(stage)
	log.debug("Initializing at the stage", stage)
	log.debug("Available resource types:", config.types)
	
	-- configure --
	resources.types = config.types
	for _, rtype in pairs(resources.types) do
		resources[rtype] = dofile(config.srcdir .. rtype .. ".lua")
		--texsprint('\input{config.srcdir .. t .. ".sty"}')
	end
	
	for _, method in pairs(config.methods) do
		resources[method] = log.call.debug(function(rtype, name) return resources[rtype][method](name) end)
	end
	
	-- initialize -- 
	for _, rtype in pairs(resources.types) do
		resources[t].initialize(stage)
	end
end

resources.finalize = function()
	log.debug("Finalizing at the stage", stage)

	-- finalize --
	for _, rtype in pairs(resources.types) do
		rtype.finalize(stage)
	end

	-- clean-up --
end


return resources
