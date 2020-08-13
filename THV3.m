%% Recursos
%https://www.mathworks.com/help/matlab/ref/heatmap.html
%http://fadedtwilight.org/blog/2013/04/07/howto-heat-map-style-plots-in-matlab/
%https://www.mathworks.com/help/matlab/ref/matlab.graphics.chart.primitive.graphplot-properties.html
%https://www.mathworks.com/help/matlab/ref/matlab.graphics.chart.primitive.graphplot.layout.html
%https://la.mathworks.com/help/matlab/ref/graph.centrality.html
%% Modelo computacional Grafo Torres Hanoi
NumeroPilas=3;
NumeroDiscos=6;
NumeroNodos=NumeroPilas^NumeroDiscos;
P1=1:NumeroDiscos;P2=zeros(1,NumeroDiscos); P3=zeros(1,NumeroDiscos);
EstadoJuego=[P1 P2 P3];
GrafoTorresHanoi=[EstadoJuego 0]; MatrizMatlab=[];
EstadosPendientes = 1; 
%% Generar Grafo:
while (EstadosPendientes ~= 0)
    CEC=GrafoTorresHanoi(:,end); % Ultima posición (Si ha sido visitado o no)
    PosicionEstadoConCero=find(CEC==0); % Encuentra 0s en la Matriz
    if isempty(PosicionEstadoConCero)
       EstadosPendientes = 1;
       break;
    end
    [NuevaCopiaEC] = Convertir(GrafoTorresHanoi(PosicionEstadoConCero(1,1),1:end-1));
    for P = 1:3
        if P==1 % Regla 1 > Voy a 2 y 3
            NuevaCEC=NuevaCopiaEC;
            [Disco, NuevaCECP] = levantar(P, NuevaCEC, NumeroDiscos);
            [NuevaCECP] = poner(P+1, NuevaCECP, NumeroDiscos, Disco, NuevaCEC);
            [MatrizMatlab] = NodosVertices(NuevaCEC, NuevaCECP, MatrizMatlab);
            [GrafoTorresHanoi] = NuevoGrafo(NuevaCECP, GrafoTorresHanoi);
            [Disco, NuevaCECP] = levantar(P, NuevaCEC, NumeroDiscos);
            [NuevaCECP] = poner(P+2, NuevaCECP, NumeroDiscos, Disco, NuevaCEC);
            [MatrizMatlab] = NodosVertices(NuevaCEC, NuevaCECP, MatrizMatlab);
            [GrafoTorresHanoi] = NuevoGrafo(NuevaCECP, GrafoTorresHanoi);
        elseif P==2 % Regla 2 > Voy a 1 y 3
            NuevaCEC=NuevaCopiaEC;
            [Disco, NuevaCECP] = levantar(P, NuevaCEC, NumeroDiscos);
            [NuevaCECP] = poner(P-1, NuevaCECP, NumeroDiscos, Disco, NuevaCEC);
            [MatrizMatlab] = NodosVertices(NuevaCEC, NuevaCECP, MatrizMatlab);
            [GrafoTorresHanoi] = NuevoGrafo(NuevaCECP, GrafoTorresHanoi);
            [Disco, NuevaCECP] = levantar(P, NuevaCEC, NumeroDiscos);
            [NuevaCECP] = poner(P+1, NuevaCECP, NumeroDiscos, Disco, NuevaCEC);
            [MatrizMatlab] = NodosVertices(NuevaCEC, NuevaCECP, MatrizMatlab);
            [GrafoTorresHanoi] = NuevoGrafo(NuevaCECP, GrafoTorresHanoi);
        elseif P==3 % Regla 3 > Voy a 1 y 2
            NuevaCEC=NuevaCopiaEC;
            [Disco, NuevaCECP] = levantar(P, NuevaCEC, NumeroDiscos);
            [NuevaCECP] = poner(P-2, NuevaCECP, NumeroDiscos, Disco, NuevaCEC);
            [MatrizMatlab] = NodosVertices(NuevaCEC, NuevaCECP, MatrizMatlab);
            [GrafoTorresHanoi] = NuevoGrafo(NuevaCECP, GrafoTorresHanoi);
            [Disco, NuevaCECP] = levantar(P, NuevaCEC, NumeroDiscos);
            [NuevaCECP] = poner(P-1, NuevaCECP, NumeroDiscos, Disco, NuevaCEC);
            [MatrizMatlab] = NodosVertices(NuevaCEC, NuevaCECP, MatrizMatlab);
            [GrafoTorresHanoi] = NuevoGrafo(NuevaCECP, GrafoTorresHanoi);
        end
    end
    GrafoTorresHanoi(PosicionEstadoConCero(1,1),end)=1;
