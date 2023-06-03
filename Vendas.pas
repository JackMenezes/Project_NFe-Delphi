unit Vendas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ACBrBase, ACBrDFe, ACBrNFe, Vcl.StdCtrls, ACBrUtil,
  Data.DB, Vcl.Buttons, Vcl.Grids, Vcl.DBGrids, ACBrNFeNotasFiscais, pcnConversao, pcnConversaoNFe,
  ACBrNFSe, pcnNFe, pnfsConversao, System.Math;

type
  TFrmVendas = class(TForm)
    nfe: TACBrNFe;
    nfce: TACBrNFe;
    btnCerfificado: TButton;
    Button1: TButton;
    Label2: TLabel;
    EdtNome: TEdit;
    Label5: TLabel;
    EdtValor: TEdit;
    Label4: TLabel;
    EdtQuantidade: TEdit;
    gridVendas: TDBGrid;
    btnAddItem: TSpeedButton;
    btnNovo: TSpeedButton;
    btnSalvar: TSpeedButton;
    btnRelatorio: TSpeedButton;
    grid: TDBGrid;
    Label1: TLabel;
    lblTotalVenda: TLabel;
    EdtCodigoVenda: TEdit;
    edtCodigo: TEdit;
    nfse: TACBrNFSe;
    Button2: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnCerfificadoClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btnAddItemClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure gridVendasCellClick(Column: TColumn);
    procedure btnRelatorioClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    function RoundTo5(Valor: Double; Casas: Integer): Double;
  private
    { Private declarations }
    procedure IniciarNFE;

      procedure associarCampos;
     procedure associarCamposVenda;
    procedure buscarTudo;
    procedure buscarTudoVendas;

    procedure gerarNFCe;
    procedure gerarNFSe;
    procedure AlimentarComponente(NumNFSe, NumLote: String);



  public
    { Public declarations }
  end;

var
  FrmVendas: TFrmVendas;
  i : integer;
  serie : string;
  addLinha : boolean;
  certificadoDig : string;


  total_venda: real;
  ultimoId: integer;
implementation

{$R *.dfm}

uses Certificado, Modulo;

{ TForm1 }

procedure TFrmVendas.AlimentarComponente(NumNFSe, NumLote: String);
var
  ValorISS: Double;
