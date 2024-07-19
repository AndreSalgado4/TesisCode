doc = vsim.GetNewDoc()
savePath = vsim.GetCurrentScriptDir() .. "HeadPositions.vehsim6"
vehicle = doc:AddDynamicVehicle(683265504)
vehicle:SetInitialPosition(0.0, 0.0)
vehicle:SetInitialOrientationZDeg(180.0)
-- Abrir o arquivo em modo de leitura ("r" para read)
local arquivoM = io.open("C://Users//Public//Day3//MHeadPosition.txt", "r")
local arquivoF = io.open("C://Users//Public//Day3//FHeadPosition.txt", "r")

for linha in arquivoM:lines() do
    -- Desempacotar os três números da linha para variáveis individuais
    local numero1, numero2, numero3 = linha:match("(%S+)%s+(%S+)%s+(%S+)")

    num1=tonumber(numero1)
    num2=tonumber(numero2)
    num3=tonumber(numero3)

    local impactorDiameterCm = 5.0 -- [cm]
    local bodyGen = doc:AddBodyGenHandler();
    bodyGen:ChangeEllipsoidSemiAxis(0,impactorDiameterCm/2.,impactorDiameterCm/2.,impactorDiameterCm/2.)
    local ballMarker = doc:AddMultibodyOneBall(bodyGen)
    ballMarker:SetInitialPosition3D(numero1, numero2, numero3)
end

for linha in arquivoF:lines() do
    -- Desempacotar os três números da linha para variáveis individuais
    local numero1, numero2, numero3 = linha:match("(%S+)%s+(%S+)%s+(%S+)")

    num1=tonumber(numero1)
    num2=tonumber(numero2)
    num3=tonumber(numero3)

    local impactorDiameterCm = 5.0 -- [cm]
    local bodyGen = doc:AddBodyGenHandler();
    bodyGen:ChangeEllipsoidSemiAxis(0,impactorDiameterCm/2.,impactorDiameterCm/2.,impactorDiameterCm/2.)
    local ballMarker = doc:AddMultibodyOneBall(bodyGen)
    ballMarker:SetInitialPosition3D(numero1, numero2, numero3)
end

doc:SaveAs(savePath)