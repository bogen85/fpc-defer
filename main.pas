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

type
  tSomeClass = class
  strict private
    name:  string;
    count: integer;
    procedure message (const msg: string);
  public
    procedure hello;
    constructor create (const _name: string);
    destructor destroy; override;
  end;

  procedure tSomeClass.message (const msg: string);
    begin
      inc(count);
      writeln(format('%d: %s %s', [count, name, msg]));
    end;

  procedure tSomeClass.hello;
    begin
      message('Greetings!');
    end;

  constructor tSomeClass.create (const _name: string);
    begin
      name := _name;
      message('now open');
    end;

  destructor tSomeClass.destroy;
    begin
      message(format('now closed! (public methods called before destruction = %d)', [count]));
      inherited;
    end;

  procedure goodbye;
    begin
      writeln('Goodbye!');
    end;

  procedure main;
    var
      defer:     tDefer;
      y:         integer;
      something: tSomeClass;

    procedure deferred;
      begin
        inc(y);
        writeln(format('Goodbye World! y = %d', [y]));
      end;

    begin
      defer.x   := @goodbye;
      something := tSomeClass.create('procastination 101');

      // Both of these do the same thing
      //   defer.add(some function reference)
      //   defer.x := some function reference

      // should really use a smart pointer for freeing, this is an example only
      defer.add(@something.free);

      // this is fine, but may not work with smart pointers if
      //   already freed due to forced reference count decrement
      //   smart pointer finalize was called first and already freed it
      defer.x := @something.hello;

      something.hello;

      y       := 4;
      defer.x := procedure
      begin
        writeln('First added runs last! y=', y);
      end;

      defer.x := procedure
      begin
        writeln('Last added runs first! y=', y);
      end;

      // type cast needed because deferred is a local function
      defer.x := tDeferProc(@deferred);
      writeln('Hello, World!');
      writeln(format('y : %d', [y]));
      defer.anchor;
    end;

begin
  main;
end.
