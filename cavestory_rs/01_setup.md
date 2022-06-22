# Cavestory를 Rust + SDL2로 리메이킹

YouTue의 [Remaking Cavestory in C++](https://www.youtube.com/watch?v=ETvApbD5xRo&list=PLNOBk_id22bw6LXhrGfhVwqQIa-M2MsLa) 시리즈를 Rust로 해보자는 생각으로 도전한다.

## 프로젝트의 설정

`cargo`를 써서 프로젝트를 만든다.

```
cargo new --bin cavestory_rs
```

## SDL2 설치

`Cargo.toml`에 추가적으로 다음의 내용을 넣는다.

```
[dependencies.sdl2]
version = "0.35"
default-features = false
features = ["ttf","image","gfx","mixer"]
```

SDL2에 대한 기본적인 모듈들을 전부 가져올 것이다.

