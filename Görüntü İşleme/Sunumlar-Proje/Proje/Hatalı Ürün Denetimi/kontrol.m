function ff = kontrol(ResimOrijinal, ResimGelen);                 % parametre ile d��ar�dan iki adet g�r�nt� dosyas� ismi al�n�yor
Rorj = imread(ResimOrijinal);                                     % Rorj (orijinal �r�n) de�i�kenine 1.parametredeki ismin g�r�nt�s� aktar�l�yor
Rgel = imread(ResimGelen);                                        % Rgel (kontrol edilecek �r�n) de�i�kenine 2.parametredeki ismin g�r�nt�s� aktar�l�yor
[y,g,r] = size(Rorj);                                             % Orijinal �r�ne ait y�kseklik, geni�lik ve kullan�lan renk katman� de�erleri al�n�yor 
ToplamPiksel = y*g*r;                                             % G�r�nt�ye hata oran�n� hesaplayabilmek i�in gereken ToplamPiksel bilgisi hesaplan�yor 
HataliPiksel = 0;                                                 % Hatal�Piksel bilgili ba�lang��ta s�f�ra e�itleniyor 
Rson = Rgel;                                                      % Rson (sonu� g�r�nt�s�) Rgel'den aktar�l�yor
subplot(1,3,1); imshow(Rorj);title('Orijinal �r�n');              % Orijinal �r�n g�r�nt�leniyor
xlabel(ResimOrijinal);                                            % Orijinal �r�ne ait g�r�nt� dosyas�n�n ismi g�r�nt�leniyor
subplot(1,3,2); imshow(Rgel);title('Kontrol Edilen �r�n');        % Kontrol edilecek �r�n g�r�nt�leniyor
xlabel(ResimGelen);                                               % Kontrol edilecek �r�ne ait g�r�nt� dosyas�n�n ismi g�r�nt�leniyor
                                                                  % �ki �r�n aras�ndaki her bir piksel kar��l�kl� olarak e�itlik kontrol� yap�lacak   
for satir=1:y                                                     % satir de�i�keni 1'den y (y�kseklik) de�erine kadar d�ng�ye sokuluyor  
    for sutun=1:g                                                 % sutun de�i�keni 1'den g (geni�lik) de�erine kadar d�ng�ye sokuluyor  
        PikselHatali = false;                                     % Ba�lang�� olarak kontrol edilecek pikselde hata olmad��� farzediliyor  
        for renk=1:r                                              % renk de�i�keni 1'den r (renk katman�) de�erine kadar d�ng�ye sokuluyor  
            if Rorj(satir,sutun,renk) ~= Rgel(satir,sutun,renk)   % Orijinal g�r�nt� ile kontrol edilecek g�r�nt�n�n ayn� koordinatlar�n�n birbirinden farkl� olmas� durumunda  
                PikselHatali = true;                              % pikselin hatal� oldu�u anla��l�yor
            end
        end
        if PikselHatali == false                                  % Pikselde hata bulunmam��sa 
            for renk=1:r                                          % i�aretleme yapmak i�in renk d�ng�m�z tekrar olu�turuluyor
                Rson(satir,sutun,renk) = 0;                       % kontrol edilen koordinat de�eri sonu� g�r�nt�s�nde  0 (siyah)'a e�itleniyor
            end
        else
            HataliPiksel = HataliPiksel+r;                        % Pikselde hata bulunmu�sa HataliPiksel de�i�kenimize renk katman� de�eri kadar de�er ekliyoruz 
        end
    end
end

HataOrani = HataliPiksel / ToplamPiksel * 100;                    % Kontrol�m�z bitti�i i�in iki g�r�nt� aras�nda olu�an HataOrani'ni hesapl�yoruz
str_hataorani = sprintf('Hata Oran� : %% %2.2f \n',HataOrani);    % str_hataorani de�i�kenine istedi�imiz formatta bilgi aktar�yoruz
subplot(1,3,3); imshow(Rson);title('Sonu�');                      % Kontrol sonucunda iki g�r�nt� aras�ndaki farklardan olu�an sonu� g�r�nt�s� g�r�nt�leniyor
xlabel(str_hataorani);                                            % G�r�nt�n�n alt�na hata oran�m�z� yazd�r�yoruz
fprintf('Toplam Piksel : %7d \n',ToplamPiksel);                   % Komut ekran�na ToplamPiksel yazd�r�l�yor
fprintf('Hatal� Piksel : %7d \n',HataliPiksel);                   % Komut ekran�na HataliPiksel yazd�r�l�yor
fprintf('Hata Oran� : %% %2.2f \n',HataOrani);                    % Komut ekran�na HataOrani yazd�r�l�yor