end
%% Requiere coordenadaspunto.mat && movimientosjugadoresdatav3.mat
load coordenadaspunto.mat;
load movimientosjugadoresdatav3.mat;
[Intentos,Edad,Pila1,Pila2,Pila3]=filtro_datos(movimientosjugadoresdatav3);
[Frecuencia] = tablafrecuencia(Intentos,Edad,Pila1,Pila2,Pila3, GrafoTorresHanoi);
%% Generar Grafo
[s,t] = IDNodos(GrafoTorresHanoi, MatrizMatlab);
G = graph(s,t);
C=coordenadaspunto; % Tabla Juan
X=C.Xcoordenada;Y=C.Ycoordenada;
h = plot(G,'XData',X,'YData',Y,'MarkerSize',5);
H=Frecuencia(:,end);
for i=1:729
    if H(i)>=10
        H(i)=10;
    end
end
h.NodeCData = H;
colormap jet
%colormap(flip(autumn,1));
colorbar
title('Comportamiento Intento 12 Juego Torres de Hanoi')
hold on
%% Funciones
function [Disco, NuevaCEC] = levantar(Pila, NuevaCEC, NumeroDiscos)
    PilaAux=NuevaCEC(:,Pila);
    Disco=0;
    if sum(PilaAux) ~= 0
        for i=1:NumeroDiscos
            if PilaAux(i,1) ~= 0
                Disco=PilaAux(i,1);
                NuevaCEC(i,Pila)=0;
                break;
            else
            end
        end
    end
end

function [EstadoJuego] = poner(Pila, EstadoJuego, NumeroDiscos, Disco, NuevaCEC)
    for i=NumeroDiscos:-1:1
        if EstadoJuego(NumeroDiscos,Pila) == 0
            EstadoJuego(i,Pila)=Disco;
            break;
        elseif EstadoJuego(i,Pila) == 0 && EstadoJuego(i+1,Pila) > Disco
            EstadoJuego(i,Pila)=Disco;
            break;
        elseif EstadoJuego(i,Pila) == 0 && EstadoJuego(i+1,Pila) < Disco
            EstadoJuego=NuevaCEC;
            break;
        end
    end
