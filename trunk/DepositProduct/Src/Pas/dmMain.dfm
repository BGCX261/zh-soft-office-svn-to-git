object dm: Tdm
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Left = 502
  Top = 159
  Height = 233
  Width = 320
  object dsMain: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dtstprvdr'
    Left = 16
    Top = 32
  end
  object qryMain: TADOQuery
    Connection = conMain
    Parameters = <>
    Left = 64
    Top = 32
  end
  object conMain: TADOConnection
    KeepConnection = False
    Mode = cmShareDenyNone
    Provider = 'Microsoft.ACE.OLEDB.12.0'
    Left = 112
    Top = 40
  end
  object dtstprvdr: TDataSetProvider
    DataSet = qryMain
    Options = [poAllowCommandText]
    Left = 24
    Top = 88
  end
end
