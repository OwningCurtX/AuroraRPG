addCommandHandler( "camshake",
    function( _, level )
        local level = math.floor( level )
        if level and level >=0 and level <= 255 then
            setCameraShakeLevel( level )
            outputChatBox( "Camera shake level updated to " .. level .. "." )
        else
            outputChatBox( "Camera shake level must be between 0 and 255." )
        end
    end
)