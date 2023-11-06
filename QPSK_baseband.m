% Experiment by Ravi Patel
N=10000 ; % no bits to be generated

Eb=1 ;
Es=2;
SNR_db=-10:3:8 ;
SINR_lin=power(10,(SNR_db/10));
sigma=(1./(SINR_lin));
sym= randn(1,N);
xt=sym>0 ;


newSeq=[];
for i = 1:N
    if(xt(i)==0)
        newSeq=[newSeq,-Eb];
    else
        newSeq=[newSeq,Eb];
    end

end
Qps_seq = reshape(newSeq,2,N/2) ; % changing into Qpsk symbol
origSig=reshape(xt,2,N/2);


for j = 1: length(SNR_db)
    modSeq=[];
    nt=sqrt(sigma(j)).*randn(1,N);
    
    % generation of modulated one
    modSeq=newSeq+nt;
   
    
    recSeq=modSeq>=0;
    recQPSK=reshape(recSeq,2,N/2);

    %% calulating bit error Expected and Calulating one
    myERR_bit=recSeq~=xt;
    caluERR_bit(j)=sum(myERR_bit)/N ;  % bit error
    expERR_bit(j)= qfunc(sqrt(1/sigma(j)));

    %% calulating Symbol error Expected and Calulating on
     
    count=0;
    for a = 1:N/2
        
        if(recQPSK(1,a)~=origSig(1,a) || recQPSK(2,a)~=origSig(2,a))
            count=count+1;
        end
    end
    
    caluERR_sym(j)=count/(N/2);
    expERR_sym(j)=2*expERR_bit(j)-expERR_bit(j)^2 ;
    

end

% Figure 1
figure(1)
semilogy(SNR_db, caluERR_bit, 'Marker', 'd', 'MarkerFaceColor', 'g', 'MarkerEdgeColor', 'm', 'LineWidth', 2);
hold on;
semilogy(SNR_db, expERR_bit, '--rs', 'Marker', 'd', 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'm', 'LineWidth', 2);
xlabel('SNR (dB)');
ylabel('Bit Error Rate');
legend('Calculated Bit Error Rate', 'Experimental Bit Error Rate');

% Figure 2
figure(2)
semilogy(SNR_db, caluERR_sym, 'Marker', 'd', 'MarkerFaceColor', 'g', 'MarkerEdgeColor', 'm', 'LineWidth', 2);
hold on;
semilogy(SNR_db, expERR_sym, '--rs', 'Marker', 'd', 'MarkerFaceColor', 'g', 'MarkerEdgeColor', 'm', 'LineWidth', 2);
xlabel('SNR (dB)');
ylabel('Symbol Error Rate');
legend('Calculated Symbol Error Rate', 'Experimental Symbol Error Rate');

