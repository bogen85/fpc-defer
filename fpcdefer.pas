{
  CudaText: lexer_file=Pascal; tab_size=2; tab_spaces=Yes; newline=LF;
}
{$mode objfpc}
{$H+}
{$modeswitch anonymousfunctions}
{$modeswitch functionreferences}
{$modeswitch advancedrecords}

unit fpcdefer;

interface

type
  tDeferProc = reference to procedure;
  tDeferred  = array of tDeferProc;
  tDefer     = record
  strict private
    deferred: tDeferred;
    class operator finalize (var self: tDefer);
  public
    procedure add (const _deferred: tDeferProc);
    property x: tDeferProc write add;
    procedure anchor;
  end;

implementation

procedure tDefer.anchor; // empty placeholder
  begin
  end;

class operator tDefer.finalize (var self: tDefer);
  var
    i: integer;
  begin
    for i := high(self.deferred) downto low(self.deferred) do self.deferred[i]();
  end;

procedure tDefer.add (const _deferred: tDeferProc);
  begin
    insert(_deferred, deferred, length(deferred));
  end;

begin
end.
