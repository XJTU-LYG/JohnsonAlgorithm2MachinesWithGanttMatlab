clc;
clear;

% Author : £ukasz Jackowski

% W tym miejscu ustawiamy czasy wykonywania.
% W pierwszym wierszu dla maszyny M1,
% w drugim wierszu dla maszyny M2

% --------- WPROWADZENIE DANYCH ---------

tab  = [4 4 8 6 2;
        5 1 4 8 3];
    
% ----------------------------------------
    
arrayN1value = java.util.ArrayList();
arrayN1index = java.util.ArrayList();
arrayN2value = java.util.ArrayList();
arrayN2index = java.util.ArrayList();

for j=1:length(tab)
    if(tab(1,j) <= tab(2,j))
        arrayN1index.add(j);
        arrayN1value.add(tab(1,j));
    end
    if(tab(1,j) > tab(2,j))
        arrayN2index.add(j);
        arrayN2value.add(tab(2,j));
    end
end

for i=1:arrayN1value.size
    obiektN1(i).value = arrayN1value.get(i-1);
    obiektN1(i).index = arrayN1index.get(i-1);
end

for i=1:arrayN2value.size
    obiektN2(i).value = arrayN2value.get(i-1);
    obiektN2(i).index = arrayN2index.get(i-1);
end

rozmiarN1 = arrayN1value.size;
rozmiarN2 = arrayN2value.size;

% Sortowanie b¹belkowe rosn¹co tablicy N1
for j=1:rozmiarN1-1
    for i=1:rozmiarN1-1
        if(obiektN1(i).value > obiektN1(i+1).value)
            temp.value = obiektN1(i).value;
            temp.index =obiektN1(i).index;
            
            obiektN1(i).value = obiektN1(i+1).value;
            obiektN1(i).index = obiektN1(i+1).index;
            
            obiektN1(i+1).value = temp.value;
            obiektN1(i+1).index = temp.index;
        end
    end
end

% Sortowanie b¹belkowo malej¹co tablicy N2
for j=1:rozmiarN2-1
    for i=1:rozmiarN2-1
        if(obiektN2(i).value < obiektN2(i+1).value)
            temp.value = obiektN2(i).value;
            temp.index =obiektN2(i).index;
            
            obiektN2(i).value = obiektN2(i+1).value;
            obiektN2(i).index = obiektN2(i+1).index;
            
            obiektN2(i+1).value = temp.value;
            obiektN2(i+1).index = temp.index;
        end
    end
end

% Uzupe³nianie optymalnej kolejnoœci zadañ posortowanych rosn¹co
% do tablicy taskOrder
for i=1:rozmiarN1
    taskOrder(i)=obiektN1(i).index;
end

% Uzupe³nianie optymalnej kolejnoœci zadañ posortowanych malej¹co
% do tablicy taskOrder
counter = 1;
for i=1:rozmiarN2
    taskOrder(rozmiarN1 + counter) = obiektN2(i).index;
    counter=counter+1;
end

% Wyœwietlenie tablicy optymalniej kolejnoœci zadañ
taskOrder

% Obliczenie rozmiaru tablicy taskOrder
taskOrderSize = size(taskOrder,2);

% Zdefiniowanie tablicy dostêpnych w procesie rysowania kolorów
colorsDef = ['y','m','c','r','g','b','m','c','y','r','g','b'];

% Automatyczne generowanie tablicy kolorów, kiedy rozmiar tablicy
% z zadaniami jest wiêkszy od tablicy colorsDef
counter = 1;
for i=1:taskOrderSize
    if(counter > size(colorsDef, 2))
        counter = 1;
    end
    colors(i) = colorsDef(counter);
    counter = counter + 1;
end

% USTAWIENIA RYSOWANIA
hold on;
axis([0 60 0 25]);
y = [10 10];
y2 = [5 5];
shift = 0;
% W³¹czanie/Wy³¹czanie siatki : off | on
grid on;
set(gca, 'XTick', 0:1:100);

% Wykres dla maszyny M1
for i=1:taskOrderSize
    x = [shift tab(1, taskOrder(i)) + shift];
    plot(x, y, colors(i), 'LineWidth', 20);
    
    % Obliczenie wartoœci przesuniêcia, u¿ywane 
    % do wyœrokowania tekstu z nr zadania 
    polowaZad = tab(1, taskOrder(i))/2;
    
    % Wyœwietlanie tekstu z nr zadania
    text(shift + polowaZad, 11, int2str(taskOrder(i)));
    
    % Obliczenie przesuniêcia kolejnego zadania
    shift = shift + tab(1, taskOrder(i));
    shift1tab(i) = shift;
end

shift1tab;

% Obliczenie przesuniêæ, ¿eby te same zadania 
% nie wykonywa³y siê w tym samym czasie
for i=1:taskOrderSize-1
    a = shift1tab(i);
    b = tab(2, taskOrder(i));
    tablica(i) = a + b
    if(i > 1 )
        if( a < tablica(i-1))
            tablica(i)= tablica(i-1) + b;
        end
    end
end

% Dodanie zera na pocz¹tku tablicy oraz jej wyœwietlenie
tablica = [0 tablica];

% Obliczenie wartoœci przesuniêcia dla tych samych zadañ,
% aby nie wykonywa³y siê w tym samym czasie
for i=1:taskOrderSize
    shift2Add(i)= shift1tab(i)-tablica(i);
    if(shift2Add(i) < 0)
        shift2Add(i) = 0;
    end
end

x=0;
shift=0;

% Wykres dla maszyny M2
for i=1:taskOrderSize
    x = [shift + shift2Add(i) tab(2, taskOrder(i)) + shift + shift2Add(i)];
    plot(x,y2,colors(i),'LineWidth',20);
     
    % Obliczenie wartoœci przesuniêcia, u¿ywane 
    % do wyœrokowania tekstu z nr zadania 
    polowaZad = tab(2, taskOrder(i))/2;
    
    % Wyœwietlanie tekstu z nr zadania
    text(shift + shift2Add(i) + polowaZad, 6, int2str(taskOrder(i)))
    shift = shift + tab(2, taskOrder(i)) + shift2Add(i);
end

%Wyœwietlenie wartoœci Cmax
Cmax = shift

%TEKST DO WYKRESU GANTTA dla M1
textGanttM1 = '';
for i=1:taskOrderSize
    for j=1:tab(1, taskOrder(i))
       textGanttM1 = strcat(textGanttM1, num2str(taskOrder(i)));
    end 
end

%TEKST DO WYKRESU GANTTA dla M2
textGanttM2 = '';
for i=1:taskOrderSize
    %Dodawanie zer z tablicy shift2Add
    for k=1:shift2Add(i)
       textGanttM2 = strcat(textGanttM2, num2str(0));
    end 
    for j=1:tab(2, taskOrder(i))
       textGanttM2 = strcat(textGanttM2, num2str(taskOrder(i)));
    end 
end

%Zapis do pliku
file = fopen('gantt.txt','w');            
if file ~= -1
  fprintf(file,'%s\r\n',textGanttM1);   
  fprintf(file,'%s\r\n',textGanttM2);   
  fclose(file);
end

%Wyœwietlanie tekstu do wykresu Gantt'a dla maszyn M1 i M2
textGanttM1
textGanttM2
