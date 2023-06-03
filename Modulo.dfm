object dm: Tdm
  OldCreateOrder = False
  Height = 294
  Width = 503
  object fd: TFDConnection
    Params.Strings = (
      'Database=nfe'
      'User_Name=root'
      'DriverID=MySQL')
    LoginPrompt = False
    Left = 48
    Top = 64
  end
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    Left = 360
    Top = 8
  end
  object tb_vendas: TFDTable
    IndexFieldNames = 'numero'
    Connection = fd
    UpdateOptions.UpdateTableName = 'nfe.vendas'
    TableName = 'nfe.vendas'
    Left = 120
    Top = 56
    object tb_vendasnumero: TFDAutoIncField
      FieldName = 'numero'
      Origin = 'numero'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object tb_vendasdata: TDateTimeField
      FieldName = 'data'
      Origin = 'data'
      Required = True
    end
    object tb_vendasvalor: TBCDField
      FieldName = 'valor'
      Origin = 'valor'
      Required = True
      Precision = 10
      Size = 2
    end
    object tb_vendasforma_pgto: TStringField
      FieldName = 'forma_pgto'
      Origin = 'forma_pgto'
      Required = True
      Size = 25
    end
  end
  object query_vendas: TFDQuery
    Connection = fd
    SQL.Strings = (
      'select * from vendas')
    Left = 120
    Top = 112
    object query_vendasnumero: TFDAutoIncField
      FieldName = 'numero'
      Origin = 'numero'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object query_vendasdata: TDateTimeField
      FieldName = 'data'
      Origin = 'data'
      Required = True
    end
    object query_vendasvalor: TBCDField
      FieldName = 'valor'
      Origin = 'valor'
      Required = True
      Precision = 10
      Size = 2
    end
    object query_vendasforma_pgto: TStringField
      FieldName = 'forma_pgto'
      Origin = 'forma_pgto'
      Required = True
      Size = 25
    end
  end
  object ds_vendas: TDataSource
    DataSet = query_vendas
    Left = 120
    Top = 168
  end
  object tb_det_vendas: TFDTable
    IndexFieldNames = 'codigo'
    Connection = fd
    UpdateOptions.UpdateTableName = 'nfe.detalhes_vendas'
    TableName = 'nfe.detalhes_vendas'
    Left = 208
    Top = 56
    object tb_det_vendascodigo: TFDAutoIncField
      FieldName = 'codigo'
      Origin = 'codigo'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object tb_det_vendasnumero_venda: TIntegerField
      FieldName = 'numero_venda'
      Origin = 'numero_venda'
      Required = True
    end
    object tb_det_vendasproduto: TStringField
      FieldName = 'produto'
      Origin = 'produto'
      Required = True
      Size = 30
    end
    object tb_det_vendasquantidade: TIntegerField
      FieldName = 'quantidade'
      Origin = 'quantidade'
      Required = True
    end
    object tb_det_vendasvalor_unitario: TBCDField
      FieldName = 'valor_unitario'
      Origin = 'valor_unitario'
      Required = True
      Precision = 10
      Size = 2
    end
    object tb_det_vendasvalor_total: TBCDField
      FieldName = 'valor_total'
      Origin = 'valor_total'
      Required = True
      Precision = 10
      Size = 2
    end
  end
  object query_det_vendas: TFDQuery
    Connection = fd
    SQL.Strings = (
      'select * from detalhes_vendas')
    Left = 208
    Top = 112
    object query_det_vendascodigo: TFDAutoIncField
      FieldName = 'codigo'
      Origin = 'codigo'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object query_det_vendasnumero_venda: TIntegerField
      FieldName = 'numero_venda'
      Origin = 'numero_venda'
      Required = True
    end
    object query_det_vendasproduto: TStringField
      FieldName = 'produto'
      Origin = 'produto'
      Required = True
      Size = 30
    end
    object query_det_vendasquantidade: TIntegerField
      FieldName = 'quantidade'
      Origin = 'quantidade'
      Required = True
    end
    object query_det_vendasvalor_unitario: TBCDField
      FieldName = 'valor_unitario'
      Origin = 'valor_unitario'
      Required = True
      Precision = 10
      Size = 2
    end
    object query_det_vendasvalor_total: TBCDField
      FieldName = 'valor_total'
      Origin = 'valor_total'
      Required = True
      Precision = 10
      Size = 2
    end
  end
  object ds_det_vendas: TDataSource
    DataSet = query_det_vendas
    Left = 208
    Top = 168
  end
end