begin
  with nfse do
  begin
    // Provedor ISSNet sem certificado
    Configuracoes.Geral.Emitente.WebChaveAcesso := 'A001.B0001.C0001-1';

    with Configuracoes.Geral.Emitente.DadosSenhaParams.Add do
    begin
      Param := 'ChaveAutorizacao';
      Conteudo := 'A001.B0001.C0001-1';
    end;

    NotasFiscais.NumeroLote := NumLote;
    NotasFiscais.Transacao := True;

    with NotasFiscais.Add.NFSe do
    begin
      NumeroLote := NumLote;

      IdentificacaoRps.Numero := FormatFloat('#########0', StrToInt(NumNFSe));

      // Para o provedor ISS.NET em ambiente de Homologação mudar a série para '8'
      IdentificacaoRps.Serie := 'NF';

      // TnfseTipoRPS = ( trRPS, trNFConjugada, trCupom );
      IdentificacaoRps.Tipo := trRPS;

      DataEmissao := Now;
      DataEmissaoRPS := Now;
      (*
        TnfseNaturezaOperacao = ( no1, no2, no3, no4, no5, no6, no7,
        no50, no51, no52, no53, no54, no55, no56, no57, no58, no59,
        no60, no61, no62, no63, no64, no65, no66, no67, no68, no69,
        no70, no71, no72, no78, no79,
        no101, no111, no121, no201, no301,
        no501, no511, no541, no551, no601, no701 );
      *)
      NaturezaOperacao := no1;
      // NaturezaOperacao := no51;

      // TnfseRegimeEspecialTributacao = ( retNenhum, retMicroempresaMunicipal, retEstimativa, retSociedadeProfissionais, retCooperativa, retMicroempresarioIndividual, retMicroempresarioEmpresaPP );
      // RegimeEspecialTributacao := retNenhum;
      RegimeEspecialTributacao := retSimplesNacional;

      // TnfseSimNao = ( snSim, snNao );
      OptanteSimplesNacional := snSim;

      // TnfseSimNao = ( snSim, snNao );
      IncentivadorCultural := snNao;

      // TnfseSimNao = ( snSim, snNao );
      // snSim = Ambiente de Produção
      // snNao = Ambiente de Homologação
      Producao := snSim;

      // TnfseStatusRPS = ( srNormal, srCancelado );
      Status := srNormal;

      // Somente Os provedores Betha, FISSLex e SimplISS permitem incluir no RPS
      // a TAG: OutrasInformacoes os demais essa TAG é gerada e preenchida pelo
      // WebService do provedor.
      OutrasInformacoes := 'Pagamento a Vista';

      // Usado quando o RPS for substituir outro
      // RpsSubstituido.Numero := FormatFloat('#########0', i);
      // RpsSubstituido.Serie  := 'UNICA';
      // TnfseTipoRPS = ( trRPS, trNFConjugada, trCupom );
      /// RpsSubstituido.Tipo   := trRPS;

      Servico.Valores.ValorServicos :=  20.00;
      Servico.Valores.ValorDeducoes := 0.00;
      Servico.Valores.ValorPis := 0.00;
      Servico.Valores.ValorCofins := 0.00;
      Servico.Valores.ValorInss := 0.00;
      Servico.Valores.ValorIr := 0.00;
      Servico.Valores.ValorCsll := 0.00;

      // TnfseSituacaoTributaria = ( stRetencao, stNormal, stSubstituicao );
      // stRetencao = snSim
      // stNormal   = snNao

      // Neste exemplo não temos ISS Retido ( stNormal = Não )
      // Logo o valor do ISS Retido é igual a zero.
      Servico.Valores.IssRetido := stNormal;
      Servico.Valores.ValorIssRetido := 0.00;

      Servico.Valores.OutrasRetencoes := 0.00;
      Servico.Valores.DescontoIncondicionado := 0.00;
      Servico.Valores.DescontoCondicionado := 0.00;

      Servico.Valores.BaseCalculo := Servico.Valores.ValorServicos -
        Servico.Valores.ValorDeducoes - Servico.Valores.DescontoIncondicionado;
      // No caso do provedor Ginfes devemos informar a aliquota já dividida por 100
      // para outros provedores devemos informar por exemplo 3, mas ao fazer o calculo
      // do valor do ISS devemos dividir por 100
      Servico.Valores.Aliquota := 4;

      // Valor do ISS calculado multiplicando-se a base de calculo pela aliquota
      ValorISS := Servico.Valores.BaseCalculo * Servico.Valores.Aliquota / 100;

      // A função RoundTo5 é usada para arredondar valores, sendo que o segundo
      // parametro se refere ao numero de casas decimais.
      // exemplos: RoundTo5(50.532, -2) ==> 50.53
      // exemplos: RoundTo5(50.535, -2) ==> 50.54
      // exemplos: RoundTo5(50.536, -2) ==> 50.54

      Servico.Valores.ValorISS := RoundTo5(ValorISS, -2);

      Servico.Valores.ValorLiquidoNfse := Servico.Valores.ValorServicos -
        Servico.Valores.ValorPis - Servico.Valores.ValorCofins -
        Servico.Valores.ValorInss - Servico.Valores.ValorIr -
        Servico.Valores.ValorCsll - Servico.Valores.OutrasRetencoes -
        Servico.Valores.ValorIssRetido - Servico.Valores.DescontoIncondicionado
        - Servico.Valores.DescontoCondicionado;

      // TnfseResponsavelRetencao = ( ptTomador, rtPrestador );
      Servico.ResponsavelRetencao := ptTomador;

      Servico.ItemListaServico := '09.01';
      Servico.CodigoCnae := '852010';

      // Usado pelo provedor de Belo Horizonte
      Servico.CodigoTributacaoMunicipio := '3106200';

      // Para o provedor ISS.NET em ambiente de Homologação
      // o Codigo CNAE tem que ser '6511102'
      // Servico.CodigoCnae                := '123'; // Informação Opcional
      // Servico.CodigoTributacaoMunicipio := '3314799';
      Servico.Discriminacao := 'discriminacao I;discriminacao II';

      // Para o provedor ISS.NET em ambiente de Homologação
      // o Codigo do Municipio tem que ser '999'
      Servico.CodigoMunicipio := '3106200';

      // Informar A Exigibilidade ISS para fintelISS [1/2/3/4/5/6/7]
      Servico.ExigibilidadeISS := exiExigivel;

      // Informar para Saatri
      Servico.CodigoPais := 1058; // Brasil
      Servico.MunicipioIncidencia := 3106200;

      // Somente o provedor SimplISS permite infomar mais de 1 serviço
      with Servico.ItemServico.Add do
      begin
        Descricao := 'SERVICO 1';
        Quantidade := 1;
        ValorUnitario := 20.00;
      end;

      Prestador.CNPJ := '18311776000198';
      Prestador.InscricaoMunicipal := '04909920012';

      // Para o provedor ISSDigital deve-se informar também:
      Prestador.Senha := '123456';
      Prestador.FraseSecreta := 'frase secreta';
      Prestador.cUF := 33;

      PrestadorServico.Endereco.CodigoMunicipio := '3106200';
      PrestadorServico.RazaoSocial := 'Q-Cursos';

      Tomador.IdentificacaoTomador.CpfCnpj := '26100568000178';
      Tomador.IdentificacaoTomador.InscricaoMunicipal := '';

      Tomador.RazaoSocial := 'INSCRICAO DE TESTE';

      Tomador.Endereco.Endereco := 'RUA PRINCIPAL';
      Tomador.Endereco.Numero := '100';
      Tomador.Endereco.Complemento := 'APTO 11';
      Tomador.Endereco.Bairro := 'CENTRO';
      Tomador.Endereco.CodigoMunicipio := '3106200';
      Tomador.Endereco.UF := 'MG';
      Tomador.Endereco.CodigoPais := 1058; // Brasil
      Tomador.Endereco.CEP := '30512660';
      // Provedor Equiplano é obrigatório o pais e IE
      Tomador.Endereco.xPais := 'BRASIL';
      Tomador.IdentificacaoTomador.InscricaoEstadual := '123456';

      Tomador.Contato.Telefone := '1122223333';
      Tomador.Contato.Email := 'nome@provedor.com.br';

      // Usado quando houver um intermediario na prestação do serviço
      // IntermediarioServico.RazaoSocial        := 'razao';
      // IntermediarioServico.CpfCnpj            := '00000000000';
      // IntermediarioServico.InscricaoMunicipal := '12547478';


      // Usado quando o serviço for uma obra
      // ConstrucaoCivil.CodigoObra := '88888';
      // ConstrucaoCivil.Art        := '433';

    end;

  end;

