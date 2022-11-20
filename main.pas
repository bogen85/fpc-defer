{
  CudaText: lexer_file=Pascal; tab_size=2; tab_spaces=Yes; newline=LF;
}
{$mode objfpc}
{$H+}
{$modeswitch anonymousfunctions}
{$modeswitch functionreferences}

program main;

uses
  fpcdefer,
  sysutils;

  procedure main;
    var
      defer: tDefer;
      y:     integer;

    procedure deferred;
      begin
        inc(y);
        writeln(format('Goodbye World! y = %d', [y]));
      end;

    begin
      y       := 4;
      defer.x := procedure
      begin
        writeln('First added runs last! y=', y);
      end;

      defer.x := procedure
      begin
        writeln('Last added runs first! y=', y);
      end;

      defer.x := tDeferProc(@deferred);
      writeln('Hello, World!');
      writeln(format('y : %d', [y]));
      defer.anchor;
    end;

begin
  main;
end.
