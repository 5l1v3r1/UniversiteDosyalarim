function [oran]=parmaklarkys(a,b)%fonksiyon olu�turulur.
deger1=parmakla(a);%ilk resim olu�turulup de�er1 e atan�r
figure %g�sterilir
deger2=parmakla(b); %2. resim olu�turulup de�er2 e atan�r
fark = abs(deger1-deger2);% de�er1 ve deger2 nin mutlak de�eri al�n�r ve fark ismine atan�r.
k=100-(fark*100/deger2);
if(k<99)
    k=abs(k-50);
end
oran=k; %oran yani fonksiyon ile hesaplanan de�er e�itlenir