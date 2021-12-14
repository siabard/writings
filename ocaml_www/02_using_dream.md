# Dream으로 Web App 만들기

## dream의 설치

`opam`을 이용해 `dream`모듈을 먼저 설치한다.

```
opam install dream
```

상당히 많은 의존성이 깔리는 것에 유의한다.

## 프로젝트 생성

`dune init` 을 이용해서 프로젝트를 생성한다.

```
dune init proj dream_webapp --libs dream
```

## 기본 페이지 생성

HTML을 생성하기위해서는 함수안에서 직접 HTML을 쓸 수 있다.
아울러, `@@`을 이용해 실행 우선순위를 당긴다.


```
let hello who =
  <html>
  <body>
    <h1>Hello, <%s who %>!</h1>
  </body>
  </html>

let () =
  Dream.run
  @@ Dream.logger
  @@ Dream.router [
    Dream.get "/" (fun _ ->
      Dream.html (hello "world"));
  ]
  @@ Dream.not_found
```


## eml의 처리

위의 소스를 `main.eml.ml`이라고 저장하고 기존의 `main.ml`은 삭제한다.

이후에 `bin/dune`에 다음의 내용을 추가한다.

```

(rule
 (targets main.ml)
 (deps main.eml.ml)
 (action
  (run dream_eml %{deps} --workspace %{workspace_root})))

(data_only_dirs _esy esy.lock lib node_modules)
```

`dream_eml`은 `main.eml.ml`을 해석하여 `main.ml`을 만든다. 위의 코드를 통해 만들어지는 코드는 아래와 같다.

```
#1 "bin/main.eml.ml"
let hello who =
let ___eml_buffer = Buffer.create 4096 in
(Buffer.add_string ___eml_buffer "<html>\n<body>\n  <h1>Hello, ");
(Printf.bprintf ___eml_buffer "%s" (Dream.html_escape (
#4 "bin/main.eml.ml"
                   who 
)));
(Buffer.add_string ___eml_buffer "!</h1>\n</body>\n</html>\n\n");
(Buffer.contents ___eml_buffer)
#8 "bin/main.eml.ml"
let () =
  Dream.run
  @@ Dream.logger
  @@ Dream.router [
    Dream.get "/" (fun _ ->
      Dream.html (hello "world"));
  ]
  @@ Dream.not_found

```

## 실행

해당 프로젝트를 실행하면 웹서비스가 실행되고, `http://localhost:8080/` 에 접속하면 HTML이 노출된다.
