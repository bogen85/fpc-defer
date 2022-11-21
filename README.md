# fpc-defer
Defer mechanism for Free Pascal.

This is similar to `defer` from other languages:
- [`defer` in `V`](https://github.com/vlang/v/blob/master/doc/docs.md#defer)
- [`defer` in `go`](https://golangbot.com/defer)

This can be approximated (but is not identical) in Free Pascal.

But it is basically equivalent in that one can defer:
- A function call.
- Code that will be be executed.

This project demonstrates how that can be done.

# Requirements
FPC 3.3.1 or later (What currently can be built from FPC gitlab main)

Reason:
- This mechanism uses Anonymous Functions
- This mechanism uses Function References

These are used so that code using `defer` can access data in their parent scope.

Options for installing FPC 3.3.1:
- [FPCUPdeluxe](https://wiki.freepascal.org/fpcupdeluxe)
- [Building FPC from sources using git or zip](https://wiki.lazarus.freepascal.org/Installing_the_Free_Pascal_Compiler#FPC_sources_Using_Git_or_Zip)

# To use

Study the code (`fpcdefer.pas` and `main.pas`) then execute `make run`.

Basically the `main.pas` example shows what to do:

- Create a variable of type `tDefer` in the function you need to defer something.
- For ease of use, you can name that variable `defer`.
  - `var defer: tDefer;`
- You then can use `defer` to add function references to a `LIFO` list.
- Both of these do the same thing:
  - `defer.x := some function reference`
  - `defer.add(some function reference)`
- You can do `defer.x := @some_global_procedure` and it will work as expected.
- You can also use a local procedure and it will work as expected, but you must cast it.
  - `defer.x := tDeferProc(@some_local_procedure)`
- You can do `defer.x := @some_class_instance.some_procedure_method` and it will work as expected.
- You can do `defer.x := @some_class_instance.free` and it will work as expected.

## You can also use an anonymous function as the function reference.

```pas
defer.x := procedure
begin
	writeln('Some anonymous function...');
end;
```

# Deferred execution
- When the `defer` goes out of scope, all the functions in the `LIFO` list will be called.
- `LIFO`, as in, `Last in`, `First out`, meaning:
  - The last function reference added will be called first.
  - The first function reference added will be called last.

# Insure the deferred code is not executed too early
Place `defer.anchor` at the bottom of the function, before it's last `end;`

## Notes

- The `.anchor` method must be used to make sure the deferred code is not called too early.
- It needs to be placed either:
  - At the end of scope it is intended to be used in.
  - At the earliest point the deferred code can be called.
- This is because FPC does in no way guarantee when exactly a managed type is finalized.
  - It can be at the end of the function or directly after its last use.
  - It is only guaranteed that it will be finalized at the latest at the end of the scope.
- Free Pascal scoping.
  - FPC is function scope.
  - FPC is not block scope (Unless one considers the whole function to be a block).
  - Nested functions are nested scopes.

# References

- See [Topic: Defer Mechanism for FreePascal](https://forum.lazarus.freepascal.org/index.php?topic=55154) in the Lazarus forums.
