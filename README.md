# fpc-defer
Defer mechanism for Free Pascal

See [Topic: Defer Mechanism for FreePascal](https://forum.lazarus.freepascal.org/index.php?topic=55154) in the Lazarus forums.

So if someone is looking for something akin to `defer` from other languages:
[`defer` in `V`](https://github.com/vlang/v/blob/master/doc/docs.md#defer)
[`defer` in `go`](https://golangbot.com/defer)

That can be approximated in Free Pascal.

By either:
- providing a function to defer
- code to defer execution of

This code demonstrates how that can be done.

# Requirements
FPC 3.3.1 or later (What currently can be built from FPC gitlab main)

Reason:
- This mechansim uses Anonymous Functions
- This mechansim uses Function References

These are used so that code using `defer` can access data in their parent scope.

# To use

Study the code (`defer.pas` and `main.pas`) then execute `make run`

# Notes

- The `.anchor` method must be used to make sure the deferred code is not called to early.
- It needs to be placed at the end of scope it is intended to be used in
- See [this comment and subsequent replies](https://forum.lazarus.freepascal.org/index.php/topic,55154.msg460637.html#msg460637) that discuss this issue.
