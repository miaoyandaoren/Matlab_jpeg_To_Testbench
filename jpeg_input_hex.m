clear
close all;
f=fopen('jpeg_name.jpg');
z=fread(f);
str = dec2hex(z, 2);
fclose(f);
fid = fopen('jpeg_name.txt','wt'); %将信号写入一个.txt文件中
fprintf(fid,'i=0;\n');
if(mod(length(str),4)==0)
    fprintf(fid,'while(i<%d)',length(str)/4);
else
    fprintf(fid,'while(i<%d)',(length(str)-mod(length(str),4))/4+1);
end
fprintf(fid,' begin\n');

for i=1:4:length(str)-4
    if(i==1)
        fprintf(fid,'if(inport_accept_o&&i==%d)begin\n',(i-1)/4);
        fprintf(fid,'inport_data_i = 32''h');
        fprintf(fid,'%c%c%c%c%c%c%c%c;\n',str(i+3,1),str(i+3,2),str(i+2,1),str(i+2,2),str(i+1,1),str(i+1,2),str(i,1),str(i,2));
        fprintf(fid,'#100\n');
        fprintf(fid,'i=i+1;\n');
        fprintf(fid,'end\n');
    else
        fprintf(fid,'else if(inport_accept_o&&i==%d)begin\n',(i-1)/4);
        fprintf(fid,'inport_data_i = 32''h');
        fprintf(fid,'%c%c%c%c%c%c%c%c;\n',str(i+3,1),str(i+3,2),str(i+2,1),str(i+2,2),str(i+1,1),str(i+1,2),str(i,1),str(i,2));
        fprintf(fid,'#100\n');
        fprintf(fid,'i=i+1;\n');
        fprintf(fid,'end\n');
    end
end
if(mod(length(str)-i+1,4) ~= 0)
    fprintf(fid,'else if(inport_accept_o&&i==%d)begin\n',(i-1)/4+1);
    fprintf(fid,'inport_data_i = 32''h');
    for j = 1:mod(length(str)-i+1,4)
        fprintf(fid,'%c%c',str(length(str)+1-j,1),str(length(str)+1-j,2));
    end
    fprintf(fid,';\n');
    fprintf(fid,'#100\n');
    fprintf(fid,'i=i+1;\n');
    fprintf(fid,'end\n');
end
fprintf(fid,'else begin\n');
fprintf(fid,'#100\n');
fprintf(fid,';\n');
fprintf(fid,'end\n');
fprintf(fid,'end\n');
fclose(fid);