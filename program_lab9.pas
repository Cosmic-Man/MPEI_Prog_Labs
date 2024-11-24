program Lab9;


const
  max_size = 100;


type
  matrix = array [1..max_size, 1..max_size] of real;


{ функция нахождения суммы элементов выше главной диагонали, абсолютное значение которых находится в заданном диапазоне }
function SumElementsAboveTheMainDiagonal(const D: matrix; matr_n, start_d, end_d: integer): real;
var
  s: real;
begin
  for i: integer := 1 to matr_n do
    for j: integer := i + 1 to matr_n do
      if (Abs(D[i, j]) >= start_d) and (Abs(D[i, j]) <= end_d) then
        s := s + D[i, j];
  Result := s;
end;


{ функция нахождения суммы элементов выше побочной диагонали, абсолютное значение которых находится в заданном диапазоне }
function SumElementsAboveTheSideDiagonal(const D: matrix; matr_n, start_d, end_d: integer): real;
var
  s: real;
begin
  for i: integer := 1 to matr_n do
    for j: integer := 1 to matr_n - i do
      if (Abs(D[i, j]) >= start_d) and (Abs(D[i, j]) <= end_d) then
        s := s + D[i, j];
  Result := s;
end;

{ процедура ввода матрицы }
procedure InputMatrix (var f: TextFile; var D: matrix; var matr_n: integer);
begin
  for i: integer := 1 to matr_n do
    for j: integer := 1 to matr_n do
      read(f, D[i, j]);
end;


{ процедура вывода массива }
procedure OutputMatrix (var f: TextFile; const D: matrix; matr_n: integer);
begin
  for i: integer := 1 to matr_n do
    begin
    for j: integer := 1 to matr_n do
      write(f, D[i, j], ' ');
    writeln(f);
    end;
end;


var
  f: TextFile;
  A, B, C: matrix;
  A_n, B_n, C_n: integer;
  range_start, range_end: integer;
  A_s_m, B_s_m, C_s_m: real;
  A_s_s, B_s_s, C_s_s: real;
  

{ основная часть программы } 
begin
  AssignFile(f, 'input.txt');
  Reset(f);
  
  { чтение матриц из файла, из размерностей с консоли }
  read(A_n);
  InputMatrix(f, A, A_n);
  read(B_n);
  InputMatrix(f, B, B_n);
  read(C_n);
  InputMatrix(f, C, C_n);
  
  { чтение границ некоторого диапозона с консоли }
  read(range_start, range_end);
  
  { обработка сумм элементов матриц, соответствующим условиям, выше главной/побочной диагонали }
  A_s_m := SumElementsAboveTheMainDiagonal(A, A_n, range_start, range_end);
  A_s_s := SumElementsAboveTheSideDiagonal(A, A_n, range_start, range_end);
  B_s_m := SumElementsAboveTheMainDiagonal(B, B_n, range_start, range_end);
  B_s_s := SumElementsAboveTheSideDiagonal(B, B_n, range_start, range_end);
  C_s_m := SumElementsAboveTheMainDiagonal(C, C_n, range_start, range_end);
  C_s_s := SumElementsAboveTheSideDiagonal(C, C_n, range_start, range_end);
  
  AssignFile(f, 'output.txt');
  Rewrite(f);
  
  { запись матриц в файл }
  OutputMatrix(f, A, A_n);
  OutputMatrix(f, B, B_n);
  OutputMatrix(f, C, C_n);
  
  { анализ полученных значений для главной диагонали, последующая запись в файл }
  if (A_s_m = B_s_m) and (B_s_m < C_s_m) then
    writeln(f, 'Сумма элементов, расположенных выше главной диагонали, в матрице С максимальна')
  else if (A_s_m = C_s_m) and (C_s_m < B_s_m) then
    writeln(f, 'Сумма элементов, расположенных выше главной диагонали, в матрице B максимальна')
  else if (B_s_m = C_s_m) and (C_s_m < A_s_m) then
    writeln(f, 'Сумма элементов, расположенных выше главной диагонали, в матрице A максимальна')
  else if (A_s_m = B_s_m) and (B_s_m > C_s_m) then
    writeln(f, 'Сумма элементов, расположенных выше главной диагонали, в матрицах A и B максимальна')
  else if (A_s_m = C_s_m) and (C_s_m > B_s_m) then
    writeln(f, 'Сумма элементов, расположенных выше главной диагонали, в матрицах A и C максимальна')
  else if (B_s_m = C_s_m) and (C_s_m > A_s_m) then
    writeln(f, 'Сумма элементов, расположенных выше главной диагонали, в матрицах B и C максимальна')
  else
    writeln(f, 'Сумма элементов, расположенных выше главной диагонали, в матрицах A, B и C одинакова');
  
  
  { анализ полученных значений для побочной диагонали, последующая запись в файл }
  if (A_s_s = B_s_s) and (B_s_s < C_s_s) then
    writeln(f, 'Сумма элементов, расположенных выше побочной диагонали, в матрице С максимальна')
  else if (A_s_s = C_s_s) and (C_s_s < B_s_s) then
    writeln('Сумма элементов, расположенных выше побочной диагонали, в матрице B максимальна')
  else if (B_s_s = C_s_s) and (C_s_s < A_s_s) then
    writeln(f, 'Сумма элементов, расположенных выше побочной диагонали, в матрице A максимальна')
  else if (A_s_s = B_s_s) and (B_s_s > C_s_s) then
    writeln(f, 'Сумма элементов, расположенных выше побочной диагонали, в матрицах A и B максимальна')
  else if (A_s_s = C_s_s) and (C_s_m > B_s_s) then
    writeln(f, 'Сумма элементов, расположенных выше побочной диагонали, в матрицах A и C максимальна')
  else if (B_s_s = C_s_s) and (C_s_s > A_s_s) then
    writeln(f, 'Сумма элементов, расположенных выше побочной диагонали, в матрицах B и C максимальна')
  else
    writeln(f, 'Сумма элементов, расположенных выше побочной диагонали, в матрицах A, B и C одинакова');
  
  CloseFile(f);
end.
