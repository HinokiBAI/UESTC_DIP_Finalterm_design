I=imread('rice.bmp');
T2=graythresh(I);
BW2=im2bw(I,T2);
figure;
imshow(BW2);
hold on;
STATS=regionprops(logical(BW2),'all');
for i=1:148
    if STATS(i).Area >12
        a=STATS(i).Centroid(:,1);
        b=STATS(i).Centroid(:,2);
        [c]=STATS(i).BoundingBox;
        plot(a,b,'o');
        rectangle('position',c,'edgecolor','r');
    end
end
