unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Mask, ExtCtrls,ShellAPI, Menus, IdMessage, IdSMTP,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, Registry,
  IdMessageClient, IdExplicitTLSClientServerBase, IdSMTPBase;
Const
  wm_IconMessage = wm_User;
type
  TForm1 = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    MaskEdit1: TMaskEdit;
    MaskEdit2: TMaskEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Timer1: TTimer;
    PopupMenu1: TPopupMenu;
    Configurar1: TMenuItem;
    Fechar1: TMenuItem;
    Label4: TLabel;
    Edit2: TEdit;
    IdSMTP: TIdSMTP;
    IdMessage: TIdMessage;
    Label5: TLabel;
    Edit3: TEdit;
    Label6: TLabel;
    Edit4: TEdit;
    Label7: TLabel;
    MaskEdit3: TMaskEdit;
    Label8: TLabel;
    Edit5: TEdit;
    Label9: TLabel;
    MaskEdit4: TMaskEdit;
    procedure BitBtn2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Configurar1Click(Sender: TObject);
    procedure Fechar1Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure EnviarEmail;
    function ExecAndWait(const FileName, Params: ShortString; const WinState: Word): boolean; export;
    procedure InicializarComWindows;
  private
    procedure IconTray (var Msg: TMessage);
    message wm_IconMessage;
 
  public
    { Public declarations }
     nid: TNotifyIconData;
     xEnviarEmail,xCliente : String;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.BitBtn2Click(Sender: TObject);
begin
  Form1.Close;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
Var
zHoraINI1, zHoraINI2,zHoraINI3, zHoraINI4  : String;
zHoraAtual : String;
begin

  zHoraINI1   := FormatDateTime('HH:MM',StrToDateTime(MaskEdit1.Text));
  zHoraINI2   := FormatDateTime('HH:MM',StrToDateTime(MaskEdit2.Text));
  zHoraINI3   := FormatDateTime('HH:MM',StrToDateTime(MaskEdit3.Text));
  zHoraINI4   := FormatDateTime('HH:MM',StrToDateTime(MaskEdit4.Text));

  zHoraAtual := FormatDateTime('HH:MM',Time);
  if (zHoraINI1 = zHoraAtual) then
    Begin
      if FileExists(Edit2.Text) then
        DeleteFile(Edit2.Text);

     if FileExists(Edit1.Text) then
      ExecAndWait(Edit1.Text , '', SW_HIDE); ;
     if (AnsiUpperCase(xEnviarEmail)='S') and(FileExists(Edit2.Text)) then
      EnviarEmail;

    end

   else if (zHoraINI2 =zHoraAtual) then
     Begin
       if FileExists(Edit2.Text) then
         DeleteFile(Edit2.Text);

       if FileExists(Edit3.Text) then
         ExecAndWait(Edit3.Text , '', SW_HIDE); ;
       if (AnsiUpperCase(xEnviarEmail)='S') and(FileExists(Edit2.Text)) then
          EnviarEmail;
     end

   else if  (zHoraINI3 = zHoraAtual) then
     Begin
        if FileExists(Edit2.Text) then
          DeleteFile(Edit2.Text);

        if FileExists(Edit4.Text) then
           ExecAndWait(Edit4.Text , '', SW_HIDE); ;
        if (AnsiUpperCase(xEnviarEmail)='S') and(FileExists(Edit2.Text)) then
          EnviarEmail;
     end
   else if (zHoraINI4 =zHoraAtual) then
    Begin
      if FileExists(Edit2.Text) then
        DeleteFile(Edit2.Text);

       if FileExists(Edit5.Text) then
         ExecAndWait(Edit1.Text , '', SW_HIDE); ;
       if (AnsiUpperCase(xEnviarEmail)='S') and(FileExists(Edit2.Text)) then
         EnviarEmail;

   end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  zCaminho,zLinha : string;
  zF : TextFile;