end;

procedure TFrmVendas.associarCampos;
begin
 dm.tb_det_vendas.FieldByName('produto').Value := edtNome.text;
 dm.tb_det_vendas.FieldByName('valor_unitario').Value := EdtValor.text;
 dm.tb_det_vendas.FieldByName('quantidade').Value := EdtQuantidade.text;
 dm.tb_det_vendas.FieldByName('valor_total').Value := strToFloat(EdtValor.text) * strToFloat(EdtQuantidade.text);
 dm.tb_det_vendas.FieldByName('numero_venda').Value := '0' ;





end;

procedure TFrmVendas.associarCamposVenda;
begin
 dm.tb_vendas.FieldByName('data').Value := DateToStr(Date);
 dm.tb_vendas.FieldByName('valor').Value := lblTotalVenda.Caption;
 dm.tb_vendas.FieldByName('forma_pgto').Value := 'Dinheiro';

end;

procedure TFrmVendas.btnAddItemClick(Sender: TObject);
begin
if (edtNome.Text <> '') and (edtQuantidade.Text > '0') then
begin

    dm.tb_det_vendas.Insert;
    associarCampos;
    dm.tb_det_vendas.Post;

    buscarTudo;

    total_venda := total_venda + dm.tb_det_vendas.FieldByName('valor_total').Value;
    lblTotalVenda.Caption := FormatFloat('R$ #,,,,0.00', total_venda);



end
else
begin
 MessageDlg('Selecione um produto e a quantidade', mtInformation, mbOKCancel, 0);
end;
end;

procedure TFrmVendas.btnCerfificadoClick(Sender: TObject);
begin
FrmCertificado := TFrmCertificado.Create(self);

