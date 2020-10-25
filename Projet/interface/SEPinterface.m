function varargout = SEPinterface(varargin)
global Img;
global I5;
global idx;
global RE;
global E;

% SEPINTERFACE M-file for SEPinterface.fig
%      SEPINTERFACE, by itself, creates a new SEPINTERFACE or raises the existing
%      singleton*.
%
%      H = SEPINTERFACE returns the handle to a new SEPINTERFACE or the handle to
%      the existing singleton*.
%
%      SEPINTERFACE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SEPINTERFACE.M with the given input arguments.
%
%      SEPINTERFACE('Property','Value',...) creates a new SEPINTERFACE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SEPinterface_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SEPinterface_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SEPinterface

% Last Modified by GUIDE v2.5 15-Apr-2017 15:59:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SEPinterface_OpeningFcn, ...
                   'gui_OutputFcn',  @SEPinterface_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before SEPinterface is made visible.
function SEPinterface_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SEPinterface (see VARARGIN)

% Choose default command line output for SEPinterface
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SEPinterface wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SEPinterface_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Img;
[fname path]=uigetfile('*All Files','select an image');
fname=strcat(path,fname);
Img=imread(fname);
axes(handles.axes1);
imshow(Img);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Img
BW=rgb2gray(Img);
J1=adapthisteq(BW);
I4=medfilt2(J1,[3,3]);
Iter_outer = 100;
Iter_inner = 10;
sigma = 4;  % scale parameter %Paramètre d'échelle
timestep = .1;
mu = 0.1/timestep;
A=255;
nu = 0.001*A^2;  % weight of length term %Poids du terme de longueur
c0 = 1;
epsilon = 1;
Img1 = double(I4(:,:,1));
Img1=normalize01(Img1)*A; % rescale the image intensity to the interval [0,A]%Redéfinir l'intensité de l'image à l'intervalle [0, A]
Mask=(Img1>5);
[nrow,ncol] = size(Img1)
numframe=0;
axes(handles.axes2);
imagesc(Img1,[0 255]);colormap(gray);hold on; axis off;axis equal;
%%% initialization of bias field and level set function
b=ones(size(Img1));
initialLSF(:,:,1) = randn(size(Img1));  % randomly initialize the level set functions
initialLSF(:,:,2) = randn(size(Img1));  % Initialiser aléatoirement les fonctions de jeu de niveau
initialLSF(:,:,1)= Mask;  % remove the background outside the mask %Retirer l'arrière-plan à l'extérieur du masque
u = sign(initialLSF);
[c,h] = contour(u(:,:,1),[0 0],'r')
[c,h] = contour(u(:,:,2),[0 0],'b')
hold off
Ksigma=fspecial('gaussian',round(2*sigma)*2+1,sigma); % Gaussian kernel
% disk_radius = 7; 
% Ksigma=fspecial('disk',disk_radius); % an alternative kernel as a truncated uniform function
KONE=conv2(ones(size(Img1)),Ksigma,'same');
pause(0.1)
totaltime =0
for n = 1:Iter_outer
    t0=cputime;
    [u, b, C]=  lse_bfe_3Phase(u,Img1,b,Ksigma,KONE, nu,timestep,mu,epsilon,Iter_inner);
    t1=cputime;
    totaltime = totaltime + t1-t0;
    if(mod(n,3) == 0)
        pause(0.01);
        imagesc(Img1,[0 255]);colormap(gray);hold on; axis off;axis equal;
        [c,h] = contour(u(:,:,1),[0 0],'r');
        [c,h] = contour(u(:,:,2),[0 0],'b');
        iterNum=[num2str(n), ' iterations'];
        title(iterNum);
        hold off;   
    end
end
I=im2bw(Img);
axes(handles.axes4);
imshow(u(:,:,1));
Il=u(:,:,2);
Il=im2bw(Il);
IL2=~Il;
k=u(:,:,1);
k=im2bw(k);
kk=~k;
axes(handles.axes5);
imshow(IL2);
axes(handles.axes10);
imshow(Il);
axes(handles.axes9);
imshow(kk);



% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Img
BW=rgb2gray(Img);
J1=adapthisteq(BW);
axes(handles.axes3);
imshow(J1)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Img;
global RE;
global idx;
global I5;
global E11;
 %L11=bwlabel(I5);
%STATS2 = regionprops(L11, 'FilledImage','FilledArea');
Label=bwlabel(double(I5));%% region :image binaire
E11=regionprops(Label,'Area');
num4=numel(E11)
Vecteur=zeros(num4,1); %vecteur ds lequel je stocke les valeurs
for i=1:num4
  surface=E11(i).Area
Vecteur(i,1)=surface
 end
%[B,Indx]=sort(Vecteur,'descend'); %%trier les distance un tri descendant
[pasbesoin,idx] = sort([E11.Area],'descend')
idx(10:end)=[]
RE= Label==idx(handles.counter);
handles.counter=handles.counter+1;
axes(handles.axes7);
imshow(RE)
guidata(hObject,handles);





% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% global I5;
% global Img;
% global C;
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% a=get(hObject,'Value');
% if a==1
global I5;
global Img;
global C;
C=rgb2gray(Img);
C(C<180)=0;
D=im2bw(C);%binary Image
I5=medfilt2(D,[5,5]);
% L11=bwlabel(I5);
 L11=logical(I5);
T=[];
STATS2 = regionprops(L11, 'FilledImage','FilledArea');
Label=bwlabel(double(I5));%% region :image binaire
E11=regionprops(Label,'Area');
num4=numel(E11)
Vecteur=zeros(num4,1); %vecteur ds lequel je stocke les valeurs
for i=1:num4
  surface=E11(i).Area
Vecteur(i,1)=surface
 end
[B,Indx]=sort(Vecteur,'descend'); %%trier les distance un tri descendant
[pasbesoin,idx] = sort([E11.Area],'descend')
idx(10:end)=[]
handles.output=hObject;
%handles.intial_parameter=varargin{1};
handles.counter=1;
RE= Label==idx(handles.counter); %change juste 2 par 1 et ça marche 
axes(handles.axes7);    
imshow(RE);
% else
%     a=0
% end
guidata(hObject, handles);



% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Img
BW=rgb2gray(Img);
J1=adapthisteq(BW);
I4=medfilt2(J1,[3,3]);
axes(handles.axes6);
imshow(I4)


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
global areaencmcarre
global data
global x;
global chemin ;
global data;
global E11;
global E1;
global Label;
global idx;
global RE;
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=get(hObject,'Value');
if a==1
global RE;
global areaencmcarre;
global lambda;
global seuil;
global iteration_number;
global regs;
global x;
global chemin ;
global data;
global E11;
global E1;
global Label;
global idx;
%Résolution de l'ecran
%Sets the units of your root object (screen) to pixels
set(0,'units','pixels');
%Obtains this pixel information
Pix_SS = get(0,'screensize');
%Sets the units of your root object (screen) to inches
set(0,'units','inches');
%Obtains this inch information
Inch_SS = get(0,'screensize');
%Calculates the resolution (pixels per inch)
Res = Pix_SS./Inch_SS;
%1-calcul d'air en cm
% E=im2bw(RE);
Label = bwlabel(RE);
 E1 = regionprops(Label,'Area');
[pasbesoin,idx] = sort([E1.Area],'descend');
% Affichage du contour du rein le plus grand
handles.counter=0;
handles.counter=handles.counter+1;
[L,num] = bwlabel(RE);
rp =regionprops(L,{'area','perimeter','Eccentricity','Solidity'});
stats = regionprops(L,'Area');
area = [stats.Area];
areaencmcarre=(area*6.4516)/(Res(3)*Res(4))
set(handles.text5,'string',areaencmcarre)
else
    a=0
end
guidata(hObject,handles);

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
global RE;
global idx;
global I5;
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=get(hObject,'Value');
if a==1
global RE;
global idx;
global I5;
L11=bwlabel(I5);
handles.counter=0;
 handles.counter=handles.counter+1;
STATS2 = regionprops(L11, 'FilledImage','FilledArea');
Label=bwlabel(double(I5));%% region :image binaire
E11=regionprops(Label,'Area');
num4=numel(E11)
Vecteur=zeros(num4,1); %vecteur ds lequel je stocke les valeurs
for i=1:num4
  surface=E11(i).Area
Vecteur(i,1)=surface
 end
[B,Indx]=sort(Vecteur,'descend'); %%trier les distance un tri descendant
[pasbesoin,idx] = sort([E11.Area],'descend')
[L,num] = bwlabel(RE);
  E3=regionprops(L,'Eccentricity')
  pe=num2str(E3.Eccentricity);
 set(handles.text7,'string',pe);
 else
    a=0
end
guidata(hObject,handles);
  


% Hint: get(hObject,'Value') returns toggle state of checkbox2


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
global RE;
global idx;
global I5;
global E11;
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=get(hObject,'Value');
if a==1
global RE;
global idx;
global I5;
global E11;
L11=bwlabel(I5);
STATS2 = regionprops(L11, 'FilledImage','FilledArea');
Label=bwlabel(double(I5));%% region :image binaire
E11=regionprops(Label,'Area');
num4=numel(E11)
Vecteur=zeros(num4,1); %vecteur ds lequel je stocke les valeurs
for i=1:num4
  surface=E11(i).Area
Vecteur(i,1)=surface
 end
[B,Indx]=sort(Vecteur,'descend'); %%trier les distance un tri descendant
[pasbesoin,idx] = sort([E11.Area],'descend')
[L,num] = bwlabel(RE);
handles.counter=0;
 handles.counter=handles.counter+1;
  E2=regionprops(L,'perimeter')
   per=E2.Perimeter*2.646/100
  perm=num2str(per);
 set(handles.text6,'string',perm);
 else
    a=0
end
guidata(hObject,handles);
 


% Hint: get(hObject,'Value') returns toggle state of checkbox3


% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
global RE;
global idx;
global I5;
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=get(hObject,'Value');
if a==1
global RE;
global idx;
global I5;
L11=bwlabel(I5);
T=[];
STATS2 = regionprops(L11, 'FilledImage','FilledArea');
Label=bwlabel(double(I5));%% region :image binaire
E11=regionprops(Label,'Area');
num4=numel(E11)
Vecteur=zeros(num4,1); %vecteur ds lequel je stocke les valeurs
for i=1:num4
  surface=E11(i).Area
Vecteur(i,1)=surface
 end
[B,Indx]=sort(Vecteur,'descend'); %%trier les distance un tri descendant
[pasbesoin,idx] = sort([E11.Area],'descend')
 [L,num] = bwlabel(RE);
E4=regionprops(L,'Solidity')
  pee=num2str(E4.Solidity);
  handles.counter=0;
 handles.counter=handles.counter+1;
 set(handles.text8,'string',pee);
 else
    a=0
end
 guidata(hObject,handles);
 

% Hint: get(hObject,'Value') returns toggle state of checkbox4


% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
global RE;
global idx;
global I5;
global E11;
global glcm;
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=get(hObject,'Value');
if a==1
global RE;
global idx;
global I5;
global E11;
global glcm;
% textstring=get(handles.text10,'string');
L11=bwlabel(I5);
STATS2 = regionprops(L11, 'FilledImage','FilledArea');
Label=bwlabel(double(I5));%% region :image binaire
E11=regionprops(Label,'Area');
num4=numel(E11)
Vecteur=zeros(num4,1); %vecteur ds lequel je stocke les valeurs
for i=1:num4
  surface=E11(i).Area
Vecteur(i,1)=surface
 end
[B,Indx]=sort(Vecteur,'descend'); %%trier les distance un tri descendant
[pasbesoin,idx] = sort([E11.Area],'descend')
handles.counter=0;
  handles.counter=handles.counter+1;
   glcm=graycomatrix(RE)
   stats = graycoprops(glcm,'contrast') 
  set(handles.text10,'string',num2str(stats.Contrast));
  else
    a=0
end
guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of checkbox5


% --- Executes on button press in checkbox6.
function checkbox6_Callback(hObject, eventdata, handles)
global RE;
global idx;
global I5;
global E11;
global glcm;
% hObject    handle to checkbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=get(hObject,'Value');
if a==1
global RE;
global idx;
global I5;
global E11;
global glcm;
L11=bwlabel(I5);
STATS2 = regionprops(L11, 'FilledImage','FilledArea');
Label=bwlabel(double(I5));%% region :image binaire
E11=regionprops(Label,'Area');
num4=numel(E11)
Vecteur=zeros(num4,1); %vecteur ds lequel je stocke les valeurs
for i=1:num4
  surface=E11(i).Area
Vecteur(i,1)=surface
 end
[B,Indx]=sort(Vecteur,'descend'); %%trier les distance un tri descendant
[pasbesoin,idx] = sort([E11.Area],'descend')
handles.counter=0;
  handles.counter=handles.counter+1;
   glcm=graycomatrix(RE)
   stats = graycoprops(glcm,'Energy') 
  set(handles.text11,'string',num2str(stats.Energy));
  else
    a=0
end
guidata(hObject,handles);

% Hint: get(hObject,'Value') returns toggle state of checkbox6


% --- Executes on button press in checkbox7.
function checkbox7_Callback(hObject, eventdata, handles)
global RE;
global idx;
global I5;
global E11;
global glcm;
% hObject    handle to checkbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=get(hObject,'Value');
if a==1
global RE;
global idx;
global I5;
global E11;
global glcm;
L11=bwlabel(I5);
STATS2 = regionprops(L11, 'FilledImage','FilledArea');
Label=bwlabel(double(I5));%% region :image binaire
E11=regionprops(Label,'Area');
num4=numel(E11)
Vecteur=zeros(num4,1); %vecteur ds lequel je stocke les valeurs
for i=1:num4
  surface=E11(i).Area
Vecteur(i,1)=surface
 end
[B,Indx]=sort(Vecteur,'descend'); %%trier les distance un tri descendant
[pasbesoin,idx] = sort([E11.Area],'descend')
handles.counter=0;
  handles.counter=handles.counter+1;
   glcm=graycomatrix(RE)
   stats = graycoprops(glcm,'Homogeneity') 
  set(handles.text12,'string',num2str(stats.Homogeneity));
  else
    a=0
end
guidata(hObject,handles);

% Hint: get(hObject,'Value') returns toggle state of checkbox7


% --- Executes on button press in checkbox8.
function checkbox8_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global idx;
idx(10:end)=[]
LL=length(idx)
set(handles.text9,'string',LL);
% Hint: get(hObject,'Value') returns toggle state of checkbox8



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Img;
C=rgb2gray(Img);
C(C<180)=0;
D=im2bw(C);%binary Image;
I5=medfilt2(D,[9,9]);
axes(handles.axes8);
imshow(I5);
