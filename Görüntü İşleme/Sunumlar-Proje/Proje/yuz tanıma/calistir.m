clear all
close all
clc
datapath = 'C:\Users\Caner\Desktop\Yeni klas�r (2)\veritaban�'; % Veritaban�n bulundu�u klas�r
TestImage = 'C:\Users\Caner\Desktop\Yeni klas�r (2)\test resimleri\6.jpg'; %test edilecek resimlerin bulundu�u klas�r
A = imread(TestImage); % Test resminin okundu�u yer
FaceDetector = vision.CascadeObjectDetector(); % kaskad y�z bulmay� �al��t�r�p facedetector adl� nesneyi olu�turuyoruz
BBOX = step(FaceDetector, A);  % Bulunan y�zlerin koordinat de�erlerini BBOX �eklinde bir matris olarak al�yoruz.
resimsayisi = size(BBOX,1); % resimde bulunan y�z say�s�n� bulup resim say�n�a at�yoruz
anaresim = zeros(1,resimsayisi); 
tanit = []; 
for sayi=1:resimsayisi
    I2 = imcrop(A,BBOX(sayi,:)); %resmin y�z k�sm�n� kesiyor.
    I2 = imresize (I2,[200 180]); % Resim boyutland�rma  
    [taninma, dbadi, recog_img] = pcayontemi(datapath,I2); %Resmin veritaban�ndaki resimler ile pca y�ntemi ile kar��la�t�r�l�p bulundu�u k�s�m
    taninma
    dbadi;
    recog_img;
    anaresim(1,sayi) = dbadi;
    tanit(sayi) = taninma;
end

word = cell(1); 
for i=1:length(anaresim)
    olanbu = eslestir(anaresim(i), tanit(i)); %Veritaban�nda kay�tl� olan resimlerin hangi ki�ilere ait oldu�unu yazan k�s�m
    word(i) = {olanbu};
end
B = insertObjectAnnotation(A,'rectangle', BBOX, word,'TextBoxOpacity',0.8,'FontSize',30); % Y�z�n kare �eklinde i�e al�n�p karenin �effafl���n� ve fontunun yaz�ld��� k�s�m.
imshow(B);