try

  nfe.SSL.LerCertificadosStore;


  addLinha := true;

  with FrmCertificado.StringGrid1 do
  begin
     ColWidths[0] := 220;
     ColWidths[1] := 250;
     ColWidths[2] := 120;
     ColWidths[3] := 80;
     ColWidths[4] := 150;

     Cells[0,0] := 'Num Série';
     Cells[1,0] := 'Razão Social';
     Cells[2,0] := 'CNPJ';
     Cells[3,0] := 'Validade';
     Cells[4,0] := 'Certificadora';

  end;

  for i := 0 to nfe.SSL.ListaCertificados.Count -1 do
  begin

  with nfe.SSL.ListaCertificados[i] do
  begin
  serie := NumeroSerie;


  with FrmCertificado.StringGrid1 do
  begin

  if addLinha then
  begin

     RowCount := RowCount + 1;


     Cells[0, RowCount - 1] := NumeroSerie;
     Cells[1, RowCount - 1] := RazaoSocial;
     Cells[2, RowCount - 1] := CNPJ;
     Cells[3, RowCount - 1] := FormatDateBr(DataVenc);
     Cells[4, RowCount - 1] := Certificadora;
     addLinha := true;

  end;




  end;


  end;

  end;



FrmCertificado.ShowModal;
if FrmCertificado.ModalResult = mrOk then
begin
  certificadoDig := FrmCertificado.StringGrid1.Cells[0, FrmCertificado.StringGrid1.Row];

end;

 nfe.Configuracoes.Certificados.NumeroSerie := certificadoDig;

  nfe.WebServices.StatusServico.Executar;
  ShowMessage(certificadoDig);
  ShowMessage(nfe.WebServices.StatusServico.Msg);




finally
FrmCertificado.Free;
end;

end;

procedure TFrmVendas.btnRelatorioClick(Sender: TObject);
var
  vNumRPS, sNomeArq: String;
begin
gerarNFCe;
//gerarNFSe;

end;

procedure TFrmVendas.btnSalvarClick(Sender: TObject);
begin
if lblTotalVenda.Caption > '0' then
begin
    dm.tb_vendas.Insert;
    associarCamposVenda;
    dm.tb_vendas.Post;
    MessageDlg('Venda Salva com sucesso!', mtInformation, mbOKCancel, 0);




    {RELACIONAR O ID DA VENDA AOS ITENS}
      dm.query_vendas.Close;
      dm.query_vendas.SQL.Clear;
     dm.query_vendas.SQL.Add('select * from vendas order by numero desc') ;
     dm.query_vendas.Open;

      ultimoId := dm.query_vendas['numero'];
      EdtCodigoVenda.Text := ultimoId.ToString;


             dm.query_det_vendas.Close;
              dm.query_det_vendas.SQL.Clear;
              dm.query_det_vendas.SQL.Add('update detalhes_vendas set numero_venda = :id where numero_venda = 0');
              dm.query_det_vendas.ParamByName('id').Value :=  ultimoId;
               dm.query_det_vendas.ExecSQL;



    buscarTudoVendas;

    lblTotalVenda.Caption := '0';
    total_venda := 0;


    gridVendas.Enabled := true;
grid.Enabled := false;

    end
    else
    begin
    MessageDlg('Adicione produtos a venda', mtInformation, mbOKCancel, 0);
end;

end;

procedure TFrmVendas.buscarTudo;
begin
   TFloatField(dm.query_det_vendas.FieldByName('valor_unitario')).DisplayFormat:='R$ #,,,,0.00';
  TFloatField(dm.query_det_vendas.FieldByName('valor_total')).DisplayFormat:='R$ #,,,,0.00';


grid.Visible := true;
 gridVendas.Visible := false;
dm.query_det_vendas.Close;
  dm.query_det_vendas.SQL.Clear;
 dm.query_det_vendas.SQL.Add('select * from detalhes_vendas WHERE numero_venda = 0 order by codigo desc') ;
  dm.query_det_vendas.Open;
end;

procedure TFrmVendas.buscarTudoVendas;
begin
       TFloatField(dm.query_vendas.FieldByName('valor')).DisplayFormat:='R$ #,,,,0.00';

 grid.Visible := false;
 gridVendas.Visible := True;
 dm.query_vendas.Close;
  dm.query_vendas.SQL.Clear;
  dm.query_vendas.SQL.Add('select * from vendas where data = curDate() order by numero desc') ;
  dm.query_vendas.Open;
