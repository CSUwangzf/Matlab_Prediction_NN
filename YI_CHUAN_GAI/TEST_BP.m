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
% -----�ƺ��������ݻ��ֽ׶εĴ����ƺ���������Ķ�Ӧ��ϵ�����ң������ڵ�Ԥ�������Ǳ仯�����̶ܹ�

clear;

clc;

%{
��������input����15�����ݣ�ÿ��3������
��Ӧ��ѹ��������������
%}
% input_train = [493 372 445;372 445 176;445 176 235;176 235 378;235 378 429;
%  		378 429 561;429 561 651;561 651 467;651 467 527;467 527 668;
%  		527 668 841; 668 841 526;841 526 480;526 480 567;480 567 685]';  %ע��ת�÷��Ų�����

%{
�������output����15�����ݣ�ÿ��1������
��Ӧ���������ʣ�������Ҫ��õ�Ԥ��ֵ
%}
% output_train = [176 235 378 429 561 651 467 527 668 841 526 480 567 685 507];

%ѵ������Ԥ��������ȡ����һ��
%���������������
% 
input = load('input.txt');
output = load('output.txt');
% %  
% % % %�ҳ�ѵ�����ݺ�Ԥ������
input_train = input((1:150),:)';
output_train = output((1:150),:)';
input_test=input((151:185),:)';
output_test=output((151:185),:)';


%{
ѵ�����ݹ�һ��	
%}
[normInput, is] = mapminmax(input_train);
[normOutput, os] = mapminmax(output_train);

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
TF1='tansig';TF2='purelin';
net=newff(minmax(normInput),[10,1],{TF1 TF2},'traingdm');%���紴��
% net = newff(minmax(normInput), [10,1], {'tansig','tansig','purelin'}, 'traingdm');

%{
�������������
%}
net.trainParam.epochs = 5000;%����ѵ������
net.trainParam.goal=0.0001;%�����������
net.trainParam.show=20;% ��ʾƵ�ʣ���������Ϊûѵ��20����ʾһ��
net.trainParam.mc=0.95;% ���Ӷ�������
net.trainParam.lr=0.01;% ѧϰ������0.01
net.trainParam.min_grad=2e-6;%��С�����ݶ�
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
[normValidateOutput,validatePerf]=sim(net,valideSample.i,[],[],valideSample.o);%�仯�����ݣ���BP�õ��Ľ��
[normTestOutput,testPerf]=sim(net,testSample.i,[],[],testSample.o);%�������ݣ���BP�õ��Ľ��
% ??????????????????????????�����ϵ�sim�������������ֻ��ǰ����????????????????????????????????????????????��
% [normTrainOutput,trainPerf]=sim(net,trainSample.i);%ѵ�������ݣ�����BP�õ��Ľ��
% [normValidateOutput,validatePerf]=sim(net,valideSample.i);%�仯�����ݣ���BP�õ��Ľ��
% [normTestOutput,testPerf]=sim(net,testSample.i);%�������ݣ���BP�õ��Ľ��
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
% ע�����
    %normTestOutput��testSample.oӦ����һһ��Ӧ�Ĺ�ϵ����Ϊ����֮ǰ����divider����������Ҫ��testSample.o
    %����һ��������ʹ��ԭʼ��output_train����Ϊԭʼ�����Ѿ���������
% testOutput = mapminmax('reverse',normTestOutput,os);%�������ݣ�BP�õ��Ĺ�һ���Ľ��output
% testInsect = mapminmax('reverse',normOutput,os);%����������֪�����output

%{
��Ԥ�⣬����ҪԤ�������pnew
%}
pnew=[480 567 685]'; %�����Ԥ������
pnewn=mapminmax(pnew); %��һ��
anewn=sim(net,pnewn); %����
anew=mapminmax('reverse',anewn,os); %����һ���õ�Ԥ����

inputn_test = mapminmax('apply', input_test, is);
an = sim(net, inputn_test);
BPoutput = mapminmax('reverse', an, os);


%{
��ʱ�����������е�trainȫ����Ϊtest����Ϊ����Ҫ��������"����ֵ"����������ѵ��ֵ--------------
%}
% ����Ԥ������� trainOutput trainInsect
figure(1)
plot(BPoutput,':og')
hold on
plot(output_test,'- *');
legend('Ԥ�����','�������')
title('BP����Ԥ�����','fontsize',12)
ylabel('�������','fontsize',12)
xlabel('����','fontsize',12)

% ���ͼ
% errors = trainInsect - trainOutput;
errors = BPoutput - output_test;
figure(2)
plot(errors,'- *')
title('BP����Ԥ�����','fontsize',12)
ylabel('���','fontsize',12)
xlabel('����','fontsize',12)




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
