UNIT CRT1;
             { расширение модуля CRT для задания практикума
                   "Интерфейс программы сортировки" }
INTERFACE

procedure getcolors(var fc,bc:byte);
  {запрос текущих переднего (fc) и фонового (bc) цветов}

procedure windcoord(var x1,y1,x2,y2:byte);
  {запрос координат текущего окна (нумерация абсолютная, с 1):
    (x1,y1) - левый верхний угол (x1-столбец, y1-строка)
    (x2,y2) - правый нижний угол}

function getch(x,y:byte):char;
  {запрос символа, высвечиваемого в x-й колонке y-й строки окна}

function getattr(x,y:byte):byte;
  {запрос атрибута символа, что в x-й колонке y-й строки окна}

procedure putch(x,y:byte; c:char);
  {запись символа в точку (x,y) окна без изменения атрибута}

procedure putattr(x,y:byte; a:byte);
  {заменить на a атрибут точки (x,y) окна без изменения символа}

procedure inkey(var c:char; var spec:boolean);
  {ввод без эха символа с клавиатуры и присваивание его параметру C;
  если это управляющий символ, то spec:=true, для обычного spec:=false
  (Enter, Ecs и Backspace считаются управляющими)}

procedure wait;     {ждать нажатия любой клавиши (она "глотается")}

procedure crsoff;   {убрать курсор (сделать невидимым)}

procedure crson;    {сделать курсор видимым}

procedure bell;     {звонок}

{================================================================}

IMPLEMENTATION
  uses crt;

const maxX=80;  maxY=25;
type  pixel=record ch:char; attr:byte end;   {элемент образа экрана}
var   screen80:   {видеопамять цветного экрана 25x80}
         array[1..maxY,1..maxX] of pixel absolute $B800:$0000;
                                          
procedure testcoord(prname:string; x,y:byte);
  {проверка координаты точки в окне}
  var x1,y1,x2,y2:byte;
begin
   windcoord(x1,y1,x2,y2);
   if (x<1) or (x>x2-x1+1) or (y<1) or (y>y2-y1+1) then
     begin
       window(1,1,80,25); gotoXY(1,1);
       writeln('Error in ',prname,': ','coord. out of window');
       write('Press Enter ...'); readln;
       halt;
     end;
end;

procedure getcolors(var fc,bc:byte);
  {запрос текущих переднего (fc) и фонового (bc) цветов}
begin   fc:=TextAttr and $F;  bc:=(TextAttr shr 4) and $7  end;

procedure windcoord(var x1,y1,x2,y2:byte);
  {запрос координат текущего окна (нумерация абсолютная, с 1):
    (x1,y1) - левый верхний угол (x1-столбец, y1-строка)
    (x2,y2) - правый нижний угол}
begin
   x1:=Lo(WindMin)+1; y1:=Hi(WindMin)+1;
   x2:=Lo(WindMax)+1; y2:=Hi(WindMax)+1;
end;

function getch(x,y:byte):char;
  {запрос символа, высвечиваемого в x-й колонке y-й строки окна}
begin
  testcoord('getch',x,y);
  getch:=screen80[Hi(WindMin)+y,Lo(WindMin)+x].ch;
end;

function getattr(x,y:byte):byte;
  {запрос атрибута символа, что в x-й колонке y-й строки окна}
begin
  testcoord('getattr',x,y);
  getattr:=screen80[Hi(WindMin)+y,Lo(WindMin)+x].attr
end;

procedure putch(x,y:byte; c:char);
  {запись символа в точку (x,y) окна без изменения атрибута}
begin
  testcoord('putch',x,y);
  screen80[Hi(WindMin)+y,Lo(WindMin)+x].ch:=c
end;

procedure putattr(x,y:byte; a:byte);
  {заменить на a атрибут точки (x,y) окна без изменения символа}
begin
  testcoord('putattr',x,y);
  screen80[Hi(WindMin)+y,Lo(WindMin)+x].attr:=a
end;

procedure inkey(var c:char; var spec:boolean);
  {ввод без эха символа с клавиатуры и присваивание его параметру C,
   если это управляющий символ, то spec:=true, обычный - spec:=false
   (Enter, Ecs и Backspace считаются управляющими) }
begin c:=readkey;
  if c>=#32 then spec:=false else
    begin spec:=true; if c=#0 then c:=readkey end;
end;

procedure wait; {ждать нажатия любой клавиши (она "глотается")}
  var c:char; spec:boolean;
begin inkey(c,spec) end;

procedure crsoff;  {убрать курсор (сделать невидимым)}
begin inline(
  $B4/$03/     {MOV AH,3}
  $B7/$00/     {MOV BH,0}
  $CD/$10/     {INT 10h}
  $80/$CD/$20/ {OR CH,20h}
  $B4/$01/     {MOV AH,1}
  $CD/$10      {INT 10h}
             );
end;

procedure crson; {сделать курсор видимым}
begin
  inline(
    $B4/$03/     {MOV AH,3}
    $B7/$00/     {MOV BH,0}
    $CD/$10/     {INT 10h}
    $80/$E5/$DF/ {AND CH,0BFh}
    $B4/$01/     {MOV AH,1}
    $CD/$10      {INT 10h}
         );
end;

procedure bell;   {звонок}
begin write(#7) end;

          {=== конец модуля CRT1 ===}
end.
