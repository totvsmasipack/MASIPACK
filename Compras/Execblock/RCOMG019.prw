User Function RCOMG019()

Local oModel    := FWModelActive()
Local cDesc     := oModel:GetValue('SC8DETAIL','C8_FORMAIL')
Local cMailFor  := 'TESTE@TESTE'

oModel:SetValue('SC8DETAIL','C8_FORMAIL',cMailFor)
oModel:LoadValue('SC8DETAIL','C8_FORMAIL',cMailFor)

Return cDesc
