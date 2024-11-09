program Lab6;

const
  n_max_size = 100;

type
  matr = array [1..n_max_size, 1..n_max_size] of real;

var
  A: matr;
  n, m, i, j, not_match_row, count: integer;
  flag: boolean;
  k, sum_nums: real;
  f: TextFile;

begin
  if ParamCount < 2 then { Проверка количество параметров }
    writeln('Недостаточно параметров!')
  else
  begin
    if not FileExists(ParamStr(1)) then { Проверка на существование файла }
      writeln('Невозможно открыть файл ''', ParamStr(1), ''' для чтения')
    else
    begin
      { ввод размерности матрицы }
      readln(m, n);
      
      if (n > 0) and (n < 101) and (m > 0) and (m < 101) then
      begin
        { открытие файла input.txt на чтение }
        AssignFile(f, ParamStr(1));
        Reset(f);
        
        { ввод матрицы А и числа k из файла input.txt }
        for i := 1 to m do
          for j := 1 to n do
            read(f, A[i, j]);
          
        read(f, k);
        
        { открытие файла output.txt на запись }
        AssignFile(f, ParamStr(2));
        Rewrite(f);
        
        { проверка все ли строки матрицы содержат хотя бы один элемент, равный числу k }
        writeln(f, 'Выполняется проверка все ли строки матрицы содержат хотя бы один элемент, равный числу k:');
        flag := true;
        i := 1;
        while flag and (i < m) do
        begin
          j := 1;
          while flag and (j < n) do
          begin
            if A[i, j] = k then
              flag := false
            else
              j := j + 1;
          end;
          if not(flag) then
            begin
            flag := true;
            i := i + 1;
            end
          else
            flag := false;
        end;
        if flag then
          begin
          writeln(f, 'Условие выполнено, все строки матрицы содержат хотя бы один элемент, равный числу k');
          not_match_row := 1;
          end
        else
          begin
          writeln(f, 'Условие не выполнено, не все строки матрицы содержат хотя бы один элемент, равный числу k');
          not_match_row := i;
          end;
        writeln(f);
        
        { поиск числа строк матрицы, сумма элементов которых меньше 0 }
        writeln(f, 'Выполняется поиск числа строк матрицы, сумма элементов которых меньше 0:');
        count := 0;
        for i := not_match_row to m do
        begin
          sum_nums := 0;
          for j := 1 to n do
            sum_nums := sum_nums + A[i, j];
          if sum_nums < 0 then
            count := count + 1;
        end;
        writeln(f, 'Количество таких строк равно ', count);
      end
      else
        writeln('Невозможно считать матрицу при данной размерности');
      
      { закрытие файлов input.txt и output.txt }
      CloseFile(f);
    end;
  end;
end.
