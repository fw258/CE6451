%% apple
[li_dir_a, li_value_a, maskobj_a,images_a] = illum_dir_int('Apple');
[nf_a,kd_a0] = normal_estimation('Apple',maskobj_a,li_dir_a, li_value_a, images_a, 0);
[~,kd_a1] = normal_estimation('Apple',maskobj_a,li_dir_a, li_value_a, images_a, 1);
[~,kd_a2] = normal_estimation('Apple',maskobj_a,li_dir_a, li_value_a, images_a, 2);
[~,kd_a3] = normal_estimation('Apple',maskobj_a,li_dir_a, li_value_a, images_a, 3);
depth_a = depth_cal(maskobj_a,nf_a);
save(["apple_all.mat"])
%% pear
[li_dir_p, li_value_p, maskobj_p,images_p] = illum_dir_int('Pear');
[nf_p,kd_p0] = normal_estimation('Pear',maskobj_p,li_dir_p, li_value_p, images_p, 0);
[~,kd_p1] = normal_estimation('Pear',maskobj_p,li_dir_p, li_value_p, images_p, 1);
[~,kd_p2] = normal_estimation('Pear',maskobj_p,li_dir_p, li_value_p, images_p, 2);
[~,kd_p3] = normal_estimation('Pear',maskobj_p,li_dir_p, li_value_p, images_p, 3);
depth_p = depth_cal(maskobj_p,nf_p);
save(["pear_all.mat"])
%% elephant
[li_dir_e, li_value_e, maskobj_e,images_e] = illum_dir_int('Elephant');
[nf_e,kd_e0] = normal_estimation('Elephant',maskobj_e,li_dir_e, li_value_e, images_e, 0);
[~,kd_e1] = normal_estimation('Elephant',maskobj_e,li_dir_e, li_value_e, images_e, 1);
[~,kd_e2] = normal_estimation('Elephant',maskobj_e,li_dir_e, li_value_e, images_e, 2);
[~,kd_e3] = normal_estimation('Elephant',maskobj_e,li_dir_e, li_value_e, images_e, 3);
depth_e = depth_cal(maskobj_e,nf_e);
save(["elephant_all.mat"])

%% visualization
load("apple_all.mat")
load("pear_all.mat")
load("elephant_all.mat")
[~,~,~] = object_vis('Apple',nf_a, kd_a0, kd_a1, kd_a2, kd_a3, depth_a);
[~,~,~] = object_vis('Pear',nf_p, kd_p0, kd_p1, kd_p2, kd_p3, depth_p);
[~,~,~] = object_vis('Elephant',nf_e, kd_e0, kd_e1, kd_e2, kd_e3, depth_e);
