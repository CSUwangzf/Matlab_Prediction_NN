
% select������ѡ��

function ret =select01(individuals,popsize)
% �ú������ڽ���ѡ�����
% individuals input    ��Ⱥ��Ϣ
% sizepop     input    ��Ⱥ��ģ
% ret         output   ѡ��������Ⱥ

k = 10;  % ϵ��
fitness = k./individuals.fitness;
% probability = fitness./sum(fitness);

P=[];%������ʰ�˳���������P��
for i=1:popsize
    P = [P fitness(i)/sum(fitness)]; 
end
%��P�и��������������ۼӸ���Q
%Q��Ӧģ���������ʵ�һ��ֱ�ߣ���ֱ���ϸ��ݸ�����ʷֳɶΣ��εĿ��Խ���������ѡ�еĸ��ʾ�Խ��
Q=[];
Q(1)=P(1);
for j=2:length(P)
    Q(j)=P(j)+Q(j-1);
end

% ��ѭ�����õ��µ���Ⱥ��ÿ��ѭ����ѡ��һ����Ⱥ���µ���ȺҲ��popsize��(��)
% ��ѭ����100��ѭ�����õ�ÿһ�е���Ⱥ��ѡ�еĴ���
% Сѭ�������̶ķ���ֻ��Ϊ���ҳ���100��ѭ���е�ÿһ�Σ�rλ���ĸ����䣬���ĸ����䣬�����Z(k)��+1
% Z��Ӧÿһ����Ⱥ(�ܹ�popsize����Ⱥ)��100��ѭ���б�ѡ�еĴ���
index = [];
for i=1:popsize %��ѭ��
    
    Z = zeros(1,popsize);       %Z[0,0,0,....0]��popsize��Ԫ�أ��ֱ��Ӧpopsize����Ⱥ����ʼֵΪ0���洢���Ǳ�ѡ�еĴ���
    for j=1:100 %��ѭ��
        r = rand;
        % ���̶�
        if r < Q(1)
            Z(1) = Z(1) + 1;
        end
        for k=2:popsize %Сѭ��
            if Q(k-1) < r <= Q(k)
                Z(k) = Z(k) + 1;
            end   
        end       
    end                   %100��ѭ����Z(k)����ÿһ�鱻ѡ�еĴ���
    [~, t] = max(Z);                 
    index = [index t];    %��100��ѭ���У���ѡ�д���������һ��
end                       %popsize��ѭ����ÿһ���ҳ�һ����ѡ�����ļӵ�index�У���ʱ�µ���Ⱥ�Ͷ�Ӧindex


    
%����Ⱥ
individuals.chrom=individuals.chrom(index,:);   %individuals.chromΪ��Ⱥ�и���
individuals.fitness=individuals.fitness(index);

ret=individuals;
     
            
    