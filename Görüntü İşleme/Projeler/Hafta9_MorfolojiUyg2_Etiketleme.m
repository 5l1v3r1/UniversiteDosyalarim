clc;
clear all;
res=imread('coins.png')
figure; imshow(res);
%�kili
coin1 = im2bw(res);
figure;imshow(coin1);
%Doldurma
coin2 = imfill(coin1,'holes');
figure;imshow(coin2);
%Kenar Belirleme
figure; imshow(res);
B = bwboundaries(coin2); %Kenar haritas�n� ��kar
text(10,10,strcat('Nesne Adeti:',num2str(length(B)))) %Koordinatl� Metin yazd�r
hold on;
     for k=1:length(B)          
       boundary = B{k};
       plot(boundary(:,2),boundary(:,1),'LineWidth',2);
     end
     
%Coin2 i�erisindeki t�m bilgiler Bilgi de�i�kenine aktar�ld�    
[Bilgi Number]=bwlabel(coin2);
%
prop=regionprops(Bilgi,'Area','Centroid');
toplam=0;
 
figure; imshow(res);
hold on
for n=1:length(B)
    %Merkez Nokta
    merkez=prop(n).Centroid;
    X=merkez(1);Y=merkez(2);
    %Alan 
    alan=prop(n).Area;
    alanstr=int2str(alan);
    %text(X,Y,alanstr);
    if alan>2000
        text(X-10,Y,'5 C') 
        toplam=toplam+5;
    else
        toplam=toplam+10;
        text(X-10,Y,'10 C') 
    end
end
hold on;
title(['Toplam: ',num2str(toplam),'cent']);

