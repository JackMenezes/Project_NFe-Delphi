unit Modulo;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet;

type
  Tdm = class(TDataModule)
    fd: TFDConnection;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    tb_vendas: TFDTable;
    tb_vendasnumero: TFDAutoIncField;
    tb_vendasdata: TDateTimeField;
    tb_vendasvalor: TBCDField;
    tb_vendasforma_pgto: TStringField;
    query_vendas: TFDQuery;
    query_vendasnumero: TFDAutoIncField;
    query_vendasdata: TDateTimeField;
    query_vendasvalor: TBCDField;
    query_vendasforma_pgto: TStringField;
    ds_vendas: TDataSource;
    tb_det_vendas: TFDTable;
    tb_det_vendascodigo: TFDAutoIncField;
    tb_det_vendasnumero_venda: TIntegerField;
    tb_det_vendasproduto: TStringField;
    tb_det_vendasquantidade: TIntegerField;
    tb_det_vendasvalor_unitario: TBCDField;
    tb_det_vendasvalor_total: TBCDField;
    query_det_vendas: TFDQuery;
    query_det_vendascodigo: TFDAutoIncField;
    query_det_vendasnumero_venda: TIntegerField;
    query_det_vendasproduto: TStringField;
    query_det_vendasquantidade: TIntegerField;
    query_det_vendasvalor_unitario: TBCDField;
    query_det_vendasvalor_total: TBCDField;
    ds_det_vendas: TDataSource;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dm: Tdm;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
