SPANEL_ADDON_CONFIG = {
    ["name"] = "SPanel",
    ["author"] = "NoIdeaIndustry",
    ["version"] = "1.0.0",
    ["website"] = "https://noideaindustry.com",

    ["logger"] = "[Logger - SPanel]",
}

SPANEL_ADDON_THEME = {
    ["logger_color"] = Color(235, 188, 186),

    ["main"] = Color(210, 144, 52),
    ["background"] = Color(52, 52, 52),
	["hover"] = Color(32,31,29),

    ["on_message"] = Color(196, 167, 231),
    ["off_message"] = Color(235, 111, 146),
}

STAFF_PANEL = {}
TICKET_PANEL = {}

local rootDirectory = "spanel"

if( SERVER ) then
    print()
    print("------------------------------------")
    print("-----------    " .. SPANEL_ADDON_CONFIG.name .. "    -----------")
    print("-------    " .. SPANEL_ADDON_CONFIG.author .. "    -------")
    print("-    " .. SPANEL_ADDON_CONFIG.website .. "    -")
    print("------------------------------------")
    print()

    print("Successfully loaded " .. SPANEL_ADDON_CONFIG.name .. " ver: " .. SPANEL_ADDON_CONFIG.version)
    print()
end

local function AddFile( File, directory )
	local prefix = string.lower( string.Left( File, 3 ) )

	if ( SERVER and prefix == "sv_" ) then
		include( directory .. File )
		print( "[SPanel] SERVER INCLUDE: " .. File )
	elseif ( prefix == "sh_" ) then
		if (SERVER) then
			AddCSLuaFile( directory .. File )
			print( "[SPanel] SHARED ADDCS: " .. File )
		end
		include( directory .. File )
		print( "[SPanel] SHARED INCLUDE: " .. File )
	elseif (prefix == "cl_") then
		if ( SERVER ) then
			AddCSLuaFile( directory .. File )
			print( "[SPanel] CLIENT ADDCS: " .. File )
		elseif ( CLIENT ) then
			include( directory .. File )
			print( "[SPanel] CLIENT INCLUDE: " .. File )
		end
	end
end

local function IncludeDir( directory )
	directory = directory .. "/"

	local files, directories = file.Find( directory .. "*", "LUA" )

	for _, v in ipairs( files ) do
		if (string.EndsWith( v, ".lua" )) then
			AddFile( v, directory )
		end
	end

	for _, v in ipairs( directories ) do
		IncludeDir( directory .. v )
	end
end

IncludeDir(rootDirectory)