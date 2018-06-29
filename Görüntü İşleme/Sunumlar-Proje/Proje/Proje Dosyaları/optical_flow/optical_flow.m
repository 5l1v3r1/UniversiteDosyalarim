function [output] = optical_flow(video, options)
t = tic;
position = [];
velocity = [];
if nargin == 0
    display('running demo...')
    display('loading video...')
    try
    load deneme
    catch
        display('missing demo file "cat_video.mat"')
        display('demo aborted.')
        return
    end
    video = single(video);
end

if size(video,3) < 2
    error('need at least 2 image frames for optical flow algorithm to operate')
end

if nargin < 2
    x_blk_size = floor(.04*size(video,2));
    y_blk_size = floor(.04*size(video,1));
else
    
    if ~isfield(options,'x_blk_size')
        x_blk_size = floor(.04*size(video,2));
        display(sprintf('no x_blk_size options found, using %g',x_blk_size))
    end
    
     if ~isfield(options,'y_blk_size')
         
        y_blk_size = floor(.04*size(video,1));
        display(sprintf('no x_blk_size options found, using %g',y_blk_size))
     end
    
    if ~isfield(options,'displayResults')
        displayResults = 0;
    end
end

nframe = 20;

for iframe = 1:nframe-1
    display(sprintf('processing frame: %g of %g...',iframe,nframe-1))
    
    frame1 = squeeze(video(:,:,iframe));
    frame2 = squeeze(video(:,:,iframe+1));
    %--------------------------------------------------------------------------
    %  Pozisyona g�re g�r�nt�lerin de�i�imini hesapla
    [Ix,Iy] = gradient(frame1);
    [ny, nx] = size(Ix);
    %--------------------------------------------------------------------------
    % En yak�n kareleri kullanarak zamana g�re g�r�nt�deki de�i�ikli�i hesapla
    It = frame2-frame1;
    
    %--------------------------------------------------------------------------
    % Sayac� ba�lat
    ct = 1;
    
    %--------------------------------------------------------------------------
    % Birinci blokun x aralığını hesapla
    x1 = 1;
    x2 = x1+x_blk_size;
    
    %--------------------------------------------------------------------------
    % X ve y yönündeki adımları hesapla
    xs = floor((nx-x_blk_size)/x_blk_size);
    ys = floor((ny-y_blk_size)/y_blk_size);
    
    %--------------------------------------------------------------------------
    % H�z vekt�lerini ba�lat�r
    % Vx, vy, h�z vekt�rlerinin x bile�enlerini depolamak i�in kullan�l�r ve
    % Y-bile�enlerini s�ras�yla g�stermektedir.
    vx = zeros(1,ys*xs);
    vy = zeros(1,ys*xs);
    
    %--------------------------------------------------------------------------
    % Konum vekt�rlerini baslat�r
    % X, y, optik hesaplamak i�in kullan�lan blo�un merkez konumunu depolar
    % Ak�� de�erleri.
    x = zeros(1,ys*xs);
    y = zeros(1,ys*xs);
    
    
    %--------------------------------------------------------------------------
    % Resim boyunca dong�
    for ix = 1:xs
        
        y1 = 1;
        y2 = y1 + y_blk_size;
        
        for iy = 1:ys
            
            %------------------------------------------------------------------
            % Ger�ekle�tirmek i�in degrade ve fark g�r�nt�s�nden bir alt etki alan� se�in
            % �zerinde hesaplama
            
            Ix_block = Ix(y1:y2,x1:x2);
            Iy_block = Iy(y1:y2,x1:x2);
            It_block = It(y1:y2,x1:x2);
            
            
            %------------------------------------------------------------------
            % Problemi do�rusal denklem olarak dökün ve bir lsqr anlamda çözmek
            % Bu yaklaşım Lucas-Kanade Metodu olarak bilinir
            % A*u = f
            % A'*A*u = A'*f
            % u = inv(A'*A)*A*f
            % solve inv(A'*A) using pseudo-inv (pinv)
            % f -> It  (Imge zamanına göre değişimi)
            % A -> [Ix,Iy] (Pozisyona göre imaj değişikliği)
            % u -> [vx,vy] (Hızları, ne için çözmek istediğimiz)
            
            A = [Ix_block(:) , Iy_block(:)];
            b = -It_block(:);
            
            A = A(1:1:end,:);
            b = b(1:1:end);
            
            P = pinv(A'*A);
            u = P*A'*b;
            
            %------------------------------------------------------------------
            % Mevcut alt alana göreceli hızlar.
            %
            % Not: bunu gerçek bir hıza (ör. [M / s] yapardın
            % Çerçeveler arasındaki oran hakkında bilgi içermesi gerekir
            % (delta-t) Ve içindeki komşu pikseller arasındaki mesafe
            % Görüntüler (delta-x, delta-y). Aksi takdirde sonuç bir
            % Göreceli hız.
            vx(ct) = u(1);
            vy(ct) = u(2);
            
            %------------------------------------------------------------------
            % Alt alanın orta noktasını hesapla
            y(ct) = (x1+x2)/2;
            x(ct) = (y1+y2)/2;
            
            ct = ct+1;
            
            %------------------------------------------------------------------
            % Yeni bloğun y aralığını elde
            y1 = y1 + y_blk_size + 1;
            y2 = y1 + y_blk_size;
            
            %------------------------------------------------------------------
            % Y yönündeki görüntü boyutunu aşmadığınızdan emin olun
            if y2 > ny
                y2  = ny;
            end
        end
        %----------------------------------------------------------------------
        % Yeni bloğun x aralığını elde et
        x1 = x1 + x_blk_size + 1;
        x2 = x1 + x_blk_size;
        %----------------------------------------------------------------------
        % X yönünde görüntü boyutunu aşmadığınızdan emin olun
        if x2 > nx
            x2 = nx;
        end
    end
    
    position(iframe,:,:) = [y ; x];
    velocity(iframe,:,:) = [vy ; vx];
    x = [];
    y = [];
    vx = [];
    vy = [];
    ct = 1;
    
end
%--------------------------------------------------------------------------
% Girdi bağımsız değişkeni yoksa, arsa sonuçları
if nargin == 0 || options.displayResults
    figure   
    for iframe = 1:size(velocity,1);
        subplot(1,1,1)
        imagesc(squeeze(video(:,:,iframe+1))),colormap gray
        title(sprintf('velocity vectors + image\n frame %g',iframe))
        hold on
        x = squeeze(position(iframe,2,:));
        y = squeeze(position(iframe,1,:));
        vx = squeeze(velocity(iframe,2,:));
        vy = squeeze(velocity(iframe,1,:));
        plot(y,x,'.k','markersize',1)
        quiver(y,x,vy,vx,'r'), hold off
        
        drawnow
        pause(.1)
    end
end
output.position = position;
output.velocity = velocity;
output.num_blks_x = xs;
output.num_blks_y = ys;
output.blk_size_x = x_blk_size;
output.blk_size_y = y_blk_size;
output.nframes = nframe;
output.process_time = sprintf('%3.2f [sec]',toc(t));
