% Code���������룩

function ret=Code01(lenchrom)
%�����������������Ⱦɫ�壬���������ʼ��һ����Ⱥ
% lenchrom   input : Ⱦɫ�峤��
% bound      input : ������ȡֵ��Χ
% ret        output: Ⱦɫ��ı���ֵ
    pick=rand(1,length(lenchrom));

    ret=(pick-0.5)*6; %���Բ�ֵ����������ʵ����������ret�У�ʵ�����뷶Χ��(-3,3)֮�䡣

