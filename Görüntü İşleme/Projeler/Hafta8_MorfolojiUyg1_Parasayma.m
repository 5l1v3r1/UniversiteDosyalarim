resim = imread('para.png');
subplot(2,3,1);imshow(resim);
title('Orijinal');

resim = rgb2gray(resim);
level = graythresh(resim); % e�ik de�er belirlenir 
bw = im2bw(resim,level); %siyah beyaz g�r�nt�ye d�n��t�r�r. level e�ik de�erine g�re alt� siyah, �st� beyaz olsun
subplot(2,3,2);imshow(bw);
title('Siyah Beyaz');
bwTers = imcomplement(bw); %renkleri ters �evir
subplot(2,3,3);imshow(bwTers);
title('Ters Renk');

bwTers = imfill(bwTers,'holes');   %b�y�k beyaz alanlardaki siyah lekeler temizlenir
subplot(2,3,4);imshow(bwTers);
title('Temizleme');

bwTers = bwareaopen(bwTers,30);   %a�ma i�lemi uygulan�r (e�ik de�eri : 30px se�tik)
subplot(2,3,5);imshow(bwTers);
title('A�ma');

se = strel('disk',12); % yap�sal element olu�turuldu (yar��ap� 12 olan bir dairesel �ekil olu�turduk. beyaz alanlar�m�z� birbirinden ay�rd�k) 
bwAsinma = imerode(bwTers,se);   %a��nd�rma i�lemi uygulan�r 
subplot(2,3,6);imshow(bwAsinma);
title('A��nd�rma');

[B,L] = bwboundaries(bwAsinma);   % nesnenin s�n�rlar� hesaplan�yor
adet = length(B);   % s�n�r i�indeki dairesel �ekil (para) say�s� hesaplan�yor
%str = adet + ' adet';
%xlabel(str);
xlabel({adet; ' adet'});