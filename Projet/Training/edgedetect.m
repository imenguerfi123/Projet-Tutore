
function edgedetect(x)
% f=imread(x);
x=im2double(x);
choice=0;
while (choice~=5)
choice=input('1: Prewitt\n2: Roberts\n3: Laplacian of a Guassian(LoG)\n4: Canny\n5: Exit\n Enter your choice : ');
switch choice
    case 1
        PF=edge(x,'prewitt');
        figure, imshow(x),title('Original Image'),figure,imshow(PF),title('Prewitt Filter');
    case 2
        RF=edge(x,'roberts');
        figure, imshow(x),title('Original Image'),figure,imshow(RF),title('Roberts Filter');
    case 3
        LF=edge(x,'log');
        figure, imshow(x),title('Original Image'),figure,imshow(LF),title('Laplacian of Gaussian (LoG) Filter');
    case 4
        CF=edge(x,'canny');
        figure, imshow(x),title('Original Image'),figure,imshow(CF),title('Canny Filter');
    case 5
        display('Program Exited');
    otherwise
        display('\nWrong Choice\n');
    end
end




