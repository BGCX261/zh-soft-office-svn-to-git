object ProductManagerForm: TProductManagerForm
  Left = 624
  Top = 190
  BorderStyle = bsDialog
  Caption = #20135#21697#32534#36753
  ClientHeight = 245
  ClientWidth = 490
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object rzpnl2: TRzPanel
    Left = 0
    Top = 0
    Width = 490
    Height = 245
    Align = alClient
    BorderOuter = fsNone
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    VisualStyle = vsGradient
    object lbl1: TRzLabel
      Left = 10
      Top = 24
      Width = 49
      Height = 13
      AutoSize = False
      Caption = #21517#31216
      Transparent = True
    end
    object lbl2: TRzLabel
      Left = 10
      Top = 56
      Width = 39
      Height = 13
      AutoSize = False
      Caption = #20195#30721
      Transparent = True
    end
    object lbl4: TRzLabel
      Left = 10
      Top = 86
      Width = 36
      Height = 13
      AutoSize = False
      Caption = #38271
      Transparent = True
    end
    object lbl5: TRzLabel
      Left = 174
      Top = 86
      Width = 27
      Height = 13
      AutoSize = False
      Caption = #23485
      Transparent = True
    end
    object lbl3: TRzLabel
      Left = 10
      Top = 115
      Width = 36
      Height = 13
      AutoSize = False
      Caption = #25968#37327
      Transparent = True
    end
    object lbl7: TRzLabel
      Left = 9
      Top = 144
      Width = 36
      Height = 13
      AutoSize = False
      Caption = #21608#38271
      Transparent = True
    end
    object lbl8: TRzLabel
      Left = 173
      Top = 142
      Width = 36
      Height = 13
      AutoSize = False
      Caption = #38754#31215
      Transparent = True
    end
    object lbl9: TRzLabel
      Left = 10
      Top = 173
      Width = 39
      Height = 13
      AutoSize = False
      Caption = #22791#27880
      Transparent = True
    end
    object lbl10: TRzLabel
      Left = 172
      Top = 115
      Width = 36
      Height = 13
      AutoSize = False
      Caption = #21333#20215
      Transparent = True
    end
    object lbl11: TRzLabel
      Left = 333
      Top = 142
      Width = 36
      Height = 13
      AutoSize = False
      Caption = #37329#39069
      Transparent = True
    end
    object edtName: TRzEdit
      Left = 48
      Top = 18
      Width = 432
      Height = 20
      ImeName = #35895#27468#25340#38899#36755#20837#27861' 2'
      TabOnEnter = True
      TabOrder = 0
    end
    object edtCode: TRzEdit
      Left = 48
      Top = 50
      Width = 432
      Height = 20
      ImeName = #35895#27468#25340#38899#36755#20837#27861' 2'
      TabOnEnter = True
      TabOrder = 1
    end
    object edtLength: TRzEdit
      Left = 48
      Top = 80
      Width = 118
      Height = 20
      ImeName = #35895#27468#25340#38899#36755#20837#27861' 2'
      TabOnEnter = True
      TabOrder = 2
      OnChange = edtLengthChange
      OnKeyPress = edtLengthKeyPress
    end
    object edtWidth: TRzEdit
      Left = 207
      Top = 80
      Width = 118
      Height = 20
      ImeName = #35895#27468#25340#38899#36755#20837#27861' 2'
      TabOnEnter = True
      TabOrder = 3
      OnChange = edtLengthChange
      OnKeyPress = edtLengthKeyPress
    end
    object edtNum: TRzEdit
      Left = 48
      Top = 109
      Width = 118
      Height = 20
      ImeName = #35895#27468#25340#38899#36755#20837#27861' 2'
      TabOnEnter = True
      TabOrder = 4
      OnChange = edtLengthChange
      OnKeyPress = edtLengthKeyPress
    end
    object edtCircle: TRzEdit
      Left = 49
      Top = 138
      Width = 118
      Height = 20
      Color = clInfoBk
      ImeName = #35895#27468#25340#38899#36755#20837#27861' 2'
      ReadOnly = True
      TabOrder = 8
    end
    object btnSave: TRzBitBtn
      Left = 216
      Top = 202
      Action = actSave
      Caption = #20445#23384
      TabOrder = 11
      Glyph.Data = {
        36060000424D3606000000000000360400002800000020000000100000000100
        0800000000000002000000000000000000000001000000000000000000003300
        00006600000099000000CC000000FF0000000033000033330000663300009933
        0000CC330000FF33000000660000336600006666000099660000CC660000FF66
        000000990000339900006699000099990000CC990000FF99000000CC000033CC
        000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF
        0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00
        330000333300333333006633330099333300CC333300FF333300006633003366
        33006666330099663300CC663300FF6633000099330033993300669933009999
        3300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC
        330000FF330033FF330066FF330099FF3300CCFF3300FFFF3300000066003300
        66006600660099006600CC006600FF0066000033660033336600663366009933
        6600CC336600FF33660000666600336666006666660099666600CC666600FF66
        660000996600339966006699660099996600CC996600FF99660000CC660033CC
        660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF
        6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00
        990000339900333399006633990099339900CC339900FF339900006699003366
        99006666990099669900CC669900FF6699000099990033999900669999009999
        9900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC
        990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300
        CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933
        CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66
        CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CC
        CC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FF
        CC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00
        FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366
        FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999
        FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCC
        FF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF00000080000080
        000000808000800000008000800080800000C0C0C00080808000191919004C4C
        4C00B2B2B200E5E5E5005A1E1E00783C3C0096646400C8969600FFC8C800465F
        82005591B9006EB9D7008CD2E600B4E6F000D8E9EC0099A8AC00646F7100E2EF
        F100C56A31000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000EEEEEEEEEEEE
        EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
        EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE180C
        EEEEEEEEEEEEEEEEEEEEEEEEEEEEE2DFEEEEEEEEEEEEEEEEEEEEEEEEEE181212
        0CEEEEEEEEEEEEEEEEEEEEEEEEE28181DFEEEEEEEEEEEEEEEEEEEEEE18121212
        120CEEEEEEEEEEEEEEEEEEEEE281818181DFEEEEEEEEEEEEEEEEEE1812121212
        12120CEEEEEEEEEEEEEEEEE2818181818181DFEEEEEEEEEEEEEEEE1812120C18
        1212120CEEEEEEEEEEEEEEE28181DFE2818181DFEEEEEEEEEEEEEE18120CEEEE
        181212120CEEEEEEEEEEEEE281DFEEEEE2818181DFEEEEEEEEEEEE180CEEEEEE
        EE181212120CEEEEEEEEEEE2DFEEEEEEEEE2818181DFEEEEEEEEEEEEEEEEEEEE
        EEEE181212120CEEEEEEEEEEEEEEEEEEEEEEE2818181DFEEEEEEEEEEEEEEEEEE
        EEEEEE181212120CEEEEEEEEEEEEEEEEEEEEEEE2818181DFEEEEEEEEEEEEEEEE
        EEEEEEEE181212120CEEEEEEEEEEEEEEEEEEEEEEE2818181DFEEEEEEEEEEEEEE
        EEEEEEEEEE1812120CEEEEEEEEEEEEEEEEEEEEEEEEE28181DFEEEEEEEEEEEEEE
        EEEEEEEEEEEE18120CEEEEEEEEEEEEEEEEEEEEEEEEEEE281DFEEEEEEEEEEEEEE
        EEEEEEEEEEEEEE180CEEEEEEEEEEEEEEEEEEEEEEEEEEEEE2DFEEEEEEEEEEEEEE
        EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE}
      NumGlyphs = 2
    end
    object rzbtbtn2: TRzBitBtn
      Left = 299
      Top = 201
      Caption = #20851#38381
      TabOrder = 12
      Kind = bkCancel
    end
    object edtArea: TRzEdit
      Left = 209
      Top = 136
      Width = 118
      Height = 20
      Color = clInfoBk
      ImeName = #35895#27468#25340#38899#36755#20837#27861' 2'
      ReadOnly = True
      TabOrder = 9
    end
    object edtMemo: TRzEdit
      Left = 48
      Top = 167
      Width = 432
      Height = 20
      ImeName = #35895#27468#25340#38899#36755#20837#27861' 2'
      TabOnEnter = True
      TabOrder = 6
    end
    object edtUnitPrice: TRzEdit
      Left = 208
      Top = 109
      Width = 118
      Height = 20
      ImeName = #35895#27468#25340#38899#36755#20837#27861' 2'
      TabOnEnter = True
      TabOrder = 5
      OnChange = edtLengthChange
      OnKeyPress = edtLengthKeyPress
    end
    object edtTotalAmount: TRzEdit
      Left = 362
      Top = 136
      Width = 118
      Height = 20
      Color = clInfoBk
      ImeName = #35895#27468#25340#38899#36755#20837#27861' 2'
      ReadOnly = True
      TabOrder = 10
    end
    object btnMultSave: TRzBitBtn
      Left = 112
      Top = 202
      Width = 94
      Action = actMultSave
      Caption = #20445#23384#24182#32487#32493
      TabOrder = 7
    end
  end
  object actlst1: TActionList
    Left = 368
    Top = 120
    object actMultSave: TAction
      Caption = #20445#23384#24182#32487#32493
      OnExecute = actMultSaveExecute
    end
    object actSave: TAction
      Caption = #20445#23384
      OnExecute = actSaveExecute
    end
  end
end
