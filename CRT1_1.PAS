UNIT CRT1;
             { ���७�� ����� CRT ��� ������� �ࠪ⨪㬠
                   "����䥩� �ணࠬ�� ���஢��" }
INTERFACE

procedure getcolors(var fc,bc:byte);
  {����� ⥪��� ��।���� (fc) � 䮭����� (bc) 梥⮢}

procedure windcoord(var x1,y1,x2,y2:byte);
  {����� ���न��� ⥪�饣� ���� (�㬥��� ��᮫�⭠�, � 1):
    (x1,y1) - ���� ���孨� 㣮� (x1-�⮫���, y1-��ப�)
    (x2,y2) - �ࠢ� ������ 㣮�}

function getch(x,y:byte):char;
  {����� ᨬ����, ��ᢥ稢������ � x-� ������� y-� ��ப� ����}

function getattr(x,y:byte):byte;
  {����� ��ਡ�� ᨬ����, �� � x-� ������� y-� ��ப� ����}

procedure putch(x,y:byte; c:char);
  {������ ᨬ���� � ��� (x,y) ���� ��� ��������� ��ਡ��}

procedure putattr(x,y:byte; a:byte);
  {�������� �� a ��ਡ�� �窨 (x,y) ���� ��� ��������� ᨬ����}

procedure inkey(var c:char; var spec:boolean);
  {���� ��� �� ᨬ���� � ���������� � ��ᢠ������ ��� ��ࠬ���� C;
  �᫨ �� �ࠢ���騩 ᨬ���, � spec:=true, ��� ���筮�� spec:=false
  (Enter, Ecs � Backspace ������� �ࠢ���騬�)}

procedure wait;     {����� ������ �� ������ (��� "���⠥���")}

procedure crsoff;   {���� ����� (ᤥ���� ��������)}

procedure crson;    {ᤥ���� ����� ������}

procedure bell;     {������}

{================================================================}

IMPLEMENTATION
  uses crt;

const maxX=80;  maxY=25;
type  pixel=record ch:char; attr:byte end;   {������� ��ࠧ� ��࠭�}
var   screen80:   {����������� 梥⭮�� ��࠭� 25x80}
         array[1..maxY,1..maxX] of pixel absolute $B800:$0000;
                                          
procedure testcoord(prname:string; x,y:byte);
  {�஢�ઠ ���न���� �窨 � ����}
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
  {����� ⥪��� ��।���� (fc) � 䮭����� (bc) 梥⮢}
begin   fc:=TextAttr and $F;  bc:=(TextAttr shr 4) and $7  end;

procedure windcoord(var x1,y1,x2,y2:byte);
  {����� ���न��� ⥪�饣� ���� (�㬥��� ��᮫�⭠�, � 1):
    (x1,y1) - ���� ���孨� 㣮� (x1-�⮫���, y1-��ப�)
    (x2,y2) - �ࠢ� ������ 㣮�}
begin
   x1:=Lo(WindMin)+1; y1:=Hi(WindMin)+1;
   x2:=Lo(WindMax)+1; y2:=Hi(WindMax)+1;
end;

function getch(x,y:byte):char;
  {����� ᨬ����, ��ᢥ稢������ � x-� ������� y-� ��ப� ����}
begin
  testcoord('getch',x,y);
  getch:=screen80[Hi(WindMin)+y,Lo(WindMin)+x].ch;
end;

function getattr(x,y:byte):byte;
  {����� ��ਡ�� ᨬ����, �� � x-� ������� y-� ��ப� ����}
begin
  testcoord('getattr',x,y);
  getattr:=screen80[Hi(WindMin)+y,Lo(WindMin)+x].attr
end;

procedure putch(x,y:byte; c:char);
  {������ ᨬ���� � ��� (x,y) ���� ��� ��������� ��ਡ��}
begin
  testcoord('putch',x,y);
  screen80[Hi(WindMin)+y,Lo(WindMin)+x].ch:=c
end;

procedure putattr(x,y:byte; a:byte);
  {�������� �� a ��ਡ�� �窨 (x,y) ���� ��� ��������� ᨬ����}
begin
  testcoord('putattr',x,y);
  screen80[Hi(WindMin)+y,Lo(WindMin)+x].attr:=a
end;

procedure inkey(var c:char; var spec:boolean);
  {���� ��� �� ᨬ���� � ���������� � ��ᢠ������ ��� ��ࠬ���� C,
   �᫨ �� �ࠢ���騩 ᨬ���, � spec:=true, ����� - spec:=false
   (Enter, Ecs � Backspace ������� �ࠢ���騬�) }
begin c:=readkey;
  if c>=#32 then spec:=false else
    begin spec:=true; if c=#0 then c:=readkey end;
end;

procedure wait; {����� ������ �� ������ (��� "���⠥���")}
  var c:char; spec:boolean;
begin inkey(c,spec) end;

procedure crsoff;  {���� ����� (ᤥ���� ��������)}
begin inline(
  $B4/$03/     {MOV AH,3}
  $B7/$00/     {MOV BH,0}
  $CD/$10/     {INT 10h}
  $80/$CD/$20/ {OR CH,20h}
  $B4/$01/     {MOV AH,1}
  $CD/$10      {INT 10h}
             );
end;

procedure crson; {ᤥ���� ����� ������}
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

procedure bell;   {������}
begin write(#7) end;

          {=== ����� ����� CRT1 ===}
end.
