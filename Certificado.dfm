object FrmCertificado: TFrmCertificado
  Left = 0
  Top = 0
  Caption = 'FrmCertificado'
  ClientHeight = 330
  ClientWidth = 610
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 285
    Width = 610
    Height = 45
    Align = alBottom
    TabOrder = 0
    ExplicitTop = 192
    ExplicitWidth = 658
    DesignSize = (
      610
      45)
    object BitBtn1: TBitBtn
      Left = 388
      Top = 5
      Width = 88
      Height = 30
      Anchors = [akTop, akRight]
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 0
      ExplicitLeft = 436
    end
    object BitBtn2: TBitBtn
      Left = 500
      Top = 6
      Width = 88
      Height = 30
      Anchors = [akTop, akRight]
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 1
      ExplicitLeft = 587
    end
  end
  object StringGrid1: TStringGrid
    Left = 0
    Top = 0
    Width = 610
    Height = 285
    Align = alClient
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goColSizing]
    TabOrder = 1
    ExplicitWidth = 658
    ExplicitHeight = 192
  end
end
