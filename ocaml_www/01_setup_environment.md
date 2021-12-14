# 환경 설정하기

## 필요한 라이브러리 설치

`dune init` 명령어를 이용해 필요한 모듈을 넣은 프로젝트를 만들 수 있다.

```
dune init proj ocaml_webapp \
    --libs core,opium,caqti,caqti-driver-postgresql,caqti-lwt,tyxml,lwt.unix \
    --ppx ppx_rapper
```

* `lib` :  라이브러리 컴포넌트. 비지니스 로직을 넣는 곳
* `bin` :  실행 컴포넌트. `lib`를 사용하는 곳
* `test` : 테스트 컴포넌트

개개의 디렉토리에는 `dune` 파일이 있으며, 여기에 필요로하는 환경 설정이 들어간다.

필요한 라이브러리를 설명하면 다음과 같다.

* Opium: Sinatra 같은 웹 툴킷
* Caqti: Postgresql과 상호연동하기위한 라이브러리
* ppx_rapper: SQL query를 위한 문법 확장
* Lwt: Cuncurrent 라이브러리
* TyXML : HTML을 만들기 위한 라이브러리
* Core: 표준 라이브러리
* logs: 로그 라이브러리


