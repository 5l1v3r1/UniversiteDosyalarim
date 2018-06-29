function y=histo(resim) %fonksiyon olu�turulur
goruntu1=imread(resim);
a=imhist(goruntu1);%g�r�nt�1 in histogram grafi�ini veren komut
goruntu2=histeq(goruntu1);%g�r�nt�1 e histogram e�itlemesi yapan komut
hist2=imhist(goruntu2);%yo�unluk g�r�nt� i�in histogram hesaplar goruntu2 histogram grafi�i g�r�l�r. Histogramda kutular�n�n say�s� g�r�nt� t�r�ne g�re belirlenir.
subplot(2,2,1)
imshow(goruntu1)% goruntu1 resmi g�sterilir
title(resim)
subplot(2,2,2)
title('orijinal resmin histogram�')
imshow(a)
subplot(2,2,3)
title('Histogram e�itlemesi i�leminin ard�ndan resim')
imshow(goruntu2)
subplot(2,2,4)
imshow(hist2)
title('Histogram e�itlemesi i�lemi ard�ndan histogram')
end