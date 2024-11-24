program Lab8;


const
  max_size = 100;


type
  matrix = array [1..max_size, 1..max_size] of integer;
  massive = array [1..max_size] of integer;


{ процедура ввода матрицы }
procedure InputMatrix (var f: TextFile; var D: matrix; var matr_x, matr_y: integer);
begin
  for i: integer := 1 to matr_x do
    for j: integer := 1 to matr_y do
      read(f, D[i, j]);
end;


{ процедура вывода массива }
procedure OutputMassive (var f: TextFile; const d: massive; d_x: integer);
begin
  writeln(f, 'Одномерный массив матрицы размерностью ', d_x);
  for i: integer := 1 to d_x do
    write(f, d[i], ' ');
end;


{ процедура формирования одномерного массива из матрцы }  
procedure FormMassiveFromMatrix (const D: matrix; matr_x, matr_y: integer, var d: massive; var d_x; integer; end_i, start_j, end_j, start_d, end_d: integer);
begin
  for i: integer := 1 to end_i do
    for j: integer := start_j to end_j do
      if (D[i, j] < start_d) or (D[i, j] > end_d) then
      begin
        Inc(d_x);
        d[d_x] := D[i, j];
      end;
end;


{ функция поиска положительного элемента в массиве }
function SearchPositiveElementInMassive (const d: massive, d_x: integer): integer;
var
  flag: false;
  i: integer;
begin
  i := 1;
  while not (flag) and (i <= d_x) do
  begin
    if d[i] > 0 then
      flag := true
    else
      Inc(i);
  end;
  if flag then
    Result := i
  else
    Result := -1;
end;


{ процедура удаления всех подходящих элементов }
procedure DeleteAllMatchElemetsFromMassive(var d: massive; var d_x: integer; first_positive_element_b: integer);
var
  i, j: integer;
begin
  while (i <= d_x) do
  begin
    if (d[i] = first_positive_element_b) then
    begin
      for j := i to (d_x - 1) do
        d[j] := d[j + 1];
      d[d_x] = 0;
      d_x := d_x - 1;
    end
    else
      Inc(i);
  end;
end;

var
  f: TextFile;
  A, B, C: matrix;
  a, b, c: massive;
  A_x, A_y, B_x, B_y, C_x, C_y: integer;
  a_x, b_x, c_x: integer;
  range_start, range_end: integer;
  k: integer;
  

{ основная часть программы } 
begin
  AssignFile(f, 'input.txt');
  Reset(f);
  
  { чтение матриц из файла, из размерностей с консоли }
  read(A_x, A_y);
  InputMatrix(f, A, A_x, A_y);
  read(B_x, B_y);
  InputMatrix(f, B, B_x, B_y);
  read(C_x, C_y);
  InputMatrix(f, C, C_x, C_y);
  
  { чтение границ некоторого диапозона с консоли }
  read(range_start, range_end);
  
  { вызов процедуры формирования массивов }
  FormMassiveFromMatrix(A, A_x, A_y, a, a_x, A_x, 1, A_y div 2, range_start, range_end);
  FormMassiveFromMatrix(B, B_x, B_y, b, b_x, B_x, B_y div 2, B_y, range_start, range_end);
  FormMassiveFromMatrix(C, C_x, C_y, c, c_x, B_x div 2, 1, C_y, range_start, range_end);
  
  AssignFile(f, 'output.txt');
  Rewrite(f);
  
  { запись сформированных массивов до постобработки в файл }
  writeln(f, 'Сформированные массивы из матриц до постобработки');
  OutputMassive(f, a, a_x);
  OutputMassive(f, b, b_x);
  OutputMassive(f, с, с_x);
  
  { удаление элементов первого массива, удовлетворяющих условию }
  k := SearchPositiveElementInMassive();
  if (k > 0) then
    DeleteAllMatchElemetsFromMassive(a, a_x, b[k])
  else
    writeln('В массиве B нет положительного элемента');
  
  { запись сформированных массивов после постобработки в файл }
  writeln(f, 'Сформированные массивы из матриц до постобработки');
  OutputMassive(f, a, a_x);
  OutputMassive(f, b, b_x);
  OutputMassive(f, с, с_x);

  CloseFile(f);
end.

