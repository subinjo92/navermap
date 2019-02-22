# navermap

* navermap 패키지는 기존 nkmap 패키지에서 naver api를 가져온 것으로 naver 지도 api가 수정된 것을 반영한 패키지입니다.

## get_naver_map

여기서 작성한 gat_naver_map은 기존에 ggmap 패키지에 들어있던 get_navermap의 오류를 수정하고 geocode기능을 추가한 것입니다. 기존 get_navermap을 수정하고 재배포할 수 있게 허락해주신 **Heewon Jeon**에게 감사드립니다.


## Installation

devtools를 이용해 install_github함수를 쓰면 편리하게 설치할 수 있습니다.

```R
devtools::install_github("subinjo92/navermap")
library('navermap')
```
