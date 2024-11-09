program Lab5;

const
  n_max_size = 100;

type
  mas = array [1..n_max_size] of integer;

var
  A: mas;
  f: TextFile;
  n, k, n_k, n_even, min_n, i: integer;
  flag: boolean;
  min_even_n : integer;

begin
  if ParamCount < 2 then { Проверяем количество параметров }
    writeln('Недостаточно параметров!')
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
      for i := 1 to n do
        read(f, A[i]);
      read(f, k);
      
      { открытие файла output.txt на запись }
      AssignFile(f, ParamStr(2));
      Rewrite(f);
      
      { поиск первого элемента, кратного k }
      writeln(f, 'Выполняется поиск первого элемента, кратного k:');
      flag := false;
      i := 1;
      while (i <= n) and not(flag) do
        begin
          if A[i] mod k = 0 then
            flag := true
          else
            i := i + 1;
        end;
      if flag then
      begin
        n_k := i;
        writeln(f, 'Номер первого элемента, кратного k = ', n_k)
      end
      else
      begin
        n_k := 1;
        writeln(f, 'В массива А нет элементов, кратных k');
      end;
      writeln(f);
      
      { поиск первого нечетного элемента с конца массива }
      writeln(f, 'Выполняется поиск первого нечетного элемента с конца массива:');
      flag := false;
      i := n;
      while (i >= n_k + 1) and not(flag) do
        begin
          if A[i] mod 2 <> 0 then
            flag := true
          else
            i := i - 1;
        end;
      if flag then
        begin
        n_even := i;
        writeln(f, 'Номер первого нечетного элемента с конца массива = ', i);
        end
      else
      begin
        n_even := n;
        writeln(f, 'В массива А нет нечетных элементов');
      end;
      writeln(f);
      
      { поиск минимального нечетного элемента на отрезке от n_k до n_even }
      write(f, 'Выполняется поиск минимального нечетного элемента на отрезке от ', n_k);
      write(f, ' до ', n_even);
      writeln(f, ':');    
      if (n_k < n_even) and flag then
      begin
        min_even_n := A[n_even];
        for i := (n_k + 1) to n_even do
          begin
            if (A[i] mod 2 <> 0) and (A[i] < min_even_n) then
            begin
              min_even_n := A[i];
              min_n := i;
            end;
          end;
        min_n := n_even;
        writeln(f, 'Минимальный элемент найден, его номер = ', min_n)
      end
      else
        writeln(f, 'Невозможно найти хотя бы один нечетный элемент, расположенный после первого элемента, кратного k');
      CloseFile(f);
    end
    else
      writeln('Невозможно считать массивы при данной размерности');
  end;
end.
