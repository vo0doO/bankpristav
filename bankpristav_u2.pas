unit bankpristav_u2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, ToolWin, ComCtrls, StdCtrls,StrUtils, Buttons,Db;

type
  TForm2 = class(TForm)
    mmo1: TMemo;
    mmo2: TMemo;
    dbgrd1: TDBGrid;
    dbgrd2: TDBGrid;
    btn2: TBitBtn;
    btn3: TBitBtn;
    edt1: TEdit;
    edt2: TEdit;
    cbb1: TComboBox;
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    btn1: TBitBtn;
    mmo3: TMemo;
    btn4: TButton;
    procedure FormShow(Sender: TObject);
    procedure btn3Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure btn4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  pk:string;
  Form2: TForm2;
  

implementation

uses bankpristav_dm;

{$R *.dfm}

procedure TForm2.FormShow(Sender: TObject);
 var
   idans,i:Integer;
   s:AnsiString;
begin
  //Form2.mmo1.Lines.Add(IntToStr(dm.ibqry1.RecNo));
  pk:=(DM.ibqry1.FieldByName('PK').asString);
   s:='';
   mmo1.Lines.Clear;
   if dm.ibqry1.FieldByName('Processed').AsInteger=1 then begin
     btn2.Enabled:=False;
     btn3.Enabled:=False;
     btn1.Enabled:=False;
   end
    else
   begin
   btn2.Enabled:=True;
     btn3.Enabled:=false;
     btn1.Enabled:=True;
   end;
  for i:=0 to dm.ibqry1.Fields.Count-1 do  begin
  dm.ibqry2.SQL.Clear;
  dm.ibqry2.SQL.Text:='select * from descr where tablename=upper('+quotedStr('Requests')+') and fieldorder='+IntToStr(i);
  DM.ibqry2.Open;
    mmo1.Lines.Add(DM.ibqry2.Fields[2].asString+':'+dupestring(' ',20-length(DM.ibqry2.Fields[2].asString))+dm.ibqry1.Fields[i].AsString ) ;
  //mo1.Lines.Add(dm.ibqry1.Fields[i].Displayt+':'+dm.ibqry1.Fields[i].AsString);
   // s:=s+dm.ibqry1.Fields[i].AsString+', ';
  end;
  //
  DM.ibqry3.SQL.Clear;
 DM.ibqry3.SQL.Text:='select * from answer where id_zapr='+(DM.ibqry1.FieldByName('PK').asString);

 DM.ibqry3.Open;
 idans:= DM.ibqry1.fieldbyname('answerid').AsInteger;
 form2.dbgrd1.DataSource:=DM.ds3;
  DM.ibqry4.SQL.Clear;
  if idans>0 then begin
    DM.ibqry4.SQL.Text:='select * from acc_data where answerpk='+IntToStr(idans)   ;
   DM.ibqry4.Open;
 form2.dbgrd2.DataSource:=DM.ds4;
  end;

end;

procedure TForm2.btn3Click(Sender: TObject);
var
  pkans:Integer;
  sql,sq:AnsiString;
begin
 pkans:=Getgenerator('PK_ANSWER'); //PK_ACC_DATA
 sql:='INSERT INTO ANSWER (PK, UNICODE, ID_ZAPR, NUMISP, DT, NUM, NUMRES, DTRES, RESULT, TEXT, FILENAME) VALUES (';
  sq:=sql;
  sq:=sq+IntToStr(pkans)+', ';

  sq:=sq+(DM.ibqry1.FieldByName('UNICODE').asString)+', '   ;
  sq:=sq+(DM.ibqry1.FieldByName('PK').asString)+', '   ;
  sq:=sq+quotedstr(DM.ibqry1.FieldByName('NUMISP').asString)+', '   ;
  sq:=sq+quotedstr(DM.ibqry1.FieldByName('DT').asString)+', '   ;
  sq:=sq+quotedstr(DM.ibqry1.FieldByName('NUM').asString)+', '   ;
  sq:=sq+QuotedStr('/')+', ';
  sq:=sq+QuotedStr(DateToStr(now))+', ';
  sq:=sq+intToStr(1)+', ';
  sq:=sq+QuotedStr('��� ������')+', Null)' ;
  mmo2.Lines.Add(sq) ;
  DM.ibqry2.SQL.Clear;
  DM.ibqry2.SQL.Text:=sq;
  DM.ibqry2.ExecSQL;
  sq:='UPDATE REQUESTS SET ANSWERID ='+IntToStr(pkans) +',processed=1  WHERE PK = '+(DM.ibqry1.FieldByName('PK').asString);
  DM.ibtrnsctn1.Commit;
  DM.ibqry2.SQL.Clear;
  DM.ibqry2.SQL.Text:=sq;
  DM.ibqry2.ExecSQL;
  DM.ibtrnsctn1.Commit;


  dbgrd1.Refresh;


end;

procedure TForm2.btn2Click(Sender: TObject);
var
  pkans,pkacc:LongInt;
  sql,sq:AnsiString;
begin
//  ���� 42307810860311008389 8585/1 ������� 194 RUR
//pk:=(DM.ibqry1.FieldByName('PK').asString);
if Length(edt1.Text)>=20 then begin


if DM.ibqry1.FieldByName('ANSWERID').AsInteger<>0 then
  pkans:= DM.ibqry1.FieldByName('ANSWERID').AsInteger
  else  pkans:=Getgenerator('PK_ANSWER'); //PK_ACC_DATA
