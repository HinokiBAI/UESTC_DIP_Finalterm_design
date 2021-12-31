img=imread('lena.bmp');
img1=imnoise(img,'gaussian');
img2=imnoise(img,'salt & pepper');
subplot(2,2,1),imshow(img1),title('高斯噪声');
subplot(2,2,2),imshow(img2),title('椒盐噪声');
F=fft2(img1);
[M,N]=size(F);
u=0:(M-1);v=0:(N-1);
idx = find(u > M/2);u(idx) = u(idx) - M;
idy = find(v > N/2);v(idy) = v(idy) - N;
[U,V]=meshgrid(u,v);
D=sqrt(U.^2+V.^2);
D0=1000;
H1=ones(M,N);
for i=1:M
    for j=1:N
        if D(i,j)^2>=D0
            H1(i,j)=0;
        end
    end
end

shiftH=fftshift(H1);
g=real(ifft2(F.*H1));

F2=fft2(img2);
[M,N]=size(F2);
u=0:(M-1);v=0:(N-1);
idx = find(u > M/2);u(idx) = u(idx) - M;
idy = find(v > N/2);v(idy) = v(idy) - N;
[U,V]=meshgrid(u,v);
D=sqrt(U.^2+V.^2);
D0=1000;
H2=ones(M,N);
for i=1:M
    for j=1:N
        if D(i,j)^2>=D0
            H2(i,j)=0;
        end
    end
end

shiftH=fftshift(H2);
g2=real(ifft2(F2.*H2));
subplot(223),imshow(g,[]),title('低通滤波');
subplot(224),imshow(g2,[]),title('低通滤波');