end;

procedure TFrmVendas.Button1Click(Sender: TObject);
begin
FrmCertificado := TFrmCertificado.Create(self);

try

  nfce.SSL.LerCertificadosStore;


  addLinha := true;

  with FrmCertificado.StringGrid1 do
  begin
     ColWidths[0] := 220;
     ColWidths[1] := 250;
     ColWidths[2] := 120;
     ColWidths[3] := 80;
     ColWidths[4] := 150;

     Cells[0,0] := 'Num Série';
     Cells[1,0] := 'Razão Social';
     Cells[2,0] := 'CNPJ';
     Cells[3,0] := 'Validade';
     Cells[4,0] := 'Certificadora';

  end;

  for i := 0 to nfce.SSL.ListaCertificados.Count -1 do
  begin

  with nfce.SSL.ListaCertificados[i] do
  begin
  serie := NumeroSerie;


  with FrmCertificado.StringGrid1 do
  begin

  if addLinha then
  begin

     RowCount := RowCount + 1;


     Cells[0, RowCount - 1] := NumeroSerie;
     Cells[1, RowCount - 1] := RazaoSocial;
     Cells[2, RowCount - 1] := CNPJ;
     Cells[3, RowCount - 1] := FormatDateBr(DataVenc);
     Cells[4, RowCount - 1] := Certificadora;
     addLinha := true;

  end;




  end;


  end;
end;

FrmCertificado.ShowModal;
if FrmCertificado.ModalResult = mrOk then
begin
  certificadoDig := FrmCertificado.StringGrid1.Cells[0, FrmCertificado.StringGrid1.Row];

end;

 nfce.Configuracoes.Certificados.NumeroSerie := certificadoDig;

  nfce.WebServices.StatusServico.Executar;
  ShowMessage(certificadoDig);
  ShowMessage(nfce.WebServices.StatusServico.Msg);




finally
FrmCertificado.Free;
end;
end;

procedure TFrmVendas.Button2Click(Sender: TObject);
begin
FrmCertificado := TFrmCertificado.Create(self);

try

  nfse.SSL.LerCertificadosStore;


  addLinha := true;

  with FrmCertificado.StringGrid1 do
  begin
     ColWidths[0] := 220;
     ColWidths[1] := 250;
     ColWidths[2] := 120;
     ColWidths[3] := 80;
     ColWidths[4] := 150;

     Cells[0,0] := 'Num Série';
     Cells[1,0] := 'Razão Social';
     Cells[2,0] := 'CNPJ';
     Cells[3,0] := 'Validade';
     Cells[4,0] := 'Certificadora';

  end;

  for i := 0 to nfse.SSL.ListaCertificados.Count -1 do
  begin

  with nfse.SSL.ListaCertificados[i] do
  begin
  serie := NumeroSerie;


  with FrmCertificado.StringGrid1 do
  begin

  if addLinha then
  begin

     RowCount := RowCount + 1;


     Cells[0, RowCount - 1] := NumeroSerie;
     Cells[1, RowCount - 1] := RazaoSocial;
     Cells[2, RowCount - 1] := CNPJ;
     Cells[3, RowCount - 1] := FormatDateBr(DataVenc);
     Cells[4, RowCount - 1] := Certificadora;
     addLinha := true;

  end;




  end;


  end;
end;

FrmCertificado.ShowModal;
if FrmCertificado.ModalResult = mrOk then
begin
  certificadoDig := FrmCertificado.StringGrid1.Cells[0, FrmCertificado.StringGrid1.Row];

end;

 nfse.Configuracoes.Certificados.NumeroSerie := certificadoDig;

  //nfse.WebServices
  ShowMessage(certificadoDig);





finally
FrmCertificado.Free;
end;

end;

procedure TFrmVendas.FormShow(Sender: TObject);
begin
IniciarNFE;



lblTotalVenda.Caption := FormatFloat('R$ #,,,,0.00', strToFloat(lblTotalVenda.Caption));


dm.tb_vendas.Active := False;
dm.tb_vendas.Active := True;
dm.tb_det_vendas.Active := False;
dm.tb_det_vendas.Active := True;

 buscarTudoVendas;


