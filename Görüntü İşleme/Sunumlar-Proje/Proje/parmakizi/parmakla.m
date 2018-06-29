function y = parmakla(resimOKU)
resim = imread(resimOKU)
subplot(2,3,1);imshow(resim);
title(resimOKU);

%resim = rgb2gray(resim);
level = graythresh(resim); % e�ik de�er belirlenir 
bw = im2bw(resim,level); %siyah beyaz g�r�nt�ye d�n��t�r�r. level e�ik de�erine g�re alt� siyah, �st� beyaz olsun
subplot(2,3,2);imshow(bw);
title('Siyah Beyaz'); 



bwInce = edge(bw,'Canny');%inceltme i�lemi yap�lm��t�r.
subplot(2,3,3);
imshow(bwInce);
title('�nceltme ��lemleri');

%bwTers = imfill(bwTers,'holes');   %b�y�k beyaz alanlardaki siyah lekeler temizlenir
%subplot(2,3,4);imshow(bwTers);
%title('Temizleme');
resimsiyah=bwInce;
%Renk kodu hesapland�
 
resimrenkkodu=sum(sum(resimsiyah));%renk kodu olu�turuluyor
resimrenkkodu=resimrenkkodu/(max(size(resimsiyah))* min(size(resimsiyah)));%renk kodu hesapland�

%Gri olan Resimde belli bir e�ik de�erin alt�nda kalan (50 olarak
 
%belirledim) renkleri logical olarak bir veya s�f�r diye kodlam�� oldu.
 
etiket=resimsiyah<50; %Logical olan dizi tipi �zerinde i�lem yapmak yerine diziyi normal double dizi tipine d�n���m�n� sa�land�.
[a1,b1]=find(resimsiyah==etiket,1);%de�eri 1 olan �art� sa�layan
[a2,b2]=find(resimsiyah==etiket-1,1);
if sqrt((a1-a2).^2 + (b1-b2).^2)   <=20 %k�k bulma i�lemi
resimsiyah(resimsiyah==etiket)=etiket-1;
end


%Bulunan nesne say�s� ve renk kodu ekrana yazd�r�l�r
 
nesneetiketleri=unique(resimsiyah);%unique her de�erden 1 tane getiriyor.kodlar�n �e�itlerini veriyor renk �e�itlerinden 1 tsne getiriyor
fprintf('�zellikleri Bulunan Toplam Nesne Say�s�= %d\n',length(nesneetiketleri)-1); %dizi indisleri 1 den ba�lad��� i�in -1 yap�yor.
disp('*** 1 ***');
fprintf('Resmin Ortalama Renk Kodu= %d\n',resimrenkkodu);
disp('*** 2 ***');
% alanda t�m nesnelerin alanlar� bulundu.
 
subplot(2,3,4);
imshow(resimsiyah);
hold on
title('Nesnelerin Alanlar�');%nesne alanlar�n� ba�l�k olarak yazd�r�yor
tur=0;
for i = 2:length(nesneetiketleri)% d�ng� olu�turulur ve 2 den length a kadar olan
tur=tur+1; 
[alanx,alany]=find(resimsiyah== nesneetiketleri(i));
plot(alany,alanx,'g.')% �l��lerin birbiri ile nas�l ili�kide oldu�unu g�rmek i�in plot kullan�l�r. g ye�il yap�yor.
fprintf('%d.Nesnenin Alan�= %d\n',tur,length(alanx));
end
disp('*** 3 ***');
% bu alanda t�m nesnelerin a��rl�k merkezleri bulundu.
 
subplot(2,3,5);
imshow(resimsiyah);
hold on
title('Nesnelerin A��rl�k Merkezleri');% ba�l�k yaz�ld�
tur=0;
for i = 2:length(nesneetiketleri)
tur=tur+1;
[alanx,alany]=find(resimsiyah== nesneetiketleri(i));
alanxmean=round(mean(alanx));% a��rl�k merkezi hesab� i�in mean kullan�l�r.
alanymean=round(mean(alany));
plot(alanymean,alanxmean,'r.','MarkerSize',5)
fprintf('%d.Nesnenin A��rl�k Merkezi: X=%d ,Y=%d\n',tur,alanymean,alanxmean);
end
disp('*** 4 ***');

y=1000/((length(nesneetiketleri)-1)*100+alanymean^3+alanxmean^3+length(alanx)*0.85+resimrenkkodu*200)% k�yaslamada kullan�lacak kod alan�d�r
