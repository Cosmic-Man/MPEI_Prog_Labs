program Lab4;

const
  n_max_size = 100;

type
  mas = array [1..n_max_size] of real;

var
  A, X, Y: mas;
  n, n_max_A, count_dots, iter: integer;
  exist_negative: boolean;
  abs_value_max_A, sum_distances, max_A: real;
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
      { ввод размерности массивов }
      readln(n);
      
      if (n > 0) and (n < 101) then
      begin
        { открытие файла input.txt на чтение }
        AssignFile(f, ParamStr(1));
        Reset(f);
        
        { ввод массива А из файла input.txt }
        for i: integer := 1 to n do
          read(f, A[i]);
        
        { открытие файла output.txt на запись }
        AssignFile(f, ParamStr(2));
        Rewrite(f);
        
        { поиск отрицательного числа и его номера в массиве А }
        writeln(f, 'Выполняется поиск отрицательного элемента в массиве А:');
        exist_negative := false;
        iter := 1;
        while (iter <= n) and not(exist_negative) do
        begin
          if A[iter] < 0 then
            exist_negative := true;
          else
          iter := iter + 1;
        end;
        
        if exist_negative then
        begin
          writeln(f, 'В массиве A есть отрицательный элемент, его номер = ', iter:2);
          writeln(f);
          
          { поиск номера наибольшего элемента массива A  }
          writeln(f, 'Выполняется поиск наибольшего элемента массива A:');
          max_A := A[1];
          n_max_A := 1;
          for i: integer := 2 to n do
          begin
            if A[i] > max_A then
            begin
              max_A := A[i];
              n_max_A := i;
            end;
          end;
          writeln(f, 'Номер наибольшего элемента массива A = ', n_max_A:2);
          writeln(f);
      
          { поиск наибольшего значения среди модулей элементов массива A }
          writeln(f, 'Выполняется поиск наибольшего значения среди модулей элементов массива A:');
          abs_value_max_A := Abs(A[1]);
          for i: integer := 2 to n do
          begin
            if Abs(A[i]) > abs_value_max_A then
              abs_value_max_A := Abs(A[i]);
          end;
          writeln(f, 'Наибольшее значение среди модулей элементов массива A = ', abs_value_max_A:2);
          writeln(f);
        end
        else
        begin
          { открытие файла input.txt на чтение }
          AssignFile(f, ParamStr(1));
          Reset(f);
          
          { ввод массивов X и Y из файла input.txt }
          for i: integer := 1 to n do
            read(f, X[i]);
          for i: integer := 1 to n do
            read(f, Y[i]);
          
          { закрытие файла input.txt }
          Closefile(f);
          
          { открытие файла output.txt на запись }
          AssignFile(f, ParamStr(2));
          Append(f);
          
          writeln(f, 'В массиве A нет отрицательных элементов');
          writeln(f);
          
          { подсчет количества точек, ордината которых больше абсциссы }
          writeln(f, 'Выполняется подсчет количества точек, ордината которых больше абсциссы:');
          count_dots := 0;
          for i: integer := 1 to n do
          begin
            if Y[i] > X[i] then
              count_dots := count_dots + 1;
          end;
          writeln(f, 'Количество точек, ордината которых больше абсциссы = ', count_dots:2);
          writeln(f);
          
          { вычисление суммы расстояний от начала координат для всех заданных точек }
          writeln(f, 'Выполняется вычисление суммы расстояний от начала координат для всех заданных точек:');
          sum_distances := 0;
          for i: integer := 1 to n do
          begin
            sum_distances := sum_distances + Sqrt(X[i] * X[i] + Y[i] * Y[i]);
          end;

          writeln(f, 'Сумма расстояний от начала координат для всех заданных точек = ', sum_distances:2:5);
        end;
      end
      else
        writeln('Невозможно считать массивы при данной размерности');
      
      { закрытие файлов input.txt и output.txt }
      CloseFile(f);
    end;
  end;
end.
