local log = dofile('logger.lua')

local template = {}
template.name  = 'template'

function template:initialize(note, stage)
	log.info(self.name .. ' initializing')
	
	self.toload = {}
	self.note   = note
	self.db     = dofile('db.lua')
	
	if stage == 1 then
		self.db:open(template.name .. '_links.db', {RO = true})
	elseif stage == 2 then
		self.db:open(template.name .. '_links.db')	
	end
end

function template:finalize(stage)
	log.info(self.name .. ' finalizing')

	if stage == 1 then
		self.resources = dofile('db.lua')
		self.resources:open(template.name .. '.db')	
		for r in self.toload do
			os:execute("cp " .. self.resources:find(r).path .. " ".. self.builddir)
		end
		self.resources:close()
	elseif stage == 2 then
		--- ask for transaction verification
	end

	self.db:close()
end

function template:find(name)
	log.info('looking for ' .. name .. ' in ' .. self.name ..'\'s database')
	
	return self.db:find(name)
end

function template:fuzzyfind(name)
	log.info('looking (fuzzy) for ' .. name .. ' in ' .. self.name  .. '\'s database')
	
	return self.db:fuzzyfind(name)
end

function template:load(name)
	log.info('loading ' .. self.name .. ' resource: ' .. name)
	
	if self.toload[name] == nil then self.toload[name] = true end
	return
end

function template:register(name)
	log.info('registering ' .. self.name .. ' resource: ' .. name)
	
	self.db:transaction({key = self.note, value = name}, {infile = self.name .. '.register'})
	
	return
end

-- ToDo get binding command
function template:bind(name)
	log.info('binding ' .. self.name .. ' to resource: ' .. name)
end

return template