end
function [GrafoTorresHanoi] = NuevoGrafo(Matriz1, Matriz2)
    [A,~]=size(Matriz2);
    Comparar=1;Matriz=[];
    for i=1:3
        Matriz = horzcat(Matriz, Matriz1(:,i)');
    end
    Matrizi=[Matriz 0];
    for j=1:A
        if isequal(Matriz, Matriz2(j,1:end-1))
           Comparar=0;
        end
    end
    if Comparar==0
       GrafoTorresHanoi=Matriz2;
    elseif Comparar==1
       GrafoTorresHanoi=cat(1,Matriz2,Matrizi);
    end
end
function [NuevaCopiaEC] = Convertir(Matriz)
    [~,B]= size(Matriz);
    Temporal=[];
    C=B/3;
    b=1;
    for i=1:3
        Temporal(i,:) = Matriz(b:i*C);
        NuevaCopiaEC(:,i)=Temporal(i,:)';
        b=b+C;
    end
end
function [MatrizMatlab] = NodosVertices(Matriz1, Matriz2, MatrizMatlab)
    MatrizA=[];MatrizB=[];[A,~]=size(MatrizMatlab);Comparar=1;
    for i=1:3
        MatrizA = horzcat(MatrizA, Matriz1(:,i)');
    end
    for i=1:3
        MatrizB = horzcat(MatrizB, Matriz2(:,i)');
    end
    if isequal(MatrizA, MatrizB)
        Comparar=0;
    else
        MatrizMatlab2 = [MatrizA MatrizB];
        MatrizMatlab3 = [MatrizB MatrizA];
        for j=1:A
            if isequal(MatrizMatlab2, MatrizMatlab(j,:)) || isequal(MatrizMatlab3, MatrizMatlab(j,:))
               Comparar=0;
            end
        end
        if Comparar==0
           MatrizMatlab=MatrizMatlab;
        elseif Comparar==1
               MatrizMatlab = cat(1,MatrizMatlab,MatrizMatlab2);
        end
    end
end
function [s,t] = IDNodos(Matriz1, Matriz2)
    [A,~]=size(Matriz1);
    [B,C]=size(Matriz2);
    s=[];t=[];
    for i=1:A
        Nodo = Matriz1(i,1:end-1);
        for j=1:B
            if isequal(Nodo, Matriz2(j,1:C/2))
                s(j,1) = i;
            end
            if isequal(Nodo, Matriz2(j,C/2+1:C))
                t(j,1) = i;
            end                        
        end
    end
end

function [Intentos,Edad,Pila1,Pila2,Pila3]=filtro_datos(Matriz)
    [A,~]=size(Matriz);
    Pila1=[];Pila2=[];Pila3=[];
    for i=1:A
        C=Matriz(i,:);
        Intentos(i,1)=C.Intentos;
        Edad(i,1)=C.Edad;
        %
        PA1=C.PilaA; PA=str2double(regexp(num2str(PA1),'\d','match'));
        [~,N]=size(PA);Tam=6-N;Complemento=zeros(1,Tam);
        Pila1A=[Complemento PA];
        Pila1=cat(1,Pila1,Pila1A);  
        %
        PB1=C.PilaB; PB=str2double(regexp(num2str(PB1),'\d','match'));
        [~,N]=size(PB);Tam=6-N;Complemento=zeros(1,Tam);
        Pila1B=[Complemento PB];
        Pila2=cat(1,Pila2,Pila1B);
        %
        PC1=C.PilaC; PC=str2double(regexp(num2str(PC1),'\d','match'));
        [~,N]=size(PC);Tam=6-N;Complemento=zeros(1,Tam);
        Pila1C=[Complemento PC];
        Pila3=cat(1,Pila3,Pila1C);         
    end
end
function [Frecuencia] = tablafrecuencia(Matriz1, Matriz2, Matriz3, Matriz4, Matriz5, Matriz6)
    Frecuencia=[];
    MatrizData=[Matriz1 Matriz2 Matriz3 Matriz4 Matriz5];
    firstColumn = MatrizData(:, 1);
    QueIntento=12; %1 a 12
    if QueIntento ~= 0
        TData = MatrizData(firstColumn == QueIntento, :);
    else
        TData = MatrizData;
    end
    TTData=TData(:,3:end);
    MatrizGrafo=Matriz6(:,1:18);
    [A,~]=size(Matriz6);
    [B,~]=size(TTData);
    for i=1:A
        frecuencia=0;
        P=MatrizGrafo(i,:);
        for j=1:B
            L=TTData(j,:);
            if isequal(P,L)
                frecuencia=frecuencia+1;
            end
        end
        F= [MatrizGrafo(i,:) frecuencia];
        Frecuencia = cat(1,Frecuencia,F);
    end
end