end;






procedure TFrmVendas.gerarNFCe;
Var NotaF: NotaFiscal;
item : integer;
Produto: TDetCollectionItem;
InfoPgto: TpagCollectionItem;

begin
nfce.NotasFiscais.Clear;
NotaF := nfce.NotasFiscais.Add;


  //DADOS DA NOTA FISCAL

  NotaF.NFe.Ide.natOp     := 'VENDA';
  NotaF.NFe.Ide.indPag    := ipVista;
  NotaF.NFe.Ide.modelo    := 65;
  NotaF.NFe.Ide.serie     := 1;
  NotaF.NFe.Ide.nNF       := StrToInt(EdtCodigoVenda.Text);
  NotaF.NFe.Ide.dEmi      := Date;
  NotaF.NFe.Ide.dSaiEnt   := Date;
  NotaF.NFe.Ide.hSaiEnt   := Now;
  NotaF.NFe.Ide.tpNF      := tnSaida;
  NotaF.NFe.Ide.tpEmis    := teNormal;
  NotaF.NFe.Ide.tpAmb     := taHomologacao;  //Lembre-se de trocar esta variável quando for para ambiente de produção
  NotaF.NFe.Ide.verProc   := '1.0.0.0'; //Versão do seu sistema
  NotaF.NFe.Ide.cUF       := 31;
  NotaF.NFe.Ide.cMunFG    := 0624123;
  NotaF.NFe.Ide.finNFe    := fnNormal;


  //DADOS DO EMITENTE

  NotaF.NFe.Emit.CNPJCPF           := '18311776000198';
  NotaF.NFe.Emit.IE                := '';
  NotaF.NFe.Emit.xNome             := 'Q-Cursos Networks';
  NotaF.NFe.Emit.xFant             := 'Q-Cursos';

  NotaF.NFe.Emit.EnderEmit.fone    := '(31)3333-3333';
  NotaF.NFe.Emit.EnderEmit.CEP     := 30512660;
  NotaF.NFe.Emit.EnderEmit.xLgr    := 'Rua A';
  NotaF.NFe.Emit.EnderEmit.nro     := '325';
  NotaF.NFe.Emit.EnderEmit.xCpl    := '';
  NotaF.NFe.Emit.EnderEmit.xBairro := 'Santa Monica';
  NotaF.NFe.Emit.EnderEmit.cMun    := 0624123;
  NotaF.NFe.Emit.EnderEmit.xMun    := 'Belo Horizonte';
  NotaF.NFe.Emit.EnderEmit.UF      := 'MG';
  NotaF.NFe.Emit.enderEmit.cPais   := 1058;
  NotaF.NFe.Emit.enderEmit.xPais   := 'BRASIL';

  NotaF.NFe.Emit.IEST              := '';
 // NotaF.NFe.Emit.IM                := '2648800'; // Preencher no caso de existir serviços na nota
  //NotaF.NFe.Emit.CNAE              := '6201500'; // Verifique na cidade do emissor da NFe se é permitido
                                // a inclusão de serviços na NFe
  NotaF.NFe.Emit.CRT               := crtSimplesNacional;// (1-crtSimplesNacional, 2-crtSimplesExcessoReceita, 3-crtRegimeNormal)



  //DADOS DO DESTINATÁRIO

   NotaF.NFe.Dest.CNPJCPF           := '05481336000137';
  NotaF.NFe.Dest.IE                := '687138770110';
  NotaF.NFe.Dest.ISUF              := '';
  NotaF.NFe.Dest.xNome             := 'D.J. COM. E LOCAÇÃO DE SOFTWARES LTDA - ME';

