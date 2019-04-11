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
input = load('input.txt');
output = load('output.txt');
save data input output

% ���ݳ�ʼ��
input_train = input(1:150,:)';
output_train = output(1:150,:)';
input_test = input(151:186,:)';
output_test = output(151:186,:)';

% ѵ�����ݹ�һ��
[input_norm, is] = mapminmax(input_train);    %is:�������ݹ�һ������
[output_norm, os] = mapminmax(output_train);  %os:������ݹ�һ������

% BP��ʼ��
input_num = 3;
hidden_num = 6;
output_num = 1;

% ��������
TF1 = 'tansig'; TF2 = 'purelin';
net = newff(input_norm, output_norm, hidden_num, {TF1 TF2}, 'trainlm');


% �Ŵ�������ʼ��
iteration_num = 10; %��������������������
popsize = 30; %��Ⱥ��ģ���Զ���
pc = 0.3; %�������
pm = 0.1; %�������


numsum=input_num*hidden_num+hidden_num+hidden_num*output_num+output_num;
lenchrom=ones(1,numsum);       
bound=[-3*ones(numsum,1) 3*ones(numsum,1)];    %���ݷ�Χ
individuals=struct('fitness',zeros(1,popsize), 'chrom',[]);  %����Ⱥ��Ϣ����Ϊһ���ṹ��


%����Ⱥ��Ӧ�ȼ��� 
for i=1:popsize
	individuals.chrom(i,:) = Code(lenchrom, bound);  %����
	x = individuals.chrom(i,:);
	%������Ӧ��
	individuals.fitness(i) = fun(x,input_num,hidden_num,output_num,net,input_norm,output_norm);
end

[bestfitness, bestindex] = min(individuals.fitness);
bestchrom = individuals.chrom(bestindex,:);  %��õ�Ⱦɫ��
%-------���ϣ���ɵ�һ�ε���Ӧ�ȼ��㼴�洢��������ѡ�񽻲����Ӷ���ø��õĸ��壬����ʮ��---------%


% ѡ�񣬽��棬����
for i=1:iteration_num
	% ѡ��  
    individuals=select(individuals,popsize);
    % ����  
    individuals.chrom=Cross(pc,lenchrom,individuals,popsize,bound);  
    % ����  
    individuals.chrom=Mutation(pm,lenchrom,individuals,popsize,i,iteration_num,bound);
    
    % ������Ӧ��
    for j=1:popsize
		x = individuals.chrom(j,:); %���壬����������һ������������룬Ҫ�����Ǽ���ѡ��/����/����֮�����Ӧ��ֵ
		%������Ӧ��
		individuals.fitness(j) = fun(x,input_num,hidden_num,output_num,net,input_norm,output_norm);
    end	
	%�ҵ���С��Ӧ�ȵ�Ⱦɫ�弰��������Ⱥ�е�λ��
    [newbestfitness,newbestindex] = min(individuals.fitness);
    [worestfitness,worestindex] = max(individuals.fitness);
    % ������һ�ν�������õ�Ⱦɫ��
	if newbestfitness < bestfitness
       bestfitness = newbestfitness;
       bestchrom = individuals.chrom(newbestindex,:);
    end
    individuals.chrom(worestindex,:) = bestchrom;
    individuals.fitness(worestindex) = bestfitness;   %������������õ��滻
end


% �ж��Ƿ��꣬�Ѵ�꣬������һ��

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
net.trainParam.epochs=1000;
net.trainParam.lr=0.1;
net.trainParam.goal=0.0001;

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









