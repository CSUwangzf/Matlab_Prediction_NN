%{
_train:ѵ��
_test:����
_norm:��һ��������λ��(0,1)
tic��toc������¼matlab����ִ�е�ʱ��
%}

% ��ʼ��
tic 
clear;
clc;

% ����

% input = load('wind_power_input_1.txt');
% output = load('wind_power_output_1.txt');
input = load('scadaWindPower_input.txt');
output = load('scadaWindPower_output.txt');
save data input output

% ���ݳ�ʼ��

% input_train = input(1:149,:)';
% output_train = output(1:149,:)';
% input_test = input(150:178,:)';
% output_test = output(150:178,:)';

input_train = input(1:400,:)';
output_train = output(1:400,:)';
input_test = input(401:450,:)';
output_test = output(401:450,:)';

% ѵ�����ݹ�һ��
[input_norm, is] = mapminmax(input_train);    %is:�������ݹ�һ������
[output_norm, os] = mapminmax(output_train);  %os:������ݹ�һ������

% BP��ʼ��
% input_num = 13;
% hidden_num = 26;
% output_num = 1;
input_num = 2;
hidden_num = 5;
output_num = 1;

% ��������
TF1 = 'tansig'; TF2 = 'purelin';
net = newff(input_norm, output_norm, hidden_num, {TF1 TF2}, 'trainlm');


% �Ŵ�������ʼ��
iteration_num = 10; %��������������������
popsize = 50; %��Ⱥ��ģ���Զ���
pc = 0.3; %�������
pm = 0.1; %�������


numsum=input_num*hidden_num+hidden_num+hidden_num*output_num+output_num;
lenchrom=ones(1,numsum);       
bound=[-3*ones(numsum,1) 3*ones(numsum,1)];    %���ݷ�Χ
individuals=struct('fitness',zeros(1,popsize), 'chrom',[]);  %����Ⱥ��Ϣ����Ϊһ���ṹ��


%����Ⱥ��Ӧ�ȼ��� 
for i=1:popsize
	individuals.chrom(i,:) = Code01(lenchrom);  %����
	x = individuals.chrom(i,:);
	%������Ӧ��
	individuals.fitness(i) = fun01(x,input_num,hidden_num,output_num,net,input_norm,output_norm);
end

[bestfitness, bestindex] = min(individuals.fitness);
bestchrom = individuals.chrom(bestindex,:);  %��õ�Ⱦɫ��
%-------���ϣ���ɵ�һ�ε���Ӧ�ȼ��㼴�洢��������ѡ�񽻲����Ӷ���ø��õĸ��壬����ʮ��---------%


% ѡ�񣬽��棬����
bestfitnessindex = []; % ������¼��Ѹ����ڵڼ���
for num=1:iteration_num
	% ѡ��  
    individuals=select01(individuals,popsize);
    % ����  
    individuals.chrom=Cross01(pc,lenchrom,individuals,popsize);  
    % ����  
    individuals.chrom=Mutation01(pm,individuals,popsize,lenchrom,num,iteration_num); 
    % individuals.chrom=Mutation(pm,lenchrom,individuals,popsize,num,iteration_num,bound); 
    
    % ������Ӧ��
    for j=1:popsize
		x = individuals.chrom(j,:); %���壬����������һ������������룬Ҫ�����Ǽ���ѡ��/����/����֮�����Ӧ��ֵ
		%������Ӧ��
		individuals.fitness(j) = fun01(x,input_num,hidden_num,output_num,net,input_norm,output_norm);
        
    end	
	%�ҵ���С��Ӧ�Ⱥ������Ӧ�ȵ�Ⱦɫ�弰��������Ⱥ�е�λ��
    [newbestfitness,newbestindex] = min(individuals.fitness);
    [worestfitness,worestindex] = max(individuals.fitness);
    % ������һ�ν�������õ�Ⱦɫ��
	if newbestfitness < bestfitness
       bestfitness = newbestfitness;
       bestindex = newbestindex;
       bestchrom = individuals.chrom(bestindex,:);
    end
    
    
    %�������ʷ���������������ܻ���������ֲ����š�
    %��˶��һ���жϣ�����������ε�������ʷ��Ѷ���ͬһ�еĸ��壬���ٽ���һ��ͻ�䡣
    bestfitnessindex = [bestfitnessindex bestindex];
    if num >= 3
        if bestfitnessindex(num) == bestfitnessindex(num-1) == bestfitnessindex(num-2)
            individuals.chrom=Mutation01(pm,individuals,popsize,lenchrom,num,iteration_num);
        end
    end
    
    individuals.chrom(worestindex,:) = bestchrom;
    individuals.fitness(worestindex) = bestfitness;   %������������õ��滻   
    
    
end


% �ж��Ƿ��꣬�Ѵ�꣬������һ��
% ���˵��뷨�ǣ��趨һ�����������������N�����ֵ����Ÿ������Ӧ�ȶ�һ��ʱ��
% �ϸ��˵Ӧ���ǣ�����N���Ӵ���Ⱥ�����Ÿ�����Ӧ�ȶ�<=�������Ÿ��Ե���Ӧ�ȣ�������ֹ���㡣
% Ҳ���Լ򵥵ĸ��ݾ���̶������Ĵ�����
% �����ѳ�ʼ��ֵȨֵ

x = bestchrom;
w1 = x(1:input_num*hidden_num);
B1 = x(input_num*hidden_num+1:input_num*hidden_num+hidden_num);
w2 = x(input_num*hidden_num+hidden_num+1:input_num*hidden_num+hidden_num+hidden_num*output_num);
B2 = x(input_num*hidden_num+hidden_num+hidden_num*output_num+1:input_num*hidden_num+hidden_num+hidden_num*output_num+output_num);

net.iw{1,1} = reshape(w1,hidden_num,input_num);
net.lw{2,1} = reshape(w2,output_num,hidden_num);
net.b{1} = reshape(B1,hidden_num,1);
net.b{2} = reshape(B2,output_num,1);

% BP����ѵ��
% �������
net.trainParam.epochs = 1000;%����ѵ������
net.trainParam.goal=0.0001;%�����������
net.trainParam.show=20;% ��ʾƵ�ʣ���������Ϊûѵ��20����ʾһ��
net.trainParam.mc=0.95;% ���Ӷ�������
net.trainParam.lr=0.01;% ѧϰ������0.01
net.trainParam.min_grad=2e-6;%��С�����ݶ�
% net.trainParam.min_fail=5;% ���ȷ��ʧ�ܴ���

net.divideFcn = ''; % Ϊ���鱾һ�£������������ٵ��������Ҫ��������

%����ѵ��
[net,tr]=train(net,input_norm,output_norm);

%���ݹ�һ��
input_test_norm = mapminmax('apply',input_test,is);
an = sim(net,input_test_norm); %��һ����Ԥ����
output_test_BP = mapminmax('reverse',an,os); %Ԥ����
error = output_test_BP-output_test;

% ��ͼ
figure(1)
plot(output_test_BP,':og','LineWidth',1.5)
hold on
plot(output_test,'-*','LineWidth',1.5);
legend('Ԥ�����','�������')
grid on
set(gca,'linewidth',1.0);
xlabel('����','FontSize',15);
ylabel('�������','FontSize',15);
set(gcf,'color','w')
title('GA-BP ����','Color','k','FontSize',15);

toc









