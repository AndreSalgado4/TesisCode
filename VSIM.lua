-- INTIIAL INFO
-- You can run this script by:
-- 1) going to your VehSim.exe folder,
-- 2) pasting the script file in this folder
-- 3) opening Powershell
-- 4) typing in: .\VehSim.exe -s="andre_head_script.lua" (you can provide a different script path if you wish)
-- Script was tested and was operational on English version 5.0.91. (commercial version) 
function GetAccelerationComponents(previousVel_ms, linvel, rotvel)
    local previousVel_X_ms = previousVel_ms[1]
    local previousVel_Y_ms = previousVel_ms[2]
    local previousVel_Z_ms = previousVel_ms[3]
    local previousRotVel_X_ms = previousVel_ms[4]
    local previousRotVel_Y_ms = previousVel_ms[5]
    local previousRotVel_Z_ms = previousVel_ms[6]

    local timeStepForAccelerationCalculation = 1000/1e6
    local accelerationX = (linvel.X - previousVel_X_ms)/timeStepForAccelerationCalculation
    local accelerationY = (linvel.Y - previousVel_Y_ms)/timeStepForAccelerationCalculation
    local accelerationZ = (linvel.Z - previousVel_Z_ms)/timeStepForAccelerationCalculation

    local rotaccelerationX = (rotvel.X-previousRotVel_X_ms)/timeStepForAccelerationCalculation
    local rotaccelerationY = (rotvel.Y-previousRotVel_Y_ms)/timeStepForAccelerationCalculation
    local rotaccelerationZ = (rotvel.Z-previousRotVel_Z_ms)/timeStepForAccelerationCalculation

    acc = {accelerationX, accelerationY, accelerationZ, rotaccelerationX, rotaccelerationY, rotaccelerationZ}
    
    return acc
end

function SaveBodyPosition(outputPath, bodyId, doc, mb, maxSimTime_us)
    local filepath = outputPath .. "\\M50.txt"
    local filepatho = outputPath .. "\\OM50.txt"
    local filepathv = outputPath .. "\\VM50.txt"
    local file = io.open(filepath, "w")
    local fileo = io.open(filepatho,"w")
    local filev = io.open(filepathv,"w")

    local timeStart_us = 2*1e6
    local timeStop_us = maxSimTime_us
    -- Main Loop
    previousVel_ms = {0.0, 0.0, 0.0, 0.0, 0.0,0.0}
    previousTime = -1e6
    for time=timeStart_us,timeStop_us,1000 do
        local log = mb:GetMBLogAtTime(time)
        local linvel = log.m_BodiesRegistry:GetBodyRecord(bodyId).linearVelocity
        local rotvel = mb:GetRotationVelocityGlobalCrdsysAtTime(time, bodyId)
        local acc = GetAccelerationComponents(previousVel_ms, linvel, rotvel)
        
        local pozycjaString = string.format("%f %f %f %f %f %f %f\n", time/1e6, acc[1], acc[2], acc[3], acc[4], acc[5], acc[6])
        file:write(pozycjaString)

        local orientationMatrix = log.m_BodiesRegistry:GetBodyRecord(bodyId).orientation
        local XX = orientationMatrix.XX
        local XY = orientationMatrix.XY
        local XZ = orientationMatrix.XZ
        local YX = orientationMatrix.YX
        local YY = orientationMatrix.YY
        local YZ = orientationMatrix.YZ
        local ZX = orientationMatrix.ZX
        local ZY = orientationMatrix.ZY
        local ZZ = orientationMatrix.ZZ

        local ori = string.format("%f %f %f %f %f %f %f %f %f %f\n", time/1e6, XX, XY, XZ, YX, YY, YZ, ZX, ZY, ZZ)
        fileo:write(ori)

        previousVel_ms = {linvel.X, linvel.Y, linvel.Z, rotvel.X, rotvel.Y, rotvel.Z}
        previousTime = log.m_nTime

        local vel = string.format("%f %f  %f\n", rotvel.X, rotvel.Y, rotvel.Z)
        filev:write(vel)

    end
    file:close()
    fileo:close()
    filev:close()
    
end


local doc = vsim.LoadDoc("C://Users//Public//Day3//M50.vehsim6")           --Carrega ficheiro guardado
local outputPath = vsim.GetCurrentScriptDir()                                 --Carrega a pasta do ficheiro
local mb = doc:GetPedestrianMB("Multibody human",false)                                          --Carrega informações do multi-corpo

maxSimTime = 3.5
doc:SetMaxSimulationTimeInSeconds(maxSimTime);                                --Define tempo máximo da simulação      
maxSimTime_us = maxSimTime*1e6                                      

--local mass = mb:GetBodyMass(4)
--print(mass)

--local mbInitialXPositions = {0.0, 0.5}
--for i = 1,2,1 do
    --mb:SetInitialPosition(0.0,mbInitialXPositions[i])
    vsim.SendCommandToMainWindow(vsimgui.ID_SIM_FORWARD)                      --Começa a simulação
    SaveBodyPosition(outputPath, 4, doc, mb, maxSimTime_us)
    vsim.SendCommandToMainWindow(vsimgui.ID_SIM_STOP)  --Reinicia a simulação depois de terminar
    vsim.ExitApplication(0)                 
--end