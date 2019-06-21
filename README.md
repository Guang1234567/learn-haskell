# learn-haskell

1) Build lib for Android

```ruby
armv7-linux-androideabi-cabal new-build

# or

aarch64-linux-android-cabal new-build

# or

x86_64-linux-android-cabal new-build
```

The commands(armv7-linux-androideabi-cabal aarch64-linux-android-cabal) is [here](https://github.com/Guang1234567/android-ndk14-toolchain-wrapper/blob/26d0633db240fc71ce764470dd0be11cdd7a828c/wrapper#L27-L47)

2) Run `ghci` for quick-debug `libhs` on OSX， you can

```ruby
cabal new-repl --repl-options -fobject-code

or 

stack ghci --ghci-options -fobject-code
```

Add `-fobject-code` means enabling `ghci` to support test `foreign` function.

3) Integrate `libhs` with Android NDK APP :

See [demo]() 