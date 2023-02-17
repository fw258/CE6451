function [nf_norm,kd_rgb,reshow] = object_vis(object, nf, kd_0, kd_1, kd_2, kd_3, depth)
% input object names, normal field and albedos of different band, as well
% as depth from previous steps, and visualize everything
% return also normalized normal field, normalized albedo in rgb band, and
% re-render picture in rgb band
% normalized normal field
nf_norm(:,:,1) = (nf(:,:,1) + 1)/2;
nf_norm(:,:,2) = (nf(:,:,2) + 1)/2;
nf_norm(:,:,3) = (nf(:,:,3) + 1)/2;
imshow(nf_norm)
imwrite(nf_norm, [object,'_normal_field.png'])
% albedo
% gray scale
kd_gray_norm = (kd_0 - min(min(kd_0)))/(max(max(kd_0)) - min(min(kd_0)));
imshow(kd_gray_norm)
imwrite(kd_gray_norm, [object,'_albedo_gray.png'])
% RGB
kd_r_norm = (kd_1 - min(min(kd_1)))/(max(max(kd_1)) - min(min(kd_1)));
kd_g_norm = (kd_2 - min(min(kd_2)))/(max(max(kd_2)) - min(min(kd_2)));
kd_b_norm = (kd_3 - min(min(kd_3)))/(max(max(kd_3)) - min(min(kd_3)));
kd_rgb = cat(3,kd_r_norm, kd_g_norm, kd_b_norm);
imshow(kd_rgb)
imwrite(kd_rgb, [object,'_albedo_RGB.png'])
% depth
imshow(depth)
imwrite(depth, [object,'_depth.png'])
% re-render (light direction is (0,0,1))
nl = reshape(nf,[],3)*[0,0,1]';
nl_mat =  reshape(nl,[size(kd_rgb,1),size(kd_rgb,2)]);
re_render = kd_rgb.*nl_mat;
remax = squeeze(max(re_render,[],[1,2]));
remin = squeeze(min(re_render,[],[1,2]));
reshow(:,:,1) = (re_render(:,:,1) - remin(1))/(remax(1) - remin(1));
reshow(:,:,2) = (re_render(:,:,2) - remin(2))/(remax(2) - remin(2));
reshow(:,:,3) = (re_render(:,:,3) - remin(3))/(remax(3) - remin(3));
imshow(reshow)
imwrite(reshow, [object,'_rerender_RGB.png'])

end