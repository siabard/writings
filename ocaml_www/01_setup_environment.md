# 환경 설정하기

## 필요한 라이브러리 설치

필요한 라이브러리를 설명하면 다음과 같다.

* Opium: Sinatra 같은 웹 툴킷
* Caqti: Postgresql과 상호연동하기위한 라이브러리
* ppx_rapper: SQL query를 위한 문법 확장
* Lwt: Cuncurrent 라이브러리
* TyXML : HTML을 만들기 위한 라이브러리
* Core: 표준 라이브러리
* logs: 로그 라이브러리

위에서 보이는 저 라이브러리들은 `opam`을 통해 미리 설치해둔다.

```
opam instlal opium caqti caqti-driver-postgresql caqti-lwt tyxml lwt
```

## 프로젝트 설정

`dune init` 명령어를 이용해 필요한 모듈을 넣은 프로젝트를 만들 수 있다.

```
dune init proj ocaml_webapp \
    --libs core,opium,caqti,caqti-driver-postgresql,caqti-lwt,tyxml,lwt \
    --ppx ppx_rapper
```

* `lib` :  라이브러리 컴포넌트. 비지니스 로직을 넣는 곳
* `bin` :  실행 컴포넌트. `lib`를 사용하는 곳
* `test` : 테스트 컴포넌트

개개의 디렉토리에는 `dune` 파일이 있으며, 여기에 필요로하는 환경 설정이 들어간다.

```
$ tree
.
├── bin
│   ├── dune
│   └── main.ml
├── lib
│   └── dune
├── ocaml_webapp.opam
└── test
    ├── dune
    └── ocaml_webapp.ml

3 directories, 6 files
```

## backtick

동일한 이름을 가지는 Variants를 enum으로 만드는 것은 일반적으로 생성이
거부된다. 하지만 OCaml에서는 이를 해결하는 방법이 있다.

예를 들어 아래와 같은 코드가 있다고 하자.

```
type lock = Open | Close;;
type door = Open | Close;;
```

자 이제 `Open`의 타입은 무엇이 되겠는가?

```
# type lock = Open | Close;;
type lock = Open | Close
# type door = Open | Close;;
type door = Open | Close
# Open;;
- : door = Open
```

`Open`의 가장 최근 정의를 이용하기 때문에 `door` 타입이 된다. 만약에
`lock` 타입의 `Open`을 사용하려고 한다면 컴파일러에서 오류를 낼
것이다. 즉 Variants는 반드시 하나의 타입만 갖는다는 것이다.

하지만 다른 방법도 가능하다. `Open`을 어떨 때는 `lock` 타입으로, 또
다를 때는 `door` 타입으로 쓰고 싶다고 해보자. OCaml에서는 아래와 같이
가능하다.

```
# type lock = [ `Open | `Close ];;
type lock = [ `Close | `Open ]
# type door = [ 'Open | `Close ];;
type door = [ 'Close | `Open ];;
```

각각의 variant는 `` ` `` (back tick) 으로 구분되었고, 각괄호(`[]`)를
이용해 값을 감쌌다. 그러면 ` `Open `의 값은 어떻게 될까?

```
# `Open
- : [> `Open ] = `Open
```

``[> `Open] ``은 ```Open`` 은 우리가 아직 알지 못하는 또다른 형까지
포함하는 Variant가 된다.

## 간단한 예제

```
open Opium

module Person = struct
  type t =
    { name : string
    ; age : int
    }

  let yojson_of_t t = `Assoc [ "name", `String t.name; "age", `Int t.age ]

  let t_of_yojson yojson =
    match yojson with
    | `Assoc [ ("name", `String name); ("age", `Int age) ] -> { name; age }
    | _ -> failwith "invalid person json"
  ;;
end

let print_person_handler req =
  let name = Router.param req "name" in
  let age = Router.param req "age" |> int_of_string in
  let person = { name; age } |> Person.yojson_of_t in
  Lwt.return (Response.of_json person)
;;

let update_person_handler req =
  let open Lwt.Syntax in
  let+ json = Request.to_json_exn req in
  let person = Person.t_of_yojson json in
  Logs.info (fun m -> m "Received person: %s" person.Person.name);
  Response.of_json (`Assoc [ "message", `String "Person saved" ])
;;

let streaming_handler req =
  let length = Body.length req.Request.body in
  let content = Body.to_stream req.Request.body in
  let body = Lwt_stream.map String.uppercase_ascii content in
  Response.make ~body:(Body.of_stream ?length body) () |> Lwt.return
;;

let print_param_handler req =
  Printf.sprintf "Hello, %s\n" (Router.param req "name")
  |> Response.of_plain_text
  |> Lwt.return
;;

let _ =
  App.empty
  |> App.post "/hello/stream" streaming_handler
  |> App.get "/hello/:name" print_param_handler
  |> App.get "/person/:name/:age" print_person_handler
  |> App.patch "/person" update_person_handler
  |> App.run_command
;;
```
