program NFE;

uses
  Vcl.Forms,
  Vendas in 'Vendas.pas' {FrmVendas},
  Modulo in 'Modulo.pas' {dm: TDataModule},
  Certificado in 'Certificado.pas' {FrmCertificado};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmVendas, FrmVendas);
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(TFrmCertificado, FrmCertificado);
  Application.Run;
end.
