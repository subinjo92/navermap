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

## usage

### file_drawer
ggmap 패키지의 내부 utility function으로 다른 함수의 내부에서 돌아가기 위해 추가한 함수입니다.

### getBorderLonLat
기존 ggmap 내부의 get_navermap함수내에 있던 함수로 get_kakao_navermap함수가 작동하기 위해 추가했습니다.

### geocode_naver
naver api를 이용한 geocode로 주소와 naver client id와 secret을 입력해줘야 사용가능합니다.

### get_kakao_navermap
center에는 위경도, 주소 또는 지명을 넣을 수 있습니다. 위경도로 입력할시 keyword와 address를 FALSE로 주어야합니다.
주소로 입력시 keyword를 FALSE로 주고 address를 TRUE로 주면 됩니다.
지명으로 검색할 시 keyword를 TRUE로 주고 address를 FALSE로 주면 됩니다.  

zoom은 확대할 단위이며 1 ~ 14까지입니다.  

baselayer는 일반지도로 그릴 수 있으며 satellite를 입력하면 위성사진입니다.  

overlayer는 "anno_satellite", "bicycle", "roadview", "traffic" 종류가 있습니다. 
default 는 4가지 모두 표시되는 것이고, 입력하게 되면 입력 받은 종류만 지도위에 표시됩니다.
- anno_satellite : 위성 오버레이 지도(위성 지도용으로 사용하는 텍스트, 도로선, 아이콘을 겹친 오버레이 지도) 
- bicycle : 자전거 오버레이 지도 
- roadview : 거리뷰 오버레이 지도 
- traffic : 실시간 교통 오버레이 지도 

markers 또는 markers_ab는 위경도값이 들어가며 지도위에 체크나 알파벳으로 특정지점을 표시할 수 있습니다.  

naver url, client id, secret이 필요하며, kakao REST API키가 필요합니다.  

## 참고할수 있는 사이트
https://apidocs.ncloud.com/ko/ai-naver/maps_static_map/
