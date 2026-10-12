<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org">
<head>
    <title>Main</title>
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
    <link id="contextPathHolder" th:data-contextPath="${#httpServletRequest.getContextPath()}"/>

    <!-- bootstrap -->
    <script src="https://code.jquery.com/jquery-latest.min.js"></script>
    <link rel="stylesheet" type="text/css" th:href="@{/css/bootstrap/bootstrap.css}">
    <script type="text/javascript" th:src="@{/js/bootstrap/bootstrap.bundle.js}"></script>

    <!-- egovframe 제공
    <link rel="stylesheet" type="text/css" th:href="@{/css/egovframework/sample.css}">
    <script type="text/javascript" th:src="@{/js/egovframework/jquery-3.6.1.min.js}"></script>-->
</head>
<body>
<div class="d-flex p-2 w-100">
    <div id="selectDiv" class="w-50 p-2 row-cols-1 border border-opacity-50">
        <select id="directorySelect_1" class="col mb-1">
            <option value="0">위성 선택</option>
            <option th:each="path: ${initPath}" th:text="${path}" th:value="${path}"></option>
        </select>
        <select id="directorySelect_2" class="col mb-1">
            <option value="0">선택</option>
        </select>
        <select id="directorySelect_3" class="col mb-1">
            <option value="0">선택</option>
        </select>
    </div>
</div>
<script th:inline="javascript">
    $(document).ready(function () {
        const selectCount = document.querySelector("#selectDiv").querySelectorAll("select").length;
        for (let i=1; i<selectCount+1; i++) {
            document.querySelector("#directorySelect_"+i).addEventListener('change', evt => {
                const nextIdx = i+1;
                directorySelectChange(evt, "#directorySelect_"+nextIdx);
            })
        }

        function directorySelectChange(event) {
            // 하위 디렉토리 드롭다운 초기화
            const targetId = event.target.id;
            const ids = targetId.split("_");
            const idIndex = parseInt(ids[1]);
            for(let i=idIndex+1; i<=selectCount; i++) {
                const id = "#"+ids[0]+"_"+i
                $(id).empty();
                $(id).append("<option value='0'>선택</option>")
            }

            // 상위 디렉토리 정보 가져오기
            const pathArr = [];
            for(let i=1; i<=idIndex; i++) {
                const preValue = $("#"+ids[0]+"_"+i).val();
                pathArr.push(preValue)
            }

            if(idIndex != selectCount) {
                $.ajax({
                    type: "POST"
                    , url: "/getPathInfo"
                    , data: {
                        path: pathArr
                    }, success: function (result) {
                        const nextId = idIndex+1
                        $.each(result, function () {
                            $("#"+ids[0]+"_"+nextId).append("<option>"+this+"</option>")
                        })
                    }
                })
            }
        }
    })
</script>
</body>
</html>