%{
1. ��ʼ��
2. ��ȡ�����������
3. ����������ݹ�һ��

3.5	����֪��������dividevec��������Ϊѵ�����ݡ��仯���ݡ���������

4. ����������
5. ����ѵ��������
6. ��ʼѵ��

7. ����
8. �������ݽ���Ԥ��
9. �������
10.��ͼ
%}

% -----�ο��ļ�����FOR I = 0 : 200������ѭ��??????????????????????????????��Ҫ�ٿ�һ��

clear;

clc;

%{
��������input����15�����ݣ�ÿ��3������
��Ӧ��ѹ��������������
%}
input = [493 372 445;372 445 176;445 176 235;176 235 378;235 378 429;
		378 429 561;429 561 651;561 651 467;651 467 527;467 527 668;
   		527 668 841; 668 841 526;841 526 480;526 480 567;480 567 685]';  %ע��ת�÷��Ų�����

%{
�������output����15�����ݣ�ÿ��1������
��Ӧ���������ʣ�������Ҫ��õ�Ԥ��ֵ
%}
output = [176 235 378 429 561 651 467 527 668 841 526 480 567 685 507];

%{
���ݹ�һ��	
%}
[normInput, is] = mapminmax(input);
[normOutput, os] = mapminmax(output);
%[p1,minp,maxp,t1,mint,maxt]=premnmx(input,output);
% ��һ����premnmx����������һ����postmnmx����

%{
�������򼰷��ദ��
�����ݻ���Ϊѵ�����ݡ��仯���ݡ���������	
%}

%--------------���ｫ�������ݺ�������ݷֱ���Ի��֣���������ǵ�һһ��Ӧ��ϵ��????????????????????
[trainSample.i,valideSample.i,testSample.i] =dividerand(normInput,0.7,0.15,0.15);

[trainSample.o,valideSample.o,testSample.o] =dividerand(normOutput,0.7,0.15,0.15);


%{
����������
ʹ��newff����
�Ľ�����������ȡ��������Ϊ����
http://blog.sina.com.cn/s/blog_5f853eb10100zyib.html
%}
net = newff(minmax(normInput), [10,1], {'tansig','tansig','purelin'}, 'trainlm');

%{
�������������
%}
net.trainParam.epochs = 5000;%����ѵ������
net.trainParam.goal=0.0000001;%�����������
net.trainParam.show=20;% ��ʾƵ�ʣ���������Ϊûѵ��20����ʾһ��
net.trainParam.mc=0.95;% ���Ӷ�������
net.trainParam.lr=0.05;% ѧϰ���ʣ���������Ϊ0.05
net.trainParam.min_grad=1e-6;%��С�����ݶ�
net.trainParam.min_fail=5;% ���ȷ��ʧ�ܴ���

%{
��ʼѵ��������	
%}
net.trainFcn='trainlm';
[net,tr]=train(net,trainSample.i,trainSample.o);
% [net,tr]=train(net,normInput,normOutput);


%{
ѵ����ɺ�ʼ����
ʹ��sim����	
%}
[normTrainOutput,trainPerf]=sim(net,trainSample.i,[],[],trainSample.o);%ѵ�������ݣ�����BP�õ��Ľ��
[normValidateOutput,validatePerf]=sim(net,valideSample.i,[],[],valideSample.o);%��֤�����ݣ���BP�õ��Ľ��
[normTestOutput,testPerf]=sim(net,testSample.i,[],[],testSample.o);%�������ݣ���BP�õ��Ľ��
% [normTestOutput,testPerf]=sim(net,normInput,[],[],normOutput);%�������ݣ���BP�õ��Ľ��

%{
����������ݷ���һ���������ҪԤ�⣬ֻ�轫Ԥ�������input����
�����Ԥ����output
%}
trainOutput = mapminmax('reverse',normTrainOutput,os);%ѵ�����ݣ�BP�õ��Ĺ�һ����Ľ��output
trainInsect = mapminmax('reverse',trainSample.o,os);%ѵ��������֪�����output
validateOutput = mapminmax('reverse',normValidateOutput,os);%�������ݣ�BP�õ��Ĺ�һ���Ľ��output
validateInsect = mapminmax('reverse',valideSample.o,os);%������������֪�����output
testOutput = mapminmax('reverse',normTestOutput,os);%�������ݣ�BP�õ��Ĺ�һ���Ľ��output
testInsect = mapminmax('reverse',testSample.o,os);%����������֪�����output
% testOutput = mapminmax('reverse',normTestOutput,os);%�������ݣ�BP�õ��Ĺ�һ���Ľ��output
% testInsect = mapminmax('reverse',normOutput,os);%����������֪�����output

%{
��Ԥ�⣬����ҪԤ�������pnew
%}
pnew=[313,256,239]'; %�����Ԥ������
pnewn=mapminmax(pnew); %��һ��
anewn=sim(net,pnewn); %����
anew=mapminmax('reverse',anewn,os); %����һ���õ�Ԥ����


%{
%����������
absTrainError = trainOutput-trainInsect;
absTestError = testOutput-testInsect;
error_sum=sqrt(absTestError(1).^2+absTestError(2).^2+absTestError(3).^2);
All_error=[All_error error_sum];
eps=90;%��Ϊ3��������ݵı�׼�����ÿ������ƫ����һ����Χ�ڶ��б�
if ((abs(absTestError(1))<=30)&(abs(absTestError(2))<=30)&(abs(absTestError(3))<=30)|(error_sum<=eps))
save mynetdata net
     break
end
j
end
j
Min_error_sqrt=min(All_error)

testOutput
testInsect
%}

%{
���ݷ����ͻ�ͼ

figure
plot(1:12,[trainOutput validateOutput],'b-',1:12,[trainInsect validateInsect],
'g--',13:15,testOutput,'m*',13:15,testInsect,'ro');

title('oΪ��ʵֵ��*ΪԤ��ֵ')

xlabel('���');
ylabel('��ͨ��������/��ҹ��');

figure
xx=1:length(All_error);
plot(xx,All_error)
title('���仯ͼ')

%}
