unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, Buttons;

type
  TForm3 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    tbbarkodno: TEdit;
    tburunadi: TEdit;
    tburunfiyati: TEdit;
    btnkaydet: TBitBtn;
    btnsil: TBitBtn;
    btncik: TBitBtn;
    btnduzenle: TBitBtn;
    DBGrid2: TDBGrid;
    procedure btnkaydetClick(Sender: TObject);
    procedure DBGrid2CellClick(Column: TColumn);
    procedure btnduzenleClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnsilClick(Sender: TObject);
    procedure btncikClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    tutnumara:String;
  end;

var
  Form3: TForm3;

implementation
uses unit1, DB;
{$R *.dfm}

procedure TForm3.btnkaydetClick(Sender: TObject);
var
cevap:Integer;
begin
if(tbbarkodno.Text='')or(tburunadi.Text='')or(tburunfiyati.Text='')then
begin
ShowMessage('Bo� Alan Ge�emezsiniz...');
end
else
begin
cevap:=Application.MessageBox('Onayl�yor Musunuz?','Uyar�',MB_YESNO);
if(cevap=IDYES) then
begin
Form1.Queryurun.SQL.Clear;
Form1.Queryurun.SQL.Add('select * from urunler where Barkodno='+#39+tbbarkodno.Text+#39);
Form1.Queryurun.ExecSQL;
Form1.Queryurun.Active:=true;
if(Form1.Queryurun.RecordCount<=0)then
begin
Form1.tableurun.Insert;
Form1.tableurun['Barkodno']:=tbbarkodno.Text;
Form1.tableurun['Urunad']:=tburunadi.Text;
Form1.tableurun['Fiyat']:=tburunfiyati.Text;
Form1.tableurun.Post;
ShowMessage('Kay�t Yap�ld�...');
end
else
begin
ShowMessage(tbbarkodno.Text+' Numaral� �r�n Var!');
end;
end;
Form1.tableurun.Refresh;
end;
end;

procedure TForm3.DBGrid2CellClick(Column: TColumn);
begin
tutnumara:=DBGrid2.Fields[0].Text;
tbbarkodno.Text:=Form1.tableurun['Barkodno'];
tburunadi.Text:=Form1.tableurun['Urunad'];
tburunfiyati.Text:=Form1.tableurun['Fiyat'];
end;

procedure TForm3.btnduzenleClick(Sender: TObject);
var
cevap:Integer;
begin
if(tbbarkodno.Text='')or(tburunadi.Text='')or(tburunfiyati.Text='')then
begin
ShowMessage('Bo� Alan Ge�emezsiniz...');
end
else
begin
cevap:=Application.MessageBox('Onayl�yor Musunuz?','Uyar�',MB_YESNO);
if(cevap=IDYES) then
begin
Form1.Queryurun.SQL.Clear;
Form1.Queryurun.SQL.Add('select * from urunler where Barkodno='+#39+tbbarkodno.Text+#39);
Form1.Queryurun.ExecSQL;
Form1.Queryurun.Active:=true;
if(Form1.Queryurun.RecordCount<=0)or(tutnumara=tbbarkodno.Text)then
begin
Form1.tableurun.Edit;
Form1.tableurun['Barkodno']:=tbbarkodno.Text;
Form1.tableurun['Urunad']:=tburunadi.Text;
Form1.tableurun['Fiyat']:=tburunfiyati.Text;
Form1.tableurun.Post;
ShowMessage('�r�n Kaydedildi...');
end
else
begin
ShowMessage(tbbarkodno.Text+' Numaral� �r�n Var!');
end;
end;
end;
end;

procedure TForm3.FormActivate(Sender: TObject);
begin
tbbarkodno.Clear;
tburunadi.Clear;
tburunfiyati.Clear;
end;

procedure TForm3.btnsilClick(Sender: TObject);
var
cevap:Integer;
begin
if(Form1.tableurun.RecordCount>0)then
begin
cevap:=Application.MessageBox('Silmek �stiyor Musunuz ?','Uyar�',MB_YESNO);
if(cevap=IDYES)then
begin
Form1.tableurun.Delete;
ShowMessage('Kay�t Silindi');
Form1.tableurun.Refresh;
end;
end
else
begin
ShowMessage('�r�n Se�ilmemi�tir...');
end;
end;

procedure TForm3.btncikClick(Sender: TObject);
begin
Form3.Close;
end;

end.
