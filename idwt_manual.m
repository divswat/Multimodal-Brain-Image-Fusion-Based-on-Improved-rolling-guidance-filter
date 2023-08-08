function x = idwt_manual(a,h,v,d,lo_d,lo_h,n)
sx = n;
shift=[0 0];
x = upsconv_manual(a,{lo_d,lo_d})+ ... 
    upsconv_manual(h,{lo_h,lo_d})+ ... 
    upsconv_manual(v,{lo_d,lo_h})+ ... 
    upsconv_manual(d,{lo_h,lo_h});     
end
function y=upsconv_manual(z,f)
            y = dyadup(z,'row',0);
            y = conv2(y',f{1}(:)','full');
            y = y';
            y = dyadup(y,'col',0);
            y = conv2(y ,f{2}(:)','full');


end




