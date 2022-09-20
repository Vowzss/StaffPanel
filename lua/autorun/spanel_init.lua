local rootDirectory = "spanel"
local configDirectory = rootDirectory .. "/config"

hook.Run("ConfigLoading")
hook.Add("ConfigLoading", "SP_HK_CONFIG_LOADING", function()
	if(SERVER) then
		print()
		print("------------------------------------")
		print("-----------    " .. SP_ADDON_CONFIG.name .. "    -----------")
		print("-------    " .. SP_ADDON_CONFIG.author .. "    -------")
		print("-    " .. SP_ADDON_CONFIG.website .. "    -")
		print("------------------------------------")
		print()
	
		print("Loading " .. SP_ADDON_CONFIG.name .. " ver: " .. SP_ADDON_CONFIG.version .. " ..........")
		print()
	end
end)

AddCSLuaFile("spanel/spanel.lua")
include("spanel/spanel.lua")

local function AddFile( File, directory )
	local prefix = string.lower( string.Left( File, 3 ) )
	if (SERVER and prefix == "sv_") then
		include(directory .. File)
		print("[SPanel] SERVER INCLUDE: " .. File)
	elseif (prefix == "sh_") then
		if (SERVER) then
			AddCSLuaFile(directory .. File)
			print("[SPanel] SHARED ADDCS: " .. File)
		end
		include(directory .. File)
		print("[SPanel] SHARED INCLUDE: " .. File)
	elseif (prefix == "cfg") then
		if (SERVER) then
			AddCSLuaFile(directory .. File)
			print("[SPanel] CONFIG ADDCS: " .. File)
		end
		include(directory .. File)
		print("[SPanel] CONFIG INCLUDE: " .. File)
	elseif (prefix == "cl_") then
		if (SERVER) then
			AddCSLuaFile(directory .. File)
			print("[SPanel] CLIENT ADDCS: " .. File)
		elseif (CLIENT) then
			include(directory .. File)
			print("[SPanel] CLIENT INCLUDE: " .. File)
		end
	end
end

local function IncludeCfg(directory)
	directory = directory .. "/"
	
	local files, directories = file.Find(directory .. "*", "LUA")

	for _, v in ipairs(files) do
		if (string.EndsWith(v, ".lua")) then
			AddFile(v, directory)
		end
	end

	for _, v in ipairs(directories) do
		IncludeCfg(directory .. v)
	end
end

IncludeCfg(configDirectory)

local function IncludeLua(directory)
	directory = directory .. "/"

	local files, directories = file.Find(directory .. "*", "LUA")

	for _, v in ipairs(files) do
		if (string.EndsWith(v, ".lua")) then
			AddFile(v, directory)
		end
	end

	for _, v in ipairs( directories) do
		IncludeLua(directory .. v)
	end
end

IncludeLua(rootDirectory)

hook.Run("ConfigLoaded")
hook.Add("ConfigLoaded", "SP_HK_CONFIG_LOADED", function()
	if(SERVER) then
		print()
		print("------------------------------------")
		print("-----------    " .. SP_ADDON_CONFIG.name .. "    -----------")
		print("-------    " .. SP_ADDON_CONFIG.author .. "    -------")
		print("-    " .. SP_ADDON_CONFIG.website .. "    -")
		print("------------------------------------")
		print()
	
		print("Successfully loaded " .. SP_ADDON_CONFIG.name .. " ver: " .. SP_ADDON_CONFIG.version)
		print()
	end
end)