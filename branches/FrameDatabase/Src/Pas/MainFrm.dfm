object MainForm: TMainForm
  Left = 572
  Top = 210
  Width = 432
  Height = 353
  Caption = 'MainForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object cxgrd1: TcxGrid
    Left = 0
    Top = 16
    Width = 250
    Height = 200
    TabOrder = 0
    object cxgrd1DBTableView1: TcxGridDBTableView
      NavigatorButtons.ConfirmDelete = False
      DataController.DataSource = ds2
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
    end
    object cxgrdlvlGrid1Level1: TcxGridLevel
      GridView = cxgrd1DBTableView1
    end
  end
  object rzbtbtn1: TRzBitBtn
    Left = 184
    Top = 256
    Caption = 'rzbtbtn1'
    TabOrder = 1
    OnClick = rzbtbtn1Click
  end
  object ds1: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 312
    Top = 40
  end
  object ds2: TDataSource
    DataSet = ds1
    Left = 328
    Top = 80
  end
end
