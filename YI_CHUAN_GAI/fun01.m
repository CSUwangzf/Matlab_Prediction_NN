% fun������BP������Ԥ�⣬��¼Ԥ����

function error = fun01(x,input_num,hidden_num,output_num,net,input_norm,output_norm)
%�ú�������������Ӧ��ֵ
%x          input     ����
%inputnum   input     �����ڵ���
%outputnum  input     ������ڵ���
%net        input     ����
%netʹ���������ж�������磬����Ҫ�ٴδ���
%inputn     input     ѵ����������
%outputn    input     ѵ���������
%error      output    ������Ӧ��ֵ
%��ȡ
w1=x(1:input_num*hidden_num);
B1=x(input_num*hidden_num+1:input_num*hidden_num+hidden_num);
w2=x(input_num*hidden_num+hidden_num+1:input_num*hidden_num+hidden_num+hidden_num*output_num);
B2=x(input_num*hidden_num+hidden_num+hidden_num*output_num+1:input_num*hidden_num+hidden_num+hidden_num*output_num+output_num);
% net=newff(input_norm,output_norm,hidden_num);
%�����������
net.trainParam.epochs=20;
net.trainParam.lr=0.1;
net.trainParam.goal=0.0001;
net.trainParam.show=100;
net.trainParam.showWindow=0;
%����Ȩֵ��ֵ
net.iw{1,1}=reshape(w1,hidden_num,input_num);
net.lw{2,1}=reshape(w2,output_num,hidden_num);
net.b{1}=reshape(B1,hidden_num,1);
net.b{2}=reshape(B2,output_num,1);

%����ѵ��
net=train(net,input_norm,output_norm);
an=sim(net,input_norm);
% error=sum(abs(an-output_norm));
error=sum(abs(an-output_norm)/output_norm);







