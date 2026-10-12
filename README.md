# netcdf-metadata-compare

국립환경과학원 환경위성센터에서 제공하는 정지궤도 복합위성 2B호(GK-2B)의 환경위성탑재체(GEMS) 데이터를 활용하여 개발함.

<br>

### 선행 조건
```
sample/
├── AERAOD
│   ├── v1.0
│   └── v2.0
├── NO2
│   ├── v1.0
│   └── v2.0
└── O3P
    ├── v1.0
    └── v2.0
```
1. sample 디렉토리 내에 <위성이름>/<버전>/ 형식으로 디렉토리 구조를 생성
2. 해당 버전에 맞는 데이터를 다운로드한 후, 생성한 디렉토리에 저장
3. application.properties 파일에서 gems.netcdf.path 값을 실제 데이터 저장 경로로 수정