//
//  NotaF.NFe.Dest.EnderDest.Fone    := '1532599600';
//  NotaF.NFe.Dest.EnderDest.CEP     := 18270170;
//  NotaF.NFe.Dest.EnderDest.xLgr    := 'Rua Coronel Aureliano de Camargo';
//  NotaF.NFe.Dest.EnderDest.nro     := '973';
//  NotaF.NFe.Dest.EnderDest.xCpl    := '';
//  NotaF.NFe.Dest.EnderDest.xBairro := 'Centro';
//  NotaF.NFe.Dest.EnderDest.cMun    := 3554003;
//  NotaF.NFe.Dest.EnderDest.xMun    := 'Tatui';
//  NotaF.NFe.Dest.EnderDest.UF      := 'SP';
//  NotaF.NFe.Dest.EnderDest.cPais   := 1058;
//  NotaF.NFe.Dest.EnderDest.xPais   := 'BRASIL';



  //ITENS DA VENDA NA NOTA

  //RELACIONANDO OS ITENS COM A  VENDA
  item := 1;
  dm.query_det_vendas.Close;
  dm.query_det_vendas.SQL.Clear;
  dm.query_det_vendas.SQL.Add('select * from detalhes_vendas WHERE numero_venda = :num order by codigo asc') ;
  dm.query_det_vendas.ParamByName('num').Value :=  EdtCodigoVenda.Text;
  dm.query_det_vendas.Open;
   dm.query_det_vendas.First;

   while not dm.query_det_vendas.eof do
   begin
  Produto := NotaF.NFe.Det.New;
  Produto.Prod.nItem    := item; // Número sequencial, para cada item deve ser incrementado
  Produto.Prod.cProd    := '123456';
  Produto.Prod.cEAN     := '7896523206646';
  Produto.Prod.xProd    := dm.query_det_vendas.FieldByName('produto').Value;
  Produto.Prod.NCM      := '94051010'; // Tabela NCM disponível em  http://www.receita.fazenda.gov.br/Aliquotas/DownloadArqTIPI.htm
  Produto.Prod.EXTIPI   := '';
  Produto.Prod.CFOP     := '5101';
  Produto.Prod.uCom     := 'UN';
  Produto.Prod.qCom     := dm.query_det_vendas.FieldByName('quantidade').Value;
  Produto.Prod.vUnCom   := dm.query_det_vendas.FieldByName('valor_unitario').Value;
  Produto.Prod.vProd    := dm.query_det_vendas.FieldByName('valor_total').Value;


  //INFORMAÇÕES DE IMPOSTOS SOBRE OS PRODUTOS
  Produto.Prod.cEANTrib  := '7896523206646';
  Produto.Prod.uTrib     := 'UN';
  Produto.Prod.qTrib     := 1;
  Produto.Prod.vUnTrib   := 100;

  Produto.Prod.vOutro    := 0;
  Produto.Prod.vFrete    := 0;
  Produto.Prod.vSeg      := 0;
  Produto.Prod.vDesc     := 0;

  Produto.Prod.CEST := '1111111';

  Produto.infAdProd := 'Informacao Adicional do Produto';


   // lei da transparencia nos impostos
  Produto.Imposto.vTotTrib := 0;
  Produto.Imposto.ICMS.CST          := cst00;
  Produto.Imposto.ICMS.orig    := oeNacional;
  Produto.Imposto.ICMS.modBC   := dbiValorOperacao;
  Produto.Imposto.ICMS.vBC     := 100;
  Produto.Imposto.ICMS.pICMS   := 18;
  Produto.Imposto.ICMS.vICMS   := 18;
  Produto.Imposto.ICMS.modBCST := dbisMargemValorAgregado;
  Produto.Imposto.ICMS.pMVAST  := 0;
  Produto.Imposto.ICMS.pRedBCST:= 0;
  Produto.Imposto.ICMS.vBCST   := 0;
  Produto.Imposto.ICMS.pICMSST := 0;
  Produto.Imposto.ICMS.vICMSST := 0;
  Produto.Imposto.ICMS.pRedBC  := 0;

       // partilha do ICMS e fundo de probreza
  Produto.Imposto.ICMSUFDest.vBCUFDest      := 0.00;
  Produto.Imposto.ICMSUFDest.pFCPUFDest     := 0.00;
  Produto.Imposto.ICMSUFDest.pICMSUFDest    := 0.00;
  Produto.Imposto.ICMSUFDest.pICMSInter     := 0.00;
  Produto.Imposto.ICMSUFDest.pICMSInterPart := 0.00;
  Produto.Imposto.ICMSUFDest.vFCPUFDest     := 0.00;
  Produto.Imposto.ICMSUFDest.vICMSUFDest    := 0.00;
  Produto.Imposto.ICMSUFDest.vICMSUFRemet   := 0.00;



  item := item + 1;
  dm.query_det_vendas.Next;
   end;

   //totalizando

    NotaF.NFe.Total.ICMSTot.vBC     := 100;
  NotaF.NFe.Total.ICMSTot.vICMS   := 18;
  NotaF.NFe.Total.ICMSTot.vBCST   := 0;
  NotaF.NFe.Total.ICMSTot.vST     := 0;
  NotaF.NFe.Total.ICMSTot.vProd   := dm.query_vendas.FieldByName('valor').Value;
  NotaF.NFe.Total.ICMSTot.vFrete  := 0;
  NotaF.NFe.Total.ICMSTot.vSeg    := 0;
  NotaF.NFe.Total.ICMSTot.vDesc   := 0;
  NotaF.NFe.Total.ICMSTot.vII     := 0;
  NotaF.NFe.Total.ICMSTot.vIPI    := 0;
  NotaF.NFe.Total.ICMSTot.vPIS    := 0;
  NotaF.NFe.Total.ICMSTot.vCOFINS := 0;
  NotaF.NFe.Total.ICMSTot.vOutro  := 0;
  NotaF.NFe.Total.ICMSTot.vNF     := 100;

    // lei da transparencia de impostos
  NotaF.NFe.Total.ICMSTot.vTotTrib := 0;

  // partilha do icms e fundo de probreza
  NotaF.NFe.Total.ICMSTot.vFCPUFDest   := 0.00;
  NotaF.NFe.Total.ICMSTot.vICMSUFDest  := 0.00;
  NotaF.NFe.Total.ICMSTot.vICMSUFRemet := 0.00;


  NotaF.NFe.Transp.modFrete := mfSemFrete;  //SEM FRETE

  // YA. Informações de pagamento

  InfoPgto := NotaF.NFe.pag.New;
  InfoPgto.indPag := ipVista;
  InfoPgto.tPag   := fpDinheiro;
  InfoPgto.vPag   := dm.query_vendas.FieldByName('valor').Value;

  nfce.NotasFiscais.Assinar;
  nfce.Enviar(Integer(EdtCodigoVenda.Text));
  ShowMessage(nfce.WebServices.StatusServico.Msg);

