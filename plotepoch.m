function [train,test]=plotepoch(filename,epochnum)
file_t=fopen(filename,'r');
A=fscanf(file_t,'%s');
fclose(file_t);
train=zeros(epochnum,1);
test=zeros(epochnum,1);
for i=2:epochnum
    str_train=strcat('train:epoch',num2str(i,'%.2i'));
    str_test=strcat('test:epoch',num2str(i,'%.2i'));
    str_train
    k_train = strfind(A,str_train);
    for j=1:length(k_train)
        flag=A(k_train(j)+26:k_train(j)+32);
        ind=regexp(flag,'\d','start');
        
        %A2=isstrprop(flag,'digit');        
        train(i,j)=str2num(flag(ind(1):ind(end)));       
    end
    
    k_test = strfind(A,str_test);
    for j=1:length(k_test)
        flag=A(k_train(j)+26:k_train(j)+32);
        ind=regexp(flag,'\d','start');
        %A2=isstrprop(flag,'digit');        
        test(i,j)=str2num(flag(ind(1):ind(end)));         
    end
end
figure,plot(1:epochnum,mean(train,2),'*r');hold on;plot(1:epochnum,mean(test,2),'og'),legend('train','test')

