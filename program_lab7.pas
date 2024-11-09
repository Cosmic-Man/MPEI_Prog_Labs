program Lab7;

const
  MinValue = 'a';
  MaxValue = 'z';

type
  CharFile = file of char;

var
  file_typed: CharFile;
  file_in: TextFile;
  k: integer;

{ очистка типизированного файла }
procedure CleanTypedFile(var file_typed: CharFile);
var
  temp: char;
  i, validPos: integer;
begin
  validPos := 0; // Позиция для записи корректных значений
  Seek(file_typed, 0);
  
  // Проход по файлу, перемещаем все корректные значения в начало файла
  for i := 0 to FileSize(file_typed) - 1 do
  begin
    Seek(file_typed, i);
    Read(file_typed, temp);
    if (temp >= MinValue) and (temp <= MaxValue) then
    begin
      Seek(file_typed, validPos);
      Write(file_typed, temp);
      validPos := validPos + 1;
    end;
  end;
  
  // Отсечение элементов вне диапазона
  Seek(file_typed, validPos);
  Truncate(file_typed);
end;


{ процедура вывода содержимого типизированного файла }
procedure DisplayTypedFile(var file_typed: CharFile);
var
  symbo: char;
begin
  Seek(file_typed, 0);
  while not EOF(file_typed) do
  begin
    Read(file_typed, symbo);
    Write(symbo, ' ');
  end;
  writeln();
end;

{ процедура для копирования всех данных из текстового файла в типизированный файл без фильтрации }
procedure CopyTextToTypedFile();
var
  symb: real;
begin
  while not EOF(file_in) do
  begin
    Read(file_in, symb);
    Write(file_typed, symb);
  end;
  CloseFile(file_in);
end;

{ функция поиска целевого элемента }
function SearchForElement(var file_typed: CharFile): integer;
var
  i: integer = 1; { Итератор }
  item_found: boolean = False; { Флаг, был ли найден элемент }
  item: char; { Считавшийся символ }
  file_size: integer = FileSize(file_typed);{ Размер файла }
begin
  { Ищем последний элемент - идем с конца в начало: 
    Пока не достигнем начала или не найдем элемент }
  while (filePos(file_typed) > 0) and (not item_found) do 
  begin
    { Ставим курсор в нужную позицию }
    Seek(file_typed, file_size - i); 
    { Считываем символ }
    Read(file_typed, item); 
    { Проверяем, является ли символ целевым }
    if (item = 'b') or (item = 'r') then 
      item_found := True { Если встретились нужные - обновляем флаг }
    else
      i := i + 1; { Увеличиваем итератор }
  end;
  if item_found then
    Result := file_size - i { Возвращаем индекс найденного символа }
  else
    Result := -1; // Возвращаем индекс найденного символа
end;

{ процедура сдвига элемента на позицию }
procedure MoveElement(var file_typed: CharFile; elementIndex, newPosition: integer);
var
  moveValue: char;
  i: integer;
begin
  Seek(file_typed, elementIndex);
  Read(file_typed, moveValue);
  
  CopyTextToTypedFile();
  CloseFile(file_typed);
  
  Reset(file_typed);
  CleanTypedFile(file_typed);
  
  { Сдвигаем элементы в зависимости от положения }
  if (elementIndex < newPosition) and (moveValue >= 'a') and (moveValue <= 'z') then
  begin
    { Перемещение вперед }
    for i := elementIndex + 1 to newPosition do
    begin
      Seek(file_typed, i);
      Read(file_typed, moveValue);
      Seek(file_typed, i - 1);
      Write(file_typed, moveValue);
    end;
  end
  else
  begin
    { Перемещение назад }
    for i := elementIndex downto newPosition + 1 do
    begin
      Seek(file_typed, i);
      Read(file_typed, moveValue);
      Seek(file_typed, i - 1);
      Write(file_typed, moveValue);
    end;
  end;
  
  { Записываем перемещенный элемент в новую позицию }
  Seek(file_typed, newPosition);
  Write(file_typed, moveValue);
end;

{ основная часть программы }
begin
  if ParamCount < 2 then { Проверка количество параметров }
    writeln('Недостаточно параметров')
  else
  begin
    if not FileExists(ParamStr(1)) then { Проверка на существование файла }
      writeln('Невозможно открыть файл ''', ParamStr(1), ''' для чтения')
    else
    begin
      AssignFile(file_in, ParamStr(1));
      Reset(file_in);
      AssignFile(file_typed, ParamStr(2));
      Rewrite(file_typed);
      
      CopyTextToTypedFile();
      CloseFile(file_typed);
      writeln('Типизированный файл до обработки:');
      DisplayTypedFile(file_typed);
      
      Reset(file_typed);
      CleanTypedFile(file_typed);
      
      var foundIndex := SearchForElement(file_typed);
      if foundIndex <> -1 then
      begin
        writeln('Найденный элемент с индексом: ', foundIndex);
        writeln('Введите значение K (позиция, куда переместить элемент):');
        readln(k);
        MoveElement(file_typed, foundIndex, k);
        writeln('Типизированный файл после обработки:');
        DisplayTypedFile(file_typed);
      end
      else
        writeln('Элемент b или r не найден.');
      
      CloseFile(file_typed);
      CloseFile(file_in);
    end;
  end;
end.
