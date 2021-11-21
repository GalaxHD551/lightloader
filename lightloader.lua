lr = ImportPackage("lightstreamer")

EditorLights = {}
EditorLightsLoaded = false

local function Editor_LoadLight()
    if EditorLightLoaded then return end
    EditorLightLoaded = true

    print('Server: Attempting to load lights.')

    local _table = File_LoadJSONTable('lights.json')
    if _table ~= nil then
        for _,v in ipairs(_table) do
            local newLight = lr.CreateLight(v.lighttype, v.x, v.y, v.z, v.rx, v.ry, v.rz, v.color, v.intensity, v.streamradius)
            lr.SetLightAttenuationRadius(newLight, v.attenuation_radius)
            lr.SetLightCastShadows(newLight, v.shadow)
            if(v.lighttype == "SPOTLIGHT") then
                lr.SetLightOuterConeAngle(newLight, v.outer_cone)
                lr.SetLightInnerConeAngle(newLight, v.inner_cone)
                lr.SetLightSourceRadius(newLight, v.source_radius)
                lr.SetLightSoftSourceRadius(newLight, v.soft_source_radius)
                lr.SetLightSourceLength(newLight, v.source_lenght)
                lr.SetLightFalloffExponent(newLight, v.falloff)
            elseif(v.lighttype == "POINTLIGHT") then
                lr.SetLightSourceRadius(newLight, v.source_radius)
                lr.SetLightSoftSourceRadius(newLight, v.soft_source_radius)
                lr.SetLightSourceLength(newLight, v.source_lenght)
                lr.SetLightFalloffExponent(newLight, v.falloff)
            elseif(v.lighttype == "RECTLIGHT") then
                lr.SetLightSourceWidth(newLight, v.source_width)
                lr.SetLightSourceHeight(newLight, v.source_height)
                lr.SetLightBarnDoorAngle(newLight, v.barn_door_angle)
                lr.SetLightBarnDoorLength(newLight, v.barn_door_lenght)
            end
            print("CreateLight("..v.lighttype..", "..v.x..", "..v.y..", "..v.z..")")
            table.insert(EditorLights, newLight)
        end
        print('Server: Lights loaded!')
    else
        print('Server: No lights.json found in root server directory, one will be made next time the server saves.')
    end
end
AddEvent('OnPackageStart', Editor_LoadLight)