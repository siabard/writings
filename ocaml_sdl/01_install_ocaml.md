# OCaml 설치하기

`OCaml`을 설치하는 가장 쉬운 방법은 `opam`을 이용하는 것이다.

## `opam` 설치하기

`opam`은 `OCaml`의 패키지를 관리하는 툴이다. `Ocaml` 을 설치하고 필요한 패키지를 설치할 수 있다.

`opam`은 여러 가지 방식으로 설치할 수 있는데, 여기에서는 수동으로 설치하는 법을 쓴다.

### 수동으로 `opam`으로 설치하기

다음의 스크립트를 실행하여 `opam`으로 설치할 수 있다.

```
bash -c "sh <(curl -fsSL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)"
```

일단 설치했으면 `opam`을 업데이트할 수 있다.

```
opam init --reinit -ni
opam update
opam upgrade
```


## `OCaml`을 `opam`으로 설치하기

`opam`으로 다음의 명령어를 내리면 실행 가능한 `OCaml`을 찾는다.

```
opam switch list-available
```

이렇게 하면 다수의 버전을 볼 수 있다. 여기서 원하는 버전을 설치하면 된다.

```
opam switch create 4.13.1
```

이것을 `switch`를 만든다고 한다. 만들어진 `switch`는 해당 버전에 대한 환경으로 결정된다. 해당 환경을 활성화하기위해서는 

```
exec $(opam env)
```

를 해서 환경 변수를 설정시킨다.

## `OCaml` 버전 바꾸기 

`opam`을 이용해 다른 버전으로 변경할 수 있다.

```
opam switich 4.11.1
```

위의 명령을 내리면, `4.11.1` 버전으로 바뀐다. 이후에 환경 변수를 설정시키면 된다.

## `OCaml` 개발환경 만들기

개발환경을 위해서는 여러가지 에디터를 위한 툴 설정이 필요하다.

```
opam tuareg merlin ocaml-lsp-server ocp-indent ocamlfmt base utop user-setup
```

이중에 에디터 환경을 설정하는 것이 `user-setup`이다. 

```
opam user-setup install
```

명령을 내리면 에디터별로 필요한 라이브러리를 구성한다.