end;

procedure TFrmVendas.gerarNFSe;
var
vNumRPS, sNomeArq: String;
begin
vNumRPS := EdtCodigoVenda.Text;
nfse.NotasFiscais.Clear;
AlimentarComponente(vNumRPS, '1');

  nfse.Gerar(StrToInt(vNumRPS));
  sNomeArq := nfse.NotasFiscais.Items[0].NomeArq;

  nfse.NotasFiscais.Clear;
  nfse.NotasFiscais.LoadFromFile(sNomeArq);
  nfse.NotasFiscais.Imprimir;
end;

procedure TFrmVendas.gridVendasCellClick(Column: TColumn);
begin
 EdtCodigoVenda.Text := dm.query_vendas.FieldByName('numero').Value;
end;

procedure TFrmVendas.IniciarNFE;
var
caminhoNfe : string;
caminhoNfse : string;
begin
 caminhoNfe := ExtractFilePath(Application.ExeName) + 'nfe\';


 //PASTA ONDE ESTÁ O XML DAS NFE
 nfe.Configuracoes.Arquivos.PathSchemas := caminhoNfe;
 nfce.Configuracoes.Arquivos.PathSchemas := caminhoNfe;
 nfse.Configuracoes.Arquivos.PathSchemas := caminhoNfe;
end;



function TFrmVendas.RoundTo5(Valor: Double; Casas: Integer): Double;
var
  xValor, xDecimais: String;
  p, nCasas: Integer;
  nValor: Double;
begin
  nValor := Valor;
  xValor := Trim(FloatToStr(Valor));
  p := pos(',', xValor);
  if Casas < 0 then
    nCasas := -Casas
  else
    nCasas := Casas;
  if p > 0 then
  begin
    xDecimais := Copy(xValor, p + 1, Length(xValor));
    if Length(xDecimais) > nCasas then
    begin
      if xDecimais[nCasas + 1] >= '5' then
        SetRoundMode(rmUP)
      else
        SetRoundMode(rmNearest);
    end;
    nValor := RoundTo(Valor, Casas);
  end;
  Result := nValor;
end;



end.
