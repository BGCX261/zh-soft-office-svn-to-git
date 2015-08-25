object DataMainBase: TDataMainBase
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Left = 86
  Top = 68
  Height = 347
  Width = 481
  object PubDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'PubDataSetProvider'
    Left = 144
    Top = 88
  end
  object PubDataSetProvider: TDataSetProvider
    DataSet = PubQuery
    Left = 48
    Top = 88
  end
  object PubQuery: TADOQuery
    EnableBCD = False
    Parameters = <>
    Left = 208
    Top = 88
  end
  object SaveDataSetProvider: TDataSetProvider
    DataSet = PubQuery
    OnUpdateError = SaveDataSetProviderUpdateError
    Left = 48
    Top = 24
  end
  object SaveDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'PubDataSetProvider'
    Left = 144
    Top = 24
  end
end