begin
  zCaminho := ExtractFilePath(Application.ExeName) + '\';
  if not FileExists(zCaminho  + 'Backup.ini') then
    begin
      Application.MessageBox('Arquivo de Configuração nao encontrado!','Atenção',MB_OK  + MB_ICONINFORMATION);
      Exit;

    end;
    AssignFile(zF,zCaminho  + 'backup.ini');
    Reset (zF);
    While not Eof(zF) do
      begin
       Readln(zF,zLinha);
       edit1.Text    := zLinha;
       Readln(zF,zLinha);
       edit3.Text    := zLinha;
       Readln(zF,zLinha);
       edit4.Text    := zLinha;
       Readln(zF,zLinha);
       edit5.Text    := zLinha;
       Readln(zF,zLinha);
       edit2.Text    := zLinha;

       Readln(zF,zLinha);
       MaskEdit1.Text := zLinha;
       Readln(zF,zLinha);
       MaskEdit2.Text := zLinha;

       Readln(zF,zLinha);
       MaskEdit3.Text := zLinha;
       Readln(zF,zLinha);
       MaskEdit4.Text := zLinha;

       Readln(zF,zLinha);
       xEnviarEmail  := zLinha;
       Readln(zF,zLinha);
       xCliente := zLinha;


      end;

    CloseFile(zF);
    Icon.Handle := LoadIcon (HInstance, 'MAINICON');
  // preenche os dados da estrutura NotifyIcon
    nid.cbSize := sizeof (nid);
    nid.wnd := Handle;
    nid.uID := 1; // Identificador do ícone
    nid.uCallBAckMessage := wm_IconMessage;
    nid.hIcon := Icon.Handle;
    nid.szTip := 'SBackup';
    nid.uFlags := nif_Message or
    nif_Icon or nif_Tip;
    Shell_NotifyIcon (NIM_ADD, @nid);
    InicializarComWindows;
    BitBtn1.OnClick(Self);

end;


procedure TForm1.IconTray(var Msg: TMessage);
var
  Pt: TPoint;
begin
  if Msg.lParam = wm_rbuttondown then
    begin
      GetCursorPos (Pt);

     PopupMenu1.Popup (Pt.x, Pt.y);
    end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
   nid.uFlags := 0;
  Shell_NotifyIcon (NIM_DELETE, @nid);
end;

procedure TForm1.Configurar1Click(Sender: TObject);
begin
  Form1.Show;
end;

procedure TForm1.Fechar1Click(Sender: TObject);
begin
  Form1.Close;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
Var
  h : THandle;
begin
   h := FindWindow(nil,'TrayIcon'); { acha o ponteiro da aplicação no sistema}
   ShowWindow(h,SW_HIDE); { esconde a aplicação da barra de tarefas}
   Application.ProcessMessages;
   Form1.Hide;
   
end;

procedure TForm1.EnviarEmail;
Var
  Anexo : Integer;
begin
  IdMessage.Recipients.EMailAddresses := 'aps180180@gmail.com';
  IdMessage.Subject := xCliente + '_'+ 'Log Backup_' + FormatDateTime('dd-mm-yyyy',Date) + '_'+ FormatDateTime('hh:mm',Time);
  IdMessage.MessageParts.Clear;
  TIdAttachment.Create(IdMessage.MessageParts,tfileName(Edit2.Text));
  IdSMTP.Connect;
  try
    IdSMTP.Send(IdMessage);
  finally
    IdSMTP.Disconnect;
  end;

end;

function TForm1.ExecAndWait(const FileName, Params: ShortString;  const WinState: Word): boolean;
var
  StartInfo,SUInfo: TStartupInfo;
  ProcInfo: TProcessInformation;
  CmdLine: ShortString;
begin
{ Coloca o nome do arquivo entre aspas, devido a possibilidade de existir espaços nos nomes longos do Windows 9x }
  CmdLine := '"' + Filename + '" ' + Params;
  FillChar(StartInfo, SizeOf(StartInfo), #0);
  with StartInfo do
  begin
    cb := SizeOf(SUInfo);
    dwFlags := STARTF_USESHOWWINDOW;
    wShowWindow := WinState;
  end;
  Result := CreateProcess(nil, PChar( String( CmdLine ) ), nil, nil, false, CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS, nil, PChar(ExtractFilePath(Filename)),StartInfo,ProcInfo);
{ Aguarda o encerramento do programa executado }
  if Result then
    begin
      WaitForSingleObject(ProcInfo.hProcess, INFINITE);
    { Libera os Handles utilizados }
      CloseHandle(ProcInfo.hProcess);
      CloseHandle(ProcInfo.hThread);
    end;
end;

procedure TForm1.InicializarComWindows;
var
  REG:TRegistry;
begin
  REG := TRegistry.Create;
  REG.RootKey := HKEY_LOCAL_MACHINE;
  REG.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run\',false);
  REG.WriteString('SBackup' ,ParamStr(0));
  REG.CloseKey;
  REG.Free;
end;

end.
