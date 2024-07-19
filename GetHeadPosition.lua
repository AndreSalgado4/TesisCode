matriz_palavras = {"M5.vehsim6", "M5V50.vehsim6", "M5V50V2.vehsim6", "M5V60.vehsim6", "M5V60V2.vehsim6", "M5V70.vehsim6", "M5V70V2.vehsim6", "M50.vehsim6", "M50V50.vehsim6", "M50V50V2.vehsim6", "M50V60.vehsim6", "M50V60V2.vehsim6", "M50V70.vehsim6", "M50V70V2.vehsim6", "M95.vehsim6", "M95V50.vehsim6", "M95V50V2.vehsim6", "M95V60.vehsim6", "M95V60V2.vehsim6", "M95V70.vehsim6", "M95V70V2.vehsim6"}

local outputPath = vsim.GetCurrentScriptDir()
local filepath = outputPath .. "\\MHeadPosition.txt"
local file = io.open(filepath, "w")

for i, palavra in ipairs(matriz_palavras) do
    local caminho_documento = "C://Users//Public//Day3//" .. palavra
    local doc = vsim.LoadDoc(caminho_documento)
    local mb = doc:GetPedestrianMB("Multibody human",false)
    local vehicle = doc:GetDynamicVehicle("Toyota RAV 4 IV")
    maxSimTime = 2.5
    doc:SetMaxSimulationTimeInSeconds(maxSimTime);
    vsim.SendCommandToMainWindow(vsimgui.ID_SIM_FORWARD)

    local mbCrashObj = doc:GetNthMBodyCrashObj(0,"Multibody human", "Head", vehicle:GetVehicleName())
    local headContactStartTime = mbCrashObj:GetStartTime()
    local mbLog = mb:GetMBLogAtTime(headContactStartTime)
    local carlog =  vehicle:GetLogAtTime(headContactStartTime)
    local position = mbLog.m_BodiesRegistry:GetBodyRecord(4).position
    local carposition = carlog.m_vPos

    local pX = position.X
    local pY = position.Y
    local pZ = position.Z
    local cpX = carposition.X
    local cpY = carposition.Y

    local pXF = pX - cpX
    local pYF = pY - cpY

    local pozycjaString = string.format("%f %f %f\n", pXF, pYF, pZ)
    file:write(pozycjaString)

    vsim.SendCommandToMainWindow(vsimgui.ID_SIM_STOP)
    vsim.ExitApplication(0)

end

file:close()