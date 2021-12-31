function varargout = LPF(varargin)
% LPF MATLAB code for LPF.fig
%      LPF, by itself, creates a new LPF or raises the existing
%      singleton*.
%
%      H = LPF returns the handle to a new LPF or the handle to
%      the existing singleton*.
%
%      LPF('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LPF.M with the given input arguments.
%
%      LPF('Property','Value',...) creates a new LPF or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before LPF_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LPF_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LPF

% Last Modified by GUIDE v2.5 07-Sep-2015 08:45:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LPF_OpeningFcn, ...
                   'gui_OutputFcn',  @LPF_OutputFcn, ...
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


% --- Executes just before LPF is made visible.
function LPF_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LPF (see VARARGIN)

home;
warning('off', 'all');
movegui(hObject, 'center');

handles.ListboxCounter = 1;

set(handles.text_D0, 'Enable', 'off');
set(handles.edit_D0, 'Enable', 'off');
set(handles.text_D1, 'Enable', 'off');
set(handles.edit_D1, 'Enable', 'off');
set(handles.text_order_n, 'Enable', 'off');
set(handles.edit_order_n, 'Enable', 'off');

time_string = datestr(now, 'yyyy-mm-dd-HH-MM-SS');
mkdir(['.\result\', time_string]);
handles.result_path = ['.\result\', time_string];

global timer_string;
timer_string = '低通滤波演示程序_版权所有_王登位_';
handles.timer = timer('Period', 0.3, 'ExecutionMode', 'FixedRate', 'TimerFcn', {@timercallback, handles});
start(handles.timer);

% Choose default command line output for LPF
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes LPF wait for user response (see UIRESUME)
% uiwait(handles.figure_main);


% --- Outputs from this function are returned to the command line.
function varargout = LPF_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
if ~isempty(handles)
    varargout{1} = handles.output;
    
    %最大化显示控制模块
    javaFrame = get(handles.figure_main, 'JavaFrame');
    set(javaFrame, 'Maximized', 0);
    
    %去除工具栏与下方区域之间的分割条
    javaFrame.showTopSeparator(false);
    
    %改变工具栏的背景颜色
    jTbar = get(get(findall(handles.figure_main, 'Tag', 'uitoolbar_mytoolbar'), 'JavaContainer'), 'ComponentPeer');
    color = java.awt.Color.green;
    jTbar.setBackground(color);
    
    %将figure以为的屏幕区域置纯
    jFig = get(handle(handles.figure_main), 'JavaFrame');
    jFig = jFig.fHG1Client.getWindow;
    jSrc = java.awt.Toolkit.getDefaultToolkit();
    jFrm = javax.swing.JFrame;
    jFrm.setSize(jSrc.getScreenSize());
    jFrm.setUndecorated(true);
    jFrm.setDefaultCloseOperation(2);
    jFrm.getContentPane().setBackground(java.awt.Color.BLACK);
    com.sun.awt.AWTUtilities.setWindowOpacity(jFrm, 1);
    jFrm.setVisible(true);
    jFrm.setEnabled(false);
    jFig.setVisible(true);
    set(jFig, 'WindowClosedCallback', @(src, evnt)jFrm.dispose());
else
    return;
end


% --- Executes on selection change in popupmenu_filter_type.
function popupmenu_filter_type_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_filter_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_filter_type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_filter_type
switch get(hObject, 'Value')
    case 1
        set(handles.text_D0, 'Enable', 'off');
        set(handles.edit_D0, 'Enable', 'off');
        set(handles.text_D1, 'Enable', 'off');
        set(handles.edit_D1, 'Enable', 'off');
        set(handles.text_order_n, 'Enable', 'off');
        set(handles.edit_order_n, 'Enable', 'off');
        handles.filter_type = '';
        set(handles.listbox_info, 'String', strvcat(get(handles.listbox_info, 'String'), '当前滤波器的类型为：空'));
        set(handles.listbox_info, 'ListboxTop', handles.ListboxCounter);
        handles.ListboxCounter = handles.ListboxCounter + 1;
    case 2
        set(handles.text_D0, 'Enable', 'on');
        set(handles.edit_D0, 'Enable', 'on');
        set(handles.text_D1, 'Enable', 'off');
        set(handles.edit_D1, 'Enable', 'off');
        set(handles.text_order_n, 'Enable', 'off');
        set(handles.edit_order_n, 'Enable', 'off');
        handles.filter_type = 'ILPF';
        set(handles.listbox_info, 'String', strvcat(get(handles.listbox_info, 'String'), '当前滤波器的类型为：理想低通滤波器'));
        set(handles.listbox_info, 'ListboxTop', handles.ListboxCounter);
        handles.ListboxCounter = handles.ListboxCounter + 1;
    case 3
        set(handles.text_D0, 'Enable', 'on');
        set(handles.edit_D0, 'Enable', 'on');
        set(handles.text_D1, 'Enable', 'off');
        set(handles.edit_D1, 'Enable', 'off');
        set(handles.text_order_n, 'Enable', 'on');
        set(handles.edit_order_n, 'Enable', 'on');
        handles.filter_type = 'BLPF';
        set(handles.listbox_info, 'String', strvcat(get(handles.listbox_info, 'String'), '当前滤波器的类型为：Butterworth低通滤波器'));
        set(handles.listbox_info, 'ListboxTop', handles.ListboxCounter);
        handles.ListboxCounter = handles.ListboxCounter + 1;
    case 4
        set(handles.text_D0, 'Enable', 'on');
        set(handles.edit_D0, 'Enable', 'on');
        set(handles.text_D1, 'Enable', 'off');
        set(handles.edit_D1, 'Enable', 'off');
        set(handles.text_order_n, 'Enable', 'off');
        set(handles.edit_order_n, 'Enable', 'off');
        handles.filter_type = 'GLPF';
        set(handles.listbox_info, 'String', strvcat(get(handles.listbox_info, 'String'), '当前滤波器的类型为：高斯低通滤波器'));
        set(handles.listbox_info, 'ListboxTop', handles.ListboxCounter);
        handles.ListboxCounter = handles.ListboxCounter + 1;
    case 5
        set(handles.text_D0, 'Enable', 'on');
        set(handles.edit_D0, 'Enable', 'on');
        set(handles.text_D1, 'Enable', 'on');
        set(handles.edit_D1, 'Enable', 'on');
        set(handles.text_order_n, 'Enable', 'off');
        set(handles.edit_order_n, 'Enable', 'off');
        handles.filter_type = 'TLPF';
        set(handles.listbox_info, 'String', strvcat(get(handles.listbox_info, 'String'), '当前滤波器的类型为：梯形低通滤波器'));
        set(handles.listbox_info, 'ListboxTop', handles.ListboxCounter);
        handles.ListboxCounter = handles.ListboxCounter + 1;
    case 6 
        set(handles.text_D0, 'Enable', 'on');
        set(handles.edit_D0, 'Enable', 'on');
        set(handles.text_D1, 'Enable', 'on');
        set(handles.edit_D1, 'Enable', 'on');
        set(handles.text_order_n, 'Enable', 'off');
        set(handles.edit_order_n, 'Enable', 'off');
        handles.filter_type = 'MAF';
        set(handles.listbox_info, 'String', strvcat(get(handles.listbox_info, 'String'), '当前滤波器的类型为：中值滤波'));
        set(handles.listbox_info, 'ListboxTop', handles.ListboxCounter);
        handles.ListboxCounter = handles.ListboxCounter + 1;
    
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function popupmenu_filter_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_filter_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'Value', 1);
handles.filter_type = '';
guidata(hObject, handles);


function edit_input_image_path_Callback(hObject, eventdata, handles)
% hObject    handle to edit_input_image_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_input_image_path as text
%        str2double(get(hObject,'String')) returns contents of edit_input_image_path as a double


% --- Executes during object creation, after setting all properties.
function edit_input_image_path_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_input_image_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_import.
function pushbutton_import_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_import (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName, FilePath, FilterIndex] = uigetfile('.\image\*.*', '导入测试图像所在路径');
if FilterIndex == 0
    return;
else
    handles.input_image_path = fullfile(FilePath, FileName);
end
set(handles.listbox_info, 'String', strvcat(get(handles.listbox_info, 'String'), ['测试图像所在路径为：', handles.input_image_path]));
set(handles.listbox_info, 'ListboxTop', handles.ListboxCounter);
handles.ListboxCounter = handles.ListboxCounter + 1;
handles.input_image = imread(handles.input_image_path);
set(handles.edit_input_image_path, 'String', handles.input_image_path);
if ndims(handles.input_image) == 3
    handles.input_image = rgb2gray(handles.input_image);
end
image_obj = findobj(handles.axes_input_image, 'Type', 'image');
if ~isempty(image_obj)
    delete(image_obj);
    image_obj = [];
end
imshow(handles.input_image, 'Parent', handles.axes_input_image);
guidata(hObject, handles);


function timercallback(obj, event, handles)
global timer_string;
temp_str{1} = timer_string(1);
temp_str{2} = timer_string(2 : end);
timer_string = strcat(temp_str{2}, temp_str{1});
set(handles.figure_main, 'Name', timer_string);


% --- Executes on selection change in listbox_info.
function listbox_info_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_info (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_info contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_info


% --- Executes during object creation, after setting all properties.
function listbox_info_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_info (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_D0_Callback(hObject, eventdata, handles)
% hObject    handle to edit_D0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_D0 as text
%        str2double(get(hObject,'String')) returns contents of edit_D0 as a double
handles.D0 = str2double(get(hObject, 'String'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit_D0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_D0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'String', num2str(20));
handles.D0 = str2double(get(hObject, 'String'));
guidata(hObject, handles);


% --- Executes on button press in pushbutton_ok.
function pushbutton_ok_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles, 'input_image')
    msgbox('        输入图像尚未导入', '出错提示');
    return;
end
if isempty(handles.filter_type)
    msgbox('滤波器的类型尚未指定', '出错提示');
    return;
end
[row, col] = size(handles.input_image);
F = fftshift(fft2(double(handles.input_image)));
height = fix(row/2);
width = fix(col/2);
G_ILPF = zeros([row, col]);
G_BLPF = zeros([row, col]);
G_GLPF = zeros([row, col]);
G_TLPF = zeros([row, col]);
H_ILPF = zeros([row, col]);
H_BLPF = zeros([row, col]);
H_GLPF = zeros([row, col]);
H_TLPF = zeros([row, col]);
figure_profile = figure('NumberTitle', 'off', 'Name', '', 'MenuBar', 'none', 'Toolbar', 'figure', 'Color', 'w');
axes_profile = axes('Parent', figure_profile);
switch handles.filter_type
    case ''
        
    case 'ILPF'
        for i = 1 : row
            for j = 1 : col
                D = sqrt((i - height)^2 + (j - width)^2);
                if D <= handles.D0
                    H_ILPF(i, j) = 1;
                else
                    H_ILPF(i, j) = 0;
                end
                G_ILPF(i, j) = H_ILPF(i, j) * F(i, j);
            end
        end
        %在GUI上显示
        surface_obj = findobj(handles.axes_filter_profile, 'Type', 'surface');
        if ~isempty(surface_obj)
            delete(surface_obj);
            surface_obj = [];
        end
        [x, y] = meshgrid(1 : col, 1 : row);
        mesh(handles.axes_filter_profile, x, y, H_ILPF);
        box(handles.axes_filter_profile, 'on');
        shading interp;
        lighting phong;
        %在浮动figure上显示
        set(figure_profile, 'Name', '理想低通滤波器');
        surface_obj = findobj(axes_profile, 'Type', 'surface');
        if ~isempty(surface_obj)
            delete(surface_obj);
            surface_obj = [];
        end
        [x, y] = meshgrid(1 : col, 1 : row);
        surf(axes_profile, x, y, H_ILPF);
        shading interp;
        lighting phong;
        colorbar;
        set(axes_profile, 'XLim', [1, col], 'YLim', [1, row]);
        box(axes_profile, 'on');
        %图像形式的滤波器透视图
        imshow(H_ILPF, 'Parent', handles.axes_filter_image, 'DisplayRange', []);
        handles.filter_image = mat2gray(H_ILPF);
        %显示滤波后结果
        handles.filtered_result = uint8(real(ifft2(ifftshift(G_ILPF))));
        image_obj = findobj(handles.axes_output_image, 'Type', 'image');
        if ~isempty(image_obj)
            delete(image_obj);
            image_obj = [];
        end
        imshow(handles.filtered_result, 'Parent', handles.axes_output_image);
    case 'BLPF'
        for i = 1 : row
            for j = 1 : col
                D = sqrt((i - height)^2 + (j - width)^2);
                H_BLPF(i, j) = 1 / (1 + (D / handles.D0)^(2 * handles.n));
                G_BLPF(i, j) = H_BLPF(i, j) * F(i, j);
            end
        end
        %在GUI上显示
        surface_obj = findobj(handles.axes_filter_profile, 'Type', 'surface');
        if ~isempty(surface_obj)
            delete(surface_obj);
            surface_obj = [];
        end
        [x, y] = meshgrid(1 : col, 1 : row);
        mesh(handles.axes_filter_profile, x, y, H_BLPF);
        box(handles.axes_filter_profile, 'on');
        shading interp;
        lighting phong;
        set(figure_profile, 'Name', 'Butterworth低通滤波器');
        surface_obj = findobj(axes_profile, 'Type', 'surface');
        if ~isempty(surface_obj)
            delete(surface_obj);
            surface_obj = [];
        end
        [x, y] = meshgrid(1 : col, 1 : row);
        surf(axes_profile, x, y, H_BLPF);
        shading interp;
        lighting phong;
        colorbar;
        set(axes_profile, 'XLim', [1, col], 'YLim', [1, row]);
         box(axes_profile, 'on');
        %图像形式的滤波器透视图
        imshow(H_BLPF, 'Parent', handles.axes_filter_image, 'DisplayRange', []);
        handles.filter_image = mat2gray(H_BLPF);
        handles.filtered_result = uint8(real(ifft2(ifftshift(G_BLPF))));
        image_obj = findobj(handles.axes_output_image, 'Type', 'image');
        if ~isempty(image_obj)
            delete(image_obj);
            image_obj = [];
        end
        imshow(handles.filtered_result, 'Parent', handles.axes_output_image);
    case 'GLPF'
        for i = 1 : row
            for j = 1 : col
                D = sqrt((i - height)^2 + (j - width)^2);
                H_GLPF(i, j) = exp(-(D / (sqrt(2) * handles.D0))^2);
                G_GLPF(i, j) = H_GLPF(i, j) * F(i, j);
            end
        end
        %在GUI上显示
        surface_obj = findobj(handles.axes_filter_profile, 'Type', 'surface');
        if ~isempty(surface_obj)
            delete(surface_obj);
            surface_obj = [];
        end
        [x, y] = meshgrid(1 : col, 1 : row);
        mesh(handles.axes_filter_profile, x, y, H_GLPF);
        box(handles.axes_filter_profile, 'on');
        shading interp;
        lighting phong;
        set(figure_profile, 'Name', '高斯低通滤波器');
        surface_obj = findobj(axes_profile, 'Type', 'surface');
        if ~isempty(surface_obj)
            delete(surface_obj);
            surface_obj = [];
        end
        [x, y] = meshgrid(1 : col, 1 : row);
        surf(axes_profile, x, y, H_GLPF);
        shading interp;
        lighting phong;
        colorbar;
        set(axes_profile, 'XLim', [1, col], 'YLim', [1, row]);
         box(axes_profile, 'on');
        %图像形式的滤波器透视图
        imshow(H_GLPF, 'Parent', handles.axes_filter_image, 'DisplayRange', []);
        handles.filter_image = mat2gray(H_GLPF);
        handles.filtered_result = uint8(real(ifft2(ifftshift(G_GLPF))));
        image_obj = findobj(handles.axes_output_image, 'Type', 'image');
        if ~isempty(image_obj)
            delete(image_obj);
            image_obj = [];
        end
        imshow(handles.filtered_result, 'Parent', handles.axes_output_image);
    case 'TLPF'
        for i = 1 : row
            for j = 1 : col
                D = sqrt((i - height)^2 + (j - width)^2);
                if D < handles.D0
                    H_TLPF(i, j) = 1;
                elseif D > handles.D1
                    H_TLPF(i, j) = 0;
                else
                    H_TLPF(i, j) = (D - handles.D1) / (handles.D0 - handles.D1);
                end
                G_TLPF(i, j) = H_TLPF(i, j) * F(i, j);
            end
        end
        %在GUI上显示
        surface_obj = findobj(handles.axes_filter_profile, 'Type', 'surface');
        if ~isempty(surface_obj)
            delete(surface_obj);
            surface_obj = [];
        end
        [x, y] = meshgrid(1 : col, 1 : row);
        mesh(handles.axes_filter_profile, x, y, H_TLPF);
        box(handles.axes_filter_profile, 'on');
        shading interp;
        lighting phong;
        set(figure_profile, 'Name', '梯形低通滤波器');
        surface_obj = findobj(axes_profile, 'Type', 'surface');
        if ~isempty(surface_obj)
            delete(surface_obj);
            surface_obj = [];
        end
        [x, y] = meshgrid(1 : col, 1 : row);
        surf(axes_profile, x, y, H_TLPF);
        shading interp;
        lighting phong;
        colorbar; 
        set(axes_profile, 'XLim', [1, col], 'YLim', [1, row]);
         box(axes_profile, 'on');
        %图像形式的滤波器透视图
        imshow(H_TLPF, 'Parent', handles.axes_filter_image, 'DisplayRange', []);
        handles.filter_image = mat2gray(H_TLPF);
        handles.filtered_result = uint8(real(ifft2(ifftshift(G_TLPF))));
        image_obj = findobj(handles.axes_output_image, 'Type', 'image');
        if ~isempty(image_obj)
            delete(image_obj);
            image_obj = [];
        end
        imshow(handles.filtered_result, 'Parent', handles.axes_output_image);
    otherwise
        
end
movegui(figure_profile, 'southwest');
m = getframe(figure_profile);
[c, d] = frame2im(m);
switch handles.filter_type
    case ''
        
    case 'ILPF'
        imwrite(handles.filtered_result, [handles.result_path, '\', 'filter_result_', handles.filter_type, '_', num2str(handles.D0), '.tif'], 'tif');
        imwrite(handles.filter_image, [handles.result_path, '\', 'filter_image_', handles.filter_type, '_', num2str(handles.D0), '.tif'], 'tif');
        imwrite(c, [handles.result_path, '\', 'filter_profile_', handles.filter_type, '_', num2str(handles.D0), '.tif'], 'tif');
    case 'BLPF'
        imwrite(handles.filtered_result, [handles.result_path, '\', 'filter_result_', handles.filter_type, '_', num2str(handles.D0), '_', num2str(handles.n), '.tif'], 'tif');
        imwrite(handles.filter_image, [handles.result_path, '\', 'filter_image_', handles.filter_type, '_', num2str(handles.D0), '_', num2str(handles.n), '.tif'], 'tif');
        imwrite(c, [handles.result_path, '\', 'filter_profile_', handles.filter_type, '_', num2str(handles.D0), '_', num2str(handles.n), '.tif'], 'tif');
    case 'GLPF'
        imwrite(handles.filtered_result, [handles.result_path, '\', 'filter_result_', handles.filter_type, '_', num2str(handles.D0), '.tif'], 'tif');
        imwrite(handles.filter_image, [handles.result_path, '\', 'filter_image_', handles.filter_type, '_', num2str(handles.D0), '.tif'], 'tif');
        imwrite(c, [handles.result_path, '\', 'filter_profile_', handles.filter_type, '_', num2str(handles.D0), '.tif'], 'tif');
    case 'TLPF'
        imwrite(handles.filtered_result, [handles.result_path, '\', 'filter_result_', handles.filter_type, '_', num2str(handles.D0), '_', num2str(handles.D1), '.tif'], 'tif');
        imwrite(handles.filter_image, [handles.result_path, '\', 'filter_image_', handles.filter_type, '_', num2str(handles.D0), '_', num2str(handles.D1), '.tif'], 'tif');
        imwrite(c, [handles.result_path, '\', 'filter_profile_', handles.filter_type, '_', num2str(handles.D0), '_', num2str(handles.D1), '.tif'], 'tif');
    otherwise 

end
guidata(hObject, handles);
       
     
% --- Executes when user attempts to close figure_main.
function figure_main_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure_main (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
stop(handles.timer);
delete(hObject);


function edit_D1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_D1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_D1 as text
%        str2double(get(hObject,'String')) returns contents of edit_D1 as a double
handles.D1 = str2double(get(hObject, 'String'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit_D1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_D1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'String', num2str(40));
handles.D1 = str2double(get(hObject, 'String'));
guidata(hObject, handles);


function edit_order_n_Callback(hObject, eventdata, handles)
% hObject    handle to edit_order_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_order_n as text
%        str2double(get(hObject,'String')) returns contents of edit_order_n as a double
handles.n = str2double(get(hObject, 'String'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit_order_n_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_order_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'String', num2str(3));
handles.n = str2double(get(hObject, 'String'));
guidata(hObject, handles);
