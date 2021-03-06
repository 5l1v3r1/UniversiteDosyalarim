unit Unit4;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DBCtrls, Grids, DBGrids, DB, DBTables, Buttons,
  ComCtrls, DBDateTimePicker, Menus;

type
  TForm4 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    tbstokadedi: TEdit;
    DataSource1: TDataSource;
    Table1: TTable;
    DBGrid1: TDBGrid;
    btnkaydet: TBitBtn;
    DBLookupComboBox1: TDBLookupComboBox;
    DBDateTimePicker1: TDBDateTimePicker;
    btnfiltrele: TBitBtn;
    btncik: TBitBtn;
    Query1: TQuery;
    DBDateTimePicker2: TDBDateTimePicker;
    DBGrid2: TDBGrid;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    PopupMenu1: TPopupMenu;
    StokSil1: TMenuItem;
    btnstokgirisrapor: TBitBtn;
    btnstokcikisrapor: TBitBtn;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnkaydetClick(Sender: TObject);
    procedure btncikClick(Sender: TObject);
    procedure btnfiltreleClick(Sender: TObject);
    procedure StokSil1Click(Sender: TObject);
    procedure btnstokgirisraporClick(Sender: TObject);
    procedure btnstokcikisraporClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation
uses unit1, Unit6, Unit7;
{$R *.dfm}

procedure TForm4.FormActivate(Sender: TObject);
begin
Table1.Active:=true;
Form1.tablecikis.Active:=true;
tbstokadedi.Clear;
end;

procedure TForm4.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Table1.Active:=false;
end;

procedure TForm4.btnkaydetClick(Sender: TObject);
var
cevap:Integer;
tarih,saat:String;
begin
if(DBLookupComboBox1.Text='')or(tbstokadedi.Text='')then
begin
ShowMessage('Bo� Alan Ge�emezsiniz...');
end
else
begin
cevap:=Application.MessageBox('Onayl�yor Musunuz?','Uyar�',MB_YESNO);
if(cevap=IDYES) then
begin
Table1.Insert;
Table1['Barkodno']:=DBLookupComboBox1.KeyValue;
Table1['StokAdet']:=tbstokadedi.Text;
Table1['Tarih']:=DateToStr(Date);
Table1.Post;
ShowMessage('Stok Eklendi...');
Table1.Refresh;

Form1.Queryurunlistele.SQL.Clear;
Form1.Queryurunlistele.SQL.Add('SELECT urunler.Barkodno,urunler.Urunad,urunler.Fiyat, SUM(stokgiris.StokAdet) as Adet from urunler.db as urunler,stokgiris.db as stokgiris where urunler.Barkodno=stokgiris.Barkodno group by stokgiris.Barkodno,urunler.Urunad,urunler.Fiyat,urunler.Barkodno');
Form1.Queryurunlistele.ExecSQL;
Form1.Queryurunlistele.Active:=true;
tbstokadedi.Clear;
end;
end;
end;



procedure TForm4.btncikClick(Sender: TObject);
begin
Form4.Close;
Table1.Filtered:=false;
form1.tablecikis.Filtered:=false;
end;

procedure TForm4.btnfiltreleClick(Sender: TObject);
begin
if(DBDateTimePicker1.Date>DBDateTimePicker2.Date)then
begin
ShowMessage('�lk Tarih Son Tarihten Sonra Olamaz...');
end
else
begin
Table1.Filter := 'Tarih >=' +#39+DateToStr(DBDateTimePicker1.Date)+#39+' AND Tarih<=' +#39+DateToStr(DBDateTimePicker2.Date)+#39;
Table1.Filtered:=true;
Form1.tablecikis.Filter := 'Tarih >=' +#39+DateToStr(DBDateTimePicker1.Date)+#39+' AND Tarih<=' +#39+DateToStr(DBDateTimePicker2.Date)+#39;
Form1.tablecikis.Filtered:=true;

Query1.SQL.Clear;
Query1.SQL.Add('select * from stokgiris where Tarih Between '+#39+DateToStr(DBDateTimePicker1.Date)+#39+' and '+#39+DateToStr(DBDateTimePicker2.Date)+#39);
Query1.ExecSQL;
Query1.Active:=true;
if(Query1.RecordCount<=0)then
begin
ShowMessage('Stok Giri�i Kayd� Yoktur...');
end
else
begin
ShowMessage(IntToStr(Query1.RecordCount)+' Tane Stok Giri�i Listelendi...');
end;

Form1.Querycikis.SQL.Clear;
Form1.Querycikis.SQL.Add('select * from stokcikis where Tarih Between '+#39+DateToStr(DBDateTimePicker1.Date)+#39+' and '+#39+DateToStr(DBDateTimePicker2.Date)+#39);
Form1.Querycikis.ExecSQL;
Form1.Querycikis.Active:=true;
if(Form1.Querycikis.RecordCount<=0)then
begin
ShowMessage('Stok ��k�� Kayd� Yoktur...');
end
else
begin
ShowMessage(IntToStr(Form1.Querycikis.RecordCount)+' Tane Stok ��k��� Listelendi...');
end;
end;
end;


procedure TForm4.StokSil1Click(Sender: TObject);
var
cevap:Integer;
begin
if(Table1.RecordCount>0)then
begin
cevap:=Application.MessageBox('Silmek �stiyor Musunuz?','Stok Sil',MB_YESNO);
if(cevap=IDYES) then
begin
Table1.Delete;
Table1.Refresh;
ShowMessage('�r�n Silindi...');

Form1.Queryurunlistele.Close;
Form1.Queryurunlistele.SQL.Clear;
Form1.Queryurunlistele.SQL.Add('SELECT urunler.Barkodno,urunler.Urunad,urunler.Fiyat, SUM(stokgiris.StokAdet) as Adet from urunler.db as urunler,stokgiris.db as stokgiris where urunler.Barkodno=stokgiris.Barkodno group by stokgiris.Barkodno,urunler.Urunad,urunler.Fiyat,urunler.Barkodno');
Form1.Queryurunlistele.ExecSQL;
Form1.Queryurunlistele.Open;

end;
end
else
begin
ShowMessage('�r�n Se�ilmemi�tir...');
end;
end;

procedure TForm4.btnstokgirisraporClick(Sender: TObject);
begin
StokGirisRapor.QuickRep1.Preview;
end;

procedure TForm4.btnstokcikisraporClick(Sender: TObject);
begin
StokCikisRapor.QuickRep1.Preview;
end;

end.
