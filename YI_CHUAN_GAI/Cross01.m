% cross���������棩
function ret=Cross01(pc,lenchrom,individuals,popsize)
%��������ɽ������
% pcorss                input  : �������
% lenchrom              input  : Ⱦɫ��ĳ���
% individuals.chrom     input  : Ⱦɫ��Ⱥ
% sizepop               input  : ��Ⱥ��ģ
% ret                   output : ������Ⱦɫ��

% ʵ�����룬�ڽ��н���ʱ������ģ�Ͷ����ƽ���SBX

 for i=1:100  %ÿһ��forѭ���У����ܻ����һ�ν��������Ⱦɫ�������ѡ��ģ�����λ��Ҳ�����ѡ��ģ�
                  %������forѭ�����Ƿ���н���������ɽ�����ʾ�����continue���ƣ�        
    pick=rand(1,2);   % ���ѡ������Ⱦɫ����н���
    row=ceil(pick.*popsize);  
    pick=rand;
    if pick < pc
         % ���ѡ�񽻲�λ
         pick=rand;       
         column=ceil(pick*length(lenchrom)); %���ѡ����н����λ�ã���ѡ��ڼ����������н��棬ע�⣺����Ⱦɫ�彻���λ����ͬ
         pick=rand; %���濪ʼ
         v1=individuals.chrom(row(1),column);                                                         %index(1)��,pos��
         v2=individuals.chrom(row(2),column);
         individuals.chrom(row(1),column)=pick*v2+(1-pick)*v1;
         individuals.chrom(row(2),column)=pick*v1+(1-pick)*v2; %�������
    end
 end

ret=individuals.chrom;

