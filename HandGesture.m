%Hand Gesture Codes By YMD


clear all; clc; close all;                                                %clear stored variables, command windows, close any open windows

vid=videoinput('winvideo',1);                                             %sets videoinput to the webcam, and the webcam device 1
%figure(3);preview(vid);                                                  %displays the webcam input
figure(1);
set(vid,'ReturnedColorspace','rgb')
pause(2);                                                                 % pause 2 seconds before snapshot of background image
IM1=getsnapshot(vid);                                                     %get snapshot from the webcam video and store to IM1 variable
figure(1);subplot(3,3,1);imshow(IM1);title('Background');                 %open up a figure and show the image stored in IM1 variable

pause(2);                                                                 %pause a second before taking the test image snapshot
IM2=getsnapshot(vid);                                                     %get snapshot of test image and store to variable IM2
figure(1);subplot(3,3,2);imshow(IM2);title('Gesture');                    %open up a figure and show the image stored in IM2 variable


IM3 = IM1 - IM2;                                                            %subtract Backround from Image
figure(1);subplot(3,3,3);imshow(IM3);title('Subtracted');                   %show the subtracted image
IM3 = rgb2gray(IM3);                                                        %Converts RGB to Gray
figure(1);subplot(3,3,4);imshow(IM3);title('Grayscale');                    %Display Gray Image
lvl = graythresh(IM3);                                                      %find the threshold value using Otsu's method for black and white

IM3 = im2bw(IM3, lvl);                                                      %Converts image to BW, pixels with value higher than threshold value is changed to 1, lower changed to 0
figure(1);subplot(3,3,5);imshow(IM3);title('Black&White');                  %display black and white image
IM3 = bwareaopen(IM3, 10000);
IM3 = imfill(IM3,'holes');
figure(1);subplot(3,3,6);imshow(IM3);title('Small Areas removed & Holes Filled');  
IM3 = imerode(IM3,strel('disk',15));                                        %erode image
IM3 = imdilate(IM3,strel('disk',20));                                       %dilate iamge
IM3 = medfilt2(IM3, [5 5]);                                                 %median filtering
figure(1);subplot(3,3,7);imshow(IM3);title('Eroded,Dilated & Median Filtered');  
IM3 = bwareaopen(IM3, 10000);                                               %finds objects, noise or regions with pixel area lower than 10,000 and removes them
figure(1);subplot(3,3,8);imshow(IM3);title('Processed');                    %displays image with reduced noise
IM3 = flipdim(IM3,1);                                                       %flip image rows
figure(1);subplot(3,3,9);imshow(IM3);title('Flip Image');   


REG=regionprops(IM3,'all');                                                 %calculate the properties of regions for objects found 
CEN = cat(1, REG.Centroid);                                                 %calculate Centroid
[B, L, N, A] = bwboundaries(IM3,'noholes');                                 %returns the number of objects (N), adjacency matrix A, object boundaries B, nonnegative integers of contiguous regions L

RND = 0;                                                                    % set variable RND to zero; to prevent errors if no object detected


%calculate the properties of regions for objects found
    for k =1:length(B)                                                      %for the given object k
            PER = REG(k).Perimeter;                                         %Perimeter is set as perimeter calculated by region properties 
            ARE = REG(k).Area;                                              %Area is set as area calculated by region properties
            RND = (4*pi*ARE)/(PER^2);                                       %Roundness value is calculated
            
            BND = B{k};                                                     %boundary set for object
            BNDx = BND(:,2);                                                %Boundary x coord
            BNDy = BND(:,1);                                                %Boundary y coord
            
            pkoffset = CEN(:,2)+.5*(CEN(:,2));                             %Calculate peak offset point from centroid
            [pks,locs] = findpeaks(BNDy,'minpeakheight',pkoffset);         %find peaks in the boundary in y axis with a minimum height greater than the peak offset
            pkNo = size(pks,1);                                            %finds the peak Nos
            pkNo_STR = sprintf('%2.0f',pkNo);                              %puts the peakNo in a string
            
            figure(2);imshow(IM3);
            hold on
            plot(BNDx, BNDy, 'b', 'LineWidth', 2);                          %plot Boundary
            plot(CEN(:,1),CEN(:,2), '*');                                   %plot centroid
            plot(BNDx(locs),pks,'rv','MarkerFaceColor','r','lineWidth',2);  %plot peaks
            hold off
    
    end
                                                                            % roundness is useful, for an object of same shape ratio, regardless of
                                                                            % size the roundess value remains the same. For instance, a circle with
                                                                            % radius 5pixels will have the same roundness as a circle with radius
                                                                            % 100pixels. It is a measure of how round an object is.
                                                                            
    % Identification Codes, You might need to change these
    
    CHAR_STR = 'not identified';                                            %sets char_str value to 'not identified'
    if RND >0.19 && RND < 0.24 && pkNo ==3
        CHAR_STR = 'W';
    elseif RND >0.44 && RND < 0.47  && pkNo ==1
        CHAR_STR = 'O';
    elseif RND >0.37 && RND < 0.40 && pkNo ==2
        CHAR_STR = 'R';
    elseif RND >0.40 && RND < 0.43 && pkNo == 3
        CHAR_STR = 'D';
    else
        CHAR_STR = 'not identified';
    end
    text(20,20,CHAR_STR,'color','r','Fontsize',18);                         %place text in x=20,y=20 on the figure with the value of Char_str in redcolour with font size 18
    text(20,100,['RND: ' sprintf('%f',RND)],'color','r','Fontsize',18);
    text(20,180,['PKS: ' pkNo_STR],'color','r','Fontsize',18);
