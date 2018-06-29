%Resmin yolunu belirtip resmi okuyup A de�i�kenine at�yoruz.
A = imread('E:\Caner\Pictures\Camera Roll\2.jpg'); 
%YuzBulucu ad�nda  y�z bulma nesnesi olu�turuyoruz.
YuzBulucu = vision.CascadeObjectDetector();
%Resmimizde Kaskad y�z bulmay� �al��t�r�yoruz.
%Bulunan y�zlerin koordinat de�erlerini BBOX �eklinde bir matris olarak al�yoruz.
BBOX = step(YuzBulucu, A);
ciz = insertObjectAnnotation(A,'rectangle',BBOX,'Y U Z');
%Bulunan y�zlerin koordinat de�erlerinin yaz�ld��� ve foto�raftaki bulunan y�z�n kare �eklinde tespit edilerek a��klamas�n�n yaz�ld��� k�s�md�r.
imshow(ciz); %Resmi G�r�nt�leme i�lemi.
