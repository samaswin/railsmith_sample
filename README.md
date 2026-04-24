# Railsmith sample smoke

Optional **non-Rails** scripts that exercise `Railsmith::Pipeline` and services the way a small app would, without shipping a full Rails skeleton in this repository.

## Checkout smoke

From the **gem root** (parent of this directory):

```bash
bundle exec ruby railsmith_sample/smoke/checkout_smoke.rb
```

Exit code is `0` when the sample pipeline completes successfully.