pkacc:=Getgenerator('PK_ACC_DATA'); //PK_ACC_DATA
sql:='INSERT INTO ANSWER (PK, UNICODE, ID_ZAPR, NUMISP, DT, NUM, NUMRES, DTRES, RESULT, TEXT, PROCESSED) VALUES (';
  sq:=sql;
  sq:=sq+IntToStr(pkans)+', ';

  sq:=sq+(DM.ibqry1.FieldByName('UNICODE').asString)+', '   ;
  sq:=sq+(DM.ibqry1.FieldByName('PK').asString)+', '   ;
  sq:=sq+quotedstr(DM.ibqry1.FieldByName('NUMISP').asString)+', '   ;
  sq:=sq+quotedstr(DM.ibqry1.FieldByName('DT').asString)+', '   ;
  sq:=sq+quotedstr(DM.ibqry1.FieldByName('NUM').asString)+', '   ;
  sq:=sq+QuotedStr('/')+', ';
  sq:=sq+QuotedStr(DateToStr(now))+', ';
  sq:=sq+intToStr(1)+', ';
  sq:=sq+QuotedStr('���� �����')+', 0)' ;
  mmo2.Lines.Add(sq) ;
  DM.ibqry2.SQL.Clear;
  DM.ibqry2.SQL.Text:=sq;
  DM.ibqry2.ExecSQL;

  //dbgrd1.Refresh;
  sql:='INSERT INTO ACC_DATA (PK, ANSWERPK, ACC, BIC_BANK, SUMMA, CURRENCY_CODE, SUMMA_INFO, DEPT_CODE, BANK_NAME) VALUES (';//);'
  DM.ibtrnsctn1.Commit;
  sq:=sql+IntToStr(pkacc )+', ';
  sq:=sq+IntToStr(pkans)+', ';
  sq:=sq+quotedStr(edt1.text)+', Null, '; //Edit gde schet
  sq:=sq+ Edt2.Text+', ';
  sq:=sq+QuotedStr(cbb1.Text)+',Null, Null,Null)'  ;
  mmo2.Lines.Add(sq);
  DM.ibqry2.SQL.Clear;
  DM.ibqry2.SQL.Text:=sq;
  DM.ibqry2.ExecSQL;
  sq:='UPDATE REQUESTS SET ANSWERID ='+IntToStr(pkans) +'   WHERE PK = '+pk;
  DM.ibtrnsctn1.Commit;
  DM.ibqry2.SQL.Clear;
  DM.ibqry2.SQL.Text:=sq;
  DM.ibqry2.ExecSQL;
  DM.ibtrnsctn1.Commit;
  dbgrd1.Refresh;
  dbgrd2.Refresh;
 // FormShow(Sender);
 end else Application.MessageBox('���� ������ ���� �� ����� 20 ��������','������ �����',mrNone);

  end;

procedure TForm2.btn1Click(Sender: TObject);
var
 path,fname,text,sq:AnsiString;
 ansid:string;

begin
  dm.ibqry4.SQL.Text:='select requests.answerid from requests where pk='+pk;
  dm.ibqry4.Open;
  dm.ibqry4.First;
  ansid:=dm.ibqry4.Fields[0].AsString;
  sq:='UPDATE REQUESTS SET processed =1   WHERE PK = '+pk;
  dM.ibqry2.SQL.Text:=sq;
  DM.ibqry2.ExecSQL;
  DM.ibtrnsctn1.Commit;
  mmo3.Lines.Clear;
  mmo2.Lines.Add(sq);
  dm.ibqry4.SQL.Text:='select * from acc_data where acc_data.answerpk=(select requests.answerid from requests where pk='+pk+')';
  dm.ibqry4.Open;
  dm.ibqry4.First;
  //���� 42301810060310574746 8585/19 ������� 0 RUR
  text:='';
  repeat
    text:=text+'���� '+Dm.ibqry4.fieldbyname('ACC').AsString+' ' ;
    text:=text+'������� '+ Dm.ibqry4.fieldbyname('Summa').AsString+' ' ;
    text:=text+ Dm.ibqry4.fieldbyname('currency_code').AsString+' ' ;
    dm.ibqry4.Next;
  until DM.ibqry4.Eof;
  mmo3.Text:=text;
  mmo2.Lines.add( IntToStr(length(text)) ) ;
  if length(text) >252 then begin


  dm.ibqry4.SQL.Text:='select filename from requests where pk='+pk;
  dm.ibqry4.Open;
  dm.ibqry4.First;
  fname:=dm.ibqry4.Fields[0].AsString;

  fname:='o'+StringReplace(fname,'.dbf','',[])+'_'+ansid+'.txt';
  mmo2.Lines.Add(fname);
  path:=ExtractfilePath(application.exename)+'Temp\' ;
  //RemoveFile
  mmo3.Lines.SaveToFile(path+fname);
  //sozdanie otveta
  //mmo2.Lines.a
  // UPDATE ANSWER SET   FILENAME = NULL,CESSED = 0, textfile WHERE (PK = 15);
  sq:='update answer set filename=:filename,textfile=:textfile where pk=(select requests.answerid from requests where pk='+pk+')' ;
  dm.ibqry4.SQL.Text:=sq;
  dm.ibqry4.ParamByName('filename').Text:=quotedstr(fname);
  dm.ibqry4.ParamByName('textfile').LoadFromFile(path+fname,ftMemo	); // TblobType
  dm.ibqry4.ExecSQL;
  dm.ibtrnsctn1.Commit;
  end else
  begin
   sq:='update answer set text='+quotedStr(text)+' where pk=(select requests.answerid from requests where pk='+pk+')';
   dm.ibqry4.SQL.Text:=sq;
   dm.ibqry4.ExecSQL;
   dm.ibtrnsctn1.Commit;
  end;




end;

procedure TForm2.btn4Click(Sender: TObject);
begin
  FormShow(Sender);
end;

end.
