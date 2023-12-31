clear all;
% close all;
for i=1:2
[file,path]= uigetfile('*.*','Select Image');
if file~=0
    I=imread(strcat(path,file));  
    I=imresize(I,[256,256]);
    T(:,:,:,i)=I;
%     if size(T,3)>1 
%         T=rgb2gray(T);
%     end
else
    warndlg('User pressed cancel');
end
end
%% 
 [r2,c2,d]=size(T(:,:,:,1));
im1=T(:,:,:,1);
im2=T(:,:,:,2);
% subplot(3,2,1),
figure,
subplot(3,2,1),imshow(im1);
title('Original image1');
% subplot(3,2,2),
subplot(3,2,2),imshow(im2);
title('Original image2');
for jk=1:d
I1=im1(:,:,jk);
I2=im2(:,:,jk);

%% 2D DISCRETE WAVELET TRANSFORM
[y,z]=dwt_code(I1);

c(jk,:)=y;
s(:,:,jk)=z;

[y1,z1]=dwt_code(I2);
c1(jk,:)=y1;
s1(:,:,jk)=z1;

end
output=fusion_image(c,s,c1,s1);

%%
% subplot(3,2,3),

subplot(3,2,3),wavegray(c(1,:),s(:,:,1),1,'append');
title('DWT of image1');
% subplot(3,2,4),
subplot(3,2,4),wavegray(c1(1,:),s1(:,:,1),1,'append');
title('DWT of image2');
output=uint8(output);

% subplot(3,2,5),

subplot(3,2,5),imshow(uint8(output));
title('Fusion of Two images');
% figure,imshow(uint8(output));
% title('Fusion of Two images');
STD=std(double(output(:)))
[MSE,dPSNR] = psnr(I1,uint8(output))
%% RMSE

%RMSE Root Mean Squared Error
I1=im1;
err = sum((I1(:) - output(:)).^2)/length(I1(:));  % MSE
RMSE = sqrt(err)                                 % RMSE


%%   Tumor segmentation and classification


J=otsuregion(I2);  
    figure,imshow(J,[]);
    title('SEGMENTED IMAGE IMAGE'); 
   %%
   GLCM2 = graycomatrix(J,'Offset',[2 0;0 2]);
       out = GLCM_Features(GLCM2,0);
%       feature(1,:)=out.maxpr;
%       feature(2,:)=out.energ;
%       feature(3,:)=out.entro;
%       feature(4,:)=out.contr;
%       feature(5,:)=out.dissi;
%       feature(6,:)=out.homom;  
%       feature(7,:)=out.idmnc;
        disp('Features Extracted');
       feature(1,:)=out.maxpr;
       disp('Maximum Probability='); disp(feature(1,:));
      feature(2,:)=out.energ;
       disp('Energy=');disp(feature(2,:));
      feature(3,:)=out.entro;
      disp('Entropy='); disp(feature(3,:));
      feature(4,:)=out.contr;
       disp('Contrast=');disp(feature(4,:));
      feature(5,:)=out.dissi;
       disp('Dissimilarity=');disp(feature(5,:));
      feature(6,:)=out.homom; 
       disp('Homogenity=');disp(feature(6,:));
      feature(7,:)=out.idmnc;
       disp('Inverse difference moment normalized=');disp(feature(7,:));


 
